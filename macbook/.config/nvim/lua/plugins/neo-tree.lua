-- neo-tree: project files as a tree in a left sidebar. SPC o p toggles it
-- (Doom "open project sidebar"). Icons come from nvim-web-devicons, already
-- pulled in by oil. netrw hijack is disabled so oil stays the dir editor.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>op", "<cmd>Neotree toggle<CR>", desc = "Project tree" },
  },
  opts = {
    window = {
      position = "left",
      mappings = {
        ["<Tab>"] = "toggle_node", -- Tab expands/collapses the folder under cursor
      },
    },
    filesystem = {
      follow_current_file = { enabled = true }, -- track the active buffer
      use_libuv_file_watcher = true, -- live-refresh on external file changes
      hijack_netrw_behavior = "disabled", -- leave netrw/dirs to oil
    },
  },
}
