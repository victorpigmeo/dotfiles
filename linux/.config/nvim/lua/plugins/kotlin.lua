-- Kotlin LSP via JetBrains' kotlin-lsp (the official IntelliJ-engine server),
-- driven by the kotlin.nvim helper. Like jdtls, it is NOT started through
-- mason-lspconfig's auto-enable path: the helper launches it via its native
-- bin/intellij-server launcher and manages inlay hints / root detection. So this
-- file installs the mason package and EXCLUDES kotlin_lsp from auto-enable, then
-- lets kotlin.nvim start it. Requires kotlin-lsp v262.4739.0+ (bundled JRE, so no
-- separate JDK). Generic SPC c d/D/a/r keymaps still apply via lsp.lua's
-- LspAttach; SPC c f formats via conform.
--
-- One caveat: kotlin.nvim starts the client itself, so blink.cmp's extra
-- capabilities (advertised in lsp.lua via vim.lsp.config("*")) may not reach this
-- server. Completion still works; some resolve-detail niceties may not.

-- Kotlin owns its mason entry: install the kotlin-lsp package, but keep the
-- kotlin_lsp server out of auto-enable (kotlin.nvim starts it). opts function
-- that inits the lists then extends in place -- lazy runs fragments in filename
-- order and replaces list-valued table opts, so init defensively (same pattern
-- as jdtls.lua / typescript.lua).
local mason_kotlin = {
  "williamboman/mason-lspconfig.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    opts.automatic_enable = opts.automatic_enable or {}
    opts.automatic_enable.exclude = opts.automatic_enable.exclude or {}
    vim.list_extend(opts.ensure_installed, { "kotlin_lsp" })
    vim.list_extend(opts.automatic_enable.exclude, { "kotlin_lsp" })
  end,
}

local kotlin_nvim = {
  "AlexandrosAlexiou/kotlin.nvim",
  ft = "kotlin",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "stevearc/oil.nvim",
    "folke/trouble.nvim", -- required by kotlin.nvim (pulled in automatically)
  },
  opts = {
    -- Root at the true project root so multi-module Gradle/Maven builds resolve
    -- cross-module types: the wrapper + settings files live only at the root,
    -- unlike a submodule's own build.gradle(.kts) (which would root too deep).
    root_markers = {
      "settings.gradle",
      "settings.gradle.kts",
      "gradlew",
      "mvnw",
      "pom.xml",
    },
    -- Inlay hints on (kotlin.nvim default); toggle in its setup if too noisy.
    inlay_hints = { enabled = true },
  },
  config = function(_, opts)
    require("kotlin").setup(opts)
  end,
}

return { mason_kotlin, kotlin_nvim }
