-- Telescope fuzzy finder. SPC SPC = find files (Doom style).
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Grep project" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
    { "<leader>bi", "<cmd>Telescope buffers<CR>", desc = "Buffer list" },
  },
  opts = {},
}
