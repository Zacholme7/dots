local opt = vim.opt

-- General settings
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.scrolloff = 999
opt.number = true
opt.relativenumber = true
opt.splitright = true
opt.smartindent = true
opt.autoindent = true
opt.clipboard = "unnamedplus"
opt.signcolumn = "yes"
opt.updatetime = 100
opt.timeoutlen = 300
opt.completeopt = "menu,menuone,noselect"
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.undolevels = 10000
opt.wrap = false

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}
