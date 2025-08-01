-- Development keymaps for all languages
-- These keymaps are globally available regardless of the current file type

local M = {}

function M.setup()
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Go development keybindings
  -- Testing
  map("n", "<leader>dgot", function() 
    if vim.bo.filetype == "go" then
      require("config.go-dev-windows").test_current_file() 
    else
      vim.notify("Not in a Go file", vim.log.levels.WARN)
    end
  end, { desc = "Go: Test current file" })
  
  map("n", "<leader>dgoT", function() 
    if vim.bo.filetype == "go" then
      require("config.go-dev-windows").test_current_function() 
    else
      vim.notify("Not in a Go file", vim.log.levels.WARN)
    end
  end, { desc = "Go: Test function" })
  
  map("n", "<leader>dgoa", function() require("config.go-dev-windows").test_all() end, { desc = "Go: Test all" })
  map("n", "<leader>dgoc", function() require("config.go-dev-windows").coverage_report() end, { desc = "Go: Coverage report" })
  map("n", "<leader>dgoC", "<cmd>GoCoverageClear<CR>", { desc = "Go: Clear coverage" })
  
  -- Code quality
  map("n", "<leader>dgof", function() require("config.go-dev-windows").fmt_window() end, { desc = "Go: Format check" })
  map("n", "<leader>dgov", function() require("config.go-dev-windows").vet_window() end, { desc = "Go: Vet" })
  map("n", "<leader>dgob", function() require("config.go-dev-windows").build_window() end, { desc = "Go: Build" })
  
  -- Code management
  map("n", "<leader>dgoi", function()
    if vim.bo.filetype == "go" then
      vim.cmd("GoImports")
    else
      vim.notify("Not in a Go file", vim.log.levels.WARN)
    end
  end, { desc = "Go: Organize imports" })
  map("n", "<leader>dgom", "<cmd>GoMod tidy<CR>", { desc = "Go: Mod tidy" })
  map("n", "<leader>dgod", "<cmd>GoDoc<CR>", { desc = "Go: Documentation" })
  
  -- Debug
  map("n", "<leader>dgoD", "<cmd>GoDebug<CR>", { desc = "Go: Start debug" })
  map("n", "<leader>dgox", "<cmd>GoDebug -s<CR>", { desc = "Go: Stop debug" })
  map("n", "<leader>dgoX", "<cmd>GoDebug -t<CR>", { desc = "Go: Debug test" })

  -- Rust development keybindings
  -- Testing
  map("n", "<leader>drst", function() 
    if vim.bo.filetype == "rust" then
      require("config.rust-dev-windows").test_current_file() 
    else
      vim.notify("Not in a Rust file", vim.log.levels.WARN)
    end
  end, { desc = "Rust: Test current file" })
  
  map("n", "<leader>drsT", function() 
    if vim.bo.filetype == "rust" then
      require("config.rust-dev-windows").test_current_function() 
    else
      vim.notify("Not in a Rust file", vim.log.levels.WARN)
    end
  end, { desc = "Rust: Test function" })
  
  map("n", "<leader>drsa", function() require("config.rust-dev-windows").test_all() end, { desc = "Rust: Test all" })
  
  -- Code quality
  map("n", "<leader>drsc", function() require("config.rust-dev-windows").clippy_check() end, { desc = "Rust: Clippy check" })
  map("n", "<leader>drsf", function() require("config.rust-dev-windows").fmt_check() end, { desc = "Rust: Format check" })
  map("n", "<leader>drsb", function() require("config.rust-dev-windows").build_window() end, { desc = "Rust: Build" })
  map("n", "<leader>drsB", function() require("config.rust-dev-windows").build_release_window() end, { desc = "Rust: Build release" })
  map("n", "<leader>drsk", function() require("config.rust-dev-windows").check_window() end, { desc = "Rust: Check (fast)" })
  
  -- Running
  map("n", "<leader>drsr", function() require("config.rust-dev-windows").run_window() end, { desc = "Rust: Run" })
  map("n", "<leader>drsR", function() 
    if vim.bo.filetype == "rust" then
      vim.cmd.RustLsp('runnables') 
    else
      vim.notify("Not in a Rust file", vim.log.levels.WARN)
    end
  end, { desc = "Rust: Run targets" })
  
  -- Code exploration
  map("n", "<leader>drse", function() 
    if vim.bo.filetype == "rust" then
      vim.cmd.RustLsp('expandMacro') 
    else
      vim.notify("Not in a Rust file", vim.log.levels.WARN)
    end
  end, { desc = "Rust: Expand macro" })
  map("n", "<leader>drsm", function() vim.cmd.RustLsp('rebuildProcMacros') end, { desc = "Rust: Rebuild proc macros" })
  map("n", "<leader>drsp", function() vim.cmd.RustLsp('parentModule') end, { desc = "Rust: Parent module" })
  map("n", "<leader>drsj", function() 
    if vim.bo.filetype == "rust" then
      vim.cmd.RustLsp('joinLines') 
    else
      vim.notify("Not in a Rust file", vim.log.levels.WARN)
    end
  end, { desc = "Rust: Join lines" })
  
  -- Cargo management
  map("n", "<leader>drsu", function() require("config.rust-dev-windows").update_window() end, { desc = "Rust: Update deps" })
  map("n", "<leader>drsC", function() vim.cmd.RustLsp('openCargo') end, { desc = "Rust: Open Cargo.toml" })
  map("n", "<leader>drso", function() require("config.rust-dev-windows").clean_window() end, { desc = "Rust: Clean" })
  
  -- Documentation
  map("n", "<leader>drsd", function() require("config.rust-dev-windows").doc_window() end, { desc = "Rust: Documentation" })
  map("n", "<leader>drsh", function() vim.cmd.RustLsp('openDocs') end, { desc = "Rust: Open docs.rs" })
  
  -- Debugging
  map("n", "<leader>drsD", function() vim.cmd.RustLsp('debuggables') end, { desc = "Rust: Debug targets" })
  map("n", "<leader>drsx", function() 
    if vim.bo.filetype == "rust" then
      vim.cmd.RustLsp('debug') 
    else
      vim.notify("Not in a Rust file", vim.log.levels.WARN)
    end
  end, { desc = "Rust: Debug current" })
  
  -- Advanced inspection
  map("n", "<leader>drsi", function() vim.cmd.RustLsp('view_mir') end, { desc = "Rust: View MIR" })
  map("n", "<leader>drsI", function() vim.cmd.RustLsp('view_hir') end, { desc = "Rust: View HIR" })

  -- Python development keybindings
  map("n", "<leader>dpyr", function()
    if vim.bo.filetype == "python" then
      require("config.python-dev-windows").run_file()
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Run file" })
  
  map("n", "<leader>dpyt", function()
    if vim.bo.filetype == "python" then
      require("config.python-dev-windows").run_tests()
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Test file" })
  
  map("n", "<leader>dpyT", function()
    if vim.bo.filetype == "python" then
      require("config.python-dev-windows").run_test_function()
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Test function" })
  
  map("n", "<leader>dpya", function()
    require("config.python-dev-windows").run_all_tests()
  end, { desc = "Python: Test all" })
  
  map("n", "<leader>dpyc", function()
    require("config.python-dev-windows").run_coverage()
  end, { desc = "Python: Coverage" })
  
  map("n", "<leader>dpym", function()
    if vim.bo.filetype == "python" then
      require("config.python-dev-windows").type_check()
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Type check (mypy)" })
  
  map("n", "<leader>dpyl", function()
    if vim.bo.filetype == "python" then
      require("config.python-dev-windows").ruff_check()
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Lint (ruff)" })
  
  map("n", "<leader>dpyf", function()
    if vim.bo.filetype == "python" then
      vim.lsp.buf.format({ async = true })
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Format" })
  
  map("n", "<leader>dpyi", function()
    require("config.python-dev-windows").repl()
  end, { desc = "Python: Interactive REPL" })
  
  -- UV package management
  map("n", "<leader>dpyu", function()
    require("config.python-dev-windows").uv_add()
  end, { desc = "Python: UV add package" })
  
  map("n", "<leader>dpyU", function()
    require("config.python-dev-windows").uv_add_dev()
  end, { desc = "Python: UV add dev package" })
  
  map("n", "<leader>dpys", function()
    require("config.python-dev-windows").uv_sync()
  end, { desc = "Python: UV sync" })
  
  map("n", "<leader>dpyp", function()
    require("config.python-dev-windows").pip_list()
  end, { desc = "Python: List packages" })
  
  -- Django support
  map("n", "<leader>dpyd", function()
    require("config.python-dev-windows").django_manage()
  end, { desc = "Python: Django manage.py" })
  
  -- Debug
  map("n", "<leader>dpyD", function()
    if vim.bo.filetype == "python" then
      require("dap").continue()
    else
      vim.notify("Not in a Python file", vim.log.levels.WARN)
    end
  end, { desc = "Python: Start debug" })

  -- JavaScript/TypeScript development keybindings
  map("n", "<leader>djsr", function()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or 
       vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" then
      require("config.js-dev-windows").run_current()
    else
      vim.notify("Not in a JavaScript/TypeScript file", vim.log.levels.WARN)
    end
  end, { desc = "JS/TS: Run current" })
  
  map("n", "<leader>djsf", function()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or 
       vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" or
       vim.bo.filetype == "vue" then
      require("config.js-dev-windows").format()
    else
      vim.notify("Not in a JS/TS/Vue file", vim.log.levels.WARN)
    end
  end, { desc = "JS/TS: Format" })
  
  map("n", "<leader>djsl", function()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or 
       vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" or
       vim.bo.filetype == "vue" then
      require("config.js-dev-windows").lint()
    else
      vim.notify("Not in a JS/TS/Vue file", vim.log.levels.WARN)
    end
  end, { desc = "JS/TS: Lint" })
  
  map("n", "<leader>djsi", function()
    require("config.js-dev-windows").install_deps()
  end, { desc = "JS/TS: Install deps" })
  
  map("n", "<leader>djsb", function()
    require("config.js-dev-windows").build()
  end, { desc = "JS/TS: Build" })
  
  map("n", "<leader>djsd", function()
    require("config.js-dev-windows").dev_server()
  end, { desc = "JS/TS: Dev server" })
  
  map("n", "<leader>djsp", function()
    require("config.js-dev-windows").preview()
  end, { desc = "JS/TS: Preview build" })
  
  map("n", "<leader>djsa", function()
    require("config.js-dev-windows").test_all()
  end, { desc = "JS/TS: Test all" })
  
  map("n", "<leader>djst", function()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or 
       vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" then
      require("config.js-dev-windows").test_current()
    else
      vim.notify("Not in a JavaScript/TypeScript file", vim.log.levels.WARN)
    end
  end, { desc = "JS/TS: Test current file" })
  
  -- Electron specific
  map("n", "<leader>djse", function()
    require("config.js-dev-windows").electron_start()
  end, { desc = "JS/TS: Start Electron" })
  
  -- Debugging keybindings
  map("n", "<leader>djsD", function()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or 
       vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" or
       vim.bo.filetype == "vue" then
      require("config.js-dev-windows").debug_file()
    else
      vim.notify("Not in a JavaScript/TypeScript file", vim.log.levels.WARN)
    end
  end, { desc = "JS/TS: Debug current file" })
  
  map("n", "<leader>djsA", function()
    require("config.js-dev-windows").attach_debugger()
  end, { desc = "JS/TS: Attach debugger" })
  
  map("n", "<leader>djsT", function()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" or 
       vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" then
      require("config.js-dev-windows").test_function()
    else
      vim.notify("Not in a JavaScript/TypeScript file", vim.log.levels.WARN)
    end
  end, { desc = "JS/TS: Test function" })

  -- PHP development keybindings
  map("n", "<leader>dphs", function()
    if vim.bo.filetype == "php" then
      require("config.php-dev-windows").php_check()
    else
      vim.notify("Not in a PHP file", vim.log.levels.WARN)
    end
  end, { desc = "PHP: Syntax check" })
  
  map("n", "<leader>dphr", function()
    if vim.bo.filetype == "php" then
      require("config.php-dev-windows").php_run()
    else
      vim.notify("Not in a PHP file", vim.log.levels.WARN)
    end
  end, { desc = "PHP: Run current file" })
  
  map("n", "<leader>dpht", function()
    if vim.bo.filetype == "php" then
      require("config.php-dev-windows").phpunit_run()
    else
      vim.notify("Not in a PHP file", vim.log.levels.WARN)
    end
  end, { desc = "PHP: Run PHPUnit tests" })
  
  map("n", "<leader>dphw", function()
    if vim.bo.filetype == "php" then
      require("config.php-dev-windows").phpcs_check()
    else
      vim.notify("Not in a PHP file", vim.log.levels.WARN)
    end
  end, { desc = "PHP: WordPress standards check" })
  
  map("n", "<leader>dphi", function()
    require("config.php-dev-windows").php_repl()
  end, { desc = "PHP: Interactive shell" })
  
  map("n", "<leader>dphp", function()
    require("config.php-dev-windows").wp_cli()
  end, { desc = "PHP: WP-CLI" })
  
  map("n", "<leader>dphf", function()
    if vim.bo.filetype == "php" then
      vim.lsp.buf.format({ async = true })
    else
      vim.notify("Not in a PHP file", vim.log.levels.WARN)
    end
  end, { desc = "PHP: Format" })
  
  map("n", "<leader>dphD", function()
    if vim.bo.filetype == "php" then
      -- Ensure PHP DAP is configured
      require("config.dap-php").setup()
      -- Start debugging with the "Launch file" configuration
      require("dap").run({
        type = "php",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        port = 9003,
        runtimeArgs = {
          "-dxdebug.mode=debug",
          "-dxdebug.start_with_request=yes",
        },
      })
    else
      vim.notify("Not in a PHP file", vim.log.levels.WARN)
    end
  end, { desc = "PHP: Debug current file" })
  
  -- Composer commands
  map("n", "<leader>dphci", function()
    require("config.php-dev-windows").composer_run("install")
  end, { desc = "PHP: Composer install" })
  
  map("n", "<leader>dphcu", function()
    require("config.php-dev-windows").composer_run("update")
  end, { desc = "PHP: Composer update" })
  
  map("n", "<leader>dphcr", function()
    require("config.php-dev-windows").composer_run("require")
  end, { desc = "PHP: Composer require" })

  -- Shell (Bash/Zsh) development keybindings
  map("n", "<leader>dzsr", function()
    if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" or vim.bo.filetype == "zsh" then
      vim.cmd("terminal %")
    else
      vim.notify("Not in a shell script file", vim.log.levels.WARN)
    end
  end, { desc = "Shell: Run script" })
  
  map("n", "<leader>dzsc", function()
    if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" or vim.bo.filetype == "zsh" then
      vim.cmd("!shellcheck %")
    else
      vim.notify("Not in a shell script file", vim.log.levels.WARN)
    end
  end, { desc = "Shell: Check with shellcheck" })
  
  map("n", "<leader>dzsx", function()
    if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" or vim.bo.filetype == "zsh" then
      vim.cmd("!chmod +x %")
      vim.notify("Made file executable", vim.log.levels.INFO)
    else
      vim.notify("Not in a shell script file", vim.log.levels.WARN)
    end
  end, { desc = "Shell: Make executable" })
  
  map("n", "<leader>dzsf", function()
    if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" or vim.bo.filetype == "zsh" then
      vim.cmd("!shfmt -w %")
      vim.cmd("edit!")  -- Reload the file
    else
      vim.notify("Not in a shell script file", vim.log.levels.WARN)
    end
  end, { desc = "Shell: Format with shfmt" })
  
  map("n", "<leader>dzsd", function()
    if vim.bo.filetype == "sh" or vim.bo.filetype == "bash" or vim.bo.filetype == "zsh" then
      vim.cmd("terminal bash -x %")
    else
      vim.notify("Not in a shell script file", vim.log.levels.WARN)
    end
  end, { desc = "Shell: Debug run" })

  -- PowerShell development keybindings
  map("n", "<leader>dpsr", function()
    if vim.bo.filetype == "ps1" then
      require("config.powershell-dev-windows").run_script()
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Run script" })
  
  map("n", "<leader>dpsc", function()
    if vim.bo.filetype == "ps1" then
      require("config.powershell-dev-windows").analyze()
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Analyze with PSScriptAnalyzer" })
  
  map("n", "<leader>dpsf", function()
    if vim.bo.filetype == "ps1" then
      -- PowerShell LSP handles formatting
      vim.lsp.buf.format({ async = true })
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Format" })
  
  map("n", "<leader>dpsi", function()
    if vim.bo.filetype == "ps1" then
      local file = vim.fn.expand("%:p")
      Snacks.terminal("pwsh -NoExit -NoProfile -File '" .. file .. "'", {
        cwd = vim.fn.fnamemodify(file, ":h"),
        win = {
          position = "float",
          width = 0.8,
          height = 0.8,
        }
      })
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Run interactive" })
  
  map("n", "<leader>dpsd", function()
    if vim.bo.filetype == "ps1" then
      require("config.powershell-dev-windows").debug_script()
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Debug run" })
  
  map("n", "<leader>dpsh", function()
    if vim.bo.filetype == "ps1" then
      require("config.powershell-dev-windows").get_help()
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Get help for word" })
  
  map("n", "<leader>dpsm", function()
    require("config.powershell-dev-windows").list_modules()
  end, { desc = "PowerShell: List modules" })
  
  map("n", "<leader>dpst", function()
    if vim.bo.filetype == "ps1" then
      require("config.powershell-dev-windows").run_tests()
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Run Pester tests" })
  
  map("n", "<leader>dpsS", function()
    if vim.bo.filetype == "ps1" then
      require("config.powershell-dev-windows").check_syntax()
    else
      vim.notify("Not in a PowerShell file", vim.log.levels.WARN)
    end
  end, { desc = "PowerShell: Check syntax" })

  -- Markdown keybindings (ensure these are always visible)
  -- Already defined in markdown.lua and keymaps.lua, but we'll make them global here too
  map("n", "<leader>mp", function()
    if vim.bo.filetype == "markdown" then
      vim.cmd("MarkdownPreviewToggle")
    else
      vim.notify("Not in a Markdown file", vim.log.levels.WARN)
    end
  end, { desc = "Markdown: Preview toggle" })
  
  map("n", "<leader>mi", function()
    if vim.bo.filetype == "markdown" then
      vim.cmd("PasteImage")
    else
      vim.notify("Not in a Markdown file", vim.log.levels.WARN)
    end
  end, { desc = "Markdown: Paste image" })
  
  map("n", "<leader>mc", function()
    local line = vim.api.nvim_get_current_line()
    local new_line = line
    if line:match("%[%s%]") then
      new_line = line:gsub("%[%s%]", "[x]")
    elseif line:match("%[x%]") or line:match("%[X%]") then
      new_line = line:gsub("%[.%]", "[ ]")
    end
    vim.api.nvim_set_current_line(new_line)
  end, { desc = "Markdown: Toggle checkbox" })
  
end

return M