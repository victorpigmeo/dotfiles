-- Autocommands. See :h autocmd
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    -- vim.highlight was renamed vim.hl in nvim 0.11 (deprecation warning); fall
    -- back to the old name on older nvim.
    local hl = vim.hl or vim.highlight
    hl.on_yank()
  end,
})

-- Strip trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
