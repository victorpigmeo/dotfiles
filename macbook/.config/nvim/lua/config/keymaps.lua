-- Doom Emacs style keymaps: Space is leader, mnemonic prefix groups.
-- Plugin-provided actions (find file, git, search) are mapped in their specs.
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Terminal: double-Esc leaves insert mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal insert mode" })

-- Terminal: Alt+1..9 jump to tab N without leaving terminal mode first, so a
-- terminal tab navigates like a project tab (normal-mode Alt+N is in project.lua).
for i = 1, 9 do
  map("t", ("<A-%d>"):format(i), ([[<C-\><C-n>%dgt]]):format(i), { desc = "Go to tab " .. i })
end

-- Move selected lines (J/K, plus Alt+Down/Up)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Move the current line with Alt+Up/Down in insert (edit) and normal mode.
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up" })

-- Toggle comment on the visual selection with Ctrl+/ (terminals may send C-_)
map("x", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
map("x", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })

-- SPC w — window
map("n", "<leader>ws", "<C-w>s", { desc = "Split window below" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split window right" })
map("n", "<leader>wq", "<C-w>c", { desc = "Delete window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Delete other windows" })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })

-- SPC b — buffer
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bk", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to other buffer" })

-- SPC f — file
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>fS", "<cmd>wa<CR>", { desc = "Save all files" })

-- SPC j — java: build / Gradle, each refreshes the jdtls cache on success
map("n", "<leader>jb", function()
  require("config.build").build()
end, { desc = "Build project" })
map("n", "<leader>jd", function()
  require("config.build").refresh_deps()
end, { desc = "Refresh Gradle dependencies" })

-- SPC p — project (group also populated in plugins/project.lua)
map("n", "<leader>ps", "<cmd>wa<CR>", { desc = "Save all project files" })

-- SPC q — quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit without saving" })
