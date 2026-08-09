-- dressing.nvim overrides vim.ui.select and vim.ui.input, so LSP code actions
-- (SPC c a) and other menus are navigable with the arrow keys instead of the
-- default numbered command-line prompt. Select prefers a telescope picker
-- (consistent with the other finders) and falls back to a builtin floating
-- menu. Unlike telescope-ui-select, dressing patches vim.ui directly, which
-- takes reliably in this setup.
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    select = {
      backend = { "telescope", "builtin" },
    },
  },
}
