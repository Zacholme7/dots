return {
	-- Shows available keys after pressing a prefix such as <leader>
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>l", group = "lsp" },
				{ "<leader>t", group = "tab" },
				{ "<leader>u", group = "toggle" },
				{ "<leader>w", group = "window" },
				{ "gs", group = "surround" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer-local keymaps",
			},
		},
	},

	-- Auto-close brackets and quotes
	{
		"nvim-mini/mini.pairs",
		version = false,
		event = "InsertEnter",
		opts = {},
	},

	-- Add / delete / replace surrounding pairs. Uses a `gs` prefix so that
	-- `s` stays free for flash.nvim.
	{
		"nvim-mini/mini.surround",
		version = false,
		keys = {
			{ "gsa", desc = "Add surrounding", mode = { "n", "x" } },
			{ "gsd", desc = "Delete surrounding" },
			{ "gsr", desc = "Replace surrounding" },
			{ "gsf", desc = "Find right surrounding" },
			{ "gsF", desc = "Find left surrounding" },
			{ "gsh", desc = "Highlight surrounding" },
			{ "gsn", desc = "Update surround search range" },
		},
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				replace = "gsr",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				update_n_lines = "gsn",
			},
		},
	},

	-- Jump anywhere on screen by typing a few characters
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			-- Show labels only after two characters are typed, so they do not
			-- appear and reshuffle while you are still typing
			label = { min_pattern_length = 2 },
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash treesitter select",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote flash",
			},
		},
	},
}
