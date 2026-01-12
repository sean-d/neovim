return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "echasnovski/mini.icons",
    event = "VeryLazy",
    init = function()
      -- Start with bufferline hidden
      vim.opt.showtabline = 0
    end,
    opts = {
      options = {
        -- Basic settings
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        
        -- Diagnostics
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and "󰅚 " -- nf-md-close_circle
              or (e == "warning" and "󰀪 " -- nf-md-alert
              or (e == "hint" and "󰌶 " -- nf-md-lightbulb  
              or (e == "info" and "󰋽 " or ""))) -- nf-md-information
            s = s .. sym .. n .. " "
          end
          return s:sub(1, -2) -- Remove trailing space
        end,
        
        -- UI
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        
        -- Tabs
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        
        -- Colors
        color_icons = true,
        
        -- Sorting - pinned buffers will stay to the left
        sort_by = 'insert_after_current',
        
        -- Style
        separator_style = { "", "" }, -- Empty separators for block style
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'}
        },
        
        -- Buffer picking
        pick = {
          alphabet = "abcdefghijklmnopqrstuvwxyz",
        },
        
        -- Offsets (keeping config for potential future use)
        offsets = {
          {
            filetype = "snacks_explorer",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          }
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Ensure bufferline starts hidden
      vim.opt.showtabline = 0
      vim.g.bufferline_enabled = false
    end,
  },
}