-- Git helpers used by config/keymaps.lua (SPC b c) and plugins/neogit.lua (mu).
local M = {}

-- The repo's default branch: origin/HEAD when set, else a local/remote main then
-- master, else "main".
local function default_branch()
  local head = vim.fn.systemlist({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
  if vim.v.shell_error == 0 and head[1] and head[1] ~= "" then
    return (head[1]:gsub("^origin/", ""))
  end
  for _, b in ipairs({ "main", "master" }) do
    vim.fn.system({ "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. b })
    if vim.v.shell_error == 0 then
      return b
    end
    vim.fn.system({ "git", "show-ref", "--verify", "--quiet", "refs/remotes/origin/" .. b })
    if vim.v.shell_error == 0 then
      return b
    end
  end
  return "main"
end

-- Check out the default branch and pull --rebase (the git-cmum equivalent).
-- Bound to `mu` inside the Neogit status buffer.
function M.checkout_default_and_rebase()
  local branch = default_branch()
  local co = vim.fn.system({ "git", "checkout", branch })
  if vim.v.shell_error ~= 0 then
    vim.notify("git checkout " .. branch .. " failed:\n" .. co, vim.log.levels.ERROR)
    return
  end
  local pull = vim.fn.system({ "git", "pull", "--rebase" })
  if vim.v.shell_error ~= 0 then
    vim.notify("git pull --rebase failed:\n" .. pull, vim.log.levels.ERROR)
    return
  end
  vim.notify("Checked out " .. branch .. " and pulled --rebase", vim.log.levels.INFO)
  local ok, neogit = pcall(require, "neogit")
  if ok and neogit.refresh then
    pcall(neogit.refresh) -- reflect the branch/log change if Neogit is open
  end
end

-- SPC b c: pick the base branch in a Telescope picker, prompt for the new branch
-- name at the command line, then `git checkout -b <name> <base>`.
function M.create_branch()
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope not available", vim.log.levels.ERROR)
    return
  end
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  builtin.git_branches({
    prompt_title = "Base branch (new branch starts here)",
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not entry then
          return
        end
        local base = entry.value
        vim.schedule(function()
          local name = vim.fn.input("New branch (from " .. base .. "): ")
          if not name or name == "" then
            return -- cancelled
          end
          local res = vim.fn.system({ "git", "checkout", "-b", name, base })
          if vim.v.shell_error ~= 0 then
            vim.notify("git checkout -b failed:\n" .. res, vim.log.levels.ERROR)
          else
            vim.notify("Created '" .. name .. "' from '" .. base .. "'", vim.log.levels.INFO)
          end
        end)
      end)
      return true
    end,
  })
end

return M
