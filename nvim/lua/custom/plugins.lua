local overrides = require "custom.configs.overrides"
local cmp = require "cmp"
---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = { enabled = true, auto_trigger = true },
        panel = { enabled = false },
        filetypes = {
          javascript = true, -- allow specific filetype
          typescript = true, -- allow specific filetype
          ["*"] = true, -- disable for all other filetypes and ignore default `filetypes`
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    after = {"copilot.lua"},
    config = function()
      require("copilot_cmp").setup {

            formatters = {
                  label = require("copilot_cmp.format").format_label_text,
                  insert_text = require("copilot_cmp.format").format_insert_text,
                  insert_text = require("copilot_cmp.format").remove_existing,
                  preview = require("copilot_cmp.format").deindent,
              },
              mapping = {
                  ["<CR>"] = cmp.mapping.confirm({
                      -- this is the important line
                      behavior = cmp.ConfirmBehavior.Replace,
                      select = false,
                  }),
              }
      }
    end,
    -- dependencies = {
    --   {
    --     "zbirenbaum/copilot.lua"
    --   }
    -- }
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "hrsh7th/nvim-cmp",
     dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts=overrides.cmp
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
