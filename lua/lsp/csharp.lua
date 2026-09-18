local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('roslyn', {
	capabilities = capabilities,
	settings = {
		['csharp|inlay_hints'] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
		},
		['csharp|code_lens'] = {
			dotnet_enable_references_code_lens = true,
		},
		['csharp|completion'] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
		},
		['csharp|background_analysis'] = {
			dotnet_analyzer_diagnostics_scope = 'openFiles',
			dotnet_compiler_diagnostics_scope = 'openFiles',
		},
	},
})
