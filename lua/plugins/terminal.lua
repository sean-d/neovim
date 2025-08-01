return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Merge terminal configuration into existing snacks opts
      opts.terminal = {
        enabled = true,
        win = {
          -- Default window options for floating terminals
          position = "float",
          border = "rounded",
          title = " Terminal ",
          title_pos = "center",
          width = 0.8,
          height = 0.8,
          keys = {
            ["<C-q>"] = { "close", desc = "Hide terminal" },
          },
        },
      }
      return opts
    end,
    keys = {
      -- Terminal keybindings with <leader>t prefix
      { "<leader>t", desc = "+terminal" },
      
      -- Toggle floating terminal
      { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal (float)" },
      
      -- Open new floating terminal
      { "<leader>tf", function() Snacks.terminal.open() end, desc = "New Terminal (float)" },
      
      -- Split terminals
      { "<leader>th", function() Snacks.terminal.open(nil, { win = { position = "bottom", height = 0.3 } }) end, desc = "Terminal Split Below" },
      { "<leader>tv", function() Snacks.terminal.open(nil, { win = { position = "right", width = 0.4 } }) end, desc = "Terminal Split Right" },
      
    },
  },
}