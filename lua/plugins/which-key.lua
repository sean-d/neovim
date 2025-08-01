return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,
      win = {
        border = {
          { '╭', 'WhichKeyBorder' },
          { '─', 'WhichKeyBorder' },
          { '╮', 'WhichKeyBorder' },
          { '│', 'WhichKeyBorder' },
          { '╯', 'WhichKeyBorder' },
          { '─', 'WhichKeyBorder' },
          { '╰', 'WhichKeyBorder' },
          { '│', 'WhichKeyBorder' },
        },
        title = true,
        title_pos = "center",
        padding = { 1, 2 },
        wo = {
          winblend = 0,
        },
      },
      layout = {
        width = { min = 20 },
        spacing = 3,
      },
      icons = {
        mappings = vim.g.have_nerd_font,
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><leader>", desc = "Switch buffers" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>cd", group = "docker", icon = { icon = "󰡨 ", color = "blue" } },
          { "<leader>cx", group = "trouble", icon = { icon = " ", color = "red" } },
          { "<leader>d", group = "debug/development", icon = { icon = " ", color = "red" } },
          { "<leader>D", group = "database", icon = { icon = " ", color = "yellow" } },
          { "<leader>dg", group = "go", icon = { icon = " ", color = "blue" } },
          { "<leader>dgo", group = "go", icon = { icon = " ", color = "blue" } },
          { "<leader>dp", group = "php/pwsh", icon = { icon = "󰔶 ", color = "cyan" } },
          { "<leader>dj", group = "javascript", icon = { icon = " ", color = "yellow" } },
          { "<leader>djs", group = "javascript/typescript", icon = { icon = " ", color = "yellow" } },
          { "<leader>dph", group = "php", icon = { icon = " ", color = "purple" } },
          { "<leader>dphc", group = "composer", icon = { icon = " ", color = "purple" } },
          { "<leader>dps", group = "powershell", icon = { icon = " ", color = "blue" } },
          { "<leader>dr", group = "rust", icon = { icon = " ", color = "orange" } },
          { "<leader>drs", group = "rust", icon = { icon = " ", color = "orange" } },
          { "<leader>dz", group = "zsh", icon = { icon = " ", color = "yellow" } },
          { "<leader>dzs", group = "zsh/shell", icon = { icon = " ", color = "green" } },
          { "<leader>dpy", group = "python", icon = { icon = " ", color = "yellow" } },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>h", group = "harpoon", icon = { icon = "󱡀 ", color = "cyan" } },
          { "<leader>q", group = "quit" },
          { "<leader>s", group = "search" },
          { "<leader>S", group = "session", icon = { icon = "💾", color = "green" } },
          { "<leader>t", group = "terminal", icon = { icon = "", color = "green" } },
          { "<leader>m", group = "markdown", icon = { icon = "󰍔 ", color = "cyan" } },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "scratch", icon = { icon = "󰆓 ", color = "cyan" } },
          { "<leader>r", group = "rest/api", icon = { icon = "󰡱 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          local docs_path = vim.fn.stdpath("config") .. "/docs/book/index.html"
          if vim.fn.filereadable(docs_path) == 1 then
            vim.fn.system("open " .. vim.fn.shellescape(docs_path))
          else
            vim.notify("Documentation not built. Run 'mdbook build' in the config directory first.", vim.log.levels.WARN)
          end
        end,
        desc = "Open Documentation (Browser)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    config = function(_, opts)
      -- Create highlight for WhichKey border
      vim.api.nvim_set_hl(0, 'WhichKeyBorder', { fg = '#ca9ee6' }) -- Mauve
      
      require("which-key").setup(opts)
    end,
  },
}
