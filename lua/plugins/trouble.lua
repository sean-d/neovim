return {
  -- Better diagnostics list
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      auto_close = false, -- auto close when there are no items
      auto_open = false, -- auto open when there are items
      auto_preview = true, -- automatically open preview when on an item
      auto_refresh = true, -- auto refresh when open
      focus = true, -- Focus the window when opened
      follow = true, -- Follow the current item
      indent_guides = true, -- show indent guides
      max_items = 200, -- limit number of items that can be displayed per section
      multiline = true, -- render multi-line messages
      pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
      warn_no_results = true, -- show warning when there are no results
      -- Window options
      win = {
        size = {
          width = 0.3,
          height = 0.3,
        },
        position = "right",
      },
      -- Keybindings inside Trouble window
      keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        -- go down to next item (accepts count)
        j = "next",
        ["<down>"] = "next",
        ["<tab>"] = "next",
        -- go up to prev item (accepts count)
        k = "prev",
        ["<up>"] = "prev",
        ["<s-tab>"] = "prev",
        dd = "delete",
        d = { action = "delete", mode = "v" },
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        zc = "fold_close",
        zC = "fold_close_recursive",
        za = "fold_toggle",
        zA = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        zR = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        zi = "fold_toggle_enable",
        gb = { -- example of a custom action that toggles the active view filter
          action = function(view)
            view:filter({ buf = 0 }, { toggle = true })
          end,
          desc = "Toggle Current Buffer Filter",
        },
      },
      -- Customize icons
      icons = {
        indent = {
          fold_open = "▾ ",
          fold_closed = "▸ ",
          ws = "  ",
        },
        folder_closed = " ",
        folder_open = " ",
        kinds = {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",
          Object = " ",
          Operator = " ",
          Package = " ",
          Property = " ",
          String = " ",
          Struct = "󰆼 ",
          TypeParameter = " ",
          Variable = "󰀫 ",
        },
      },
    },
    keys = {
      { "<leader>cxx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle trouble" },
      { "<leader>cxX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>cxs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
      { "<leader>cxl", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions" },
      { "<leader>cxq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>cxL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>cxt", "<cmd>Trouble todo toggle<cr>", desc = "Todo comments" },
    },
  },
  
  -- Todo comments (works with trouble)
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the sign column
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰋽 ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        multiline = true, -- enable multine todo comments
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide" or empty
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
}