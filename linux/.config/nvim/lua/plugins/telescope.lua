-- Telescope fuzzy finder. SPC SPC = find files (Doom style).

-- Java files sit in deep package dirs. Shorten the displayed path: every
-- middle directory is cut to 3 chars, while the last directory and the
-- filename stay full. Matching still runs on the full path, so typing whole
-- package names filters as normal.
--   src/main/java/com/example/service/impl/UserServiceImpl.java
--   -> src/mai/jav/com/exa/ser/impl/UserServiceImpl.java
-- Non-Java paths are shown unchanged.
local function path_display(_, path)
  if not path:match("%.java$") then
    return path
  end
  local parts = vim.split(path, "/", { plain = true, trimempty = true })
  local n = #parts
  if n <= 2 then
    return path -- just a filename, or one dir + file: nothing to shorten
  end
  for i = 1, n - 2 do -- middle dirs -> first 3 chars; last dir + file stay full
    parts[i] = parts[i]:sub(1, 3)
  end
  return table.concat(parts, "/")
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim", -- vim.ui.select (code actions) via telescope
  },
  cmd = "Telescope",
  keys = {
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>sp", "<cmd>Telescope live_grep<CR>", desc = "Search project text" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
    { "<leader>bi", "<cmd>Telescope buffers<CR>", desc = "Buffer list" },
  },
  opts = {
    defaults = {
      path_display = path_display,
      -- Preview highlighting via built-in syntax, not treesitter: telescope 0.1.x
      -- calls the removed nvim-treesitter master API (ft_to_lang), which errors
      -- against the main branch (required for Neovim 0.12). Regex preview works.
      preview = { treesitter = false },
    },
    pickers = {
      -- rg --files respects .gitignore; avoids `find` fallback that lists ignored files
      find_files = {
        find_command = { "rg", "--files", "--color", "never" },
      },
    },
  },
  -- Route vim.ui.select (used by LSP code actions) through a Telescope dropdown,
  -- so it is navigable with the arrow keys instead of typed numbers.
  config = function(_, opts)
    opts.extensions = {
      ["ui-select"] = { require("telescope.themes").get_dropdown() },
    }
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("ui_select")
  end,
}
