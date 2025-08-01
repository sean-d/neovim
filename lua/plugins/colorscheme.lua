return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
      color_overrides = {
        macchiato = {
          -- Use Mocha's darker background colors
          base = "#1e1e2e",     -- Mocha base
          mantle = "#181825",   -- Mocha mantle
          crust = "#11111b",    -- Mocha crust
        },
      },
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        snacks = true,
        telescope = {
          enabled = false,
        },
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
      
      -- Flash.nvim highlights
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
      vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#3e4451", fg = "#cdd6f4" })
      vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#45475a", fg = "#f5e0dc" })
      vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#f5c2e7", fg = "#11111b", bold = true })
      
      -- Pink borders for floating windows (affects Harpoon and others)
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#f5c2e7" })
      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    end,
  },
}