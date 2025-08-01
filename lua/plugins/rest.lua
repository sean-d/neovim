return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      -- Main commands
      { "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Send request" },
      { "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Run all requests" },
      
      -- Common commands
      { "<leader>rp", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay last request" },
      { "<leader>rq", function()
        -- Simply close the bottom window (where responses typically appear)
        vim.cmd('wincmd j')  -- Move to bottom window
        local current_win = vim.api.nvim_get_current_win()
        local current_buf = vim.api.nvim_win_get_buf(current_win)
        local bufname = vim.api.nvim_buf_get_name(current_buf)
        
        -- Only close if we're not in the original http file
        if not bufname:match("%.http$") and not bufname:match("%.rest$") then
          vim.cmd('close')
        else
          -- If we're in the http file, try the original close
          require('kulala').close()
        end
      end, desc = "Close response" },
      { "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as curl" },
      { "<leader>ri", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Import from curl" },
      { "<leader>rs", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open REST scratchpad" },
      { "<leader>re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Select environment" },
      { "<leader>rv", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show request stats" },
    },
    config = function()
      require("kulala").setup({
        default_view = "body",
        split_direction = "horizontal",
        show_icons = "above_req",
        additional_curl_options = {},
        scratchpad = {
          convert_to_http_file = true,
        },
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
            error = "❌",
          },
          lualine = "🔌",
        },
        -- Use Snacks for floating windows
        on_open = function(result)
          -- Format the response nicely
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = result.buffer, silent = true })
        end,
      })

      -- Set up syntax highlighting for .http files
      vim.filetype.add({
        extension = {
          http = "http",
          rest = "http",
        },
      })
    end,
  },
}