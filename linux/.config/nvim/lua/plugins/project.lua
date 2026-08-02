-- project.nvim: track project roots; open each project as its own tab.
-- One project per tabpage, each with a tab-local cwd (:tcd).
--   SPC p o  pick a known project -> opens in a NEW tab (oil at its root)
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

    vim.keymap.set("n", "<leader>po", pick_project, { desc = "Open project (new tab)" })
    vim.keymap.set("n", "<leader>pq", "<cmd>tabclose<CR>", { desc = "Close project (tab)" })
    for i = 1, 9 do
      vim.keymap.set("n", ("<A-%d>"):format(i), ("%dgt"):format(i), { desc = "Go to project " .. i })
    end
  end,
}
