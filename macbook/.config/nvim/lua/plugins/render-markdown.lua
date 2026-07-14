-- render-markdown: in-editor markdown rendering (headings, tables, code, lists,
-- checkboxes) via treesitter. No browser, no external binary. SPC m = markdown.
--   SPC m r  open current buffer as a rendered preview in a right vsplit (80%
--            width); press again to close the preview split.
-- The preview shows the SAME buffer, so edits on the left reflect live on the
-- right. render-markdown conceals markup in every window showing the buffer, so
-- the split reads as rendered output.
local preview_win

local function toggle_preview()
  if preview_win and vim.api.nvim_win_is_valid(preview_win) then
    vim.api.nvim_win_close(preview_win, false)
    preview_win = nil
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype ~= "markdown" then
    vim.notify("Not a markdown buffer", vim.log.levels.WARN)
    return
  end
  vim.cmd("botright vsplit")
  preview_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(preview_win, buf)
  vim.api.nvim_win_set_width(preview_win, math.floor(vim.o.columns * 0.8))
end

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {},
  keys = {
    { "<leader>mr", toggle_preview, desc = "Markdown render preview (right 80%)" },
  },
}
