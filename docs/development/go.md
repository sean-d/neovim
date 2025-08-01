# Go Development

Comprehensive Go development environment powered by go.nvim and gopls.

## Features

- **Full LSP Support** via gopls
- **Integrated Testing** with beautiful output windows
- **Code Coverage** visualization
- **Debugging** with delve integration
- **Import Management** automatic organization
- **Format on Save** with gofmt/goimports
- **Code Quality** with go vet and custom format checking
- **Code Generation** struct tags, interfaces, etc.

## Prerequisites

```bash
# Install Go
brew install go           # macOS
sudo apt install golang   # Ubuntu/Debian

# Verify installation
go version
```

## Initial Setup

When you first open a Go file, run:
```vim
:lua require("go.install").update_all_sync()
```

This installs all necessary Go tools:
- goimports
- gopls  
- golines (formatter with line length limit)
- delve (debugger)
- and more...

## Key Mappings

All Go commands are under `<leader>dgo` prefix:

### Testing
| Key | Description |
|-----|-------------|
| `<leader>dgot` | Test current file |
| `<leader>dgoT` | Test current function |
| `<leader>dgoa` | Test all packages |
| `<leader>dgoc` | Show test coverage |
| `<leader>dgoC` | Clear test coverage |

### Code Quality
| Key | Description |
|-----|-------------|
| `<leader>dgof` | Format check (shows diff) |
| `<leader>dgov` | Run go vet |
| `<leader>dgob` | Build project |
| `<leader>dgoi` | Organize imports |
| `<leader>dgom` | Run go mod tidy |

### Debugging
| Key | Description |
|-----|-------------|
| `<leader>dgoD` | Start debugger |
| `<leader>dgox` | Stop debugger |
| `<leader>dgoX` | Debug current test |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>dO` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |

### Documentation
| Key | Description |
|-----|-------------|
| `<leader>dgod` | Show Go documentation |
| `K` | Hover documentation (LSP) |

## Automatic Features

### Format on Save
Your code is automatically formatted with goimports when you save.

### Error Checking
Real-time error checking via gopls with custom diagnostic icons shows:
- Syntax errors
- Type errors
- Missing imports
- Unused variables

### Auto-completion
Get intelligent completions for:
- Package names
- Function names
- Struct fields
- Method calls
- Import paths

## Testing Workflow

### Run Tests
```vim
" Test current file
<leader>dgot

" Test function under cursor
<leader>dgoT

" Test entire project
<leader>dgoa
```

Tests open in a beautiful floating window showing:
- Pass/fail status with colors
- Error messages and stack traces
- Test duration
- Coverage percentage

### View Coverage
```vim
" Show coverage report window
<leader>dgoc

" Clear coverage highlighting
<leader>dgoC
```

Coverage is displayed in a floating window showing:
- Function-level coverage percentages
- Overall package coverage
- Navigable list of functions

## Debugging Workflow

### Basic Debugging
1. Set breakpoints: `<leader>db`
2. Start debugger: `<leader>dgoD`
3. Use debug controls:
   - Continue: `<leader>dc`
   - Step over: `<leader>dO`
   - Step into: `<leader>di`
   - Step out: `<leader>do`
4. View variables in debug UI

### Debug Tests
Position cursor on test function and press `<leader>dgoX` to debug it.

## Code Navigation

### Go to Definition
- `gd` - Opens definition in custom preview window
- `<C-]>` - Jump to definition
- `<C-o>` - Jump back

### Find References
- `gr` - List all references to symbol

### Symbol Outline
- `<leader>co` - Toggle outline showing all functions, types, etc.

## Code Generation

While go.nvim supports various code generation features, they're accessible through commands:

```vim
:GoAddTag         " Add struct tags
:GoRmTag          " Remove struct tags
:GoImpl           " Generate interface implementation
:GoGenerate       " Run go generate
```

## Project Structure

The configuration recognizes standard Go project layouts:
- `go.mod` files for module detection
- `vendor/` directories
- `internal/` packages
- Test files (`*_test.go`)

## Tips & Tricks

### Quick Import
When you use an unimported package, save the file and goimports will add it automatically.

### Test Output
Test output windows can be:
- Scrolled with mouse or `<C-d>`/`<C-u>`
- Closed with `q` or `<Esc>`
- Resized by dragging borders

### Struct Tags
Add tags to struct fields:
```go
type User struct {
    Name string // Put cursor here
    Email string
}
```
Run `:GoAddTag json` to add JSON tags.

### Interface Implementation
With cursor on type name:
```vim
:GoImpl io.Reader
```
Generates the required methods.

## Troubleshooting

### gopls not starting
```vim
:LspInfo          " Check if gopls is running
:LspLog           " View error logs
:Mason            " Reinstall gopls
```

### Tests not running
- Ensure you're in a Go module: `go mod init`
- Check for compilation errors: `<leader>dgb`
- Verify test file naming: `*_test.go`

### Debugging not working
```vim
:checkhealth      " Check overall setup
:lua require("go.install").update_all_sync() " Reinstall tools
```

## Configuration

The Go setup is in `lua/plugins/go.lua`. Key settings:
- Format on save: enabled with goimports
- Line length: 120 characters (via golines)
- Import management: gopls
- Test display: Custom floating windows with color-coded results
- Inlay hints: Enabled for parameters and types

---
[← Back to Development Overview](index.md) | [JavaScript/TypeScript →](javascript.md)