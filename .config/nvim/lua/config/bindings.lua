-- split screen
vim.keymap.set("n", "<leader>wv", "<C-w>v<C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>ws", "<C-w>s<C-w>j", { noremap = true })

-- Navigate on split
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true })

-- Save & Quit
vim.keymap.set("n", "<leader>wq", ":q<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fs", ":w<CR>", { noremap = true })
vim.keymap.set("n", "<leader>qq", ":qa!<CR>", { noremap = true })

-- Return to normal mode on terminal with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Resize splits
vim.keymap.set("n", "<S-A-Left>", "<C-w><", { noremap = true })
vim.keymap.set("n", "+", "<C-w>+", { noremap = true })
vim.keymap.set("n", "-", "<C-w>-", { noremap = true })
vim.keymap.set("n", "<S-A-Right>", "<C-w>>", { noremap = true })
vim.keymap.set("n", "=", "<C-w>=", { noremap = true })

-- Move lines
vim.keymap.set({ "n", "i" }, "<A-Up>", ":move -2<CR>") -- move line up(n)
vim.keymap.set({ "n", "i" }, "<A-Down>", ":move +1<CR>") -- move line down(n)

-- Comments
-- To get the <C-/> char I:
-- Enter insert mode
-- C-v then C-/, and I copy the char that it inserted
vim.keymap.set("n", "", "gcc", { remap = true })
vim.keymap.set("v", "", "gc", { remap = true })
-- Delete entire word
vim.keymap.set("i", "", "<C-w>", { remap = true })

-- See `:help K` for why this keymap
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

--LSP Specific commands
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "<leader>cD", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
vim.keymap.set(
	"n",
	"<leader>cI",
	require("telescope.builtin").lsp_implementations,
	{ desc = "[G]oto [I]mplementation" }
)
-- See `:help K` for why this keymap
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { noremap = true })

vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { noremap = true })
