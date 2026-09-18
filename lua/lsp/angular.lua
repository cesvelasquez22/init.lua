local function angular_request(method)
	vim.lsp.buf_request(0, method,
		function(client, _)
			return vim.lsp.util.make_position_params(0, client.offset_encoding)
		end,
		function(err, result)
			if err or not result then return end
			local location = vim.islist(result) and result[1] or result
			if not location then return end
			if not location.uri and location.targetUri then
				location = { uri = location.targetUri, range = location.targetRange or location.targetSelectionRange }
			end
			if not location.uri then return end
			vim.lsp.util.show_document(location, 'utf-16', { focus = true })
		end
	)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('angularls', {
	capabilities = capabilities,
	filetypes = { 'typescript', 'htmlangular' },
})

vim.lsp.enable('angularls')

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client or client.name ~= 'angularls' then return end
		local opts = { buffer = event.buf, silent = true }
		vim.keymap.set('n', '<leader>gt', function()
			angular_request('angular/getTemplateLocationForComponent')
		end, opts)
		vim.keymap.set('n', '<leader>gc', function()
			angular_request('angular/getComponentsWithTemplateFile')
		end, opts)
	end,
})
