-- PHP/WordPress Plugin Development Support
return {
  -- PHP-specific tools
  {
    "gbprod/phpactor.nvim",
    ft = { "php" },
    build = function()
      -- Only try to update phpactor if composer is available
      if vim.fn.executable("composer") == 1 then
        require("phpactor.handler.update")()
      else
        vim.notify("Composer not found. Install PHP and Composer to use phpactor features.", vim.log.levels.WARN)
      end
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Only configure if composer is available
      if vim.fn.executable("composer") == 1 then
        require("phpactor").setup({
          install = {
            check_on_startup = "daily",
          },
          lspconfig = {
            enabled = false, -- We'll use intelephense instead
          },
        })
      end
    end,
  },

  -- Note: wordpress.nvim was removed as the repository no longer exists
  -- Intelephense with WordPress stubs provides excellent WordPress support


  -- PHP Testing
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "olimorris/neotest-phpunit",
    },
    opts = {
      adapters = {
        ["neotest-phpunit"] = {
          root_files = { "phpunit.xml", "composer.json" },
          phpunit_cmd = function()
            -- Check for vendor/bin/phpunit first
            if vim.fn.filereadable("vendor/bin/phpunit") == 1 then
              return "vendor/bin/phpunit"
            -- Check for Composer-installed global phpunit
            elseif vim.fn.executable("phpunit") == 1 then
              return "phpunit"
            -- Docker fallback
            else
              return "docker-compose exec app phpunit"
            end
          end,
          -- WordPress test configuration
          env = {
            WP_TESTS_DIR = "/tmp/wordpress-tests-lib",
            WP_CORE_DIR = "/tmp/wordpress",
          },
        },
      },
    },
  },
}