return {
  require 'kickstart.plugins.neo-tree',
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  require 'plugins.basic.presentation',
  require 'plugins.basic.navigation',
}
