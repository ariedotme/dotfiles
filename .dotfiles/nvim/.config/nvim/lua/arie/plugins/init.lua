return {
  {
    "luukvbaal/nnn.nvim",
    config = function()
      require("nnn").setup({
        picker = {
          cmd = "tmux new-session nnn -Pp",
          style = { border = "single" },
          session = "shared",
        },
        replace_netrw = "picker",
      })

      vim.keymap.set("n", "<C-O>", ":NnnPicker<CR>")
      vim.api.nvim_set_hl(0, "NnnBorder", { bg = "NONE" })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "elixir", "css", "javascript", "html", "rust", "yuck", "go", "typescript" },
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    "dundalek/parpar.nvim",
    dependencies = { "gpanders/nvim-parinfer", "julienvincent/nvim-paredit" },
    opts = {}
  },
}
