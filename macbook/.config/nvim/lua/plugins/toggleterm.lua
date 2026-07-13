-- toggleterm: terminals inside nvim. SPC t = terminal group.
--   SPC t t  floating terminal, 80% of the screen, over the buffers
--   SPC t s  bottom split, full width, pushes buffers up (30% height)
--   SPC t v  right split, 30% width, pushes buffers left
--   SPC t c  float 90%, runs claude code; toggle hides it (process stays alive)
-- Distinct <count> per mapping = three independent, persistent terminals.

-- Dedicated Claude Code terminal. Built once, reused so toggle hides/shows the
-- same job instead of spawning a new one. close_on_exit=false keeps the buffer
-- if claude quits.
local claude_term
local function toggle_claude()
  if not claude_term then
    claude_term = require("toggleterm.terminal").Terminal:new({
      cmd = "claude",
      direction = "float",
      close_on_exit = false,
      float_opts = {
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
      },
    })
  end
  claude_term:toggle()
end

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
    { "<leader>tc", toggle_claude, desc = "Terminal (Claude Code, 90%)" },
  },
}
