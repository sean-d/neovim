return {
  {
    "rmagatti/auto-session",
    lazy = false, -- Load immediately for auto-restore
    opts = {
      -- Basic behavior
      enabled = true,
      auto_save = true,
      auto_restore = true,

      -- Save session every 30 seconds (not on every BufLeave)
      auto_save_interval = 30000,

      -- Don't create sessions for these directories
      suppressed_dirs = {
        "~/",
        "~/Downloads",
        "~/Desktop",
        "~/Documents",
        "/tmp",
        "/",
      },

      -- Don't restore these buffer types
      bypass_save_filetypes = {
        "netrw",
        "dashboard",
        "help",
        "qf",
        "gitcommit",
        "gitrebase",
        "neoterm",
        "terminal",
        "dap-repl",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_scopes",
        "dapui_console",
        "trouble",
      },
      
      -- Close these before saving
      close_unsupported_windows = true,
      
      -- Log level (error only)
      log_level = "error",
      
      -- Don't show session picker on startup
      session_lens = {
        load_on_setup = false,
        picker_opts = { border = true },
        previewer = false,
      },
      
      -- Save extra info
      pre_save_cmds = {
        function()
          -- Close all terminal windows before saving
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "terminal" then
              vim.api.nvim_win_close(win, true)
            end
          end
        end,
      },
    },
    
    -- Keybindings
    keys = {
      -- Session management under <leader>S
      { "<leader>Ss", "<cmd>AutoSession save<cr>", desc = "Save session" },
      { "<leader>Sr", "<cmd>AutoSession restore<cr>", desc = "Restore session" },
      { "<leader>Sd", "<cmd>AutoSession delete<cr>", desc = "Delete current session" },
      { "<leader>SD", "<cmd>AutoSession purge_orphaned<cr>", desc = "Delete orphaned sessions" },
      { "<leader>Sl", "<cmd>AutoSession search<cr>", desc = "List/search sessions" },
      { "<leader>St", "<cmd>AutoSession toggle_auto_save<cr>", desc = "Toggle auto-save" },
      { "<leader>SL", "<cmd>LspStart<cr>", desc = "Start LSP (fix session restore)" },
    },
    
    config = function(_, opts)
      -- Set up auto-session
      require("auto-session").setup(opts)
      
      -- Clean up scratch buffers on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(buf)
              if name:match("filetype%-match%-scratch") then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end)
        end,
      })
      
      -- Fix for LSP not attaching to restored buffers
      vim.api.nvim_create_autocmd("SessionLoadPost", {
        callback = function()
          vim.defer_fn(function()
            -- Re-edit all buffers to trigger proper filetype detection and LSP
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd("silent! e")
                end)
              end
            end
            
            -- Clean up scratch buffers created by filetype detection
            vim.schedule(function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(buf)
                if name:match("filetype%-match%-scratch") then
                  pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
              end
            end)
          end, 200)
        end,
      })
    end,
  },
}
