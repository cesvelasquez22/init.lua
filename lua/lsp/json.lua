vim.lsp.config('jsonls', {
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	settings = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
})

vim.lsp.enable('jsonls')
