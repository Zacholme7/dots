return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "clangd", "rust_analyzer", "solidity" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp = require("cmp")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Hover and signature help styling
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded", max_width = 80}),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded", max_width = 80, max_height = 12}),
      }

      -- Set up nvim-cmp
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- LSP setup function
      local function setup_lsp(server, config)
        config = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
          handlers = handlers,
          flags = {
            debounce_text_changes = 150,
          },
        }, config or {})
        lspconfig[server].setup(config)
      end

      -- Python
      setup_lsp("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
              },
            },
          },
        },
      })

      -- C++
      setup_lsp("clangd", {
        cmd = {
          "clangd",
          "--clang-tidy",
          "--suggest-missing-includes",
          "--completion-style=detailed",
          "--inlay-hints",
        },
      })

      -- Rust
      setup_lsp("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            inlayHints = {
              enable = true,
              parameterHints = {
                enable = true,
              },
              typeHints = {
                enable = true,
              },
              chainingHints = {
                enable = true,
              },
            },
          },
        },
      })

      -- Solidity
      setup_lsp("solidity", {
        cmd = { "solc", "--lsp" },
        filetypes = { "solidity" },
        root_dir = lspconfig.util.root_pattern("hardhat.config.js", "hardhat.config.ts", "foundry.toml", "package.json", ".git"),
        single_file_support = true,
      })

      -- Keybindings
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)

      -- Enable inlay hints for all supported languages
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local bufnr = ev.buf
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          else
          end
        end,
      })

      -- Globally enable inlay hints
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end,
      })
    end
  }
}
