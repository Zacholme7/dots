return {
	-- Performance: Lazy-load Mason only when needed
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"rust-analyzer",
				"lua-language-server",
				"stylua",
				"shellcheck",
				"shfmt",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			-- Performance: Install tools in background
			vim.defer_fn(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end, 100)
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = { "rust_analyzer", "lua_ls" },
			automatic_installation = true,
		},
	},

	-- Performance: Optimized LSP configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Visual: Better diagnostic configuration
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
					-- Performance: Only show errors and warnings in virtual text
					severity = { min = vim.diagnostic.severity.WARN },
				},
				severity_sort = true,
				update_in_insert = false, -- Performance: Don't update diagnostics in insert mode
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "󰌵 ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				float = {
					-- Visual: Better floating window for diagnostics
					border = "rounded",
					source = "always",
				},
			})

			-- Performance: Optimized LSP keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- Core navigation keymaps
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					-- Code actions and refactoring
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					-- Formatting (async for performance)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({
							async = true,
							-- Performance: Only format with specific LSPs if multiple are attached
							filter = function(format_client)
								return format_client.name ~= "tsserver"
							end,
						})
					end, opts)

					-- Visual: Diagnostic navigation with better UX
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_prev({ float = { border = "rounded" } })
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_next({ float = { border = "rounded" } })
					end, opts)

					-- Performance: Optimized inlay hints with better error handling
					if client and client.server_capabilities.inlayHintProvider then
						vim.defer_fn(function()
							local success, err = pcall(function()
								if vim.api.nvim_buf_is_valid(ev.buf) then
									vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
								end
							end)
							if not success then
								vim.notify("Failed to enable inlay hints: " .. tostring(err), vim.log.levels.WARN)
							end
						end, 200) -- Slightly longer delay for stability
					end
				end,
			})

			-- Performance: Get optimized capabilities from blink.cmp
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Performance: Disable semantic tokens for faster response (optional)
			-- capabilities.textDocument.semanticTokens = nil

			local lspconfig = require("lspconfig")

			-- Optimized Lua LS configuration
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
							-- Performance: Disable some checks for speed
							disable = { "missing-fields" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
							-- Performance: Don't analyze entire workspace
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
						telemetry = { enable = false },
						-- Clean: Disable inlay hints for Lua to avoid conflicts
						hint = { enable = false },
						-- Performance: Format configuration
						format = { enable = false }, -- Use stylua instead
					},
				},
			})

			-- Performance: Setup other LSPs if they exist
			local servers = { "rust_analyzer", "pyright", "tsserver" }
			for _, server in ipairs(servers) do
				if require("mason-registry").is_installed(server) then
					lspconfig[server].setup({
						capabilities = capabilities,
					})
				end
			end
		end,
	},

	-- Performance: Optimized formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
						timeout_ms = 1000, -- Faster timeout
					})
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" }, -- Consider black over autopep8 for speed
				rust = { "rustfmt" },
				sh = { "shfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
			},
			-- Performance: Faster format on save
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
				async = false, -- Synchronous for save
			},
			-- Performance: Notify on format errors
			notify_on_error = true,
		},
	},
}
