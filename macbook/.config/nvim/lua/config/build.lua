-- Async project build with a statusline progress indicator. SPC c b (mapped in
-- config/keymaps.lua) runs the project's build tool -- gradle / maven / npm,
-- auto-detected from the root -- as a background job. A spinner takes over the
-- statusline while it runs, then shows OK / FAILED for a few seconds. On failure
-- the captured output goes to the quickfix list (:copen) so errors are navigable.
local M = {}

-- Gradle task for "build". Swap to "assemble" or "compileJava" for a
-- compile-only build (no tests).
local GRADLE_TASK = "build"

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local state = { running = false, timer = nil, saved = nil, frame = 1 }

local function show(text)
  -- centre the message; escape % so the statusline parser treats it literally
  vim.o.statusline = "%=" .. text:gsub("%%", "%%%%") .. "%="
  vim.cmd("redrawstatus")
end

local function restore()
  vim.o.statusline = state.saved or ""
  vim.cmd("redrawstatus")
end

-- Pick a build command from the tooling present at the project root.
local function build_cmd(root)
  local has = function(p)
    return vim.uv.fs_stat(root .. "/" .. p) ~= nil
  end
  if has("gradlew") then
    return { "./gradlew", GRADLE_TASK }, "gradle"
  elseif has("mvnw") then
    return { "./mvnw", "compile" }, "maven"
  elseif has("pom.xml") then
    return { "mvn", "compile" }, "maven"
  elseif has("package.json") then
    return { "npm", "run", "build" }, "npm"
  end
  return nil
end

function M.build()
  if state.running then
    vim.notify("Build already running", vim.log.levels.WARN)
    return
  end

  local root = vim.fs.root(0, {
    "settings.gradle",
    "settings.gradle.kts",
    "gradlew",
    "pom.xml",
    "mvnw",
    "package.json",
    ".git",
  }) or vim.fn.getcwd()

  local cmd, tool = build_cmd(root)
  if not cmd then
    vim.notify("No gradle/maven/npm build tool found at " .. root, vim.log.levels.ERROR)
    return
  end

  state.running = true
  state.saved = vim.o.statusline
  state.frame = 1
  local name = vim.fs.basename(root)
  local out = {}

  state.timer = vim.fn.timer_start(100, function()
    state.frame = state.frame % #spinner + 1
    show(spinner[state.frame] .. "  Building " .. name .. " (" .. tool .. ")…")
  end, { ["repeat"] = -1 })

  vim.fn.jobstart(cmd, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, d)
      if d then
        vim.list_extend(out, d)
      end
    end,
    on_stderr = function(_, d)
      if d then
        vim.list_extend(out, d)
      end
    end,
    on_exit = function(_, code)
      state.running = false
      if state.timer then
        vim.fn.timer_stop(state.timer)
        state.timer = nil
      end
      if code == 0 then
        show("✓  Build OK — " .. name)
      else
        show("✗  Build FAILED (exit " .. code .. ") — :copen for errors")
        vim.fn.setqflist({}, "r", { title = "Build " .. name, lines = out })
      end
      vim.defer_fn(restore, 4000)
    end,
  })
end

return M
