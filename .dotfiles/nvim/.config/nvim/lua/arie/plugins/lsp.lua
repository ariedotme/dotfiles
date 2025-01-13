return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "stevearc/conform.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
      "nvim-java/nvim-java"
    },
    config = function()
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

      require("java").setup()

      require("conform").setup({
        formatters_by_ft = {
          rust = { "rustfmt", lsp_format = "fallback" },
          lua = { "stylua" },
          cpp = { "clang-format" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })
      local cmp = require("cmp")
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities(),
        {
          textDocument = {
            inlayHint = {
              dynamicRegistration = false,
            },
          },
        }
      )
      require("fidget").setup({})
      require("mason").setup()

      local lspconfig = require("lspconfig")
      lspconfig.jdtls.setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "gopls",
          "clangd",
          "zls"
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,
          ["zls"] = function()
            lspconfig.zls.setup {}
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = "Lua 5.1" },
                  diagnostics = {
                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                  }
                }
              }
            }
          end,
        }
      })
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
          -- ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
          { name = 'buffer' },
        })
      })

      vim.diagnostic.config({
        -- update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      local configs = require("lspconfig.configs")
      local nvim_lsp = require("lspconfig")
      if not configs.neocmake then
        configs.neocmake = {
          default_config = {
            cmd = { "neocmakelsp", "--stdio" },
            filetypes = { "cmake" },
            root_dir = function(fname)
              return nvim_lsp.util.find_git_ancestor(fname)
            end,
            single_file_support = true, -- suggested
            on_attach = on_attach,      -- on_attach is the on_attach function you defined
            init_options = {
              format = {
                enable = true
              },
              lint = {
                enable = true
              },
              scan_cmake_in_package = true -- default is true
            }
          }
        }
        nvim_lsp.neocmake.setup({})
      end

      require("trouble").setup {}
    end
  },
  {
    "nvimdev/guard.nvim",
    -- lazy load by ft
    ft = { "lua", "c", "markdown" },
    -- Builtin configuration, optional
    dependencies = {
      "nvimdev/guard-collection",
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "<C-g>", require("actions-preview").code_actions)
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    }
  }
  --    {
  --        "mrcjkb/rustaceanvim",
  --        lazy = false,
  --        version = "^5"
  --    }
}
