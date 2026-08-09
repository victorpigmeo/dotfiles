-- TOML support via taplo (Even Better TOML). Provides completion, hover, schema
-- validation and formatting for .toml files -- including Gradle's version catalog
-- (gradle/libs.versions.toml). mason installs taplo and mason-lspconfig
-- auto-enables it (see lsp.lua); the shared blink capabilities and SPC c keymaps
-- apply. SPC c f formats TOML via conform's LSP fallback (taplo). Parser: see
-- treesitter.lua (toml).
return {
  -- opts function that inits then extends in place (lazy replaces list-valued
  -- table opts and runs fragments in filename order, so init defensively).
  "williamboman/mason-lspconfig.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, { "taplo" })
  end,
}
