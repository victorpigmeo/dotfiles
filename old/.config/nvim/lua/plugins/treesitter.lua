return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'c',
        'cpp',
        'rust',
        'go',
        'lua',
        'javascript',
        'typescript',
        'tsx',
        'markdown',
        'vim',
        'luadoc',
      },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
