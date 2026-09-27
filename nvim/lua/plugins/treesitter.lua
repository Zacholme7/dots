return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- the main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			-- Custom parsers must be (re)registered on every TSUpdate event
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").huff = {
						install_info = { url = "https://github.com/mmsaki/huff-treesitter", branch = "main" },
					}
				end,
			})

			require("nvim-treesitter").install({
				"bash",
				"c",
				"cpp",
				"huff",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"rust",
				"solidity",
				"toml",
				"vim",
				"vimdoc",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
				callback = function(ev)
					if not pcall(vim.treesitter.start, ev.buf) then
						return
					end
					-- Solidity's treesitter indent is flaky; it keeps Vim's indenter
					-- (see after/ftplugin/solidity.lua). Other langs use TS indent.
					local lang = vim.treesitter.language.get_lang(ev.match)
					if ev.match ~= "solidity" and vim.treesitter.query.get(lang, "indents") then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- Incremental selection is built into Neovim 0.12 (v_an / v_in); keep the old keys
			vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start node selection" })
			vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand node selection" })
			vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink node selection" })
		end,
	},
	{
		"mmsaki/huff.nvim",
		version = "0.2.*",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			window_type = "floating", -- "floating" or "split"
		},
		config = function(_, opts)
			-- ponytail: huff.nvim still calls master-branch get_parser_configs(), gone on main.
			-- Stub it (parser is registered above instead); delete once huff.nvim supports main.
			local parsers = require("nvim-treesitter.parsers")
			parsers.get_parser_configs = parsers.get_parser_configs or function()
				return {}
			end
			require("huff").setup(opts)
		end,
	},
}
