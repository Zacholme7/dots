local opts = {noremap = true, silent = true}
local term_opts = { silent = true }


-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- remap the leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal mode
------------------
-- better window naviation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize the splits
--
-- open up splits
keymap("n", "<leader>v", ":vsplit<CR>", opts) -- vertical split
keymap("n", "<leader>h", ":split<CR>", opts) -- horizontal split

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)



-- Insert --
-- Press kj fast to enter
keymap("i", "kj", "<ESC>", opts)

-- Visual
------------------
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)



