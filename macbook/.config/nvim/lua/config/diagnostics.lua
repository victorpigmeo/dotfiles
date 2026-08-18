-- Diagnostics (LSP problems) list. Bound in config/keymaps.lua under SPC c x.
-- Collects every diagnostic across loaded buffers into the quickfix list and
-- opens it in a window at the bottom. Ordering: errors first (by severity), and
-- within each severity the CURRENT file's problems come first. In the list:
--   <CR>  jump to the problem's file/line
--   j / k move between problems (or n / N)
--   Q     close the list
local M = {}

-- quickfix `type` letter per diagnostic severity.
local function type_char(severity)
  local s = vim.diagnostic.severity
  return ({ [s.ERROR] = "E", [s.WARN] = "W", [s.INFO] = "I", [s.HINT] = "N" })[severity] or "E"
end

function M.show()
  local cur = vim.api.nvim_get_current_buf()
  local diags = vim.diagnostic.get(nil) -- all loaded buffers
  if vim.tbl_isempty(diags) then
    vim.notify("No diagnostics", vim.log.levels.INFO)
    return
  end

  -- Sort: severity first (ERROR=1 < WARN=2 < INFO=3 < HINT=4), then the current
  -- buffer ahead of others, then group by buffer and line.
  table.sort(diags, function(a, b)
    if a.severity ~= b.severity then
      return a.severity < b.severity
    end
    local a_cur, b_cur = a.bufnr == cur, b.bufnr == cur
    if a_cur ~= b_cur then
      return a_cur
    end
    if a.bufnr ~= b.bufnr then
      return a.bufnr < b.bufnr
    end
    return a.lnum < b.lnum
  end)

  local items = {}
  for _, d in ipairs(diags) do
    items[#items + 1] = {
      bufnr = d.bufnr,
      lnum = d.lnum + 1, -- diagnostics are 0-based; quickfix is 1-based
      col = d.col + 1,
      text = d.message,
      type = type_char(d.severity),
    }
  end

  vim.fn.setqflist({}, " ", { title = "Diagnostics", items = items })
  vim.cmd("botright copen") -- window at the bottom, spanning the full width
  local buf = vim.api.nvim_get_current_buf()
  local opts = { buffer = buf, nowait = true }

  -- q / Q close the list.
  vim.keymap.set("n", "q", "<cmd>cclose<CR>", vim.tbl_extend("force", opts, { desc = "Close diagnostics" }))
  vim.keymap.set("n", "Q", "<cmd>cclose<CR>", vim.tbl_extend("force", opts, { desc = "Close diagnostics" }))

  -- <CR> jumps to the problem under the cursor, then closes the list. The line
  -- number in the quickfix window is the entry index, so `<n>cc` jumps to it.
  vim.keymap.set("n", "<CR>", function()
    local line = vim.fn.line(".")
    vim.cmd(line .. "cc")
    vim.cmd("cclose")
  end, vim.tbl_extend("force", opts, { desc = "Jump to problem and close" }))
end

return M
