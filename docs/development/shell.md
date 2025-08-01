# Shell Scripting

This guide covers Bash and Zsh scripting support in Neovim.

## Overview

Full language support for shell scripting including:
- Bash, sh, and Zsh syntax
- LSP features (completion, diagnostics, hover)
- Formatting with shfmt (format on save enabled)
- Linting with shellcheck (command line)
- Direct script execution in terminal
- Script execution

## Language Server

**bash-language-server** (bashls) provides:
- Auto-completion for commands, variables, functions, and file paths
- Hover documentation for built-in commands
- Go to definition for functions and variables
- Real-time error checking (syntax errors, undefined variables)
- Parameter hints

Supported file types: `sh`, `bash`, `zsh`
Glob pattern: `*@(.sh|.inc|.bash|.zsh|.command)`

## Features

### Syntax Support
- Full syntax highlighting for:
  - Variables and expansions
  - Functions and control structures
  - Here documents
  - Command substitution
  - Arrays and associative arrays

### Diagnostics
The LSP warns about common issues:
- Unquoted variables that may split
- Undefined variables
- Syntax errors
- Deprecated constructs
- POSIX compliance issues

### Auto-completion
- Shell built-ins and keywords
- Functions defined in script
- Variables in scope
- File paths
- Command options (when available)

## Key Bindings

### Shell Development Commands

Shell commands use the `<leader>dzs` prefix (zsh/shell):

| Key | Description |
|-----|-------------|
| `<leader>dzsr` | Run current script in terminal |
| `<leader>dzsc` | Check script with shellcheck |
| `<leader>dzsx` | Make script executable (chmod +x) |
| `<leader>dzsf` | Format with shfmt |
| `<leader>dzsd` | Debug run (bash -x) |

### Standard LSP bindings

| Key | Description |
|-----|-------------|
| `K` | Show hover documentation |
| `gd` | Go to definition |
| `gr` | Find references |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code actions |
| `[d` / `]d` | Navigate diagnostics |

## Prerequisites

### Required Tools
```bash
# Install formatting tool
brew install shfmt        # macOS
sudo apt install shfmt    # Ubuntu/Debian

# Install linting tool
brew install shellcheck   # macOS
sudo apt install shellcheck  # Ubuntu/Debian
```

### Auto-installed Components
- **bash-language-server** - Automatically installed via Mason

## Writing Scripts

### Best Practices
```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Always quote variables
file_path="$HOME/documents"
[ -d "$file_path" ] && echo "Directory exists"

# Use shellcheck directives when needed
# shellcheck disable=SC2086
command $unquoted_var  # Intentionally unquoted
```

### Functions
```bash
# Good function style
process_file() {
    local file=$1
    local output=${2:-/tmp/output}
    
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found" >&2
        return 1
    fi
    
    # Process the file
    grep -v '^#' "$file" > "$output"
}
```

### Arrays
```bash
# Indexed arrays
declare -a fruits=("apple" "banana" "orange")
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done

# Associative arrays (Bash 4+)
declare -A colors=(
    ["red"]="#FF0000"
    ["green"]="#00FF00"
    ["blue"]="#0000FF"
)
echo "Red is ${colors[red]}"
```

## Running Scripts

### From Neovim
- `<leader>dzsr` - Run script in terminal (using Snacks terminal)
- `<leader>dzsd` - Debug run with bash -x
- `<leader>dzsx` - Make script executable
- `<leader>dzsc` - Check with shellcheck
- `<leader>dzsf` - Format with shfmt

### Debugging
```bash
# Enable debug mode
set -x  # Print commands as executed
set -v  # Print lines as read

# Or run with debug
bash -x script.sh
```

## Shellcheck Integration

### Current Integration
- The bash-language-server provides basic diagnostics (undefined variables, syntax errors)
- Shellcheck provides more comprehensive warnings via `<leader>dzsc`
- Shellcheck runs in command line mode, not inline

### Note on Inline Diagnostics
The current setup provides:
- Basic LSP diagnostics inline via bash-language-server
- Full shellcheck analysis via command line (`<leader>dzsc`)
- Manual check with `:!shellcheck %`

For inline shellcheck warnings, additional setup would be required (e.g., none-ls or similar).

### Using Shellcheck Directives
Control specific warnings with directives:
```bash
# shellcheck disable=SC2034
unused_var="value"  # Intentionally unused

# shellcheck disable=SC2086
command $unquoted_var  # Intentionally unquoted
```

## Zsh Specific Features

The bash-language-server also supports Zsh:
- Zsh-specific syntax
- Parameter expansion
- Glob patterns
- Completion functions

## Tips

### Script Headers
```bash
#!/usr/bin/env bash
#
# Description: Brief description of script
# Usage: script.sh [options] <args>
# Author: Your Name
# Date: 2024-07-22

set -euo pipefail
IFS=$'\n\t'
```

### Error Handling
```bash
error_exit() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

# Usage
command || error_exit "Command failed" 2
```

### Portable Scripts
- Use `#!/usr/bin/env bash` for portability
- Check bash version if using advanced features
- Test with `shellcheck -s sh` for POSIX compliance
- Avoid bashisms in `/bin/sh` scripts

## Common LSP Warnings

### Unquoted Variables
```bash
# Bad
file=my file.txt
touch $file  # Creates two files!

# Good
file="my file.txt"
touch "$file"
```

### Undefined Variables
```bash
# Bad
echo $UNDEFINED_VAR

# Good
echo "${UNDEFINED_VAR:-default}"
```

### Command Substitution
```bash
# Old style (avoid)
files=`ls *.txt`

# Modern style
files=$(ls *.txt)

# Better (no ls parsing)
files=(*.txt)
```

## Formatting

### shfmt Configuration
The formatter is configured in `lua/plugins/formatting.lua`:
- Supports `sh`, `bash`, and `zsh` files
- Format on save enabled (500ms timeout)
- Manual format with `<leader>cf`

### Installation Required
shfmt must be installed separately (see Prerequisites above).

---
[← Back to Rust Development](rust.md) | [Lua Development →](lua.md)