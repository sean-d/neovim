return {
  -- Database interface
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
  },
  
  -- Database UI
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_winwidth = 40
      
      -- Icons configuration
      vim.g.db_ui_icons = {
        expanded = {
          db = "▾ ",
          buffers = "▾ ",
          saved_queries = "▾ ",
          schemas = "▾ ",
          schema = "▾ ",
          tables = "▾ ",
          table = "▾ ",
        },
        collapsed = {
          db = "▸ ",
          buffers = "▸ ",
          saved_queries = "▸ ",
          schemas = "▸ ",
          schema = "▸ ",
          tables = "▸ ",
          table = "▸ ",
        },
        saved_query = "",
        new_query = "󰝒",
        tables = "",
        buffers = "󰦨",
        add_connection = "",
        connection_ok = "✓",
        connection_error = "✕",
      }
      
      -- Use table helper for common queries
      vim.g.db_ui_use_nvim_notify = 1
      
      -- Save location for queries
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      
      -- Don't execute on save by default
      vim.g.db_ui_execute_on_save = 0
    end,
    keys = {
      { "<leader>Dt", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<CR>", desc = "Add DB Connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "Find DB Buffer" },
    },
  },
  
  -- SQL completion
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "vim-dadbod", "hrsh7th/nvim-cmp" },
    ft = { "sql", "mysql", "plsql" },
    config = function()
      -- Setup autocmd for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          -- Configure completion for SQL files
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            }),
            -- Configure completion behavior
            completion = {
              autocomplete = { 
                require("cmp.types").cmp.TriggerEvent.TextChanged,
                require("cmp.types").cmp.TriggerEvent.InsertEnter,
              },
              keyword_length = 1,
              keyword_pattern = [=[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]=],
            },
            -- Add SQL-specific trigger patterns
            experimental = {
              ghost_text = false,
            },
            -- Trigger on SQL keywords
            performance = {
              trigger_debounce_time = 100,
            },
          })
          
          -- Also set omnifunc as fallback
          vim.bo.omnifunc = "vim_dadbod_completion#omni"
        end,
      })
    end,
  },
}