-- Telescope fuzzy finder. SPC SPC = find files (Doom style).
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>sp", "<cmd>Telescope live_grep<CR>", desc = "Search project text" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
    { "<leader>bi", "<cmd>Telescope buffers<CR>", desc = "Buffer list" },
  },
  opts = {
    pickers = {
      -- rg --files respects .gitignore; avoids `find` fallback that lists ignored files
      find_files = {
        find_command = { "rg", "--files", "--color", "never" },
      },
    },
  },
}
