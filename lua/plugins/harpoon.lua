return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          key = function()
            -- This ensures we get project-specific marks
            return vim.loop.cwd()
          end,
        },
      })
      
      -- Set pink border for Harpoon menu
      vim.api.nvim_set_hl(0, 'HarpoonBorder', { fg = '#f5c2e7' })
      vim.api.nvim_set_hl(0, 'HarpoonWindow', { link = 'Normal' })
    end,
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
          vim.notify("Added to Harpoon", vim.log.levels.INFO)
        end,
        desc = "Add file to Harpoon",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list(), {
            border = "rounded",
            title_pos = "center",
            ui_nav_wrap = true,
            ui_width_ratio = 0.40,
          })
        end,
        desc = "Toggle Harpoon menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<leader>5",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon file 5",
      },
      -- Navigate through the list
      {
        "[h",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Previous Harpoon file",
      },
      {
        "]h",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Next Harpoon file",
      },
    },
  },
}