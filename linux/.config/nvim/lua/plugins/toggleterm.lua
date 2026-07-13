-- toggleterm: terminals inside nvim. SPC t = terminal group.
--   SPC t t  floating terminal, 80% of the screen, over the buffers
--   SPC t s  bottom split, full width, pushes buffers up (30% height)
--   SPC t v  right split, 30% width, pushes buffers left
-- Distinct <count> per mapping = three independent, persistent terminals.
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.3)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.3)
      end
    end,
    float_opts = {
      width = function()
        return math.floor(vim.o.columns * 0.8)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.8)
      end,
    },
  },
  keys = {
    { "<leader>tt", "<cmd>1ToggleTerm direction=float<cr>", desc = "Terminal (float 80%)" },
    { "<leader>ts", "<cmd>2ToggleTerm direction=horizontal<cr>", desc = "Terminal (bottom split)" },
    { "<leader>tv", "<cmd>3ToggleTerm direction=vertical<cr>", desc = "Terminal (right split)" },
  },
}
