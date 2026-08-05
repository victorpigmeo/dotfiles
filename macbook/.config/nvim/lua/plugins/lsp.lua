-- LSP: mason installs language servers, nvim-lspconfig provides their configs.
-- jdtls = Java. mason-lspconfig (v2) auto-enables installed servers.
-- Keymaps live under SPC c (code) and bind per-buffer when an LSP attaches.
return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "jdtls" },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Advertise blink.cmp's completion capabilities to every server so the
      -- LSP returns snippets and resolvable detail. Applied before servers
      -- attach (BufReadPre), which is why it lives here, not in blink's spec.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- jdtls's own JVM needs Java 21+. Projects may target older Java; only
      -- the server runtime is pinned here. Prefer $JDTLS_JAVA_HOME, else the
      -- newest SDKMAN java >= 21. Nil = fall back to JAVA_HOME/PATH.
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

      local jhome = jdtls_java_home()
      if jhome then
        vim.lsp.config("jdtls", { cmd_env = { JAVA_HOME = jhome } })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP buffer-local keymaps",
        callback = function(ev)
          local function m(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          m("<leader>cd", vim.lsp.buf.definition, "Go to definition")
          m("<leader>cD", vim.lsp.buf.references, "Find usages")
          m("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })
    end,
  },
}
