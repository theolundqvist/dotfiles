-- copilot completion support
--
local cmp = require "cmp"


return {
  -- {
  --   "fatih/vim-go",
  --   run = ":GoUpdateBinaries",
  -- },
  {
    'FabijanZulj/blame.nvim',
    cmd = "BlameToggle",
    config = function()
      require("blame").setup({
        date_format = "%d.%m.%Y",
        virtual_style = "right_align",
        focus_blame = true,
        merge_consecutive = false,
        max_summary_width = 30,
        colors = nil,
        blame_options = nil,
        commit_detail_view = "vsplit",
        mappings = {
          commit_info = "i",
          stack_push = "<TAB>",
          stack_pop = "<BS>",
          show_commit = "<CR>",
          close = { "<esc>", "q" },
        }
      })
    end
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "sheerun/vim-polyglot"
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<TAB>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            -- dismiss = "<C-n>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          javascript = true, -- allow specific filetype
          typescript = true, -- allow specific filetype
          ["*"] = true,      -- disable for all other filetypes and ignore default `filetypes`
        },
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      -- {
      -- 	"jose-elias-alvarez/null-ls.nvim",
      -- 	config = function()
      -- 		require("configs.null-ls")
      -- 	end,
      -- },
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "prettier",

        -- c/cpp stuff
        "clangd",
        "clang-format",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "markdown",
        "markdown_inline",
      },
      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
    },
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
    opts = {
      sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      },
      mapping = {
        -- ["<Up>"] = cmp.mapping.select_prev_item(),
        -- ["<Down>"] = cmp.mapping.select_next_item(),
        -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<Down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<Up>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
    }
    ,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true,
      },
      view = {
        width = {
          max = 60
        }
      },

      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
      on_attach = function(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", ".", api.tree.change_root_to_node, opts "change root to node")
      end,
    }
    ,
  },
  -- {
  -- 	"folke/which-key.nvim",
  -- 	keys = { "<leader>", '"', "'", "`", "c", "v" },
  -- 	init = function()
  -- 		require("core.utils").load_mappings("whichkey")
  -- 	end,
  -- 	disable = false,
  -- 	config = function(_, opts)
  -- 		dofile(vim.g.base46_cache .. "whichkey")
  -- 		require("which-key").setup(opts)
  -- 		local present, wk = pcall(require, "which-key")
  -- 		if not present then
  -- 			return
  -- 		end
  -- 		wk.register({
  -- 			-- add group
  -- 			["<leader>"] = {
  -- 				g = { name = "+Git" },
  -- 				l = { name = "+LSP" },
  -- 				s = { name = "+Search" },
  -- 				t = { name = "+Term" },
  -- 				tn = { name = "+New" },
  -- 				r = { name = "+Refactor" },
  -- 				n = { name = "+Line Numbers" },
  -- 				w = { name = "+Workspace" },
  -- 			},
  -- 		})
  -- 	end,
  -- 	setup = function()
  -- 		require("core.utils").load_mappings("whichkey")
  -- 	end,
  -- },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
