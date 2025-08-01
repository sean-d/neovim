return {
  -- Disable indent-blankline since we'll use mini.indentscope
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  
  -- Better indent guides with scope highlighting
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        draw = {
          delay = 100,
          animation = require("mini.indentscope").gen_animation.quadratic({
            easing = "out",
            duration = 25,  -- Very fast animation
            unit = "step",
          }),
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          object_scope = 'ii',
          object_scope_with_border = 'ai',
          goto_top = '[i',
          goto_bottom = ']i',
        },
        -- Options which control scope computation
        options = {
          border = 'both',
          indent_at_cursor = true,
          try_as_border = false,
        },
        -- Symbol to display for scope
        symbol = '│',
      })
      
      -- Set colors for indent scope
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Active scope in mauve
          vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#c6a0f6" })
          -- Other indent guides in grey
          vim.api.nvim_set_hl(0, "IblIndent", { fg = "#494d64" })
          vim.api.nvim_set_hl(0, "IblScope", { fg = "#c6a0f6" })
        end,
      })
      
      -- Apply immediately
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#c6a0f6" })
    end,
  },
  
  -- Keep basic indent guides for non-active scopes
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = false, -- We use mini.indentscope for this
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}