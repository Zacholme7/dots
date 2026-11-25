return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
			{ "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus NeoTree" },
		},
		opts = {
			close_if_last_window = true,
			popup_border_style = "rounded",
			window = {
				width = 30,
				-- Everything else uses neo-tree's default mappings (press ? in the tree)
				mappings = {
					["l"] = "open",
					["u"] = "navigate_up",
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						"node_modules",
						".git",
					},
				},
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
			},
		},
	},
}
