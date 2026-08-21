-- Run Java (Gradle) tests without leaving the editor. Bound in
-- config/keymaps.lua under SPC j (java):
--   SPC j t  run the test method (or class) under the cursor
--   SPC j r  re-run the last test (no-op if none has run yet)
-- Treesitter resolves the fully-qualified target at the cursor, then
-- `./gradlew cleanTest test --tests <fqn>` runs it in a TERMINAL split on the
-- right (40% wide) -- a pty, so Gradle keeps its colours and streams live. A
-- Gradle init script turns on full test-failure logging so the assertion
-- message + stack trace show (not just "FAILED"). Press q or Esc to close.
local M = {}

local state = { last = nil, job = nil }
local out = { win = nil, buf = nil, prev = nil }

-- Gradle init script (rewritten each run) that enables full test-failure output.
local function init_script()
  local path = vim.fn.stdpath("cache") .. "/nvim-gradle-test-logging.gradle"
  local f = io.open(path, "w")
  if f then
    f:write([[
allprojects {
    tasks.withType(Test).configureEach {
        testLogging {
            events "failed"
            exceptionFormat "full"
            showExceptions true
            showCauses true
            showStackTraces true
        }
    }
}
]])
    f:close()
  end
  return path
end

-- ---- output window -------------------------------------------------------
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

local function open_window()
  if not (out.win and vim.api.nvim_win_is_valid(out.win)) then
    out.prev = vim.api.nvim_get_current_win()
    vim.cmd("botright vsplit") -- full-height split on the far right (focused)
    out.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_width(out.win, math.max(40, math.floor(vim.o.columns * 0.4)))
    local wo = vim.wo[out.win]
    wo.number = false
    wo.relativenumber = false
    wo.signcolumn = "no"
    wo.wrap = true -- wrap long lines (stack traces) instead of truncating off-screen
  else
    vim.api.nvim_set_current_win(out.win)
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

-- Gradle project prefix for the current file's module, e.g. ":optimizer:". A
-- multi-module build must qualify the task (":optimizer:test") -- an unqualified
-- "test" runs every module, and modules without the --tests match fail with
-- "No tests found for given includes". Empty for a single-module build (build
-- file at the Gradle root), so tasks stay unqualified there.
local function module_prefix(root)
  local module_dir = vim.fs.root(0, { "build.gradle", "build.gradle.kts" })
  if not module_dir or module_dir == root then
    return ""
  end
  return ":" .. module_dir:sub(#root + 2):gsub("/", ":") .. ":"
end

local function run(root, tasks, target, label, info)
  if state.job then
    vim.notify("A test is already running", vim.log.levels.WARN)
    return
  end
  -- tasks are module-qualified (":optimizer:cleanTest", ":optimizer:test");
  -- cleanTest forces re-run across Gradle versions; --tests filters to our fqn;
  -- --init-script turns on full failure logging. No --console: in the pty Gradle
  -- auto-detects a terminal and emits colour. `info` adds --info (SPC j T) to
  -- surface Gradle's INFO logs (test lifecycle, skipped reasons, etc).
  -- -x jacocoTestCoverageVerification: builds that finalize `test` with the
  -- coverage gate fail a single-test run (one test can't meet a whole-module
  -- threshold), so exclude it here.
  local cmd = { root .. "/gradlew" }
  vim.list_extend(cmd, tasks)
  vim.list_extend(cmd, { "--tests", target, "--init-script", init_script() })
  vim.list_extend(cmd, { "-x", "jacocoTestCoverageVerification" })
  if info then
    table.insert(cmd, "--info")
  end

  open_window() -- sized before the job so the pty gets the right width
  local old = out.buf
  out.buf = vim.api.nvim_create_buf(false, false) -- empty buffer for the terminal
  vim.api.nvim_win_set_buf(out.win, out.buf)
  vim.api.nvim_set_current_win(out.win)
  if old and vim.api.nvim_buf_is_valid(old) then
    pcall(vim.api.nvim_buf_delete, old, { force = true }) -- don't pile up terminals
  end

  state.job = vim.fn.jobstart(cmd, {
    term = true, -- run in a pty so Gradle keeps its colours and streams live
    cwd = root,
    on_exit = function()
      state.job = nil
    end,
  })
  vim.cmd("stopinsert") -- stay in normal mode so q / Esc close the window

  vim.keymap.set("n", "q", close_output, { buffer = out.buf, nowait = true, desc = "Close test output" })
  vim.keymap.set("n", "<Esc>", close_output, { buffer = out.buf, nowait = true, desc = "Close test output" })

  state.last = { root = root, tasks = tasks, target = target, label = label, info = info }
end

-- Run the test at the cursor. `info` (SPC j T) adds --info for verbose Gradle
-- logs; without it (SPC j t) the run stays quiet.
function M.run_nearest(info)
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
  local prefix = module_prefix(root)
  local tasks = { prefix .. "cleanTest", prefix .. "test" }
  run(root, tasks, target, name or target, info)
end

function M.run_last()
  if not state.last then
    vim.notify("No test has been run yet", vim.log.levels.INFO)
    return -- no-op
  end
  run(state.last.root, state.last.tasks, state.last.target, state.last.label, state.last.info)
end

return M
