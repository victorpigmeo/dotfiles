-- Async Gradle/Maven/npm actions with a statusline progress indicator, plus a
-- jdtls cache refresh so the Java LSP re-imports afterwards. Bound in
-- config/keymaps.lua under SPC j (java):
--   SPC j b  build the project (gradle: build -x test)
--   SPC j d  refresh jdtls only (re-read the build config) -- fast; use when
--            jdtls goes stale (e.g. a red import for a dep already on classpath)
--   SPC j D  refresh Gradle dependencies (--refresh-dependencies) THEN jdtls --
--            run after adding/removing a dependency so it lands on the classpath
-- The command runs as a background job; a spinner takes over the statusline
-- while it runs, then shows OK/FAILED for a few seconds. On failure the output
-- goes to the quickfix list (:copen). On SUCCESS jdtls is asked to re-read the
-- build config (update_projects_config) so new dependencies land on the
-- classpath -- without wiping the workspace or restarting the server.
local M = {}

-- SPC j b task; tests are skipped via -x test in build_cmd. Use "assemble" or
-- "compileJava" for an even lighter compile-only build.
local GRADLE_TASK = "build"

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local state = { running = false, timer = nil, saved = nil, frame = 1, gen = 0, overridden = false }

local function show(text)
  -- centre the message; escape % so the statusline parser treats it literally
  vim.o.statusline = "%=" .. text:gsub("%%", "%%%%") .. "%="
  vim.cmd("redrawstatus")
end

local function restore()
  vim.o.statusline = state.saved or ""
  state.overridden = false
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

-- Ask the running jdtls to re-read the build config and update the project's
-- classpath -- fast: no workspace wipe, no server restart -- so a newly added
-- dependency lands without a full re-import.
local function jdtls_reimport()
  if not next(vim.lsp.get_clients({ name = "jdtls" })) then
    return false
  end
  local ok, jdtls = pcall(require, "jdtls")
  if ok then
    -- select_mode = "all" updates every module without the "which project?" prompt
    pcall(jdtls.update_projects_config, { select_mode = "all" })
    vim.notify("jdtls project config updated", vim.log.levels.INFO)
    return true
  end
  return false
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
  state.gen = state.gen + 1
  local run_gen = state.gen
  -- Capture the real statusline only when we're not already showing our own
  -- message, so restore always goes back to the user's statusline, not a stale
  -- "OK/FAILED" line left over from a quick retry.
  if not state.overridden then
    state.saved = vim.o.statusline
    state.overridden = true
  end
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
        jdtls_reimport()
      else
        show("✗  " .. verb .. " FAILED (exit " .. code .. ") — :copen for errors")
        -- pcall so a setqflist error can never skip the restore scheduled below
        pcall(vim.fn.setqflist, {}, "r", { title = verb .. " " .. name, lines = out })
      end
      -- Only the latest run restores, so a retry within the 4s window can't
      -- leave a stale message stuck on the statusline.
      vim.defer_fn(function()
        if state.gen == run_gen then
          restore()
        end
      end, 4000)
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

-- SPC j d: ask jdtls to re-read the build config, nothing else. Fast (no Gradle
-- run) -- use when jdtls has gone stale but the deps are already resolved.
function M.refresh_jdtls()
  if not jdtls_reimport() then
    vim.notify("jdtls is not running for this buffer", vim.log.levels.WARN)
  end
end

-- SPC j D: force Gradle to re-resolve dependencies (after adding/removing one),
-- then refresh jdtls so the new deps land on its classpath.
function M.refresh_deps()
  local root = project_root()
  if not vim.uv.fs_stat(root .. "/gradlew") then
    vim.notify("No gradlew at " .. root .. " (refresh-dependencies is Gradle-only)", vim.log.levels.ERROR)
    return
  end
  run(root, { root .. "/gradlew", "dependencies", "--refresh-dependencies" }, "gradle", "Refreshing deps")
end

return M
