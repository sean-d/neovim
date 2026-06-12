return {
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        draw = {
          delay = 100,
          animation = require("mini.indentscope").gen_animation.quadratic({
            easing = "out",
            duration = 25,
            unit = "step",
          }),
        },
        mappings = {
          object_scope = 'ii',
          object_scope_with_border = 'ai',
          goto_top = '[i',
          goto_bottom = ']i',
        },
        options = {
          border = 'both',
          indent_at_cursor = true,
          try_as_border = false,
        },
        symbol = '│',
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#c6a0f6" })
          vim.api.nvim_set_hl(0, "IblIndent", { fg = "#494d64" })
          vim.api.nvim_set_hl(0, "IblScope", { fg = "#c6a0f6" })
        end,
      })

      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#c6a0f6" })
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#494d64" })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = false,
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