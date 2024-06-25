return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local bufferline = require("bufferline")

    -- Function to get buffers for the current tab
    local function get_tab_buffers()
      return vim.t.bufs or {}
    end

    bufferline.setup({
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = function(bufnum)
          -- Remove the buffer from the tab's buffer list
          local new_buffers = vim.tbl_filter(function(b) return b ~= bufnum end, get_tab_buffers())
          vim.t.bufs = new_buffers
          vim.cmd("bdelete! " .. bufnum)
        end,
        right_mouse_command = "vertical sbuffer %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        custom_filter = function(buf_number)
          -- Show buf if it's in the current tab's buffer list
          return vim.tbl_contains(get_tab_buffers(), buf_number)
        end,
      }
    })

    -- Autocommands to manage tab-local buffers
    local augroup = vim.api.nvim_create_augroup("TabLocalBuffers", { clear = true })

    vim.api.nvim_create_autocmd("TabNew", {
      group = augroup,
      callback = function()
        vim.t.bufs = {}
      end,
    })

    vim.api.nvim_create_autocmd("BufAdd", {
      group = augroup,
      callback = function(ev)
        local bufs = get_tab_buffers()
        if not vim.tbl_contains(bufs, ev.buf) then
          table.insert(bufs, ev.buf)
          vim.t.bufs = bufs
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup,
      callback = function(ev)
        local bufs = get_tab_buffers()
        if not vim.tbl_contains(bufs, ev.buf) then
          table.insert(bufs, ev.buf)
          vim.t.bufs = bufs
        end
      end,
    })

    -- Helper function to switch to a buffer within the current tab
    local function switch_buffer(id)
      local bufs = get_tab_buffers()
      if vim.tbl_contains(bufs, id) then
        vim.api.nvim_set_current_buf(id)
      end
    end

    -- Key mappings for buffer navigation within the tab
    vim.keymap.set('n', '<S-f>', function() bufferline.cycle(1) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<S-d>', function() bufferline.cycle(-1) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>1', function() switch_buffer(get_tab_buffers()[1]) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>2', function() switch_buffer(get_tab_buffers()[2]) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>3', function() switch_buffer(get_tab_buffers()[3]) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>4', function() switch_buffer(get_tab_buffers()[4]) end, { noremap = true, silent = true })
    -- Add more number keys as needed
    --
    --
        -- Corrected buffer deletion function
    vim.keymap.set('n', '<leader>x', function()
      local current_buf = vim.api.nvim_get_current_buf()
      local tab_buffers = get_tab_buffers()
      
      -- Filter out the current buffer
      local other_buffers = vim.tbl_filter(function(buf)
        return buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
      end, tab_buffers)

      if #other_buffers > 0 then
        -- Switch to the next buffer in the tab
        vim.cmd('buffer ' .. other_buffers[1])
      else
        -- Create a new empty buffer
        vim.cmd('enew')
      end

      -- Remove the buffer from the tab's buffer list
      vim.t.bufs = vim.tbl_filter(function(buf) return buf ~= current_buf end, tab_buffers)

      -- Delete the buffer
      vim.cmd('bdelete! ' .. current_buf)

      -- No need to manually update bufferline, it should update automatically
    end, { noremap = true, silent = true, desc = 'Close current buffer' })

    -- Command to move buffer to another tab
    vim.api.nvim_create_user_command("MoveBufferToTab", function(opts)
      local buf = vim.api.nvim_get_current_buf()
      local target_tab = tonumber(opts.args)
      if target_tab then
        -- Remove from current tab
        local current_bufs = vim.tbl_filter(function(b) return b ~= buf end, get_tab_buffers())
        vim.t.bufs = current_bufs
        
        -- Add to target tab
        vim.cmd.tabn(target_tab)
        local target_bufs = get_tab_buffers()
        table.insert(target_bufs, buf)
        vim.t.bufs = target_bufs
        vim.cmd.buf(buf)
      end
    end, { nargs = 1 })
  end,
}
