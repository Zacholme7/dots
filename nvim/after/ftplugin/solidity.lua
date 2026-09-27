-- Solidity-only indentation. Match `forge fmt` (4-space, expand tabs) so the
-- code lines up *as you type* instead of jumping on save.
local opt = vim.opt_local
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Treesitter's Solidity indent is unreliable, so it's disabled for `solidity`
-- in plugins/treesitter.lua. Indentation then falls to Neovim's built-in
-- runtime indenter ($VIMRUNTIME/indent/solidity.vim, GetSolidityIndent()),
-- which indents correctly at the 4-space width set above.
