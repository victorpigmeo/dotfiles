-- Formatting via conform.nvim. Java is formatted by the project's own Spotless
-- when the project configures it, so the result matches `gradlew spotlessCheck`
-- exactly -- including its import order -- rather than jdtls's Eclipse formatter.
-- Spotless's IDE hook reads the buffer on stdin and returns the formatted text
-- on stdout. When the project has no Spotless (or the file is not in a Gradle
-- project), conform skips Java and SPC c f falls back to the LSP (jdtls)
-- formatter. SPC c f is a GLOBAL keymap defined here (not LspAttach-bound), so
-- it works even before/without an LSP attaching.

-- Enable Spotless only for Gradle projects that actually configure it: walk up
-- from the file and look for "spotless" in a build.gradle(.kts). Otherwise the
-- gradlew spotlessApply task doesn't exist and would error with no fallback.
local function has_spotless(ctx)
  local builds = vim.fs.find({ "build.gradle", "build.gradle.kts" }, {
    path = vim.fs.dirname(ctx.filename),
    upward = true,
    limit = math.huge,
  })
  for _, b in ipairs(builds) do
    local ok, lines = pcall(vim.fn.readfile, b)
    if ok and table.concat(lines, "\n"):find("spotless", 1, true) then
      return true
    end
  end
  return false
end

return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>cf",
      function()
        -- Java -> Spotless (conform); other filetypes / no-Spotless projects
        -- fall back to the LSP formatter.
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = function()
    local util = require("conform.util")
    return {
      formatters = {
        spotless = {
          command = "./gradlew",
          args = {
            "spotlessApply",
            "-PspotlessIdeHook=$FILENAME",
            "-PspotlessIdeHookUseStdIn",
            "-PspotlessIdeHookUseStdOut",
            "--quiet",
          },
          stdin = true,
          -- ./gradlew must run from the Gradle root.
          cwd = util.root_file({ "settings.gradle", "settings.gradle.kts", "gradlew" }),
          require_cwd = true,
          condition = function(_, ctx)
            return has_spotless(ctx)
          end,
        },
      },
      formatters_by_ft = {
        java = { "spotless" },
      },
    }
  end,
}
