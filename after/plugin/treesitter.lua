require('nvim-treesitter').setup({
	ensure_installed = { 'lua', 'javascript', 'typescript', 'tsx', 'html', 'angular', 'css', 'json', 'jsonc', 'c_sharp' },
	auto_install = true,
	highlight = { enable = true },
})

-- use angular treesitter parser for Angular HTML templates
vim.treesitter.language.register('angular', 'htmlangular')
