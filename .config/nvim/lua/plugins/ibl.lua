return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {},
  config = function()
    local highlight = { 'IblHighlight' }
    local hooks = require 'ibl.hooks'
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'IblHighlight', { fg = '#3b4261' })
    end)

    require('ibl').setup { indent = { highlight = highlight } }
  end,
}
