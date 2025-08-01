-- JavaScript/TypeScript Development Windows
local M = {}

-- Window management utilities
local function close_window_by_buf_pattern(pattern)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match(pattern) then
      vim.api.nvim_win_close(win, true)
    end
  end
end

local function close_window_by_title(title)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local success, win_config = pcall(vim.api.nvim_win_get_config, win)
    if success and win_config.title and win_config.title == title then
      vim.api.nvim_win_close(win, true)
    end
  end
end

-- Run current JavaScript/TypeScript file
function M.run_current()
  close_window_by_title(" JS/TS Output ")
  
  -- Get file info first, before any window operations
  local file = vim.api.nvim_buf_get_name(0)
  local filetype = vim.bo.filetype
  local file_dir = vim.fn.fnamemodify(file, ":h")
  
  -- Check if file exists
  if file == "" or vim.fn.filereadable(file) == 0 then
    vim.notify("No file to run", vim.log.levels.ERROR)
    return
  end
  
  -- Save the file first
  vim.cmd("write")
  
  local bufnr = vim.api.nvim_create_buf(false, true)
  
  -- Create split window
  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_height(win, 15)
  
  -- Set window options
  vim.api.nvim_win_set_config(win, {
    title = " JS/TS Output ",
    title_pos = "center",
  })
  
  -- Make it look like a terminal
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  
  -- Add keymaps to output buffer
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
  
  -- Determine command based on file type
  local cmd
  if filetype == "typescript" or filetype == "typescriptreact" then
    -- Use ts-node if available, otherwise use tsx
    if vim.fn.executable("ts-node") == 1 then
      cmd = {"ts-node", file}
    elseif vim.fn.executable("tsx") == 1 then
      cmd = {"tsx", file}
    else
      cmd = {"npx", "tsx", file}
    end
  else
    cmd = {"node", file}
  end
  
  -- Show running message
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"Running: " .. table.concat(cmd, " "), ""})
  
  vim.fn.jobstart(cmd, {
    cwd = file_dir,
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
    on_exit = function(_, exit_code)
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "Process exited with code: " .. exit_code})
    end,
  })
  
  -- Return to previous window
  vim.cmd("wincmd p")
end

-- Format current file
function M.format()
  require("conform").format({ async = true, lsp_fallback = true })
  vim.notify("Formatted file", vim.log.levels.INFO)
end

-- Lint current file
function M.lint()
  -- Try LSP command first
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local has_eslint = false
  
  for _, client in ipairs(clients) do
    if client.name == "eslint" then
      has_eslint = true
      vim.cmd("EslintFixAll")
      vim.notify("Fixed ESLint issues", vim.log.levels.INFO)
      return
    end
  end
  
  -- Fallback to command line eslint
  if not has_eslint then
    local file = vim.api.nvim_buf_get_name(0)
    local file_dir = vim.fn.fnamemodify(file, ":h")
    
    -- Check if eslint exists in the project
    local has_local_eslint = vim.fn.filereadable(file_dir .. "/node_modules/.bin/eslint") == 1
    local eslint_cmd = has_local_eslint and "npx eslint" or "eslint"
    
    -- Run eslint --fix
    vim.notify("Running ESLint fix...", vim.log.levels.INFO)
    vim.fn.system(eslint_cmd .. " --fix " .. vim.fn.shellescape(file))
    
    -- Reload the buffer to show changes
    vim.cmd("edit!")
    vim.notify("ESLint fix complete", vim.log.levels.INFO)
  end
end

-- Install dependencies
function M.install_deps()
  close_window_by_title(" npm install ")
  
  -- Check which package manager to use
  local pkg_manager = "npm"
  if vim.fn.filereadable("yarn.lock") == 1 then
    pkg_manager = "yarn"
  elseif vim.fn.filereadable("pnpm-lock.yaml") == 1 then
    pkg_manager = "pnpm"
  end
  
  -- Use Snacks terminal for visual feedback
  local Snacks = require("snacks")
  Snacks.terminal.open(pkg_manager .. " install", {
    win = {
      height = 0.7,
      width = 0.8,
      title = " " .. pkg_manager .. " install ",
    },
  })
end

-- Build project
function M.build()
  close_window_by_title(" Build ")
  
  -- Check for build script
  local package_json = vim.fn.getcwd() .. "/package.json"
  if vim.fn.filereadable(package_json) == 0 then
    vim.notify("No package.json found", vim.log.levels.ERROR)
    return
  end
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  Snacks.terminal.open("npm run build", {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Build ",
    },
  })
end

-- Start dev server (Vite)
function M.dev_server()
  close_window_by_title(" Dev Server ")
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  Snacks.terminal.open("npm run dev", {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Dev Server ",
    },
  })
end

-- Preview production build
function M.preview()
  close_window_by_title(" Preview ")
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  Snacks.terminal.open("npm run preview", {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Preview ",
    },
  })
end

-- Run tests
function M.test_all()
  close_window_by_title(" Test All ")
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  Snacks.terminal.open("npm test", {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Test All ",
    },
  })
end

-- Test current file
function M.test_current()
  close_window_by_title(" Test File ")
  
  local file = vim.api.nvim_buf_get_name(0)
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  Snacks.terminal.open("npm test -- " .. file, {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Test File ",
    },
  })
end

-- Test current function (run single test under cursor)
function M.test_function()
  close_window_by_title(" Test Function ")
  
  local file = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.expand("%:t")
  
  -- Check if this is a test file
  local is_test_file = filename:match("%.test%.[jt]s$") or 
                       filename:match("%.spec%.[jt]s$") or
                       filename:match("%.test%.[jt]sx$") or
                       filename:match("%.spec%.[jt]sx$")
  
  if not is_test_file then
    vim.notify("Not a test file", vim.log.levels.WARN)
    return
  end
  
  -- Get the current line to find test name
  local line = vim.api.nvim_get_current_line()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Search upward for the nearest test/it block
  local test_name = nil
  for i = line_num, 1, -1 do
    local current_line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]
    if current_line then
      -- Match patterns like: it('test name', ...) or test('test name', ...)
      local match = current_line:match("%s*it%s*%([\'\"](.-)[\'\"]") or 
                    current_line:match("%s*test%s*%([\'\"](.-)[\'\"]")
      if match then
        test_name = match
        break
      end
    end
  end
  
  if not test_name then
    vim.notify("No test found at cursor position", vim.log.levels.WARN)
    return
  end
  
  -- Determine test runner and build command
  local cmd
  if vim.fn.filereadable("vitest.config.ts") == 1 or vim.fn.filereadable("vitest.config.js") == 1 then
    -- Vitest uses -t flag for test name pattern
    cmd = string.format('npx vitest run %s -t "%s"', file, test_name)
  elseif vim.fn.filereadable("jest.config.js") == 1 then
    -- Jest uses -t flag for test name pattern
    cmd = string.format('npx jest %s -t "%s"', file, test_name)
  else
    -- Default to vitest
    cmd = string.format('npx vitest run %s -t "%s"', file, test_name)
  end
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  -- Add message and wait for Enter key specifically
  local full_cmd = cmd .. ' ; echo -e "\\n\\n══════════════════════════════════════════════════════════════════════" ; echo "Press Enter to close..." ; read'
  
  Snacks.terminal.open(full_cmd, {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Test Function: " .. test_name .. " ",
      footer = " Press Enter to close ",
      footer_pos = "center",
    },
  })
end

-- Start Electron app
function M.electron_start()
  close_window_by_title(" Electron ")
  
  -- Use Snacks terminal
  local Snacks = require("snacks")
  Snacks.terminal.open("npm start", {
    win = {
      height = 0.7,
      width = 0.8,
      title = " Electron ",
    },
  })
end

-- Debug current file with smart configuration filtering
function M.debug_file()
  -- Ensure DAP is loaded
  require("config.dap-js").setup()
  
  local dap = require("dap")
  local filetype = vim.bo.filetype
  
  -- Check file context
  local filename = vim.fn.expand("%:t")
  local filepath = vim.fn.expand("%:p")
  local is_test_file = filename:match("%.test%.[jt]s$") or 
                       filename:match("%.spec%.[jt]s$") or
                       filename:match("%.test%.[jt]sx$") or
                       filename:match("%.spec%.[jt]sx$")
  
  -- Check if in Electron project
  local is_electron = vim.fn.filereadable(vim.fn.getcwd() .. "/package.json") == 1 and
                      vim.fn.system("grep -q electron " .. vim.fn.getcwd() .. "/package.json; echo $?"):gsub("\n", "") == "0"
  
  -- Filter configurations based on context
  local filtered_configs = {}
  local all_configs = dap.configurations[filetype] or {}
  
  for _, config in ipairs(all_configs) do
    local should_include = true
    
    -- Skip Vitest configs (require manual setup)
    if config.name:match("Vitest") then
      should_include = false
    -- Skip test configs if not in a test file
    elseif config.name:match("Jest") and not is_test_file then
      should_include = false
    -- Only show Electron configs if in Electron project
    elseif config.name:match("Electron") and not is_electron then
      should_include = false
    end
    
    if should_include then
      table.insert(filtered_configs, config)
    end
  end
  
  -- Use filtered configurations
  if #filtered_configs == 0 then
    vim.notify("No debug configurations available for this file type", vim.log.levels.WARN)
  elseif #filtered_configs == 1 then
    -- If only one config, run it directly
    dap.run(filtered_configs[1])
  else
    -- Show picker with filtered configs
    -- Temporarily replace configurations
    local original_configs = dap.configurations[filetype]
    dap.configurations[filetype] = filtered_configs
    dap.continue()
    -- Restore original after a delay
    vim.defer_fn(function()
      dap.configurations[filetype] = original_configs
    end, 100)
  end
end

-- Attach to running process with smart filtering
function M.attach_debugger()
  require("config.dap-js").setup()
  
  local dap = require("dap")
  local filetype = vim.bo.filetype
  
  -- Get all configurations
  local all_configs = dap.configurations[filetype] or {}
  local attach_configs = {}
  
  -- Filter to only show attach configurations
  for _, config in ipairs(all_configs) do
    if config.request == "attach" then
      -- Skip Electron renderer attach unless in Electron project
      if config.name:match("Electron Renderer") then
        local is_electron = vim.fn.filereadable(vim.fn.getcwd() .. "/package.json") == 1 and
                            vim.fn.system("grep -q electron " .. vim.fn.getcwd() .. "/package.json; echo $?"):gsub("\n", "") == "0"
        if is_electron then
          table.insert(attach_configs, config)
        end
      else
        table.insert(attach_configs, config)
      end
    end
  end
  
  -- Show attach configurations
  if #attach_configs == 0 then
    vim.notify("No attach configurations available", vim.log.levels.WARN)
  elseif #attach_configs == 1 then
    dap.run(attach_configs[1])
  else
    -- Temporarily replace configurations  
    local original_configs = dap.configurations[filetype]
    dap.configurations[filetype] = attach_configs
    dap.continue()
    -- Restore original after a delay
    vim.defer_fn(function()
      dap.configurations[filetype] = original_configs
    end, 100)
  end
end

-- Debug current test
function M.debug_test()
  require("config.dap-js").setup()
  local dap = require("dap")
  
  -- Find and use the test configuration
  for _, config in ipairs(dap.configurations.javascript) do
    if config.name == "Debug Jest/Vitest tests" then
      dap.run(config)
      return
    end
  end
end

return M