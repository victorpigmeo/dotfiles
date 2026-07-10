-- split screen
vim.keymap.set("n", "<leader>wv", "<C-w>v<C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>ws", "<C-w>s<C-w>j", { noremap = true })

-- Navigate on split
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<leader>wb", "<C-w>b", { noremap = true })
vim.keymap.set("n", "<leader>wt", "<C-w>t", { noremap = true })
--Move windows
vim.keymap.set("n", "<leader>wL", "<C-w>L", { noremap = true })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { noremap = true })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { noremap = true })
vim.keymap.set("n", "<leader>wH", "<C-w>H", { noremap = true })

--Navigate on buffer
-- Go to matching bracket
vim.keymap.set("n", "<tab>", "%", { noremap = true })

-- Save & Quit
vim.keymap.set("n", "<leader>wq", ":q<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fs", ":w<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ps", ":wa<CR>", { noremap = true })
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
vim.keymap.set({ "n", "i" }, "<A-Up>", ":move -2<CR>", { noremap = true }) -- move line up(n)
vim.keymap.set({ "n", "i" }, "<A-Down>", ":move +1<CR>", { noremap = true }) -- move line down(n)

-- Navigate on buffer
-- <M-O>d corresponds to <C-Left> and <M-O>c to <C-Right>
vim.keymap.set({ "n", "i" }, "<M-O>d", "<C-o>b", { remap = true })
vim.keymap.set({ "n", "i" }, "<M-O>c", "<C-o>w", { remap = true })
-- Delete entire word
vim.keymap.set("i", "", "<C-w>", { remap = true })
-- TerminalToggle
vim.keymap.set("n", "<leader>tt", ":ToggleTerm size=12 name=Terminal direction=float<CR>", { noremap = true })
vim.keymap.set(
	"n",
	"<leader>tv",
	":ToggleTerm size=12 name=Terminal direction=vertical size=80<CR>",
	{ noremap = true }
)
vim.keymap.set("n", "<leader>ts", ":ToggleTerm size=12 name=Terminal direction=horizontal<CR>", { noremap = true })

-- Comments
-- To get the <C-/> char I:
-- Enter insert mode
-- C-v then C-/, and I copy the char that it inserted
vim.keymap.set("n", "", "gcc", { remap = true })
vim.keymap.set("v", "", "gc", { remap = true })

--LSP Specific commands
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
vim.keymap.set("n", "<leader>cd", require("telescope.builtin").lsp_definitions, { desc = "[G]oto [D]efinition" })
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

-- Neogit
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { noremap = true })

--Nvim tree
vim.keymap.set("n", "<leader>op", ":NvimTreeToggle<CR>", { noremap = true })

--Flutter
vim.keymap.set("n", ",fd", ":FlutterDevices<CR>", { noremap = true })
vim.keymap.set("n", ",fr", ":FlutterReload<CR>", { noremap = true })
vim.keymap.set("n", ",fR", ":FlutterRestart<CR>", { noremap = true })
vim.keymap.set("n", ",fg", ":FlutterPubGet<CR>", { noremap = true })
vim.keymap.set("n", ",fq", ":FlutterQuit<CR>", { noremap = true })

--Java
-- vim.keymap.set("n", ",tt", ":JavaTestDebugCurrentMethod<CR>", { noremap = true })
-- vim.keymap.set("n", ",tc", ":JavaTestDebugCurrentClass<CR>", { noremap = true })
-- vim.keymap.set("n", ",jr", ":JavaRunnerRunMain<CR>", { noremap = true })
