local options = {
    number = true, -- set the line numbers
    wrap = false, -- make it so that lines do not wrap

    -- makes is so that searching ignores case, exepct if we search with a capital letter then it is case sensitive
    ignorecase = true,
    smartcase = true,

    scrolloff = 999,-- makes is so that the cursor is always in the center, not sure if i like this

    swapfile = false,-- make sure that swapfiles are not generated
    autochdir = true,-- makes it so that the directory is changed when we open files
    relativenumber = true, -- makes the line numbers relative
    cursorline = true, -- highlights the line where the cursor is 
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    mouse = "a", -- allows the mouse to be used
    undofile = true, -- enables persistent undo
    expandtab = true, -- cover tabs to spaces
    shiftwidth = 4, -- the number of spaces for each indentation
    tabstop = 4, -- the number of spaces for a tab
}

for k, v in pairs(options) do
    vim.opt[k] = v
end













