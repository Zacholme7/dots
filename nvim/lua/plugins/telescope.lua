return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8", -- Updated to latest version
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- Setup telescope with better defaults
			require("telescope").setup({
				defaults = {
					-- Visual improvements
					prompt_prefix = "🔍 ",
					selection_caret = "❯ ",
					-- Better performance
					file_ignore_patterns = {
						"node_modules/.*",
						"%.git/.*",
						"%.DS_Store",
						"%.pyc",
						"__pycache__/.*",
					},
					-- Preview configuration for better line indication
					preview = {
						treesitter = true, -- Enable syntax highlighting
					},
					-- Improved mappings (avoiding conflicts with your existing keymaps)
					mappings = {
						i = {
							-- Use Ctrl-h to show which_key help (doesn't conflict with your window nav)
							["<C-h>"] = "which_key",
							-- Better navigation that works with your style
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
							-- Quick close
							["<C-q>"] = "close",
							-- Send to quickfix (works with your ]q [q navigation)
							["<C-x>"] = "select_horizontal",
							["<C-v>"] = "select_vertical",
						},
					},
					-- Center layout for middle-of-screen positioning
					layout_strategy = "center",
					layout_config = {
						center = {
							height = 0.4,
							width = 0.6,
							preview_cutoff = 40,
						},
					},
				},
				pickers = {
					-- Customize specific pickers for better workflow
					find_files = {
						previewer = false, -- Faster file finding
						hidden = true, -- Show hidden files
					},
					live_grep = {
						-- Use horizontal layout with preview on the right
						layout_strategy = "horizontal",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								preview_width = 0.55,
								results_width = 0.45,
								mirror = false, -- This puts preview on the right
							},
							width = 0.9,
							height = 0.8,
						},
						-- Enable previewer with line highlighting
						previewer = true,
					},
					grep_string = {
						-- Same layout as live_grep for consistency
						layout_strategy = "horizontal",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								preview_width = 0.55,
								results_width = 0.45,
								mirror = false, -- This puts preview on the right
							},
							width = 0.9,
							height = 0.8,
						},
						-- Enable previewer with line highlighting
						previewer = true,
					},
					buffers = {
						previewer = false,
						initial_mode = "normal",
						sort_mru = true, -- Most recently used first
						ignore_current_buffer = true,
					},
					help_tags = {
						layout_config = {
							center = {
								height = 0.6,
								width = 0.8,
							},
						},
					},
					git_commits = {
						layout_config = {
							center = {
								height = 0.6,
								width = 0.9,
							},
						},
					},
					lsp_references = {
						initial_mode = "normal",
					},
					lsp_definitions = {
						initial_mode = "normal",
					},
				},
			})

			-- Configure preview window to show line numbers and highlight current line
			vim.api.nvim_create_autocmd("User", {
				pattern = "TelescopePreviewerLoaded",
				callback = function(args)
					-- Enable line numbers in preview
					vim.wo.number = true
					vim.wo.relativenumber = false
					-- Highlight the current line more clearly
					vim.wo.cursorline = true
					-- Wrap long lines for better readability
					vim.wo.wrap = true
					vim.wo.linebreak = true
				end,
			})

			-- Keymaps that integrate with your existing workflow
			local builtin = require("telescope.builtin")

			-- File operations (using 'f' prefix to match your pattern)
			vim.keymap.set("n", "ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>df", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find old files" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })
			vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find commands" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last search" })

			-- Git integration (using 'g' prefix like your tab commands use 't')
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
			vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
			vim.keymap.set("n", "<leader>gt", builtin.git_stash, { desc = "Git stash" })

			-- LSP integration (using 'l' prefix)
			vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "LSP references" })
			vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP definitions" })
			vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, { desc = "LSP implementations" })
			vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "LSP document symbols" })
			vim.keymap.set("n", "<leader>lw", builtin.lsp_workspace_symbols, { desc = "LSP workspace symbols" })
			vim.keymap.set("n", "<leader>lD", builtin.diagnostics, { desc = "LSP diagnostics" })

			-- Search in current buffer (complements your existing search clearing)
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find({
					layout_strategy = "center",
					layout_config = {
						center = {
							height = 0.4,
							width = 0.6,
						},
					},
					previewer = false,
				})
			end, { desc = "Fuzzy search in current buffer" })

			-- Quick access to telescope itself
			vim.keymap.set("n", "<leader>ft", builtin.builtin, { desc = "Find telescope pickers" })

			-- Registers picker (great for paste workflows)
			vim.keymap.set("n", '<leader>f"', builtin.registers, { desc = "Find registers" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- Configure ui-select BEFORE loading the extension
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						layout_strategy = "center",
						layout_config = {
							center = {
								height = 0.4,
								width = 0.5,
							},
						},
					},
				},
			})
			-- Load the extension
			require("telescope").load_extension("ui-select")
		end,
	},
}
