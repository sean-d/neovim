return {
  -- nvim-dap: Debug Adapter Protocol client implementation
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      -- General debugging keybindings under <leader>d
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>ds", "<cmd>DapStepOver<cr>", desc = "Step over" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step into" },
      { "<leader>do", "<cmd>DapStepOut<cr>", desc = "Step out" },
      { "<leader>dd", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Evaluate expression", mode = { "n", "v" } },
      { "<leader>dE", function() require("dapui").eval(vim.fn.input("Expression: ")) end, desc = "Evaluate input" },
      { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
      { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover variables" },
      { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Preview" },
      { "<leader>df", function() 
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end, desc = "Frames" },
      { "<leader>dS", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end, desc = "Scopes" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup dap-ui
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })
      
      -- Virtual text for debugging
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
      })
      
      -- Auto open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      -- Set breakpoint signs
      vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointCondition', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointRejected', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapLogPoint', {text='●', texthl='DapLogPoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='▶', texthl='DapStopped', linehl='DapStoppedLine', numhl=''})
      
      -- Set highlight colors
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#f5c2e7' }) -- Pink like indent line
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#89b4fa' }) -- Blue
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#a6e3a1' }) -- Green
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e3440' }) -- Subtle background for current line
      
      -- Python debugging configuration
      dap.adapters.python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }
      
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Use activated venv if available
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file with arguments',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, " ")
          end,
          pythonPath = function()
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Django',
          program = vim.fn.getcwd() .. '/manage.py',
          args = { 'runserver', '--noreload' },
          django = true,
          pythonPath = function()
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Flask',
          module = 'flask',
          env = {
            FLASK_APP = 'app.py',
            FLASK_ENV = 'development',
          },
          args = { 'run', '--no-debugger', '--no-reload' },
          pythonPath = function()
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
      }
      
      -- PHP debugging configuration will be loaded on demand
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "php",
        callback = function()
          -- Lazy load PHP DAP configuration when entering a PHP file
          local ok, dap_php = pcall(require, "config.dap-php")
          if ok then
            dap_php.setup()
          end
        end,
      })
    end,
  },
  
  -- nvim-dap-go: Go debugging support
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("dap-go").setup({
        -- Additional dap configurations
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        -- delve configurations
        delve = {
          -- Path to delve executable (default: "dlv")
          path = "dlv",
          -- Time to wait for delve to initialize the debug session
          initialize_timeout_sec = 20,
          -- Port to start delve debugger on
          port = "${port}",
        },
      })
    end,
  },
}