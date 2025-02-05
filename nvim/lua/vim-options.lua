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

local function swap_splits(direction)
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    
    -- Save current window state
    local current_state = {
        cursor = vim.api.nvim_win_get_cursor(current_win),
        view = vim.fn.winsaveview(),
        filetype = vim.bo[current_buf].filetype
    }
    
    -- Check for NeoTree
    if current_state.filetype == "neo-tree" then return end
    
    -- Try to navigate to adjacent window
    vim.cmd("wincmd " .. direction)
    local target_win = vim.api.nvim_get_current_win()
    if current_win == target_win then return end  -- No adjacent window
    
    -- Save target window state
    local target_buf = vim.api.nvim_win_get_buf(target_win)
    local target_state = {
        cursor = vim.api.nvim_win_get_cursor(target_win),
        view = vim.fn.winsaveview(),
        filetype = vim.bo[target_buf].filetype
    }
    
    -- Check target for NeoTree
    if target_state.filetype == "neo-tree" then
        vim.api.nvim_set_current_win(current_win)
        return
    end
    
    -- Perform swap based on buffer equality
    if current_buf ~= target_buf then
        -- Swap buffers
        vim.api.nvim_win_set_buf(current_win, target_buf)
        vim.api.nvim_win_set_buf(target_win, current_buf)
    end
    
    -- Always swap window states (cursor, scroll position, etc.)
    vim.api.nvim_win_set_cursor(current_win, target_state.cursor)
    vim.fn.winrestview(target_state.view)
    vim.api.nvim_win_set_cursor(target_win, current_state.cursor)
    vim.fn.winrestview(current_state.view)
    
    -- Maintain focus in the original window
    vim.api.nvim_set_current_win(target_win)
end



-- Key mappings using Ctrl-d
vim.keymap.set('n', '<C-o>', function() swap_splits('h') end, 
    { noremap = true, silent = true, desc = 'Swap with left split' })
vim.keymap.set('n', '<C-.>', function() swap_splits('l') end, 
    { noremap = true, silent = true, desc = 'Swap with right split' })
vim.keymap.set('n', '<C-d>j', function() swap_splits('j') end, 
    { noremap = true, silent = true, desc = 'Swap with below split' })
vim.keymap.set('n', '<C-d>k', function() swap_splits('k') end, 
    { noremap = true, silent = true, desc = 'Swap with above split' })

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
