local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('emmet_language_server', {
	capabilities = capabilities,
	filetypes = {
		'html',
		'htmlangular',
		'css',
		'scss',
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
	},
})

vim.lsp.enable('emmet_language_server')
