-- "Gaze deeply into unknown regions using the power of the moon."
-- It's a powerful fuzzy finder.

local function find(source)
  return function()
    require("telescope.builtin")[source]()
  end
end

return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  keys = {
    { "<Leader>/",  find("current_buffer_fuzzy_find"), desc = "Search" },
    { "<Leader>fc", find("commands"),                  desc = "Commands" },
    { "<Leader>ff", find("find_files"),                desc = "Files" },
    { "<Leader>fg", find("live_grep"),                 desc = "Grep" },
  },
  config = function()
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePromptCounter", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE" })
  end
}
