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

    -- Build a tab label for a path: "Project" for the main worktree, or
    -- "Project (worktree-dir)" for a linked worktree. The main worktree is the
    -- first entry of `git worktree list`. Non-git paths fall back to the dir
    -- name. Computed once at open time, then cached as a tab-local var.
    local function tab_label_for(path)
      local this = vim.fn.fnamemodify(path, ":t")
      local wl = vim.fn.systemlist({ "git", "-C", path, "worktree", "list", "--porcelain" })
      if vim.v.shell_error ~= 0 then
        return this
      end
      local main
      for _, l in ipairs(wl) do
        local p = l:match("^worktree (.+)")
        if p then
          main = p
          break
        end
      end
      local project = main and vim.fn.fnamemodify(main, ":t") or this
      if this == project then
        return project
      end
      return string.format("%s (%s)", project, this)
    end

    -- Open a folder as a project: new tab, tab-local cwd, labelled, oil at root.
    local function open_project_in_tab(path)
      if not path or path == "" then
        return
      end
      vim.cmd("tabnew")
      vim.cmd("tcd " .. vim.fn.fnameescape(path))
      vim.api.nvim_tabpage_set_var(0, "project_label", tab_label_for(path))
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

    -- Tabline: show each tab's "Project (worktree)" label (set at open time),
    -- falling back to the tab-local cwd's dir name for tabs opened another way.
    function _G.ProjectTabline()
      local parts = {}
      local current = vim.api.nvim_get_current_tabpage()
      for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local hl = (tab == current) and "%#TabLineSel#" or "%#TabLine#"
        local ok, label = pcall(vim.api.nvim_tabpage_get_var, tab, "project_label")
        if not ok or label == nil or label == "" then
          local cwd = vim.fn.getcwd(-1, i)
          label = (cwd ~= "" and vim.fn.fnamemodify(cwd, ":t")) or "[No Name]"
        end
        label = label:gsub("%%", "%%%%") -- escape for the statusline parser
        parts[#parts + 1] = hl .. "%" .. i .. "T " .. label .. " "
      end
      parts[#parts + 1] = "%#TabLineFill#%T"
      return table.concat(parts)
    end

    vim.o.tabline = "%!v:lua.ProjectTabline()"
    vim.o.showtabline = 2

    vim.keymap.set("n", "<leader>po", pick_project, { desc = "Open project (new tab)" })
    vim.keymap.set("n", "<leader>pw", pick_worktree, { desc = "Switch git worktree (new tab)" })
    vim.keymap.set("n", "<leader>pq", "<cmd>tabclose<CR>", { desc = "Close project (tab)" })
    for i = 1, 9 do
      vim.keymap.set("n", ("<A-%d>"):format(i), ("%dgt"):format(i), { desc = "Go to project " .. i })
    end
  end,
}
