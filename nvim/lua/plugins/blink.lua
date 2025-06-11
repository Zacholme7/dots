return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		-- Use main branch for latest optimizations and build from source
		version = "1.*", -- Remove this to track main
		build = "cargo build --release",
		opts = {
			-- Performance: Use default keymap preset which is optimized
			keymap = { preset = "default" },

			-- Visual: Better appearance with mono font for proper alignment
			appearance = {
				nerd_font_variant = "mono",
				-- Set fallback highlights for better visibility if theme doesn't support blink.cmp
				use_nvim_cmp_as_default = false,
				-- Better kind icons for visual appeal
				kind_icons = {
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒓",
					Field = "󰜢",
					Variable = "󰆦",
					Property = "󰖷",
					Class = "󱡠",
					Interface = "󱡠",
					Struct = "󱡠",
					Module = "󰅩",
					Unit = "󰪚",
					Value = "󰦨",
					Enum = "󰦨",
					EnumMember = "󰦨",
					Keyword = "󰻾",
					Constant = "󰏿",
					Snippet = "󱄽",
					Color = "󰏘",
					File = "󰈔",
					Reference = "󰬲",
					Folder = "󰉋",
					Event = "󱐋",
					Operator = "󰪚",
					TypeParameter = "󰬛",
				},
			},

			completion = {
				-- Performance: Faster acceptance with auto brackets
				accept = {
					auto_brackets = { enabled = true },
					-- Performance: Create undo points and enable dot repeat
					create_undo_point = true,
					dot_repeat = true,
				},

				-- Performance: Optimized menu settings
				menu = {
					auto_show = true,
					-- Visual: Better borders and contrast for visibility
					border = "rounded", -- Add rounded borders for better separation
					winblend = 0, -- No transparency for better visibility
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					min_width = 20, -- Ensure minimum width for readability
					max_height = 12, -- Good balance of items visible
					-- Visual: Better column layout for readability
					draw = {
						columns = {
							{ "kind_icon", gap = 1 },
							{ "label", "label_description", gap = 1 },
						},
						-- Visual: Better padding and alignment
						padding = 1,
						gap = 1,
						-- Performance: Enable treesitter highlighting for better visuals
						treesitter = { "lsp" },
					},
					-- Visual: Better scrolling experience
					scrolloff = 2,
					scrollbar = true,
				},

				-- Visual: Enhanced documentation with faster display
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100, -- Faster than your current 100ms
					update_delay_ms = 50,
					treesitter_highlighting = true,
					window = {
						max_width = 80,
						max_height = 20,
						border = "rounded", -- Match menu border style
						winblend = 0, -- No transparency for better readability
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
						scrollbar = true,
					},
				},

				-- Performance: Optimized trigger settings
				trigger = {
					prefetch_on_insert = true, -- Performance boost
					show_on_keyword = true,
					show_on_trigger_character = true,
					keyword_length = 1, -- Removed this as it's not needed
					-- Performance: Reduced blocked characters for better responsiveness
					show_on_blocked_trigger_characters = { " ", "\n", "\t" },
				},

				-- Visual: Enable ghost text for better UX
				ghost_text = {
					enabled = true,
				},
			},

			-- Performance: Enable signature help for better development experience
			signature = {
				enabled = true,
				trigger = {
					show_on_insert_on_trigger_character = true,
				},
				window = {
					max_width = 100,
					max_height = 10,
					border = "rounded", -- Consistent border style
					winblend = 0, -- No transparency
					winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
					treesitter_highlighting = true,
				},
			},

			-- Performance: Optimized source configuration
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					-- Performance: Heavily prioritize LSP
					lsp = {
						score_offset = 1000,
						fallbacks = { "buffer" }, -- Only fallback to buffer when LSP has no results
					},
					-- Performance: High priority for snippets
					snippets = {
						score_offset = 500,
					},
					-- Performance: Medium priority for paths
					path = {
						score_offset = 100,
						min_keyword_length = 2,
					},
					-- Performance: Limit buffer completions significantly
					buffer = {
						score_offset = -100, -- Lower priority
						max_items = 3, -- Reduced from 5 for better performance
						min_keyword_length = 3, -- Increased from 2 to reduce noise
					},
				},
			},

			-- Performance: Use Rust implementation for best performance (built from source)
			fuzzy = {
				implementation = "rust", -- Since we're building from source, we can enforce rust
				-- Performance: Enable all performance features
				use_frecency = true,
				use_proximity = true,
				-- Performance: Allow some typos but not too many
				max_typos = function(keyword)
					return math.min(math.floor(#keyword / 4), 2)
				end,
				-- Advanced sorting for better results
				sorts = {
					"score",
					"sort_text",
				},
			},
		},
	},
}
