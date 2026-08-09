-- Async Gradle/Maven/npm actions with a statusline progress indicator, plus a
-- jdtls cache refresh so the Java LSP re-imports afterwards. Bound in
-- config/keymaps.lua under SPC j (java):
--   SPC j b  build the project (gradle: build -x test)
--   SPC j d  refresh Gradle dependencies (--refresh-dependencies) -- run after
--            adding/removing a dependency so jdtls picks it up
-- The command runs as a background job; a spinner takes over the statusline
-- while it runs, then shows OK/FAILED for a few seconds. On failure the output
-- goes to the quickfix list (:copen). On SUCCESS the jdtls workspace cache is
-- wiped and loaded, unmodified Java buffers are reloaded so jdtls re-imports
-- with the fresh classpath.
local M = {}

-- SPC j b task; tests are skipped via -x test in build_cmd. Use "assemble" or
-- "compileJava" for an even lighter compile-only build.
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

local function project_root()
  return vim.fs.root(0, {
    "settings.gradle",
    "settings.gradle.kts",
    "gradlew",
    "pom.xml",
    "mvnw",
    "package.json",
    ".git",
  }) or vim.fn.getcwd()
end

-- Wipe the jdtls workspace cache and restart jdtls on open Java buffers so it
-- re-imports with the current classpath (e.g. a newly added dependency).
-- Unmodified buffers only, so no unsaved work is lost.
local function refresh_jdtls()
  for _, c in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
    vim.lsp.stop_client(c.id, true)
  end
  vim.fn.delete(vim.fn.stdpath("cache") .. "/jdtls", "rf")
  vim.defer_fn(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].filetype == "java"
        and not vim.bo[buf].modified
        and vim.api.nvim_buf_get_name(buf) ~= ""
      then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("edit")
        end)
      end
    end
    vim.notify("jdtls cache cleared — re-importing project", vim.log.levels.INFO)
  end, 300)
end

-- Run an async job from the project root: spinner on the statusline, quickfix on
-- failure, jdtls refresh on success. The wrappers are absolute paths because
-- jobstart's executable check runs against Neovim's cwd, not the job's cwd.
local function run(root, cmd, tool, verb)
  if state.running then
    vim.notify("A build/refresh is already running", vim.log.levels.WARN)
    return
  end
  state.running = true
  state.saved = vim.o.statusline
  state.frame = 1
  local name = vim.fs.basename(root)
  local out = {}

  state.timer = vim.fn.timer_start(100, function()
    state.frame = state.frame % #spinner + 1
    show(spinner[state.frame] .. "  " .. verb .. " " .. name .. " (" .. tool .. ")…")
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
        show("✓  " .. verb .. " OK — " .. name .. "; refreshing jdtls…")
        refresh_jdtls()
      else
        show("✗  " .. verb .. " FAILED (exit " .. code .. ") — :copen for errors")
        vim.fn.setqflist({}, "r", { title = verb .. " " .. name, lines = out })
      end
      vim.defer_fn(restore, 4000)
    end,
  })
end

-- gradle/maven/npm wrapper for the build task.
local function build_cmd(root)
  local has = function(p)
    return vim.uv.fs_stat(root .. "/" .. p) ~= nil
  end
  if has("gradlew") then
    return { root .. "/gradlew", GRADLE_TASK, "-x", "test" }, "gradle"
  elseif has("mvnw") then
    return { root .. "/mvnw", "compile" }, "maven"
  elseif has("pom.xml") then
    return { "mvn", "compile" }, "maven"
  elseif has("package.json") then
    return { "npm", "run", "build" }, "npm"
  end
  return nil
end

function M.build()
  local root = project_root()
  local cmd, tool = build_cmd(root)
  if not cmd then
    vim.notify("No gradle/maven/npm build tool found at " .. root, vim.log.levels.ERROR)
    return
  end
  run(root, cmd, tool, "Building")
end

-- Force Gradle to re-resolve dependencies (after adding/removing one), then
-- refresh jdtls so the new deps land on its classpath.
function M.refresh_deps()
  local root = project_root()
  if not vim.uv.fs_stat(root .. "/gradlew") then
    vim.notify("No gradlew at " .. root .. " (refresh-dependencies is Gradle-only)", vim.log.levels.ERROR)
    return
  end
  run(root, { root .. "/gradlew", "dependencies", "--refresh-dependencies" }, "gradle", "Refreshing deps")
end

return M
