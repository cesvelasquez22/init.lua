vim.lsp.config('eslint', {
	on_attach = function(_, bufnr)
		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.execute_command({ command = 'eslint.applyAllFixes', arguments = { { uri = vim.uri_from_bufnr(bufnr) } } })
			end,
		})
	end,
	settings = {
		workingDirectory = { mode = 'auto' },
	},
})

vim.lsp.enable('eslint')
