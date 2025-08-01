-- Go development output windows
local M = {}

-- Reuse the create_float function from definition-preview
local function create_float(content, opts)
  opts = opts or {}
  
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  
  -- Calculate window size
  local width = opts.width or math.min(120, vim.o.columns - 10)
  local height = opts.height or math.min(40, #content + 2)
  
  -- Calculate position (centered)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Create window with nice borders and title
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = opts.title,
    title_pos = "center",
  }
  
  -- Check if footer is supported (Neovim 0.9+)
  local has_footer = vim.fn.has("nvim-0.9") == 1
  if opts.footer and has_footer then
    win_opts.footer = opts.footer
    win_opts.footer_pos = "center"
  end
  
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  
  -- If footer wasn't supported, add it as buffer content
  if opts.footer and not has_footer then
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
      string.rep("─", width),
      opts.footer
    })
    vim.bo[buf].modifiable = false
  end
  
  -- Set window options
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  
  -- Set buffer options
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  
  -- Basic keymaps
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
  
  -- Scrolling keymaps
  vim.keymap.set("n", "<C-d>", function()
    local win_height = vim.api.nvim_win_get_height(win)
    vim.cmd("normal! " .. math.floor(win_height / 2) .. "j")
  end, { buffer = buf })
  
  vim.keymap.set("n", "<C-u>", function()
    local win_height = vim.api.nvim_win_get_height(win)
    vim.cmd("normal! " .. math.floor(win_height / 2) .. "k")
  end, { buffer = buf })
  
  return buf, win
end

-- Parse test output and create structured data
local function parse_test_output(output)
  local lines = vim.split(output, "\n")
  local parsed = {
    summary = {},
    tests = {},
    failures = {},
    coverage = nil,
    build_error = nil,
  }
  
  local current_test = nil
  local in_failure = false
  local failure_buffer = {}
  
  for _, line in ipairs(lines) do
    -- Check for build errors
    if line:match("^# ") or line:match("cannot find package") or line:match("no Go files") then
      parsed.build_error = line
    -- Test result lines
    elseif line:match("^%s*%-%-%- PASS:") then
      local test_name, duration = line:match("^%s*%-%-%- PASS: (%S+) %(([^%)]+)%)")
      if test_name then
        table.insert(parsed.tests, {
          name = test_name,
          status = "PASS",
          duration = duration,
          line = line
        })
      end
    elseif line:match("^%s*%-%-%- FAIL:") then
      local test_name, duration = line:match("^%s*%-%-%- FAIL: (%S+) %(([^%)]+)%)")
      if test_name then
        current_test = {
          name = test_name,
          status = "FAIL",
          duration = duration,
          line = line,
          error_lines = {}
        }
        table.insert(parsed.tests, current_test)
        in_failure = true
      end
    elseif line:match("^%s*%-%-%- SKIP:") then
      local test_name, duration = line:match("^%s*%-%-%- SKIP: (%S+) %(([^%)]+)%)")
      if test_name then
        table.insert(parsed.tests, {
          name = test_name,
          status = "SKIP",
          duration = duration,
          line = line
        })
      end
    -- Package summary
    elseif line:match("^PASS$") or line:match("^ok%s+") then
      parsed.summary.status = "PASS"
      parsed.summary.line = line
    elseif line:match("^FAIL$") or line:match("^FAIL%s+") then
      parsed.summary.status = "FAIL"
      parsed.summary.line = line
    -- Coverage
    elseif line:match("coverage:") then
      parsed.coverage = line
    -- Failure details
    elseif in_failure and current_test then
      -- Check if this is the start of a new test or end of output
      if line:match("^%s*%-%-%- ") or line:match("^FAIL") or line:match("^ok%s+") then
        in_failure = false
      else
        table.insert(current_test.error_lines, line)
      end
    end
  end
  
  return parsed
end

-- Format test output for display
local function format_test_output(parsed)
  local lines = {}
  local highlights = {}
  
  -- Add build error if present
  if parsed.build_error then
    table.insert(lines, "❌ Build Error:")
    table.insert(lines, "")
    table.insert(lines, parsed.build_error)
    table.insert(lines, "")
    table.insert(lines, string.rep("─", 80))
    table.insert(lines, "")
  end
  
  -- Add summary
  local pass_count = 0
  local fail_count = 0
  local skip_count = 0
  
  for _, test in ipairs(parsed.tests) do
    if test.status == "PASS" then
      pass_count = pass_count + 1
    elseif test.status == "FAIL" then
      fail_count = fail_count + 1
    elseif test.status == "SKIP" then
      skip_count = skip_count + 1
    end
  end
  
  table.insert(lines, string.format("Test Summary: %d passed, %d failed, %d skipped", 
    pass_count, fail_count, skip_count))
  table.insert(lines, "")
  
  -- Add coverage if available
  if parsed.coverage then
    table.insert(lines, parsed.coverage)
    table.insert(lines, "")
  end
  
  table.insert(lines, string.rep("─", 80))
  table.insert(lines, "")
  
  -- Add individual test results
  for _, test in ipairs(parsed.tests) do
    local prefix = ""
    local line_num = #lines + 1
    
    if test.status == "PASS" then
      prefix = "✅"
      highlights[line_num] = "DiagnosticOk"
    elseif test.status == "FAIL" then
      prefix = "❌"
      highlights[line_num] = "DiagnosticError"
    elseif test.status == "SKIP" then
      prefix = "⏭️ "
      highlights[line_num] = "DiagnosticWarn"
    end
    
    table.insert(lines, string.format("%s %s (%s)", prefix, test.name, test.duration))
    
    -- Add error details for failed tests
    if test.status == "FAIL" and test.error_lines then
      for _, error_line in ipairs(test.error_lines) do
        table.insert(lines, "    " .. error_line)
      end
      table.insert(lines, "")
    end
  end
  
  return lines, highlights
end

-- Run go test and show results in window
function M.test_window(args)
  args = args or {}
  local cmd = { "go", "test" }
  
  -- Add common flags
  table.insert(cmd, "-v") -- verbose output
  
  if args.coverage then
    table.insert(cmd, "-cover")
  end
  
  if args.race then
    table.insert(cmd, "-race")
  end
  
  if args.func then
    table.insert(cmd, "-run")
    table.insert(cmd, args.func)
  end
  
  -- Add package path
  table.insert(cmd, args.package or "./...")
  
  -- Run the test command
  local output = ""
  local job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_stderr = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_exit = function(_, exit_code)
      -- Parse the output
      local parsed = parse_test_output(output)
      local lines, highlights = format_test_output(parsed)
      
      -- Determine title based on exit code
      local title = exit_code == 0 and " ✅ Go Test Results " or " ❌ Go Test Results "
      
      -- Create the window
      local buf, win = create_float(lines, {
        title = title,
        footer = " q: close │ <CR>: jump to test │ r: rerun │ c: toggle coverage ",
        width = 100,
      })
      
      -- Set up custom highlight groups if they don't exist
      vim.cmd([[
        highlight default DiagnosticOk guifg=#9ece6a
        highlight default DiagnosticWarn guifg=#e0af68
        highlight default DiagnosticError guifg=#f7768e
      ]])
      
      -- Set filetype before applying syntax
      vim.bo[buf].filetype = "go"  -- Set to go for proper highlighting
      vim.bo[buf].syntax = "on"
      
      -- Apply custom highlights
      for line_num, hl_group in pairs(highlights) do
        vim.api.nvim_buf_add_highlight(buf, -1, hl_group, line_num - 1, 0, -1)
      end
      
      -- Highlight specific patterns
      vim.fn.matchadd("String", '"[^"]*"')  -- Strings in quotes
      vim.fn.matchadd("Number", "\\d\\+\\.\\d\\+s")  -- Duration times
      vim.fn.matchadd("Function", "Test\\w\\+")  -- Test function names
      vim.fn.matchadd("Comment", "^\\s\\+.*\\.go:\\d\\+:")  -- File locations
      
      -- Add keybindings
      vim.keymap.set("n", "r", function()
        vim.api.nvim_win_close(win, true)
        M.test_window(args)
      end, { buffer = buf })
      
      vim.keymap.set("n", "c", function()
        vim.api.nvim_win_close(win, true)
        args.coverage = not args.coverage
        M.test_window(args)
      end, { buffer = buf })
      
      -- Jump to test on enter
      vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        -- Extract test name from the line
        local test_name = line:match("([%w_]+)%s+%(")
        if test_name and test_name:match("^Test") then
          vim.api.nvim_win_close(win, true)
          -- Search for the test function
          vim.cmd("silent! grep -n 'func " .. test_name .. "' **/*_test.go")
          vim.cmd("copen")
        end
      end, { buffer = buf })
    end,
  })
end

-- Convenience functions for common test scenarios
function M.test_current_file()
  local file = vim.fn.expand("%:p:h")
  M.test_window({ package = file })
end

function M.test_current_function()
  local test_name = nil
  local current_line = vim.fn.line(".")
  
  -- Search backwards for test function
  for i = current_line, 1, -1 do
    local line = vim.fn.getline(i)
    local match = line:match("^func%s+(Test%w+)")
    if match then
      test_name = match
      break
    end
  end
  
  if test_name then
    M.test_window({ func = test_name })
  else
    vim.notify("No test function found", vim.log.levels.WARN)
  end
end

function M.test_all()
  M.test_window({ package = "./..." })
end

-- Run go fmt and show differences
function M.fmt_window()
  local file = vim.fn.expand("%:p")
  local cmd = { "gofmt", "-d", file }
  
  local output = ""
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_exit = function(_, exit_code)
      local lines = {}
      
      if output == "" or output:match("^%s*$") then
        table.insert(lines, "✅ File is properly formatted!")
      else
        table.insert(lines, "📝 Formatting differences found:")
        table.insert(lines, "")
        -- Add the diff output
        for line in output:gmatch("[^\n]+") do
          table.insert(lines, line)
        end
      end
      
      -- Create the window
      local buf, win = create_float(lines, {
        title = " Go Format Check ",
        footer = " q: close │ f: apply formatting ",
        width = 100,
      })
      
      -- Syntax highlighting for diff
      vim.bo[buf].filetype = "diff"
      
      -- Add keybinding to apply formatting
      vim.keymap.set("n", "f", function()
        vim.api.nvim_win_close(win, true)
        vim.cmd("GoFmt")
        vim.notify("Formatting applied!", vim.log.levels.INFO)
      end, { buffer = buf })
    end,
  })
end

-- Run go vet and show results
function M.vet_window()
  local cmd = { "go", "vet", "./..." }
  
  local output = ""
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_stderr = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_exit = function(_, exit_code)
      local lines = {}
      
      if exit_code == 0 then
        table.insert(lines, "✅ No issues found by go vet!")
      else
        table.insert(lines, "⚠️  Go vet found issues:")
        table.insert(lines, "")
        -- Parse vet output
        for line in output:gmatch("[^\n]+") do
          if line ~= "" then
            table.insert(lines, line)
          end
        end
      end
      
      -- Create the window
      local buf, win = create_float(lines, {
        title = exit_code == 0 and " ✅ Go Vet Results " or " ⚠️  Go Vet Results ",
        footer = " q: close │ <CR>: jump to issue ",
        width = 100,
      })
      
      -- Syntax highlighting
      vim.bo[buf].syntax = "on"
      vim.bo[buf].filetype = "go"
      vim.fn.matchadd("ErrorMsg", "^.*\\.go:\\d\\+:\\d\\+:")
      vim.fn.matchadd("WarningMsg", "\\s\\+vet\\s")
      
      -- Jump to issue on enter
      vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        -- Extract file and line number
        local file, line_num = line:match("^(.-%.go):(%d+):")
        if file and line_num then
          vim.api.nvim_win_close(win, true)
          vim.cmd("edit " .. file)
          vim.api.nvim_win_set_cursor(0, { tonumber(line_num), 0 })
        end
      end, { buffer = buf })
    end,
  })
end

-- Run go build and show errors
function M.build_window()
  local cmd = { "go", "build", "./..." }
  
  local output = ""
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_stderr = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_exit = function(_, exit_code)
      local lines = {}
      
      if exit_code == 0 then
        table.insert(lines, "✅ Build successful!")
        table.insert(lines, "")
        table.insert(lines, "All packages compiled without errors.")
      else
        table.insert(lines, "❌ Build failed:")
        table.insert(lines, "")
        -- Parse build errors
        for line in output:gmatch("[^\n]+") do
          if line ~= "" then
            table.insert(lines, line)
          end
        end
      end
      
      -- Create the window
      local buf, win = create_float(lines, {
        title = exit_code == 0 and " ✅ Go Build Results " or " ❌ Go Build Results ",
        footer = " q: close │ <CR>: jump to error │ b: rebuild ",
        width = 100,
      })
      
      -- Syntax highlighting
      vim.bo[buf].syntax = "on"
      vim.bo[buf].filetype = "go"
      vim.fn.matchadd("ErrorMsg", "^.*\\.go:\\d\\+:\\d\\+:")
      vim.fn.matchadd("Error", "\\s\\+error\\s")
      vim.fn.matchadd("Function", "func\\s\\+\\w\\+")
      vim.fn.matchadd("Type", "\\s\\+\\w\\+\\s\\+undefined")
      
      -- Keybindings
      vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        -- Extract file and line number
        local file, line_num, col = line:match("^(.-%.go):(%d+):(%d+):")
        if file and line_num then
          vim.api.nvim_win_close(win, true)
          vim.cmd("edit " .. file)
          vim.api.nvim_win_set_cursor(0, { tonumber(line_num), tonumber(col or 0) - 1 })
        end
      end, { buffer = buf })
      
      vim.keymap.set("n", "b", function()
        vim.api.nvim_win_close(win, true)
        M.build_window()
      end, { buffer = buf })
    end,
  })
end

-- Run go test -coverprofile and analyze coverage by function
function M.coverage_report()
  local tmp_cover = vim.fn.tempname() .. ".out"
  local cmd = { "go", "test", "-coverprofile=" .. tmp_cover, "./..." }
  
  local output = ""
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_stderr = function(_, data)
      if data then
        output = output .. table.concat(data, "\n")
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        -- Tests failed, show the test output
        local lines = vim.split(output, "\n")
        create_float(lines, {
          title = " ❌ Tests Failed - Cannot Generate Coverage Report ",
          footer = " q: close ",
          width = 100,
        })
        vim.fn.delete(tmp_cover)
        return
      end
      
      -- Parse coverage data
      local cover_cmd = { "go", "tool", "cover", "-func=" .. tmp_cover }
      local cover_output = vim.fn.system(cover_cmd)
      
      -- Parse the coverage output
      local lines = {}
      local total_coverage = nil
      
      table.insert(lines, "📊 Go Coverage Report by Function")
      table.insert(lines, "")
      table.insert(lines, string.format("%-60s %10s", "Function", "Coverage"))
      table.insert(lines, string.rep("─", 72))
      
      local covered_count = 0
      local uncovered_count = 0
      local partial_count = 0
      
      for line in cover_output:gmatch("[^\n]+") do
        -- Match lines with tabs: file:line:<tab>function<tab>coverage%
        local file, line_num, func_name, coverage = line:match("([^:]+):(%d+):%s*(%S+)%s+(%d+%.%d+)%%")
        if file and line_num and func_name and coverage then
          local cov_num = tonumber(coverage)
          local symbol = ""
          local highlight = ""
          
          if cov_num == 100 then
            symbol = "✅"
            covered_count = covered_count + 1
          elseif cov_num == 0 then
            symbol = "❌"
            uncovered_count = uncovered_count + 1
          else
            symbol = "⚠️ "
            partial_count = partial_count + 1
          end
          
          -- Shorten file path for display
          local short_file = file:match("([^/]+/[^/]+)$") or file
          local func_display = string.format("%s %s:%s", symbol, short_file, func_name)
          table.insert(lines, string.format("%-60s %9s%%", func_display, coverage))
        elseif line:match("^total:") then
          -- Total line
          total_coverage = line:match("(%d+%.%d+)%%")
        end
      end
      
      table.insert(lines, string.rep("─", 72))
      table.insert(lines, "")
      table.insert(lines, string.format("Summary: %d covered | %d uncovered | %d partial", 
        covered_count, uncovered_count, partial_count))
      if total_coverage then
        table.insert(lines, string.format("Total Coverage: %s%%", total_coverage))
      end
      table.insert(lines, "")
      table.insert(lines, "Legend:")
      table.insert(lines, "  ✅ = 100% covered")
      table.insert(lines, "  ⚠️  = Partially covered")  
      table.insert(lines, "  ❌ = 0% covered (not tested)")
      
      -- Create the window
      local buf, win = create_float(lines, {
        title = " 📊 Go Coverage Report ",
        footer = " q: close ",
        width = 80,
      })
      
      -- Set filetype for highlighting
      vim.bo[buf].filetype = "go"
      
      
      -- Clean up temp file when window closes
      vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = buf,
        once = true,
        callback = function()
          vim.fn.delete(tmp_cover)
        end,
      })
    end,
  })
end

return M