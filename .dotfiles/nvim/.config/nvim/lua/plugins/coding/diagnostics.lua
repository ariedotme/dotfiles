return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {
      focus = true,
      open_no_results = true,
      preview = {
        type = 'float',
      },
    },
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
    },
  },
}
