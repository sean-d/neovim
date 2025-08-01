return {
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>co", "<cmd>Outline<CR>", desc = "Toggle code outline" },
      { "<leader>cO", "<cmd>OutlineFocus<CR>", desc = "Focus code outline" },
    },
    opts = {
      outline_window = {
        position = 'right',
        width = 25,
        relative_width = true,
        auto_close = false,
        auto_jump = false,
        jump_highlight_duration = 300,
        center_on_jump = true,
        show_numbers = false,
        show_relative_numbers = false,
        wrap = false,
        show_cursorline = true,
        hide_cursor = false,
        focus_on_open = false,
        
        -- Keybindings in outline window
        keymaps = {
          show_help = '?',
          close = {'<Esc>', 'q'},
          goto_location = '<CR>',
          focus_location = 'o',
          hover_symbol = '<C-space>',
          toggle_preview = 'K',
          rename_symbol = 'r',
          code_actions = 'a',
          fold = 'h',
          unfold = 'l',
          fold_toggle = '<Tab>',
          fold_toggle_all = '<S-Tab>',
          fold_all = 'W',
          unfold_all = 'E',
          fold_reset = 'R',
          down_and_jump = '<C-j>',
          up_and_jump = '<C-k>',
        },
      },
      
      outline_items = {
        show_symbol_details = true,
        show_symbol_lineno = false,
        highlight_hovered_item = true,
        auto_set_cursor = true,
        auto_update_events = {
          follow = { 'CursorMoved' },
          items = { 'InsertLeave', 'WinEnter', 'BufEnter', 'BufWinEnter', 'TabEnter', 'BufWritePost' },
        },
      },
      
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
          only = 1,
        },
        markers = { '', '' },
      },
      
      preview_window = {
        auto_preview = false,
        open_hover_on_preview = false,
        width = 50,
        min_width = 50,
        relative_width = true,
        border = 'single',
        winhl = 'NormalFloat:',
        winblend = 0,
        live = false,
      },
      
      -- Provider priority
      providers = {
        priority = { 'lsp', 'coc', 'markdown', 'norg' },
        lsp = {
          blacklist_clients = {},
        },
      },
      
      -- Symbols configuration
      symbols = {
        -- Filter symbols to show
        filter = nil,
        
        -- Icon mappings
        icon_fetcher = function(kind)
          local icons = {
            File = '󰈙 ',
            Module = ' ',
            Namespace = '󰌗 ',
            Package = ' ',
            Class = '󰌗 ',
            Method = '󰆧 ',
            Property = ' ',
            Field = ' ',
            Constructor = ' ',
            Enum = ' ',
            Interface = '󰕘 ',
            Function = '󰊕 ',
            Variable = '󰆧 ',
            Constant = '󰏿 ',
            String = ' ',
            Number = '󰎠 ',
            Boolean = '◩ ',
            Array = '󰅪 ',
            Object = '󰅩 ',
            Key = '󰌋 ',
            Null = '󰟢 ',
            EnumMember = ' ',
            Struct = '󰌗 ',
            Event = ' ',
            Operator = '󰆕 ',
            TypeParameter = '󰊄 ',
            
            -- Markdown specific
            H1 = '󰉫 ',
            H2 = '󰉬 ',
            H3 = '󰉭 ',
            H4 = '󰉮 ',
            H5 = '󰉯 ',
            H6 = '󰉰 ',
          }
          return icons[kind] or ' '
        end,
        
        -- Custom icon source
        icon_source = nil,  -- Use our custom icon_fetcher instead
      },
    },
    config = function(_, opts)
      require("outline").setup(opts)
      
      -- Custom highlights
      vim.api.nvim_set_hl(0, "OutlineGuides", { fg = "#494d64" })
      vim.api.nvim_set_hl(0, "OutlineFoldMarker", { fg = "#c6a0f6" })
      vim.api.nvim_set_hl(0, "OutlineCurrent", { fg = "#f5c2e7", bold = true })
    end,
  },
}