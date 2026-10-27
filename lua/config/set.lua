vim.g.mapleader = " "
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

if vim.g.neovide then
	vim.o.guifont = "JetBrains Mono:h16"
	vim.g.neovide_ligatures = true
	vim.g.neovide_progress_bar_enabled = false
	vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_position_animation_length = 0
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_cursor_smooth_blink = false
	vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_floating_blur_amount = 0
	vim.g.neovide_floating_shadow = false
	vim.g.neovide_opacity = 1.0
	vim.g.neovide_remember_window_size = false
end
