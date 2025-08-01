-- PHP DAP configuration
local M = {}

function M.setup()
  local dap = require("dap")
  
  -- Skip if already configured
  if dap.adapters.php then
    return
  end
  
  -- Direct path to php-debug-adapter
  local path = vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter"
  if vim.fn.isdirectory(path) == 0 then
    vim.notify("php-debug-adapter not found. Install with :MasonInstall php-debug-adapter", vim.log.levels.WARN)
    return
  end
  
  dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { path .. "/extension/out/phpDebug.js" },
  }
  
  dap.configurations.php = {
    {
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
    },
    {
      type = "php",
      request = "launch",
      name = "Launch WordPress Plugin",
      cwd = "${workspaceFolder}",
      port = 9003,
      pathMappings = {
        ["/var/www/html/wp-content/plugins/${workspaceFolderBasename}"] = "${workspaceFolder}",
      },
      hostname = "localhost",
      skipFiles = {
        "/var/www/html/wp-admin/**",
        "/var/www/html/wp-includes/**",
      },
    },
    {
      type = "php",
      request = "launch",
      name = "Launch current script in Docker",
      cwd = "${workspaceFolder}",
      port = 9003,
      pathMappings = {
        ["/app"] = "${workspaceFolder}",
      },
      hostname = "host.docker.internal",
    },
  }
  
  vim.notify("PHP DAP configured", vim.log.levels.INFO)
end

return M