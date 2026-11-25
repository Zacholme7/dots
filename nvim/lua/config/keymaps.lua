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

-- Window splitting / closing (one chord, right hand). These replace normal-mode
-- <C-n>/<C-p> (same as j/k) and <C-y> (scroll up one line).
map("n", "<C-n>", "<C-w>v", { desc = "Split side by side" })
map("n", "<C-p>", "<C-w>s", { desc = "Split top and bottom" })
map("n", "<C-y>", "<C-w>q", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close all other windows" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize window sizes" })

-- Window resizing
map("n", "<A-h>", ":vertical resize +2<CR>", { silent = true })
map("n", "<A-l>", ":vertical resize -2<CR>", { silent = true })

-- Buffer management
-- Close the buffer but keep its window open. Plain :bdelete also closes the
-- window, which leaves neo-tree as the last window and makes it quit Neovim.
local function delete_buffer()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].modified then
		local choice = vim.fn.confirm("Save changes to " .. vim.fn.bufname(buf) .. "?", "&Yes\n&No\n&Cancel")
		if choice == 1 then
			vim.cmd.write()
		elseif choice ~= 2 then
			return
		end
	end
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			local alt = vim.fn.bufnr("#")
			if alt > 0 and alt ~= buf and vim.bo[alt].buflisted then
				vim.cmd.buffer(alt)
			else
				vim.cmd.bprevious()
			end
			if vim.api.nvim_get_current_buf() == buf then
				vim.cmd.enew() -- it was the only buffer; show an empty one
			end
		end)
	end
	if vim.api.nvim_buf_is_valid(buf) then
		vim.cmd.bdelete({ buf, bang = true })
	end
end
map("n", "<leader>x", delete_buffer, { desc = "Delete buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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

	if current_win == target_win then
		return
	end

	local target_buf = vim.api.nvim_win_get_buf(target_win)
	local target_cursor = vim.api.nvim_win_get_cursor(target_win)

	vim.api.nvim_win_set_buf(current_win, target_buf)
	vim.api.nvim_win_set_buf(target_win, current_buf)
	vim.api.nvim_win_set_cursor(current_win, target_cursor)
	vim.api.nvim_win_set_cursor(target_win, current_cursor)
	vim.api.nvim_set_current_win(target_win)
end

-- Window swapping keymaps
map("n", "<leader>wh", function()
	swap_splits("h")
end, { desc = "Swap with left split" })
map("n", "<leader>wl", function()
	swap_splits("l")
end, { desc = "Swap with right split" })
map("n", "<leader>wj", function()
	swap_splits("j")
end, { desc = "Swap with below split" })
map("n", "<leader>wk", function()
	swap_splits("k")
end, { desc = "Swap with above split" })

-- Diagnostic navigation
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })

-- Toggle options
map("n", "<leader>uw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle word wrap" })
map("n", "<leader>ul", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })
map("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
map("n", "<leader>uc", function()
	vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0
end, { desc = "Toggle conceal" })
