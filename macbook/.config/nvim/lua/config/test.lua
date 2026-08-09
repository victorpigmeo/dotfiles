-- Run Java (Gradle) tests without leaving the editor. Bound in
-- config/keymaps.lua under SPC j (java):
--   SPC j t  run the test method (or class) under the cursor
--   SPC j r  re-run the last test (no-op if none has run yet)
-- Treesitter resolves the fully-qualified target at the cursor, then
-- `./gradlew cleanTest test --tests <fqn>` runs it. Output opens in a scratch
-- window on the right (30% wide); press q or Esc in it to close.
local M = {}

local state = { last = nil, job = nil }

-- ---- output window -------------------------------------------------------
local out = { win = nil, buf = nil, prev = nil }

local function close_output()
  local prev = out.prev
  if out.win and vim.api.nvim_win_is_valid(out.win) then
    vim.api.nvim_win_close(out.win, true)
  end
  out.win = nil
  if prev and vim.api.nvim_win_is_valid(prev) then
    vim.api.nvim_set_current_win(prev)
  end
end

local function ensure_output()
  if not (out.buf and vim.api.nvim_buf_is_valid(out.buf)) then
    out.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[out.buf].bufhidden = "hide"
    vim.keymap.set("n", "q", close_output, { buffer = out.buf, nowait = true, desc = "Close test output" })
    vim.keymap.set("n", "<Esc>", close_output, { buffer = out.buf, nowait = true, desc = "Close test output" })
  end
  if not (out.win and vim.api.nvim_win_is_valid(out.win)) then
    out.prev = vim.api.nvim_get_current_win()
    vim.cmd("botright vsplit") -- full-height split on the far right (focused)
    out.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(out.win, out.buf)
    vim.api.nvim_win_set_width(out.win, math.max(30, math.floor(vim.o.columns * 0.3)))
    local wo = vim.wo[out.win]
    wo.number = false
    wo.relativenumber = false
    wo.signcolumn = "no"
    wo.wrap = false
  end
end

local function render(lines)
  ensure_output()
  vim.bo[out.buf].modifiable = true
  vim.api.nvim_buf_set_lines(out.buf, 0, -1, false, lines)
  vim.bo[out.buf].modifiable = false
  if out.win and vim.api.nvim_win_is_valid(out.win) then
    pcall(vim.api.nvim_win_set_cursor, out.win, { vim.api.nvim_buf_line_count(out.buf), 0 })
  end
end

-- ---- nearest test target -------------------------------------------------
-- Returns "pkg.Class.method" when the cursor is inside a method, else
-- "pkg.Class", or nil if it can't be resolved. Uses the nearest enclosing
-- method and the OUTERMOST class (top-level test classes are the common case).
local function test_target()
  if vim.bo.filetype ~= "java" then
    return nil
  end
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return nil
  end
  local method, class
  local n = node
  while n do
    local t = n:type()
    if not method and t == "method_declaration" then
      local name = n:field("name")[1]
      if name then
        method = vim.treesitter.get_node_text(name, 0)
      end
    elseif t == "class_declaration" or t == "record_declaration" then
      local name = n:field("name")[1]
      if name then
        class = vim.treesitter.get_node_text(name, 0) -- keep climbing: last = outermost
      end
    end
    n = n:parent()
  end
  if not class then
    return nil
  end
  local pkg
  for child in node:tree():root():iter_children() do
    if child:type() == "package_declaration" then
      pkg = vim.treesitter.get_node_text(child, 0):match("package%s+([%w%.]+)")
      break
    end
  end
  local fqn = pkg and (pkg .. "." .. class) or class
  if method then
    return fqn .. "." .. method, method
  end
  return fqn, class
end

-- ---- run -----------------------------------------------------------------
local function gradle_root()
  return vim.fs.root(0, { "gradlew", "settings.gradle", "settings.gradle.kts" })
end

local function run(root, target, label)
  if state.job then
    vim.notify("A test is already running", vim.log.levels.WARN)
    return
  end
  -- cleanTest forces re-run across Gradle versions; --tests filters to our fqn.
  local cmd = { root .. "/gradlew", "cleanTest", "test", "--tests", target, "--console=plain" }
  render({ "▶ Running " .. label, "  " .. target, "", "  running gradle…" })
  local output = {}
  state.job = vim.fn.jobstart(cmd, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, d)
      if d then
        vim.list_extend(output, d)
      end
    end,
    on_stderr = function(_, d)
      if d then
        vim.list_extend(output, d)
      end
    end,
    on_exit = function(_, code)
      state.job = nil
      local lines = { "▶ " .. label, "  " .. target, "" }
      vim.list_extend(lines, output)
      lines[#lines + 1] = ""
      lines[#lines + 1] = code == 0 and "✓ PASSED" or ("✗ FAILED (exit " .. code .. ")")
      render(lines)
    end,
  })
  state.last = { root = root, target = target, label = label }
end

function M.run_nearest()
  local root = gradle_root()
  if not root then
    vim.notify("No Gradle project (gradlew) found for this file", vim.log.levels.ERROR)
    return
  end
  local target, name = test_target()
  if not target then
    vim.notify("No test method/class at the cursor (open a .java test file)", vim.log.levels.WARN)
    return
  end
  run(root, target, name or target)
end

function M.run_last()
  if not state.last then
    vim.notify("No test has been run yet", vim.log.levels.INFO)
    return -- no-op
  end
  run(state.last.root, state.last.target, state.last.label)
end

return M
