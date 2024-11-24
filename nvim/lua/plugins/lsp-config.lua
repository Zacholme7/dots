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
        ensure_installed = { "rust_analyzer" }
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
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp = require("cmp")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Hover and signature help styling
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
          max_width = 80
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
          max_width = 80,
          max_height = 12
        })
      }

      -- Set up nvim-cmp
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
        })
      })

      -- Set up signature help with no emoji
      require("lsp_signature").setup({
        bind = true,
        handler_opts = { border = "rounded" },
        floating_window = true,
        toggle_key = '<C-k>',
        hint_enable = true,
        hint_prefix = "", -- Removed emoji/panda
        hint_scheme = "String", -- Changed hint color scheme
        max_height = 12,
        max_width = 80,
        wrap = true,
        floating_window_above_cur_line = true,
        padding = ' ',
      })

      -- Keybindings
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
      end, opts)

      -- Enable inlay hints for all supported languages
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end,
      })

      -- Add rust-analyzer setup
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        handlers = handlers,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            completion = {
              fullFunctionSignatures = true,
            },
            inlayHints = {
              enabled = true,
              bindingModeHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "always" },
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
          }
        },
        on_attach = function(client, bufnr)
          -- Enable signature help for this buffer with no emoji
          require("lsp_signature").on_attach({
            bind = true,
            handler_opts = { border = "rounded" },
            floating_window = true,
            toggle_key = '<C-k>',
            hint_enable = true,
            hint_prefix = "", -- Removed emoji/panda
            hint_scheme = "String", -- Changed hint color scheme
            padding = ' ',
          }, bufnr)

          -- Enable inlay hints for this buffer
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end
      })
    end
  }
}
