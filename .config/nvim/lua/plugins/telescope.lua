return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
    }

    local builtin = require 'telescope.builtin'

    vim.keymap.set('n', '/', function()
      builtin.current_buffer_fuzzy_find(
        require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        }
      )
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set(
      'n',
      '<leader>bb',
      builtin.buffers,
      { desc = '[F]ind [B]uffers' }
    )

    vim.keymap.set(
      'n',
      '<leader> ',
      builtin.find_files,
      { desc = '[F]ind [F]iles' }
    )

    vim.keymap.set(
      'n',
      '<leader>sp',
      builtin.live_grep,
      { desc = '[F]ind Files Live [G]rep' }
    )

 end,
}
