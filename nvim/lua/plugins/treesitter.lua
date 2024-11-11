return {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "lua", 
                "cpp", 
                "python",
                "markdown",
                "markdown_inline",  -- This is important for markdown hover
                "rust",            -- Since you use rust
                "c",              -- Since you use cpp
                "vim",
                "vimdoc",         -- For help files
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
