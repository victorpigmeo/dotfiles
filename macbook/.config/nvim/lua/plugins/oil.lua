-- oil.nvim: edit the filesystem like a buffer. SPC f f = open parent dir.

-- Skip empty middle packages: when opening a directory, descend through any
-- chain of single-subdirectory folders (e.g. Java packages with no files of
-- their own) and land on the first directory that has files or more than one
-- entry. Only affects going DOWN (opening a dir); `-` (parent) is unchanged, so
-- you can still walk back up one level at a time.
local function first_nonempty(path)
  while true do
    local fd = vim.uv.fs_scandir(path)
    if not fd then
      break
    end
    local name, typ = vim.uv.fs_scandir_next(fd)
    if not name then
      break -- empty dir: stop here
    end
    if vim.uv.fs_scandir_next(fd) then
      break -- more than one entry: stop here
    end
    if typ ~= "directory" then
      break -- the single entry is a file: stop here
    end
    path = path .. "/" .. name
  end
  return path
end

-- <CR>: open a directory (skipping empty middle packages) or a file.
local function open_entry()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  local dir = oil.get_current_dir()
  if entry and dir and entry.type == "directory" then
    oil.open(first_nonempty(dir .. entry.name))
  else
    oil.select()
  end
end

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "<leader>ff", "<cmd>Oil<CR>", desc = "Open file explorer (oil)" },
  },
  opts = {
    view_options = { show_hidden = true },
    keymaps = {
      ["<CR>"] = { desc = "Open (skip empty packages) / open file", callback = open_entry },
    },
  },
}
