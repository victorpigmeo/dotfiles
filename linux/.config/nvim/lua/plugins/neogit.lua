-- Neogit magit-style git UI. SPC g g = open (Doom style).
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit status" },
  },
  opts = {
    -- Open the status in the current window (same project tab) instead of a new
    -- tab. Neogit restores the previous buffer when the status is closed.
    kind = "replace",
  },
}
