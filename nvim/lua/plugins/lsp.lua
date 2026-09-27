return {
	{
		"mason-org/mason.nvim",
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
				"prettier",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			-- Install missing tools in the background once the registry is loaded
			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
					-- Only show errors and warnings in virtual text
					severity = { min = vim.diagnostic.severity.WARN },
				},
				severity_sort = true,
				update_in_insert = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "󰌵 ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				float = {
					border = "rounded",
					source = true,
				},
			})

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

					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
					end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
						telemetry = { enable = false },
						hint = { enable = false },
						format = { enable = false }, -- Use stylua instead
					},
				},
			})

			-- Foundry-native Solidity LSP: mmsaki/solidity-language-server, powered by
			-- solc + forge. Provides completion (incl. inherited members), hover,
			-- go-to-definition, references, rename, and diagnostics.
			--   Install: cargo install --locked solidity-language-server  (binary -> ~/.cargo/bin)
			--   Requires: `forge` on PATH and a project that compiles (`forge build`)
			--   for full indexing. Runs over stdio.
			vim.lsp.config("solidity_ls_foundry", {
				cmd = { "solidity-language-server", "--stdio" },
				filetypes = { "solidity" },
				root_markers = { "foundry.toml", "remappings.txt", ".git" },
			})

			vim.lsp.config("rust_analyzer", {
				-- rust-analyzer's WARN chatter otherwise lands in lsp.log as ERROR lines (it grew to ~300MB)
				cmd_env = { RA_LOG = "error" },
				settings = {
					["rust-analyzer"] = {
						-- Faster on big workspaces, but tests/benches/examples get no
						-- diagnostics. Set to true if you want them checked.
						check = { allTargets = false },
						files = { exclude = { ".direnv", "node_modules" } },
					},
				},
			})

			vim.lsp.enable({ "lua_ls", "solidity_ls_foundry", "rust_analyzer" })

			local optional_servers = {
				pyright = "pyright",
				ts_ls = "typescript-language-server",
			}
			local mason_registry = require("mason-registry")
			for server, package in pairs(optional_servers) do
				if mason_registry.is_installed(package) then
					vim.lsp.enable(server)
				end
			end
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback", timeout_ms = 1000 })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				solidity = { "forge_fmt" },
			},
			formatters = {
				-- stdin variant of the built-in forge_fmt (no temp files next to your sources)
				forge_fmt = {
					command = "forge",
					args = { "fmt", "--raw", "-" },
					stdin = true,
				},
			},
			default_format_opts = { lsp_format = "fallback" },
			format_on_save = { timeout_ms = 1000 },
			notify_on_error = true,
		},
	},
}
