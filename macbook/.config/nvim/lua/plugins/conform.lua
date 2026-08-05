-- Formatting via conform.nvim. Java is formatted by the project's own Spotless,
-- so the result matches `gradlew spotlessCheck` exactly -- including its import
-- order -- rather than jdtls's Eclipse formatter. Spotless's IDE hook reads the
-- buffer on stdin and returns the formatted text on stdout. It runs only when a
-- Gradle root is found; otherwise (and for every non-Java filetype) SPC c f
-- falls back to the LSP formatter. SPC c f is bound in lsp.lua.
return {
  "stevearc/conform.nvim",
  lazy = true,
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
          -- ./gradlew must run from the Gradle root; require_cwd skips Spotless
          -- (so SPC c f falls back to the LSP formatter) when the file is not
          -- inside a Gradle project.
          cwd = util.root_file({ "settings.gradle", "settings.gradle.kts", "gradlew" }),
          require_cwd = true,
        },
      },
      formatters_by_ft = {
        java = { "spotless" },
      },
    }
  end,
}
