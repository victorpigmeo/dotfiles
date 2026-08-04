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

-- SPC q — quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit without saving" })

-- Relative-line jump: type the count AFTER the prefix (relativenumber shows it).
--   lu<count>  jump <count> lines up      (== <count>k)
--   ld<count>  jump <count> lines down    (== <count>j)
-- The count is read live: fast-typed digits (lu52) are drained from the input
-- queue, so no terminator key is needed; a pause commits (lu5 then jump). Esc
-- cancels; a non-digit is replayed so no keystroke is lost.
--
-- read_relative_count is pure (input comes only from `next_char`) so it can be
-- unit-tested. next_char(true) blocks for the first key; next_char(false)
-- returns the next already-queued char or nil.
local function read_relative_count(next_char)
  local first = next_char(true)
  if first == nil or first == "\27" then -- nothing / Esc: cancel
    return nil
  end
  if not first:match("^%d$") then
    vim.api.nvim_feedkeys(first, "n", false) -- not a number: replay, abort
    return nil
  end
  local digits = first
  while true do
    local c = next_char(false) -- only chars already queued (fast typing)
    if c == nil then
      break
    elseif c:match("^%d$") then
      digits = digits .. c
    else
      vim.api.nvim_feedkeys(c, "n", false) -- non-digit: replay, stop
      break
    end
  end
  return tonumber(digits)
end

-- Default reader: blocking getcharstr for the first key, non-blocking getchar
-- for the rest of the queue.
local function getchar_reader(blocking)
  if blocking then
    return vim.fn.getcharstr()
  end
  if vim.fn.getchar(1) == 0 then
    return nil
  end
  local code = vim.fn.getchar(0)
  if code == 0 then
    return nil
  end
  return type(code) == "number" and vim.fn.nr2char(code) or code
end

local function relative_jump(dir)
  local n = read_relative_count(getchar_reader)
  if n and n > 0 then
    vim.cmd("normal! " .. n .. (dir == "up" and "k" or "j"))
  end
end

map("n", "lu", function()
  relative_jump("up")
end, { desc = "Jump <count> relative lines up" })
map("n", "ld", function()
  relative_jump("down")
end, { desc = "Jump <count> relative lines down" })
