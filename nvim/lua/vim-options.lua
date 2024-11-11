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
vim.cmd("set clipboard+=unnamedplus")

-- KEY REMAPS
-- quality of live remaps
vim.keymap.set('i', 'kj', '<Esc>')

-- remap for moving between panges
vim.keymap.set('n', '<C-j>', '<C-W><C-J>')
vim.keymap.set('n', '<C-k>', '<C-W><C-K>')
vim.keymap.set('n', '<C-l>', '<C-W><C-L>')
vim.keymap.set('n', '<C-h>', '<C-W><C-H>')


-- buffer navigation
--vim.keymap.set('n', '<S-d>', '<cmd>BufferLineCyclePrev<CR>')
--vim.keymap.set('n', '<S-f>', '<cmd>BufferLineCycleNext<CR>')
-- Move buffer position
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferLineMoveNext<CR>', { noremap = true, silent = true, desc = 'Move buffer right' })
vim.keymap.set('n', '<leader>bh', '<Cmd>BufferLineMovePrev<CR>', { noremap = true, silent = true, desc = 'Move buffer left' })

-- Close buffers to the left or right
vim.keymap.set('n', '<leader>bL', '<Cmd>BufferLineCloseRight<CR>', { noremap = true, silent = true, desc = 'Close all buffers to the right' })
vim.keymap.set('n', '<leader>bH', '<Cmd>BufferLineCloseLeft<CR>', { noremap = true, silent = true, desc = 'Close all buffers to the left' })

-- Close all buffers except current one
vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', { noremap = true, silent = true, desc = 'Close all other buffers' })

-- Pick a buffer
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLinePick<CR>', { noremap = true, silent = true, desc = 'Pick a buffer' })



-- remap for resizing the text
vim.keymap.set('n', '<A-l>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<A-h>', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '<A-j>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<A-k>', ':resize +2<CR>', { silent = true })

-- Move to next tab
vim.keymap.set('n', '<leader>tn', ':tabnext<CR>', { silent = true, desc = "Next tab" })

-- Move to previous tab
vim.keymap.set('n', '<leader>tp', ':tabprevious<CR>', { silent = true, desc = "Previous tab" })

-- Create a new tab
vim.keymap.set('n', '<leader>tc', ':tabnew<CR>', { silent = true, desc = "Create new tab" })

-- Close current tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { silent = true, desc = "Close current tab" })
