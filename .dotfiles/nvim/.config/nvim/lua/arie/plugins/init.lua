return {
  -- Blazing fast lazy language pack for syntax highlight and identation.
  -- I might regret using it instead of treesitter eventually.
  "sheerun/vim-polyglot",
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
}
