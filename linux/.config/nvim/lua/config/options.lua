-- Core editor options. See :h vim.opt
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
