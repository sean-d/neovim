local M = {}

-- Helper function to run Python commands in a split
local function run_in_split(cmd, title)
  -- Save current window
  local current_win = vim.api.nvim_get_current_win()
  
  -- Create horizontal split
  vim.cmd("botright new")
  
  -- Set buffer options
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  
  -- Set window height
  vim.api.nvim_win_set_height(0, 15)
  
  -- Add title
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Python: " .. title,
    string.rep("-", 80),
    ""
  })
  
  -- Run command and capture output
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        -- Filter out empty strings
        local lines = {}
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(lines, line)
          end
        end
        if #lines > 0 then
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local lines = {}
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(lines, "ERROR: " .. line)
          end
        end
        if #lines > 0 then
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
        end
      end
    end,
    on_exit = function(_, exit_code)
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
        "",
        string.rep("-", 80),
        "Exit code: " .. exit_code,
        "Press 'q' to close this window"
      })
      
      -- Set up 'q' to close the window
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    end,
  })
  
  -- Return to original window
  vim.api.nvim_set_current_win(current_win)
end

-- Run current Python file
function M.run_file()
  local file = vim.fn.expand("%:p")
  local cmd = { "python", file }
  run_in_split(cmd, "Run File: " .. vim.fn.expand("%:t"))
end

-- Run pytest
function M.run_tests()
  local file = vim.fn.expand("%:p")
  local cmd = { "python", "-m", "pytest", file, "-v" }
  run_in_split(cmd, "Pytest: " .. vim.fn.expand("%:t"))
end

-- Run pytest for current function
function M.run_test_function()
  local file = vim.fn.expand("%:p")
  local function_name = vim.fn.search("^def test_", "bnW")
  if function_name == 0 then
    vim.notify("No test function found", vim.log.levels.WARN)
    return
  end
  
  -- Get the test function name
  local line = vim.fn.getline(function_name)
  local test_name = line:match("def%s+([%w_]+)%s*%(")
  
  if test_name then
    local cmd = { "python", "-m", "pytest", file .. "::" .. test_name, "-v" }
    run_in_split(cmd, "Pytest Function: " .. test_name)
  else
    vim.notify("Could not parse test function name", vim.log.levels.ERROR)
  end
end

-- Run all tests in project
function M.run_all_tests()
  local cmd = { "python", "-m", "pytest", "-v" }
  run_in_split(cmd, "Pytest All")
end

-- Run coverage
function M.run_coverage()
  local cmd = { "python", "-m", "pytest", "--cov=.", "--cov-report=term-missing" }
  run_in_split(cmd, "Coverage Report")
end

-- Type check with mypy
function M.type_check()
  local file = vim.fn.expand("%:p")
  local cmd = { "python", "-m", "mypy", file }
  run_in_split(cmd, "Type Check: " .. vim.fn.expand("%:t"))
end

-- Ruff check
function M.ruff_check()
  local file = vim.fn.expand("%:p")
  local cmd = { "ruff", "check", file, "--output-format=concise" }
  run_in_split(cmd, "Ruff Check")
end

-- UV commands
function M.uv_add()
  vim.ui.input({ prompt = "Package to add: " }, function(package)
    if package and package ~= "" then
      local cmd = { "uv", "add", package }
      run_in_split(cmd, "UV Add: " .. package)
    end
  end)
end

function M.uv_add_dev()
  vim.ui.input({ prompt = "Dev package to add: " }, function(package)
    if package and package ~= "" then
      local cmd = { "uv", "add", "--dev", package }
      run_in_split(cmd, "UV Add Dev: " .. package)
    end
  end)
end

function M.uv_sync()
  local cmd = { "uv", "sync" }
  run_in_split(cmd, "UV Sync")
end

function M.pip_list()
  local cmd = { "pip", "list" }
  run_in_split(cmd, "Installed Packages")
end

-- Interactive Python REPL
function M.repl()
  Snacks.terminal("python", {
    cwd = vim.fn.getcwd(),
    win = {
      position = "float",
      width = 0.8,
      height = 0.8,
    }
  })
end

-- Run Django management commands
function M.django_manage()
  vim.ui.input({ prompt = "Django manage.py command: " }, function(command)
    if command and command ~= "" then
      local cmd = { "python", "manage.py", unpack(vim.split(command, " ")) }
      run_in_split(cmd, "Django: " .. command)
    end
  end)
end

return M