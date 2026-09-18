-- Aylin Selene overrides for the ayu colorscheme (mirage variant).
-- This module loads the highlight overrides automatically:
--   * at startup, via require() from the ayu plugin config
--   * whenever `:colorscheme ayu` is invoked (ColorScheme autocmd)
-- Only applied when g:ayucolor == "mirage" (the variant closest to Aylin Selene).

local overrides = vim.fn.stdpath('config') .. '/after/colors/ayu.lua'

local M = {}

function M.apply()
	if vim.g.ayucolor ~= 'mirage' then
		return
	end
	vim.cmd('source ' .. vim.fn.fnameescape(overrides))
end

-- Re-apply whenever the ayu colorscheme is loaded (covers manual :colorscheme ayu)
vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = 'ayu',
	callback = function()
		pcall(M.apply)
	end,
})

return M