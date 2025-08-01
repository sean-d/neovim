# Debugging (DAP)

Debug Adapter Protocol (DAP) integration for debugging various languages.

## Overview

This configuration uses nvim-dap for debugging with:
- **Floating UI** - Clean debugging interface
- **Virtual Text** - See variable values inline
- **Conditional Breakpoints** - Break on specific conditions
- **REPL** - Interactive debugging console
- **Variable Inspection** - Hover to see values

## Supported Languages

Currently configured:
- **Go** - Via delve debugger

Coming soon:
- Python (debugpy)
- JavaScript/TypeScript (node debug adapter)
- Rust (lldb/rust-gdb)

## Key Mappings

### Basic Controls
| Key | Description |
|-----|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>dC` | Run to cursor |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dd` | Toggle debug UI |
| `<leader>de` | Evaluate expression |
| `<leader>dE` | Evaluate input |
| `<leader>dt` | Terminate debug session |
| `<leader>dr` | Toggle REPL |
| `<leader>dl` | Run last debug configuration |
| `<leader>dh` | Hover variables |
| `<leader>dp` | Preview |
| `<leader>df` | Show frames |
| `<leader>dS` | Show scopes |

### Language-Specific
| Key | Description |
|-----|-------------|
| `<leader>dgoD` | Start Go debugger |
| `<leader>dgx` | Stop Go debugger |
| `<leader>dgoX` | Debug current Go test |

## Debugging Workflow

### 1. Set Breakpoints
Click in the gutter or press `<leader>db` on any line.

Breakpoints appear as red dots: 🔴

### 2. Start Debugging
For each language:
```vim
" Go
<leader>dgoD    " Debug main package
<leader>dgoX    " Debug test under cursor

" Python
<leader>dpyD    " Debug current file

" JavaScript/TypeScript
<leader>djsD    " Debug current file
<leader>djsA    " Attach to Node process

" Rust
<leader>drsx    " Debug current target

" PHP
<leader>dphD    " Debug current file
```

### 3. Control Execution
Once debugging starts:
- **Continue** (`<leader>dc`) - Run to next breakpoint
- **Step Over** (`<leader>ds`) - Execute current line
- **Step Into** (`<leader>di`) - Enter function calls
- **Step Out** (`<leader>do`) - Exit current function

### 4. Inspect Variables
- Hover over variables to see values
- Use the debug UI to explore scope
- Evaluate expressions with `<leader>de`

### 5. Stop Debugging
Press `<leader>dgx` or close the debug UI.

## Debug UI

The debug UI (`<leader>du`) shows:
- **Variables** - Local and global variables
- **Watches** - Expressions to monitor
- **Call Stack** - Current execution path
- **Breakpoints** - All set breakpoints
- **REPL** - Interactive console

### UI Navigation
- `<Tab>` - Switch between panels
- `<CR>` - Expand/collapse items
- `q` - Close UI

## Advanced Features

### Conditional Breakpoints
Set breakpoints that only trigger when conditions are met:
```lua
require('dap').set_breakpoint(nil, 'i == 10')
```

### Log Points
Print messages without stopping execution:
```lua
require('dap').set_breakpoint(nil, nil, 'Value of i: ' .. i)
```

### Exception Breakpoints
For languages that support it, break on exceptions:
```lua
require('dap').set_exception_breakpoints({"raised", "uncaught"})
```

## Virtual Text

During debugging, variable values appear inline:
```go
func example() {
    x := 42      // x: 42
    y := "hello" // y: "hello"
}
```

## REPL Commands

In the REPL (`:DapToggleRepl`):
- `.exit` - Close REPL
- `.c` or `.continue` - Continue execution
- `.n` or `.next` - Step over
- `.s` or `.step` - Step into
- `.help` - Show all commands

## Language-Specific Debugging

### Go Debugging
1. Set breakpoints: `<leader>db`
2. Start debugging: `<leader>dgoD` (main) or `<leader>dgoX` (test)
3. Use DAP controls to step through

**Note**: Go debugging uses go.nvim integration with delve.

### JavaScript/TypeScript Debugging
The configuration supports multiple debug scenarios:

**Node.js Applications:**
- Debug current file with `<leader>djsD`
- Attach to running process with `<leader>djsA`

**Browser Debugging:**
- Chrome/Brave/Edge support built-in
- Vue.js debugging configured
- Source map support enabled

**Electron Applications:**
- Start Electron with `<leader>djse`
- Debug main and renderer processes

**Test Debugging:**
- Jest/Vitest test debugging support
- Debug individual tests or suites

### Python Debugging
1. Set breakpoints in Python file
2. Start debugging: `<leader>dpyD`
3. Supports virtual environments automatically

### Rust Debugging
1. Build project first: `<leader>drsb`
2. Debug with `<leader>drsx`
3. Uses codelldb for better Rust support

### PHP Debugging
1. Configure Xdebug in PHP environment
2. Set breakpoints: `<leader>db`
3. Start debugging: `<leader>dphD`
4. Trigger request from browser/CLI

## Configuration

### Adding Debug Adapters
Debug configurations are in:
- `lua/plugins/dap.lua` - General DAP setup
- `lua/plugins/go.lua` - Go-specific debugging

### Custom Configurations
Add custom debug configurations:
```lua
local dap = require('dap')
dap.configurations.go = {
  {
    type = 'go',
    name = 'Debug with flags',
    request = 'launch',
    program = '${file}',
    buildFlags = '-tags=integration'
  }
}
```

## Troubleshooting

### Debugger not starting
- Check adapter is installed: `:Mason`
- Verify language setup: `:checkhealth`
- View DAP log: `:DapShowLog`

### Breakpoints not working
- Ensure code is compiled with debug symbols
- For Go: avoid compiler optimizations
- Check source maps are correct

### Variables not showing
- Ensure virtual text is enabled
- Check scope is correct
- Try manual evaluation: `<leader>de`

## Tips

1. **Quick Debugging**: Use `<leader>dgoX` to debug Go tests instantly
2. **Watch Expressions**: Monitor complex expressions across steps
3. **Hover Values**: During debugging, hover shows current values
4. **Debug UI**: Keep it open for full debugging context
5. **REPL**: Use for quick expression evaluation

---
[← Back to Database Tools](database.md) | [Markdown →](../markdown.md)