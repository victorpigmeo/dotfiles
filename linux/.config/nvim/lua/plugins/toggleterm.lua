-- toggleterm: terminals inside nvim. SPC t = terminal group.
--   SPC t t  floating terminal, 80% of the screen, over the buffers
--   SPC t s  bottom split, full width, pushes buffers up (30% height)
--   SPC t v  right split, 30% width, pushes buffers left
--   SPC t c  float 90%, runs claude code; toggle hides it (process stays alive)
--   SPC t T  terminal in its own tab ("Terminal"); closing the tab ends it
--   SPC t q  kill the active terminal, ending its process
-- Distinct <count> per mapping = three independent, persistent terminals.
-- SPC t T tabs join the project tab row; jump to them with Alt+1..9.

-- Dedicated Claude Code terminal. Built once, reused so toggle hides/shows the
-- same job instead of spawning a new one. close_on_exit=false keeps the buffer
-- if claude quits. Rebuilt if it was killed (e.g. via SPC t q).
local claude_term
local function toggle_claude()
  local tt = require("toggleterm.terminal")
  if not claude_term or not tt.get(claude_term.id, true) then
    claude_term = tt.Terminal:new({
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

-- Kill the active terminal outright: shutdown() closes the window, wipes the
-- buffer and stops the job. Prefer the focused terminal, else the last focused.
local function kill_terminal()
  local tt = require("toggleterm.terminal")
  local id = tt.get_focused_id()
  local term = (id and tt.get(id, true)) or tt.get_last_focused()
  if term then
    term:shutdown()
  else
    vim.notify("No active toggleterm terminal", vim.log.levels.WARN)
  end
end

-- Open a terminal in its own tab, like a project tab. The tabline shows
-- "Terminal" (reusing project.lua's tab-local `project_label`), and
-- bufhidden=wipe ends the job the instant the tab is closed. Alt+1..9 jump
-- between tabs (terminal-mode variants live in config/keymaps.lua).
local function terminal_in_tab()
  vim.cmd("tabnew")
  vim.api.nvim_tabpage_set_var(0, "project_label", "Terminal")
  vim.cmd("terminal")
  vim.bo.bufhidden = "wipe"
  vim.cmd("startinsert")
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
    { "<leader>tT", terminal_in_tab, desc = "Terminal (new tab)" },
    { "<leader>tc", toggle_claude, desc = "Terminal (Claude Code, 90%)" },
    { "<leader>tq", kill_terminal, desc = "Kill active terminal" },
  },
}
