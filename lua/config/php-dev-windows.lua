-- PHP/WordPress Development Windows
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

-- PHP Syntax Check
function M.php_check()
  close_window_by_title(" PHP Syntax Check ")
  
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "php-check-output")
  
  -- Create split window
  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_height(win, 15)
  
  -- Set window options
  vim.api.nvim_win_set_config(win, {
    title = " PHP Syntax Check ",
    title_pos = "center",
  })
  
  -- Make it look like a terminal
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  
  -- Add keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
  
  -- Get current file
  local file = vim.api.nvim_buf_get_name(0)
  
  -- Run syntax check
  local cmd = {"php", "-l", file}
  vim.fn.jobstart(cmd, {
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
      if exit_code == 0 then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "✓ Syntax check passed!"})
      else
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "✗ Syntax errors found!"})
      end
    end,
  })
  
  -- Return to previous window
  vim.cmd("wincmd p")
end

-- Run PHP File
function M.php_run()
  close_window_by_title(" PHP Output ")
  
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "php-run-output")
  
  -- Create split window
  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_height(win, 20)
  
  -- Set window options
  vim.api.nvim_win_set_config(win, {
    title = " PHP Output ",
    title_pos = "center",
  })
  
  -- Make it look like a terminal
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  
  -- Add keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
  
  -- Get current file
  local file = vim.api.nvim_buf_get_name(0)
  
  -- Check if we're in a Docker environment
  local in_docker = vim.fn.filereadable("docker-compose.yml") == 1 or vim.fn.filereadable("docker-compose.yaml") == 1
  
  local cmd
  if in_docker then
    -- Try to run in Docker container
    cmd = {"docker-compose", "exec", "-T", "app", "php", file}
  else
    -- Run locally
    cmd = {"php", file}
  end
  
  vim.fn.jobstart(cmd, {
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

-- Run PHPUnit Tests
function M.phpunit_run()
  close_window_by_title(" PHPUnit Tests ")
  
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "phpunit-output")
  
  -- Create split window
  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_height(win, 20)
  
  -- Set window options
  vim.api.nvim_win_set_config(win, {
    title = " PHPUnit Tests ",
    title_pos = "center",
  })
  
  -- Make it look like a terminal
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  
  -- Add keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
  
  -- Determine PHPUnit command
  local cmd
  if vim.fn.filereadable("vendor/bin/phpunit") == 1 then
    cmd = {"vendor/bin/phpunit"}
  elseif vim.fn.filereadable("docker-compose.yml") == 1 or vim.fn.filereadable("docker-compose.yaml") == 1 then
    cmd = {"docker-compose", "exec", "-T", "app", "phpunit"}
  else
    cmd = {"phpunit"}
  end
  
  -- Add current file if it's a test file
  local file = vim.api.nvim_buf_get_name(0)
  if file:match("Test%.php$") or file:match("test%.php$") then
    table.insert(cmd, file)
  end
  
  vim.fn.jobstart(cmd, {
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
      if exit_code == 0 then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "✓ All tests passed!"})
      else
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "✗ Tests failed with exit code: " .. exit_code})
      end
    end,
  })
  
  -- Return to previous window
  vim.cmd("wincmd p")
end

-- WordPress Coding Standards Check
function M.phpcs_check()
  close_window_by_title(" WordPress Coding Standards ")
  
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "phpcs-output")
  
  -- Create split window
  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_height(win, 15)
  
  -- Set window options
  vim.api.nvim_win_set_config(win, {
    title = " WordPress Coding Standards ",
    title_pos = "center",
  })
  
  -- Make it look like a terminal
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  
  -- Add keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
  
  -- Get current file
  local file = vim.api.nvim_buf_get_name(0)
  
  -- Run PHPCS with WordPress standards
  local cmd = {"phpcs", "--standard=WordPress", file}
  
  -- Check if we should run in Docker
  if vim.fn.filereadable("docker-compose.yml") == 1 or vim.fn.filereadable("docker-compose.yaml") == 1 then
    cmd = {"docker-compose", "exec", "-T", "app", "phpcs", "--standard=WordPress", file}
  end
  
  vim.fn.jobstart(cmd, {
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
      if exit_code == 0 then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "✓ Code meets WordPress standards!"})
      end
    end,
  })
  
  -- Return to previous window
  vim.cmd("wincmd p")
end

-- Run Composer command
function M.composer_run(command)
  close_window_by_title(" Composer ")
  
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "composer-output")
  
  -- Create split window
  vim.cmd("botright split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_height(win, 15)
  
  -- Set window options
  vim.api.nvim_win_set_config(win, {
    title = " Composer ",
    title_pos = "center",
  })
  
  -- Make it look like a terminal
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  
  -- Add keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
  
  -- Build command
  local cmd = {"composer", command}
  
  -- Check if we should run in Docker
  if vim.fn.filereadable("docker-compose.yml") == 1 or vim.fn.filereadable("docker-compose.yaml") == 1 then
    cmd = {"docker-compose", "exec", "-T", "app", "composer", command}
  end
  
  vim.fn.jobstart(cmd, {
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
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"", "Composer finished with exit code: " .. exit_code})
    end,
  })
  
  -- Return to previous window
  vim.cmd("wincmd p")
end

-- WP-CLI command runner
function M.wp_cli()
  -- Check if we're in a Docker environment
  local docker_compose = vim.fn.filereadable("docker-compose.yml") == 1 or vim.fn.filereadable("docker-compose.yaml") == 1
  local cmd
  
  if docker_compose then
    -- Open a bash shell in the WordPress container with instructions
    cmd = "docker-compose exec wordpress bash -c 'echo \"WP-CLI is available. Try: wp --info\"; echo \"\"; exec bash'"
  else
    -- If WP-CLI is installed locally
    if vim.fn.executable("wp") == 1 then
      cmd = "wp shell"
    else
      vim.notify("WP-CLI not found. Install with: brew install wp-cli", vim.log.levels.ERROR)
      return
    end
  end
  
  -- Create a floating terminal for WP-CLI
  local Snacks = require("snacks")
  Snacks.terminal.open(cmd, {
    win = {
      position = "float",
      width = 0.8,
      height = 0.8,
      title = docker_compose and " WP-CLI Shell (Docker) " or " WP-CLI Shell ",
      title_pos = "center",
      border = "rounded",
    },
  })
end

-- PHP Interactive Shell
function M.php_repl()
  -- Create a floating terminal for PHP interactive shell
  local Snacks = require("snacks")
  Snacks.terminal.open("php -a", {
    win = {
      position = "float",
      width = 0.8,
      height = 0.8,
      title = " PHP Interactive Shell ",
      title_pos = "center",
      border = "rounded",
    },
  })
end

return M