-- Only non-default settings are listed; see `:h blink-cmp-config-reference` for the rest.
return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*", -- latest release; downloads the prebuilt Rust fuzzy matcher
		opts = {
			completion = {
				menu = {
					border = "rounded",
					min_width = 20,
					max_height = 12,
					draw = {
						columns = {
							{ "kind_icon", gap = 1 },
							{ "label", "label_description", gap = 1 },
						},
						-- Highlight LSP completion labels with treesitter
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = true },
			},

			signature = {
				enabled = true,
				window = { border = "rounded" },
			},

			-- Ranking: LSP first, then snippets, then paths; buffer words last and sparse
			sources = {
				providers = {
					lsp = { score_offset = 1000 },
					snippets = { score_offset = 500 },
					path = { score_offset = 100, min_keyword_length = 2 },
					buffer = { score_offset = -100, max_items = 3, min_keyword_length = 3 },
				},
			},

			fuzzy = {
				-- One typo per 4 characters typed, capped at 2
				max_typos = function(keyword)
					return math.min(math.floor(#keyword / 4), 2)
				end,
			},
		},
	},
}
