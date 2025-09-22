-- Disable mouse integration
vim.opt.mouse = ""
vim.opt.guicursor = ""

-- Enable line numbers and relative numbers
vim.opt.nu = true
vim.opt.relativenumber = false

-- Indent options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartindent = true

-- Show line for max columns
vim.opt.colorcolumn = "80"

-- Misc
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.updatetime = 50

-- Map leader to space
vim.g.mapleader = " "

-- Enable clipboard yanking and pasting
vim.o.clipboard = "unnamedplus"

-- Disable backup writing
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Highlight current line
vim.opt.cursorline = true

-- Change cursor according to mouse
-- vim.opt.guicursor = "n-c-v:block-nCursor,i-ci:ver30-nCursor"
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25"
