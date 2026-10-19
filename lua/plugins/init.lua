return {
	-- Tokyo Night stays installed as an alternate theme (`:colorscheme tokyonight`)
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 900,
		--       config = function()
		-- 	-- load the colorscheme here
		-- 	vim.cmd([[colorscheme tokyonight-moon]])
		-- end

	},
	-- Aylin Selene look: ayu-vim mirage variant (dark bg #212733, bright accents)
	{
		"ayu-theme/ayu-vim",
		lazy = false,
		priority = 100,
		config = function()
			-- Load the Aylin Selene override module first (registers ColorScheme autocmd)
			local aylin_selene = require('config.aylin_selene')
			vim.g.ayucolor = "mirage" -- use the mirage variant (closest to Aylin Selene)
			-- vim.cmd([[colorscheme ayu]])
			-- Apply the Aylin Selene palette overrides on top of ayu
			-- aylin_selene.apply()
		end,
	},
    -- {
    --     "catppuccin/nvim",
	-- 	lazy = false,
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         vim.cmd([[colorscheme catppuccin-mocha]])
    --     end
    -- },
	-- Nord theme (active)
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.nord_contrast = true
			vim.g.nord_borders = false
			vim.g.nord_disable_background = false
			vim.g.nord_italic = false
			vim.g.nord_uniform_diff_background = true
			vim.g.nord_bold = false
			vim.cmd.colorscheme('nord')
		end,
	},
	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			vim.opt.showmode = false
			require('lualine').setup({
				options = {
					theme = 'nord',
				},
				sections = {
					lualine_x = { 'encoding', 'filetype' },
				},
			})
		end,
	},
	{
		'nvim-telescope/telescope.nvim', version = '*',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- optional but recommended
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		}
	},
	-- LSP
	{
		'williamboman/mason.nvim',
		build = ':MasonUpdate',
		config = function()
			require('mason').setup({
				registries = {
					'github:mason-org/mason-registry',
					'github:Crashdummyy/mason-registry',
				},
			})
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
		config = function()
			require('mason-lspconfig').setup({
				ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'angularls', 'jsonls', 'emmet_language_server', 'pyright' },
				automatic_installation = true,
			})
			require('lsp.typescript')
			require('lsp.eslint')
			require('lsp.lua')
			require('lsp.angular')
			require('lsp.json')
			require('lsp.emmet')
			require('lsp.python')
			require('lsp.codebook')
		end,
	},
	-- C# LSP (roslyn)
	{
		'seblyng/roslyn.nvim',
		ft = 'cs',
		opts = {
			broad_search = false,
			lock_target = false,
		},
	},
	{
		'nvim-treesitter/nvim-treesitter',
		event = { 'BufReadPre', 'BufNewFile' },  -- lazy load on file events
		build = ':TSUpdate'
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" },
    {
      'nvim-mini/mini.comment',
      version = false,
      dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
      opts = {
        options = {
          custom_commentstring = function()
            local ok, parser = pcall(vim.treesitter.get_parser)
            if ok and parser then
              parser:parse()
            end
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      },
    },
	{ "b0o/schemastore.nvim" },

	-- DAP (debugger)
	{ 'nvim-neotest/nvim-nio' },
	{
		-- Debug Framework
		'mfussenegger/nvim-dap',
		event = 'VeryLazy',
		dependencies = { 'rcarriga/nvim-dap-ui' },
		config = function()
			local dap = require('dap')
			local mason_path = vim.fn.stdpath('data') .. '/mason/packages/netcoredbg/netcoredbg'

			local netcoredbg_adapter = {
				type = 'executable',
				command = mason_path,
				args = { '--interpreter=vscode' },
			}

			dap.adapters.netcoredbg = netcoredbg_adapter -- normal debugging
			dap.adapters.coreclr    = netcoredbg_adapter -- unit test debugging

			-- Reads Properties/launchSettings.json from the project root and builds
			-- the DAP configuration dynamically. Falls back gracefully for console
			-- apps or projects without launchSettings.json.
			local function get_cs_config()
				local cwd = vim.fn.getcwd()

				-- Parse launchSettings.json if present
				local env_vars = {}
				local app_url  = nil
				local settings_file = io.open(cwd .. '/Properties/launchSettings.json', 'r')
				if settings_file then
					local ok, settings = pcall(vim.json.decode, settings_file:read('*a'))
					settings_file:close()
					if ok and settings.profiles then
						-- Prefer the 'http' profile, fall back to any Project commandName
						local selected = settings.profiles['http']
						if not selected or selected.commandName ~= 'Project' then
							for _, profile in pairs(settings.profiles) do
								if profile.commandName == 'Project' then
									selected = profile
									break
								end
							end
						end
						if selected then
							if selected.applicationUrl then
								app_url = selected.applicationUrl:match('([^;]+)')
							end
							if selected.environmentVariables then
								for k, v in pairs(selected.environmentVariables) do
									env_vars[k] = v
								end
							end
						end
					end
				end

				if app_url then
					env_vars['ASPNETCORE_URLS'] = app_url
				end

				-- Auto-detect dll path from .csproj name + bin/Debug/net* folder.
				-- Prefer the folder matching the csproj's TargetFramework (e.g.
				-- net7.0) over the first alphabetical glob match, so stale
				-- net* folders from other branches never win.
				local csproj   = vim.fn.glob(cwd .. '/*.csproj')
				local dll_name = csproj ~= ''
					and vim.fn.fnamemodify(csproj, ':t:r')
					or  vim.fn.fnamemodify(cwd, ':t')
				local tf_dirs  = vim.fn.glob(cwd .. '/bin/Debug/net*', false, true)
				local tfm      = csproj ~= ''
					and vim.fn.matchstr(table.concat(vim.fn.readfile(csproj), '\n'), '<TargetFramework>\\zs[^<]*\\ze</TargetFramework>')
					or  ''
				local dll_path = cwd .. '/bin/Debug/'
				if #tf_dirs > 0 then
					local target_dir = vim.tbl_filter(function(dir)
						return tfm ~= '' and vim.fn.fnamemodify(dir, ':t') == tfm
					end, tf_dirs)
					local chosen = #target_dir > 0 and target_dir[1] or tf_dirs[1]
					dll_path = chosen .. '/' .. dll_name .. '.dll'
				end

				return {
					type    = 'coreclr',
					name    = 'launch - netcoredbg',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to dll: ', dll_path, 'file')
					end,
					env = env_vars,
				}
			end

			dap.configurations.cs = { get_cs_config() }

			local opts = { noremap = true, silent = true }
			vim.keymap.set('n', '<F5>',  dap.continue,                    opts)
			vim.keymap.set('n', '<F9>',  dap.toggle_breakpoint,            opts)
			vim.keymap.set('n', '<F7>',  function()
				dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end,                                                            opts)
			vim.keymap.set('n', '<F10>', dap.step_over,                    opts)
			vim.keymap.set('n', '<F11>', dap.step_into,                    opts)
			vim.keymap.set('n', '<F8>',  dap.step_out,                     opts)
            vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, opts)
			vim.keymap.set('n', '<leader>dB', function()
				dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end, opts)
			vim.keymap.set('n', '<leader>dr', dap.repl.open,               opts)
			vim.keymap.set('n', '<leader>dl', dap.run_last,                 opts)
			vim.keymap.set('n', '<leader>dq', dap.terminate,               opts)
		end,
	},
	{
		-- UI for debugging
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
		config = function()
			local dap   = require('dap')
			local dapui = require('dapui')

			dapui.setup()

			-- auto open/close on debug session events
			dap.listeners.after.event_initialized['dapui_config']  = function() dapui.open() end
			dap.listeners.before.event_terminated['dapui_config']  = function() dapui.close() end
			dap.listeners.before.event_exited['dapui_config']      = function() dapui.close() end

			vim.keymap.set('n', '<leader>du', dapui.toggle, { noremap = true, silent = true })
			vim.keymap.set('n', '<leader>dc', dapui.close,  { noremap = true, silent = true })
			vim.keymap.set('n', '<leader>ds', function()
				dapui.open({ reset = false })
				-- focus the scopes element
				dapui.float_element('scopes', { width = 80, height = 30, enter = true })
			end, { noremap = true, silent = true, desc = 'DAP float scopes' })
		end,
	},
	-- Snippets
	{
		'L3MON4D3/LuaSnip',
		version = 'v2.*',
		dependencies = { 'rafamadriz/friendly-snippets', 'mlaursen/vim-react-snippets' },
		config = function()
			local ls = require('luasnip')
			ls.filetype_extend('typescript', { 'angular' })
			ls.filetype_extend('html', { 'angular' })
			ls.filetype_extend('jsonc', { 'angular' })
			require('luasnip.loaders.from_vscode').lazy_load()
			require('vim-react-snippets').setup()
		end,
	},
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			cmp.setup({
				snippet = {
					expand = function(args) luasnip.lsp_expand(args.body) end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
						else fallback() end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then luasnip.jump(-1)
						else fallback() end
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
				}),
			})
		end,
	},
	-- Formatter (manual only, no format on save)
	{
		'stevearc/conform.nvim',
		config = function()
			require('conform').setup({
				formatters_by_ft = {
					typescript     = { 'prettier' },
					javascript     = { 'prettier' },
					htmlangular    = { 'prettier' },
					html           = { 'prettier' },
					css            = { 'prettier' },
					scss           = { 'prettier' },
					json           = { 'prettier' },
					python         = { 'ruff' },
				},
			})
			-- manual format: <leader>f (normal), <leader>f (visual line selection)
			vim.keymap.set('n', '<leader>f', function()
				require('conform').format({ async = true, lsp_fallback = true })
			end, { silent = true })
			vim.keymap.set('v', '<leader>f', function()
				require('conform').format({
					async = true,
					lsp_fallback = true,
					range = {
						start = vim.api.nvim_buf_get_mark(0, '<'),
						['end'] = vim.api.nvim_buf_get_mark(0, '>'),
					},
				})
			end, { silent = true })
		end,
	},
	-- Auto-close/rename HTML tags
	{
		'windwp/nvim-ts-autotag',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			require('nvim-ts-autotag').setup()
		end,
	},
	-- Auto-close brackets, parens, quotes
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = function()
			local autopairs = require('nvim-autopairs')
			autopairs.setup({
				check_ts = true, -- use treesitter to avoid closing inside strings/comments
			})
			-- integrate with nvim-cmp: insert closing pair on confirm
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end,
	},
	-- Emmet completions via emmet-language-server
	{
		'olrtg/nvim-emmet',
		config = function()
			vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
		end,
	},
	{
		'mg979/vim-visual-multi',
		init = function()
			vim.g.VM_maps = {
				['Find Under']         = 'gl',  -- normal: select next occurrence
				['Find Subword Under'] = 'gl',
				['Find Prev']          = 'gL',  -- normal: select prev occurrence
				['Add Cursor Up']      = '<M-Up>',
				['Add Cursor Down']    = '<M-Down>',
			}
		end,
	},
}
