local overrides = require("custom.configs.overrides")
local cmp = require("cmp")
---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options
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
					["*"] = true, -- disable for all other filetypes and ignore default `filetypes`
				},
			})
		end,
	},
	-- {
	-- 	"timtro/glslView-nvim",
	-- 	ft = "glsl",
	-- 	config = function()
	-- 		require("glslView").setup({
	-- 			exe_path = "/path/to/glslViewer",
	-- 			arguments = { "-l", "-w", "128", "-h", "256" },
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"tikhomirov/vim-glsl",
	-- },
	{
		"sheerun/vim-polyglot",
	},
	-- {
	--   "zbirenbaum/copilot-cmp",
	--   -- event = "InsertEnter",
	--   after = { "copilot.lua" },
	--   config = function()
	--     require("copilot_cmp").setup {
	--
	--       -- formatters = {
	--       --   label = require("copilot_cmp.format").format_label_text,
	--       --   insert_text = require("copilot_cmp.format").format_insert_text,
	--       --   -- insert_text = require("copilot_cmp.format").remove_existing,
	--       --   preview = require("copilot_cmp.format").deindent,
	--       -- },
	--       -- mapping = {
	--       --   ["<CR>"] = cmp.mapping.confirm {
	--       --     -- this is the important line
	--       --     behavior = cmp.ConfirmBehavior.Replace,
	--       --     select = false,
	--       --   },
	--       -- },
	--     }
	--   end,
	--   -- dependencies = {
	--   --   {
	--   --     "zbirenbaum/copilot.lua"
	--   --   }
	--   -- }
	-- },

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
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
		opts = overrides.cmp,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},
	{
		"folke/which-key.nvim",
		keys = { "<leader>", '"', "'", "`", "c", "v" },
		init = function()
			require("core.utils").load_mappings("whichkey")
		end,
		disable = false,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)
			local present, wk = pcall(require, "which-key")
			if not present then
				return
			end
			wk.register({
				-- add group
				["<leader>"] = {
					g = { name = "+Git" },
					l = { name = "+LSP" },
					s = { name = "+Search" },
					t = { name = "+Term" },
					tn = { name = "+New" },
					r = { name = "+Refactor" },
					n = { name = "+Line Numbers" },
					w = { name = "+Workspace" },
				},
			})
		end,
		setup = function()
			require("core.utils").load_mappings("whichkey")
		end,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{
		"scalameta/nvim-metals",
    ft="scala",
		-- pattern = { "scala", "sbt", "java" },
		config = function()
			-- local metals_config = require("metals").bare_config()
			--
			-- -- Example of settings
			-- metals_config.settings = {
			-- 	showImplicitArguments = true,
			-- 	-- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
			-- }
   --    metals_config.capabilities = require("nvim_cmp").default_capabilities()
			-- require("metals").initialize_or_attach(metals_config)
      require("metals").initialize_or_attach({})
      -- require("nvim-metals").setup()
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
