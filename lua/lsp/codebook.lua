local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('codebook', {
	capabilities = capabilities,
	root_dir = function(bufnr, on_dir)
		local path = vim.api.nvim_buf_get_name(bufnr)
		if path == '' then
			return
		end
		local marker = vim.fs.find({ 'codebook.toml', '.codebook.toml' }, {
			upward = true,
			path = vim.fs.dirname(path),
		})[1]
		if marker then
			on_dir(vim.fs.dirname(marker))
		end
	end,
})

vim.lsp.enable('codebook')