local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('pyright', {
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = 'basic', -- 'basic', 'standard', 'strict'
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
})

vim.lsp.enable('pyright')
