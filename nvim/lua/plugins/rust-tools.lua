return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Set up rust_analyzer via mason
    local mason_registry = require("mason-registry")
    local rust_analyzer = mason_registry.get_package("rust-analyzer")
    
    -- Ensure specific version of rust-analyzer is installed
    if not rust_analyzer:is_installed() then
      rust_analyzer:install({
        version = "2024-10-21"  -- Pin to the working version
      })
    end

    local rt = require("rust-tools")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    rt.setup({
      tools = {
        hover_actions = {
          auto_focus = true,
          border = "rounded",
          width = 60,
          height = 30,
        },
        inlay_hints = {
          auto = false,
        }
      },
      server = {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              loadOutDirsFromCheck = true,
              autoreload = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          rt.inlay_hints.disable();
          local opts = { buffer = bufnr }
          -- Rust-tools specific bindings
          vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
          vim.keymap.set("n", "<leader>rd", rt.open_documentation, opts)
          vim.keymap.set("n", "<leader>rr", rt.runnables.runnables, opts)
          vim.keymap.set("n", "<leader>ra", rt.code_action_group.code_action_group, opts)
          
          -- Standard LSP bindings
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
        standalone = true,
      },
    })

    -- Add a command to easily check the rust-analyzer version
    vim.api.nvim_create_user_command("RustAnalyzerVersion", function()
      if rust_analyzer:is_installed() then
        local version = rust_analyzer.spec.version
        print("rust-analyzer version: " .. (version or "unknown"))
      else
        print("rust-analyzer is not installed")
      end
    end, {})
  end
}
