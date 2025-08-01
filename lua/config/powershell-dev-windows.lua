local M = {}

-- Helper function to run PowerShell commands in a split
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
    "PowerShell: " .. title,
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

-- Script Analyzer
function M.analyze()
  local file = vim.fn.expand("%:p")
  local cmd = { "pwsh", "-NoProfile", "-Command", 
    string.format("Invoke-ScriptAnalyzer -Path '%s' -Severity @('Error', 'Warning', 'Information') | Format-Table -AutoSize | Out-String -Width 120", file)
  }
  run_in_split(cmd, "Script Analyzer")
end

-- Run Script
function M.run_script()
  local file = vim.fn.expand("%:p")
  local cmd = { "pwsh", "-NoProfile", "-File", file }
  run_in_split(cmd, "Run Script")
end

-- Debug Script
function M.debug_script()
  local file = vim.fn.expand("%:p")
  local cmd = { "pwsh", "-NoProfile", "-Command", 
    string.format("Set-PSDebug -Trace 1; & '%s'", file)
  }
  run_in_split(cmd, "Debug Script")
end

-- Get Help
function M.get_help()
  local word = vim.fn.expand("<cword>")
  local cmd = { "pwsh", "-NoProfile", "-Command", 
    string.format("Get-Help %s -Full | Out-String -Width 120", word)
  }
  run_in_split(cmd, "Get-Help: " .. word)
end

-- List Modules
function M.list_modules()
  local cmd = { "pwsh", "-NoProfile", "-Command", 
    "Get-Module -ListAvailable | Select-Object Name, Version, Description | Format-Table -AutoSize | Out-String -Width 120"
  }
  run_in_split(cmd, "Available Modules")
end

-- Run Pester Tests
function M.run_tests()
  local file = vim.fn.expand("%:p")
  local cmd = { "pwsh", "-NoProfile", "-Command", 
    string.format("if (Get-Module -ListAvailable -Name Pester) { Invoke-Pester -Path '%s' -Output Detailed } else { Write-Host 'Pester not installed. Run: Install-Module -Name Pester -Force -Scope CurrentUser' }", file)
  }
  run_in_split(cmd, "Pester Tests")
end

-- Check Syntax
function M.check_syntax()
  local file = vim.fn.expand("%:p")
  local cmd = { "pwsh", "-NoProfile", "-Command", 
    string.format("[System.Management.Automation.Language.Parser]::ParseFile('%s', [ref]$null, [ref]$null) | Out-Null; Write-Host 'Syntax OK'", file)
  }
  run_in_split(cmd, "Syntax Check")
end

return M