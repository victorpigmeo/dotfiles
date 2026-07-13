-- Doom Emacs style keymaps: Space is leader, mnemonic prefix groups.
-- Plugin-provided actions (find file, git, search) are mapped in their specs.
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Terminal: double-Esc leaves insert mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal insert mode" })

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- SPC w — window
map("n", "<leader>ws", "<C-w>s", { desc = "Split window below" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split window right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Delete other windows" })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })

-- SPC b — buffer
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to other buffer" })

-- SPC f — file
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>fS", "<cmd>wa<CR>", { desc = "Save all files" })

-- SPC q — quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit without saving" })
