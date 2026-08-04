-- project.nvim: track project roots; open each project as its own tab.
-- One project per tabpage, each with a tab-local cwd (:tcd).
--   SPC p o  pick a known project -> opens in a NEW tab (oil at its root)
--   SPC p w  pick a git worktree of the current repo -> opens in a NEW tab
--   SPC p q  close the current project (tabpage)
--   Alt+1..9 switch to project (tab) N
-- SPC p group is declared in which-key ("project").
return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    -- main module is "project_nvim" despite the repo name.
    require("project_nvim").setup({
      -- keep auto-cd tab-local so each project tab holds its own cwd
      scope_chdir = "tab",
      detection_methods = { "pattern", "lsp" },
      patterns = {
        ".git",
        "package.json",
        "Cargo.toml",
        "go.mod",
        "pom.xml",
        "build.gradle",
        "settings.gradle",
        ".root",
      },
    })

    -- Open a folder as a project: new tab, tab-local cwd, oil at the root.
    local function open_project_in_tab(path)
      if not path or path == "" then
        return
      end
      vim.cmd("tabnew")
      vim.cmd("tcd " .. vim.fn.fnameescape(path))
      require("oil").open(path)
    end

    -- Telescope picker of recent projects (most recent first); the chosen
    -- project opens in a new tab.
    local function pick_project()
      local recents = require("project_nvim").get_recent_projects()
      local items = {}
      for i = #recents, 1, -1 do
        table.insert(items, recents[i])
      end
      if vim.tbl_isempty(items) then
        vim.notify("No known projects yet (visit a project root first)", vim.log.levels.INFO)
        return
      end
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      pickers
        .new({}, {
          prompt_title = "Projects",
          finder = finders.new_table({ results = items }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(bufnr)
            actions.select_default:replace(function()
              actions.close(bufnr)
              local entry = action_state.get_selected_entry()
              open_project_in_tab(entry and entry[1])
            end)
            return true
          end,
        })
        :find()
    end

    -- Parse `git worktree list --porcelain` into { path, branch } entries.
    local function list_worktrees(cwd)
      local out = vim.fn.systemlist({ "git", "-C", cwd, "worktree", "list", "--porcelain" })
      if vim.v.shell_error ~= 0 then
        return nil
      end
      local trees, cur = {}, nil
      for _, line in ipairs(out) do
        if line:match("^worktree ") then
          cur = { path = line:sub(10), branch = "(detached)" }
          table.insert(trees, cur)
        elseif cur and line:match("^branch ") then
          cur.branch = line:gsub("^branch refs/heads/", "")
        elseif cur and line == "bare" then
          cur.branch = "(bare)"
        end
      end
      return trees
    end

    -- Telescope picker of the current repo's worktrees; the chosen one opens
    -- in a new tab (same as opening a project).
    local function pick_worktree()
      local trees = list_worktrees(vim.fn.getcwd())
      if not trees then
        vim.notify("Not inside a git repository", vim.log.levels.WARN)
        return
      end
      if vim.tbl_isempty(trees) then
        vim.notify("No worktrees found", vim.log.levels.INFO)
        return
      end
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      pickers
        .new({}, {
          prompt_title = "Git worktrees",
          finder = finders.new_table({
            results = trees,
            entry_maker = function(t)
              return {
                value = t.path,
                display = string.format("%-24s %s", t.branch, t.path),
                ordinal = t.branch .. " " .. t.path,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(bufnr)
            actions.select_default:replace(function()
              actions.close(bufnr)
              local entry = action_state.get_selected_entry()
              open_project_in_tab(entry and entry.value)
            end)
            return true
          end,
        })
        :find()
    end

    vim.keymap.set("n", "<leader>po", pick_project, { desc = "Open project (new tab)" })
    vim.keymap.set("n", "<leader>pw", pick_worktree, { desc = "Switch git worktree (new tab)" })
    vim.keymap.set("n", "<leader>pq", "<cmd>tabclose<CR>", { desc = "Close project (tab)" })
    for i = 1, 9 do
      vim.keymap.set("n", ("<A-%d>"):format(i), ("%dgt"):format(i), { desc = "Go to project " .. i })
    end
  end,
}
