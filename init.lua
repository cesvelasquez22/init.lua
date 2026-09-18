vim.env.PATH = vim.env.PATH .. ':/opt/homebrew/bin'

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.remap")
require("config.lazy")
require("config.set")
require("config.tools")
require("config.tanstack_router")
