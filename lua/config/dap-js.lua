-- JavaScript/TypeScript debugging configuration
local M = {}

function M.setup()
  local dap = require("dap")
  local dap_utils = require("dap.utils")
  
  -- Path to js-debug-adapter
  local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
  
  -- Adapter configuration for js-debug-adapter
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        js_debug_path .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
  
  -- Chrome/Edge adapter
  dap.adapters["pwa-chrome"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        js_debug_path .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
  
  -- Node.js configurations
  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch with npm/yarn/pnpm",
      runtimeExecutable = function()
        -- Detect package manager
        if vim.fn.filereadable("yarn.lock") == 1 then
          return "yarn"
        elseif vim.fn.filereadable("pnpm-lock.yaml") == 1 then
          return "pnpm"
        else
          return "npm"
        end
      end,
      runtimeArgs = function()
        local cmd = vim.fn.input("npm script to debug (e.g., 'dev', 'start'): ")
        return { "run", cmd }
      end,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to process",
      processId = dap_utils.pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Port 9229",
      port = 9229,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Vitest (Current File)",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "${workspaceFolder}/node_modules/.bin/vitest",
      runtimeArgs = {
        "run",
        "${file}",
        "--reporter=verbose",
        "--no-coverage",
        "--single-thread"
      },
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      sourceMaps = true,
      outFiles = { "${workspaceFolder}/**/*.js" },
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node", 
      request = "launch",
      name = "Debug Vitest (Attach Mode)",
      runtimeExecutable = "node",
      runtimeArgs = {
        "--inspect-brk=9229",
        "${workspaceFolder}/node_modules/.bin/vitest",
        "run",
        "${file}"
      },
      port = 9229,
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      sourceMaps = true,
      autoAttachChildProcesses = true,
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
  }
  
  -- TypeScript uses same configurations but with source map support
  dap.configurations.typescript = vim.deepcopy(dap.configurations.javascript)
  
  -- Add TypeScript specific launch configs
  -- Option 1: Launch compiled JS (recommended by article)
  table.insert(dap.configurations.typescript, 1, {
    type = "pwa-node",
    request = "launch",
    name = "Launch compiled JS",
    program = function()
      -- Try to find the compiled JS file
      local ts_file = vim.fn.expand("%:p")
      local js_file = ts_file:gsub("/src/", "/dist/"):gsub("%.ts$", ".js")
      
      if vim.fn.filereadable(js_file) == 1 then
        return js_file
      else
        vim.notify("Compiled JS not found. Run 'npm run build' first", vim.log.levels.WARN)
        return "${file}"
      end
    end,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    outFiles = {
      "${workspaceFolder}/dist/**/*.js",
    },
  })
  
  -- Option 2: Use npx tsx (project-local)
  table.insert(dap.configurations.typescript, 2, {
    type = "pwa-node",
    request = "launch",
    name = "Launch with npx tsx",
    runtimeExecutable = "npx",
    runtimeArgs = { "tsx" },
    args = { "${file}" },
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  })
  
  -- Option 3: Attach to Node process (from article)
  table.insert(dap.configurations.typescript, 3, {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node process",
    processId = dap_utils.pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  })
  
  -- Chrome debugging for Vue/React/Frontend
  dap.configurations.javascriptreact = {
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch Brave",
      runtimeExecutable = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
      url = function()
        local default_url = "http://localhost:3000"
        if vim.fn.filereadable("vite.config.ts") == 1 or vim.fn.filereadable("vite.config.js") == 1 then
          default_url = "http://localhost:5173"
        end
        return vim.fn.input("URL: ", default_url)
      end,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      -- Skip files we don't want to debug into
      skipFiles = {
        "<node_internals>/**",
        "node_modules/**",
        "**/*.min.js",
      },
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach to Brave",
      port = 9222,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch Chrome",
      runtimeExecutable = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      url = function()
        local default_url = "http://localhost:3000"
        if vim.fn.filereadable("vite.config.ts") == 1 or vim.fn.filereadable("vite.config.js") == 1 then
          default_url = "http://localhost:5173"
        end
        return vim.fn.input("URL: ", default_url)
      end,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = {
        "<node_internals>/**",
        "node_modules/**",
        "**/*.min.js",
      },
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach to Chrome",
      port = 9222,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch Edge",
      runtimeExecutable = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
      url = function()
        local default_url = "http://localhost:3000"
        if vim.fn.filereadable("vite.config.ts") == 1 or vim.fn.filereadable("vite.config.js") == 1 then
          default_url = "http://localhost:5173"
        end
        return vim.fn.input("URL: ", default_url)
      end,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = {
        "<node_internals>/**",
        "node_modules/**",
        "**/*.min.js",
      },
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach to Edge",
      port = 9222,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
  }
  
  -- Copy Chrome configs for TypeScript React and Vue
  dap.configurations.typescriptreact = vim.deepcopy(dap.configurations.javascriptreact)
  dap.configurations.vue = vim.deepcopy(dap.configurations.javascriptreact)
  
  -- Add Node configs to Vue for SSR debugging
  for _, config in ipairs(dap.configurations.javascript) do
    table.insert(dap.configurations.vue, config)
  end
  
  -- Electron debugging configurations
  -- Add Electron main process debugging
  table.insert(dap.configurations.javascript, {
    type = "pwa-node",
    request = "launch",
    name = "Debug Electron Main",
    runtimeExecutable = "${workspaceFolder}/node_modules/.bin/electron",
    runtimeArgs = { "." },
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  })
  
  -- Add to TypeScript configurations too
  table.insert(dap.configurations.typescript, {
    type = "pwa-node",
    request = "launch",
    name = "Debug Electron Main (TS)",
    runtimeExecutable = "${workspaceFolder}/node_modules/.bin/electron",
    runtimeArgs = { "." },
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    outFiles = {
      "${workspaceFolder}/dist/**/*.js",
    },
  })
  
  -- Electron renderer debugging (requires main process to be running)
  table.insert(dap.configurations.javascriptreact, {
    type = "pwa-chrome",
    request = "attach",
    name = "Debug Electron Renderer",
    port = 9223,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    timeout = 30000,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  })
  
  -- Add to TypeScript React configs too
  table.insert(dap.configurations.typescriptreact, {
    type = "pwa-chrome",
    request = "attach",
    name = "Debug Electron Renderer (TS)",
    port = 9223,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    timeout = 30000,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  })
  
  -- Custom signs
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = "◈", texthl = "DapLogPoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
  
  -- Highlight groups
  vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
  vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" })
  vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e3440" })
  vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#c678dd" })
end

return M