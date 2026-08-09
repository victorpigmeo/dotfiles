-- Gradle build scripts. build.gradle is Groovy (filetype "groovy"); groovyls
-- provides language-level completion and hover. NOTE: no Neovim LSP understands
-- the Gradle DSL the way IntelliJ does, so completion is Groovy-language level,
-- not Gradle-plugin aware. build.gradle.kts (Kotlin) is not covered here.
-- Formatting is handled by Spotless in conform.lua (groovy -> spotless) when the
-- project configures Spotless for Gradle files. mason installs groovyls (a JVM
-- app -- needs a JDK, already required by jdtls) and mason-lspconfig auto-enables
-- it (see lsp.lua). Parser: see treesitter.lua (groovy).
return {
  "williamboman/mason-lspconfig.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, { "groovyls" })
  end,
}
