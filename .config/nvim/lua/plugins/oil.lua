return {
  'stevearc/oil.nvim',
  dependencies = {
    'echasnovski/mini.icons',
  },

  config = function()
    require('oil').setup {

      default_file_explorer = true,

      view_options = {
        show_hidden = true,
      },

      columns = {
        {
          'icon',
        },
      },
    }

    vim.keymap.set('n', '<leader>ff', '<cmd>Oil<cr>')
  end,
}
