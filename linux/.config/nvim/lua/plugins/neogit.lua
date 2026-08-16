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
    -- The commit editor defaults to "tab"; open it as a split so it stays in the
    -- same tab as the Neogit status instead of spawning a new tab.
    commit_editor = {
      kind = "split",
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)
    -- Inside the Neogit status buffer, `mu` checks out the default branch and
    -- pulls --rebase (the git-cmum equivalent). It's a two-key sequence, so the
    -- default `m` (merge popup) waits briefly to see if a `u` follows.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitStatus",
      desc = "Neogit: mu = checkout default branch + rebase",
      callback = function(ev)
        vim.keymap.set("n", "mu", function()
          require("config.git").checkout_default_and_rebase()
        end, { buffer = ev.buf, desc = "Checkout default branch + rebase" })
      end,
    })
  end,
}
