-- fidget.nvim: unobtrusive notifications + LSP progress in the bottom-right.
-- Two jobs here:
--   * override vim.notify so our messages (e.g. "jdtls project config updated",
--     "jdtls is not running") show as a lingering colored toast instead of a
--     single flash on the message line.
--   * show LSP progress spinners while jdtls / kotlin-lsp index a project.
-- Loaded on VeryLazy so the notify override is in place for anything after
-- startup, and early enough to catch LSP progress.
return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  opts = {
    notification = {
      override_vim_notify = true, -- route vim.notify through fidget
    },
  },
}
