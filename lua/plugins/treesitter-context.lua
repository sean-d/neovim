return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,  -- Explicitly enable the plugin
    event = "VeryLazy",  -- Load earlier to ensure it's ready
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enable = true, -- Enable this plugin (can be toggled on/off later)
      max_lines = 5, -- Increased to show more context lines
      min_window_height = 0, -- Minimum editor window height to enable context
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'inner', -- Changed to 'inner' to be less aggressive
      mode = 'topline', -- Changed from 'cursor' to 'topline' for better tracking
      separator = nil, -- Separator between context and content (nil for no separator)
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- Function to run when attaching to a buffer
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      
      -- Custom highlighting to match your theme
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#2a2b3c" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#6c7086", bg = "#2a2b3c" })
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#494d64" })
    end,
    keys = {
      { "<leader>tc", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" },
      { "[c", function() require("treesitter-context").go_to_context() end, desc = "Jump to context" },
    },
    init = function()
      -- Ensure it's enabled by default
      vim.g.treesitter_context_enabled = true
    end,
  },
}