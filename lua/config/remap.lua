-- Inline diagnostics
vim.diagnostic.config({
	virtual_text = { prefix = '●', spacing = 4 },
	signs = true,
	update_in_insert = false,
	severity_sort = true,
})

-- General
vim.keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Save (mirrors <leader>s / <leader>S)
vim.keymap.set('n', '<leader>s', '<cmd>w<CR>', { silent = true })
vim.keymap.set('n', '<leader>S', '<cmd>wa<CR>', { silent = true })

-- Organize imports: remove unused then sort (targets ts_ls)
vim.keymap.set('n', '<leader>oi', function()
	local clients = vim.lsp.get_clients({ bufnr = 0, name = 'ts_ls' })
	if #clients == 0 then
		vim.notify('ts_ls not attached to this buffer', vim.log.levels.WARN)
		return
	end
	vim.schedule(function()
		vim.lsp.buf.code_action({
			apply = true,
			context = { only = { 'source.removeUnusedImports' }, diagnostics = {} },
		})
	end)
	vim.defer_fn(function()
		vim.lsp.buf.code_action({
			apply = true,
			context = { only = { 'source.organizeImports' }, diagnostics = {} },
		})
	end, 300)
end, { silent = true })

-- Insert mode: jj → Esc, Ctrl+j → Enter, Ctrl+c → Esc
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })
vim.keymap.set('i', '<C-j>', '<CR>', { silent = true })
vim.keymap.set('i', '<C-c>', '<Esc>', { silent = true })
vim.keymap.set('v', '<C-c>', '<Esc>', { silent = true })
vim.keymap.set('n', '<C-c>', '<Esc>', { silent = true })

-- Visual mode: indent/outdent, move lines, multi-cursor next/prev
vim.keymap.set('v', 't', '>gv', { silent = true })
vim.keymap.set('v', 'T', '<gv', { silent = true })
vim.keymap.set('v', 'K', ":move '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'J', ":move '>+1<CR>gv=gv", { silent = true })

-- Multi-cursor: select next/prev occurrence (vim-visual-multi)
vim.keymap.set({'n', 'v'}, 'gl', '<Plug>(VM-Find-Under)', { silent = true })
vim.keymap.set({'n', 'v'}, 'gL', '<Plug>(VM-Find-Prev)', { silent = true })

-- Highlighted yank (mirrors vim.highlightedyank)
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
	end,
})

--ThePrimeagen configs
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", function()
	if vim.env.TMUX ~= nil then
		vim.cmd("silent !tmux neww tmux-sessionizer")
	else
		vim.cmd("silent !tmux-sessionizer")
	end
end)
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- LSP keymaps (apply to any attached LSP)
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		-- Remove Neovim 0.10 built-in 'grr' (references) to prevent duplicate
		-- quickfix results when our 'gr' map below also fires references.
		pcall(vim.keymap.del, 'n', 'grr', { buffer = event.buf })
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts) -- K equivalent
		-- Use a single client for references to avoid duplicates when both
		-- ts_ls and angularls are attached to the same TypeScript buffer.
		local function smart_references()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			-- Prefer ts_ls; fall back to the first available client.
			local preferred = nil
			for _, c in ipairs(clients) do
				if c.name == 'ts_ls' then preferred = c; break end
			end
			preferred = preferred or clients[1]
			if not preferred then return end
			local params = vim.lsp.util.make_position_params(0, preferred.offset_encoding)
			params.context = { includeDeclaration = true }
			vim.lsp.buf_request(
				0,
				'textDocument/references',
				params,
				function(err, result, ctx)
					if err then vim.notify(tostring(err), vim.log.levels.ERROR); return end
					if not result or #result == 0 then vim.notify('No references found'); return end
					local items = vim.lsp.util.locations_to_items(result, preferred.offset_encoding)
					vim.fn.setqflist({}, 'r', { title = 'References', items = items })
					vim.cmd('copen')
				end
			)
		end
		vim.keymap.set('n', 'gr', smart_references, opts)          -- gA equivalent
		vim.keymap.set('n', 'gA', smart_references, opts)
		vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, opts)     -- gotoSymbol
		vim.keymap.set('n', 'gS', vim.lsp.buf.workspace_symbol, opts)    -- showAllSymbols
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- cd (rename)
		vim.keymap.set('n', 'cd', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
		vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
		vim.keymap.set('i', "C-h", vim.lsp.buf.signature_help, opts)
	end,
})
