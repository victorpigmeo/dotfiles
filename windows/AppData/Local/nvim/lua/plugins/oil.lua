-- oil.nvim: edit the filesystem like a buffer. SPC f f = open parent dir.
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "<leader>ff", "<cmd>Oil<CR>", desc = "Open file explorer (oil)" },
  },
  opts = {
    view_options = { show_hidden = true },
  },
}
