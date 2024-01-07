-- general vim setting
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set scrolloff=999")
vim.cmd("set nu")
vim.cmd("set relativenumber")
vim.cmd("set splitright")
vim.cmd("set smartindent")
vim.cmd("set autoindent")

-- KEY REMAPS
-- quality of live remaps
vim.keymap.set('i', 'kj', '<Esc>')

-- remap for moving between panges
vim.keymap.set('n', '<C-j>', '<C-W><C-J>')
vim.keymap.set('n', '<C-k>', '<C-W><C-K>')
vim.keymap.set('n', '<C-l>', '<C-W><C-L>')
vim.keymap.set('n', '<C-h>', '<C-W><C-H>')

-- remap for resizing the text
vim.keymap.set('n', '<A-l>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<A-h>', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '<A-j>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<A-k>', ':resize +2<CR>', { silent = true })
