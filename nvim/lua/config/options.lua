local opt = vim.opt

-- No plugins here use the remote-plugin providers; skip probing for them
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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
opt.clipboard = "unnamedplus"
opt.signcolumn = "yes"
opt.updatetime = 100
opt.timeoutlen = 300
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.undolevels = 10000
opt.wrap = false
-- Jump history behaves like a browser's back/forward and drops closed buffers
opt.jumpoptions = "stack,clean"
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
