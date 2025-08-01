# PHP/WordPress Plugin Development

This configuration is optimized for WordPress plugin development using modern PHP practices inspired by projects like [Basis](https://github.com/fivefifteen/basis).

## Overview

Our PHP setup focuses exclusively on WordPress plugin development with:
- **Composer-based dependency management**
- **WordPress coding standards enforcement**
- **Docker-first development workflow**
- **Modern tooling integration**

## Prerequisites

```bash
# Install PHP and Composer
brew install php composer

# Install Xdebug for debugging
pecl install xdebug

# Configure Xdebug (add to php.ini)
# Note: pecl usually adds zend_extension="xdebug.so" automatically
# Add these lines to your php.ini:
# xdebug.mode=debug
# xdebug.start_with_request=yes
# xdebug.client_port=9003  # Xdebug 3 default

# Install WordPress coding standards
composer global require wp-coding-standards/wpcs
composer global require phpcsstandards/phpcsutils
composer global require phpcsstandards/phpcsextra
composer global require dealerdirect/phpcodesniffer-composer-installer

# Verify installation
php --version  # Should be 8.1+ (WordPress 6.4+ recommendation)
composer --version
php -m | grep xdebug  # Should show xdebug
phpcs -i  # Should list WordPress standards
```

### Auto-installed Components

The following components are automatically installed by Mason when you open Neovim:
- **intelephense** - PHP Language Server with WordPress-optimized configuration
- **php-debug-adapter** - PHP debugging support (DAP)

Note: Auto-installation is disabled when running inside Docker containers.

## Development Workflow

### PHPActor Integration

The configuration includes PHPActor for advanced refactoring capabilities:
- Automatically updates PHPActor when Composer is available
- Provides code transformations and refactoring tools
- Note: LSP features are disabled in PHPActor to avoid conflicts with Intelephense

### Project Structure

Modern WordPress plugin development uses a Composer-centric approach:

```
my-plugin/
├── composer.json          # Dependencies and autoloading
├── phpunit.xml           # Test configuration
├── .phpcs.xml            # WordPress coding standards
├── docker-compose.yml    # Local development environment
├── src/                  # PSR-4 autoloaded classes
│   ├── Admin/
│   ├── Frontend/
│   └── Core/
├── tests/                # PHPUnit tests
├── assets/               # CSS, JS, images
├── languages/            # i18n files
└── my-plugin.php         # Main plugin file
```

### Composer Setup

Example `composer.json` for a WordPress plugin:

```json
{
    "name": "yourname/your-plugin",
    "description": "WordPress plugin description",
    "type": "wordpress-plugin",
    "require": {
        "php": ">=8.1",
        "composer/installers": "^2.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^9.5",
        "wp-coding-standards/wpcs": "^3.0",
        "phpcsstandards/phpcsutils": "^1.0",
        "dealerdirect/phpcodesniffer-composer-installer": "^1.0",
        "brain/monkey": "^2.6",
        "mockery/mockery": "^1.5"
    },
    "autoload": {
        "psr-4": {
            "YourPlugin\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "YourPlugin\\Tests\\": "tests/"
        }
    },
    "scripts": {
        "test": "phpunit",
        "phpcs": "phpcs",
        "phpcbf": "phpcbf"
    }
}
```

### Docker Development Environment

Example `docker-compose.yml` for WordPress development:

```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DEBUG: 1
      WORDPRESS_CONFIG_EXTRA: |
        define( 'WP_DEBUG_LOG', true );
        define( 'WP_DEBUG_DISPLAY', false );
        define( 'SCRIPT_DEBUG', true );
    volumes:
      - ./:/var/www/html/wp-content/plugins/your-plugin
      - wordpress:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: somewordpress
    volumes:
      - db:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - "8081:80"
    environment:
      PMA_HOST: db
      PMA_USER: wordpress
      PMA_PASSWORD: wordpress
    depends_on:
      - db

volumes:
  wordpress:
  db:
```

### WordPress Coding Standards

Create `.phpcs.xml` in your project root:

```xml
<?xml version="1.0"?>
<ruleset name="WordPress Plugin Coding Standards">
    <description>WordPress coding standards for my plugin</description>

    <!-- Check all PHP files in directory -->
    <file>.</file>
    
    <!-- Exclude vendor and node_modules -->
    <exclude-pattern>*/vendor/*</exclude-pattern>
    <exclude-pattern>*/node_modules/*</exclude-pattern>
    
    <!-- Use WordPress standards -->
    <rule ref="WordPress">
        <!-- Allow short array syntax -->
        <exclude name="Universal.Arrays.DisallowShortArraySyntax"/>
    </rule>
    
    <!-- Configure text domain for i18n -->
    <rule ref="WordPress.WP.I18n">
        <properties>
            <property name="text_domain" type="array">
                <element value="your-plugin-textdomain"/>
            </property>
        </properties>
    </rule>
    
    <!-- Use PSR-4 autoloading -->
    <rule ref="WordPress.Files.FileName">
        <exclude-pattern>*/src/*</exclude-pattern>
    </rule>
</ruleset>
```

## Keybindings

All PHP keybindings use the `<leader>dph` prefix.

### Code Quality
- `<leader>dphs` - Syntax check current file
- `<leader>dphw` - Check WordPress coding standards
- `<leader>dphf` - Format file (using intelephense)

### Running Code
- `<leader>dphr` - Run current PHP file
- `<leader>dpht` - Run PHPUnit tests
- `<leader>dphi` - Open PHP interactive shell
- `<leader>dphD` - Start debugging (requires Xdebug)

### WordPress Tools
- `<leader>dphp` - Open WP-CLI interface

### Composer Commands
- `<leader>dphci` - Composer install
- `<leader>dphcu` - Composer update
- `<leader>dphcr` - Composer require (interactive)


## LSP Features

Intelephense provides:
- **Autocompletion** for WordPress functions, hooks, and classes
- **Go to definition** for core WordPress functions
- **Hover documentation** with function signatures
- **Signature help** for function parameters
- **Find references** across your codebase
- **Rename** symbols project-wide
- **Auto-insertion** of use declarations
- **Parameter hints** with inlay hints support

The configuration includes extensive WordPress stubs:
- WordPress core functions and classes
- WordPress globals
- WP-CLI functions
- All PHP extensions (bcmath, curl, json, PDO, etc.)

## Testing

### PHPUnit Setup

Create `phpunit.xml`:

```xml
<?xml version="1.0"?>
<phpunit
    bootstrap="tests/bootstrap.php"
    colors="true"
    convertErrorsToExceptions="true"
    convertNoticesToExceptions="true"
    convertWarningsToExceptions="true"
>
    <testsuites>
        <testsuite name="unit">
            <directory suffix="Test.php">tests/Unit</directory>
        </testsuite>
        <testsuite name="integration">
            <directory suffix="Test.php">tests/Integration</directory>
        </testsuite>
    </testsuites>
    
    <coverage processUncoveredFiles="true">
        <include>
            <directory suffix=".php">src</directory>
        </include>
    </coverage>
</phpunit>
```

### Writing Tests

Example unit test using Brain Monkey for WordPress mocking:

```php
<?php
namespace YourPlugin\Tests\Unit;

use Brain\Monkey;
use Brain\Monkey\Functions;
use PHPUnit\Framework\TestCase;
use YourPlugin\Core\Plugin;

class PluginTest extends TestCase {
    protected function setUp(): void {
        parent::setUp();
        Monkey\setUp();
    }

    protected function tearDown(): void {
        Monkey\tearDown();
        parent::tearDown();
    }

    public function test_plugin_initialization() {
        Functions\expect('add_action')
            ->once()
            ->with('init', Mockery::type('callable'));
        
        $plugin = new Plugin();
        $plugin->init();
        
        $this->assertTrue(true); // Assertion will fail if expectations not met
    }
}
```

## WP-CLI Integration

Access WP-CLI with `<leader>dphp`. Common commands:

```bash
# Plugin management
wp plugin list
wp plugin activate your-plugin
wp plugin deactivate your-plugin

# Database operations
wp db export
wp db import backup.sql
wp search-replace oldurl.com newurl.com

# User management
wp user create testuser test@example.com --role=administrator

# Testing data
wp post generate --count=100
wp user generate --count=50
```

## Docker Workflow

### Starting Development

```bash
# Start containers
docker-compose up -d

# View logs
docker-compose logs -f wordpress

# Access WordPress
open http://localhost:8080

# Access phpMyAdmin
open http://localhost:8081
```

### Running Commands in Container

The Neovim configuration automatically detects Docker and runs commands inside containers:

```bash
# These commands auto-detect Docker when you use the keybindings:
<leader>dphr   # Runs PHP file in container if Docker is detected
<leader>dpht   # Runs PHPUnit in container if Docker is detected
<leader>dphp   # Opens WP-CLI in container if Docker is detected

# Manual container commands:
docker-compose exec wordpress composer install
docker-compose exec wordpress vendor/bin/phpunit
docker-compose exec wordpress wp plugin list
```

## Debugging

### Local Debugging

With Xdebug installed and configured (see Prerequisites), you can debug PHP files locally:

1. Open a PHP file in Neovim
2. Set breakpoints: `<leader>db`
3. Start debugging: `<leader>dphD`
4. In another terminal, run: `php yourfile.php`
5. The debugger will stop at your breakpoints

### Docker Xdebug Setup

Add to your Docker image or install in container:

```dockerfile
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini
```

The configuration includes three DAP configurations:
1. **Launch File** - Basic PHP file debugging (port 9003)
2. **Launch WordPress Plugin** - Docker-based plugin debugging with path mappings
3. **Docker Script** - General Docker debugging with /app mapping

All configurations automatically handle Xdebug mode and path mappings for seamless debugging.

## Best Practices

1. **Use Composer for all dependencies** - Never manually download libraries
2. **Follow WordPress coding standards** - Use PHPCS to enforce (K&R brace style)
3. **Write tests** - Use PHPUnit with Brain Monkey for unit tests
4. **Use proper namespacing** - PSR-4 autoloading for clean code structure
5. **Escape everything** - Use WordPress escaping functions for security
6. **Internationalize from the start** - Use `__()`, `_e()`, etc.
7. **Use WordPress APIs** - Don't reinvent the wheel
8. **Version control everything** - Including composer.lock
9. **Target PHP 8.2** - As configured in Intelephense for modern PHP features

## Troubleshooting

### Common Issues

1. **Intelephense License**
   - Free version works fine for most development
   - Premium adds better type inference and performance

2. **WordPress Stubs Not Loading**
   - The configuration automatically includes WordPress stubs
   - Stubs include: wordpress, wordpress-globals, wp-cli, and all PHP extensions
   - Restart LSP with `:LspRestart` if needed

3. **Docker Performance (macOS)**
   - Use named volumes instead of bind mounts for better performance
   - Consider using Mutagen or docker-sync

4. **Composer Memory Errors**
   ```bash
   export COMPOSER_MEMORY_LIMIT=-1
   composer install
   ```

---
[← Back to JavaScript/TypeScript](javascript.md) | [PowerShell →](powershell.md)