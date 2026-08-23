-- Java LSP via nvim-jdtls. The generic mason-lspconfig auto-enable path shares
-- one jdtls -data workspace across every project and omits jdtls's
-- extendedClientCapabilities, which leaves jdtls degraded: diagnostics work but
-- code actions do not. nvim-jdtls gives each project its own workspace and sets
-- those capabilities, unlocking add-import / organize-imports / generate /
-- extract, etc. This file owns all of Java's LSP config: it installs the jdtls
-- binary via mason and keeps it out of auto-enable (nvim-jdtls starts it), then
-- drives nvim-jdtls itself.

-- Java owns its mason entry: install jdtls, but let nvim-jdtls start it. An opts
-- function that initialises the lists then extends them in place -- lazy runs
-- fragments in filename order and replaces list-valued table opts, so each
-- contributor must defensively init before extending.
local mason_jdtls = {
  "williamboman/mason-lspconfig.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    opts.automatic_enable = opts.automatic_enable or {}
    opts.automatic_enable.exclude = opts.automatic_enable.exclude or {}
    vim.list_extend(opts.ensure_installed, { "jdtls" })
    vim.list_extend(opts.automatic_enable.exclude, { "jdtls" })
  end,
}

local nvim_jdtls = {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    -- jdtls's own JVM needs Java 21+. Prefer $JDTLS_JAVA_HOME, else the newest
    -- SDKMAN java >= 21. Nil = let the mason launcher use JAVA_HOME / PATH.
    local function jdtls_java_home()
      if vim.env.JDTLS_JAVA_HOME then
        return vim.env.JDTLS_JAVA_HOME
      end
      local dirs = vim.fn.glob(vim.fn.expand("~/.sdkman/candidates/java") .. "/*", true, true)
      local best, best_major
      for _, dir in ipairs(dirs) do
        local major = tonumber(vim.fn.fnamemodify(dir, ":t"):match("^(%d+)"))
        if major and major >= 21 and vim.fn.isdirectory(dir) == 1 then
          if not best_major or major > best_major then
            best, best_major = dir, major
          end
        end
      end
      return best
    end

    local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

    -- Root the LSP at the OUTERMOST project dir so multi-module Gradle/Maven
    -- builds resolve cross-module types. settings.gradle(.kts), gradlew and mvnw
    -- live only at the true root, so prefer them over a submodule's own
    -- build.gradle / pom.xml (which vim.fs.root would otherwise pick because it
    -- is nearer). Fall back to the topmost build file, then .git.
    local function project_root(bufnr)
      local single = vim.fs.root(bufnr, {
        "settings.gradle",
        "settings.gradle.kts",
        "gradlew",
        "mvnw",
      })
      if single then
        return single
      end
      -- No wrapper/settings: climb to the topmost dir that still has a build
      -- file (covers multi-module Maven, where every module has a pom.xml).
      local markers = { "pom.xml", "build.gradle", "build.gradle.kts" }
      local root = vim.fs.root(bufnr, markers)
      while root do
        local up = vim.fs.root(vim.fs.dirname(root), markers)
        if not up or up == root then
          break
        end
        root = up
      end
      return root or vim.fs.root(bufnr, { ".git" })
    end

    local function start()
      local jdtls = require("jdtls")
      local root = project_root(0)
      if not root then
        return -- loose file, not in a project: skip rather than spawn a stray workspace
      end

      -- One -data workspace per project root (full path sanitised to a dir name),
      -- so projects never share/corrupt each other's jdtls index.
      local key = vim.fn.fnamemodify(root, ":p"):gsub("[/\\:]+", "-")
      local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. key

      -- extendedClientCapabilities is what unlocks jdtls's source actions.
      local caps = jdtls.extendedClientCapabilities
      caps.resolveAdditionalTextEditsSupport = true

      local jhome = jdtls_java_home()

      -- Lombok agent: @Slf4j / @Data / @Builder etc. generate members at compile
      -- time, so jdtls only sees them (e.g. the `log` field) when Lombok is loaded
      -- as a javaagent into its JVM. Enabled when lombok.jar is present
      -- (linux/scripts/setup-full.sh downloads it; macOS: drop it at the path
      -- below). --jvm-arg is passed through by mason's jdtls launcher.
      local cmd = { jdtls_bin, "-data", workspace }
      local lombok = vim.fn.stdpath("data") .. "/lombok.jar"
      if vim.uv.fs_stat(lombok) then
        table.insert(cmd, 2, "--jvm-arg=-javaagent:" .. lombok)
      end

      jdtls.start_or_attach({
        cmd = cmd,
        cmd_env = jhome and { JAVA_HOME = jhome } or nil,
        root_dir = root,
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        init_options = { extendedClientCapabilities = caps },
        settings = {
          java = {
            completion = {
              -- jdtls only completes/auto-imports static members from this list.
              -- It defaults to JUnit + Mockito (Mockito/ArgumentMatchers/Answers);
              -- add AssertJ and the rest of the common Mockito holders -- notably
              -- BDDMockito (given/willReturn/then), MockitoAnnotations (openMocks)
              -- and the Additional* matchers/answers -- so assertThat, given, etc.
              -- resolve and auto-import.
              favoriteStaticMembers = {
                "org.assertj.core.api.Assertions.*",
                "org.assertj.core.api.Assumptions.*",
                "org.assertj.core.api.InstanceOfAssertFactories.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.junit.jupiter.api.Assumptions.*",
                "org.junit.jupiter.api.DynamicTest.*",
                "org.junit.jupiter.api.DynamicContainer.*",
                "org.junit.Assert.*",
                "org.junit.Assume.*",
                "org.mockito.Mockito.*",
                "org.mockito.BDDMockito.*",
                "org.mockito.ArgumentMatchers.*",
                "org.mockito.Answers.*",
                "org.mockito.AdditionalMatchers.*",
                "org.mockito.AdditionalAnswers.*",
                "org.mockito.MockitoAnnotations.*",
              },
            },
          },
        },
        on_attach = function(_, bufnr)
          -- generic SPC c d/D/a/f come from lsp.lua's LspAttach; add the
          -- jdtls-only organize-imports here.
          vim.keymap.set("n", "<leader>co", jdtls.organize_imports, {
            buffer = bufnr,
            desc = "Organize imports",
          })
        end,
      })
    end

    local group = vim.api.nvim_create_augroup("jdtls_start", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "java",
      callback = start,
    })
    -- The FileType event that lazy-loaded this plugin already fired for the
    -- current buffer, so start it explicitly too.
    if vim.bo.filetype == "java" then
      start()
    end
  end,
}

return { mason_jdtls, nvim_jdtls }
