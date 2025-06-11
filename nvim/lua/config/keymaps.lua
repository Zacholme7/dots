local map = vim.keymap.set

-- Better escape
map("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better movement
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
map("n", "<A-h>", ":vertical resize +2<CR>", { silent = true })
map("n", "<A-l>", ":vertical resize -2<CR>", { silent = true })
map("n", "<A-k>", ":resize +2<CR>", { silent = true })
map("n", "<A-j>", ":resize -2<CR>", { silent = true })

-- Buffer management
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>b", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Tab navigation
map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tc", ":tabnew<CR>", { desc = "Create new tab" })
map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Window swapping function
local function swap_splits(direction)
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  local current_cursor = vim.api.nvim_win_get_cursor(current_win)
  
  vim.cmd("wincmd " .. direction)
  local target_win = vim.api.nvim_get_current_win()
  
  if current_win == target_win then return end
  
  local target_buf = vim.api.nvim_win_get_buf(target_win)
  local target_cursor = vim.api.nvim_win_get_cursor(target_win)
  
  vim.api.nvim_win_set_buf(current_win, target_buf)
  vim.api.nvim_win_set_buf(target_win, current_buf)
  vim.api.nvim_win_set_cursor(current_win, target_cursor)
  vim.api.nvim_win_set_cursor(target_win, current_cursor)
  vim.api.nvim_set_current_win(target_win)
end

-- Window swapping keymaps
map("n", "<C-o>", function() swap_splits("h") end, { desc = "Swap with left split" })
map("n", "<C-.>", function() swap_splits("l") end, { desc = "Swap with right split" })
map("n", "<C-d>j", function() swap_splits("j") end, { desc = "Swap with below split" })
map("n", "<C-d>k", function() swap_splits("k") end, { desc = "Swap with above split" })

-- Diagnostic navigation
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })

-- Toggle options
map("n", "<leader>uw", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle word wrap" })
map("n", "<leader>ul", function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end, { desc = "Toggle relative line numbers" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle diagnostics" })
map("n", "<leader>uc", function() vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0 end, { desc = "Toggle conceal" })
