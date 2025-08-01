# Rust Development

Comprehensive Rust development environment powered by rustaceanvim (version 5+) and rust-analyzer.

## Features

- **Full LSP Support** via rust-analyzer
- **Integrated Testing** with beautiful output windows
- **Clippy Integration** for advanced linting
- **Debugging** with CodeLLDB
- **Cargo Management** build, run, test, and more
- **Format on Save** with rustfmt
- **Macro Expansion** view expanded macros
- **Code Generation** derive macros, trait implementations

## Prerequisites

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verify installation
rustc --version
cargo --version

# Install additional tools
rustup component add rust-src
rustup component add rust-analyzer  # Also managed by rustaceanvim
rustup component add clippy
rustup component add rustfmt
```

## Initial Setup

When you first open a Rust file, rust-analyzer will automatically start through rustaceanvim.

### Auto-installed Components

The following components are automatically installed by Mason when you open Neovim:
- **rust-analyzer** - Rust Language Server (managed by rustaceanvim)
- **codelldb** - Rust debugging support (DAP)

Note: rustaceanvim manages rust-analyzer configuration independently from standard LSP setup.

## Key Mappings

All Rust commands are under `<leader>drs` prefix:

### Testing
| Key | Description |
|-----|-------------|
| `<leader>drst` | Test current file |
| `<leader>drsT` | Test current function (uses treesitter) |
| `<leader>drsa` | Test all packages |

### Code Quality
| Key | Description |
|-----|-------------|
| `<leader>drsc` | Run Clippy check (with all warnings) |
| `<leader>drsf` | Format check (shows diff) |
| `<leader>drsb` | Build project (debug) |
| `<leader>drsB` | Build release |
| `<leader>drsk` | Check (fast type checking) |

### Running
| Key | Description |
|-----|-------------|
| `<leader>drsr` | Run project |
| `<leader>drsR` | Show runnable targets |

### Code Exploration
| Key | Description |
|-----|-------------|
| `<leader>drse` | Expand macro |
| `<leader>drsm` | Rebuild proc macros |
| `<leader>drsp` | Go to parent module |
| `<leader>drsj` | Join lines (smart) |

### Cargo Management
| Key | Description |
|-----|-------------|
| `<leader>drsu` | Update dependencies |
| `<leader>drsC` | Open Cargo.toml |
| `<leader>drso` | Clean build artifacts |

### Documentation
| Key | Description |
|-----|-------------|
| `<leader>drsd` | Generate documentation |
| `<leader>drsh` | Open docs.rs for crate |
| `K` | Hover documentation (LSP) |

### Debugging
| Key | Description |
|-----|-------------|
| `<leader>drsD` | Show debug targets |
| `<leader>drsx` | Debug current target |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>dO` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |

### Advanced Inspection
| Key | Description |
|-----|-------------|
| `<leader>drsi` | View MIR (Mid-level IR) |
| `<leader>drsI` | View HIR (High-level IR) |

## Automatic Features

### Format on Save
Your code is automatically formatted with rustfmt when you save.

### Error Checking
Real-time error checking via rust-analyzer shows:
- Syntax errors
- Type errors
- Borrow checker errors
- Missing imports
- Unused code warnings

### Auto-completion
Get intelligent completions for:
- Crate names
- Function names
- Struct fields
- Method calls
- Trait implementations
- Macro invocations

## Testing Workflow

### Run Tests
```vim
" Test current file
<leader>drst

" Test function under cursor
<leader>drsT

" Test entire project
<leader>drsa
```

Tests open in a beautiful floating window showing:
- Pass/fail status with colors
- Error messages and stack traces
- Test duration
- Failed assertion details

### Clippy Analysis
```vim
" Run Clippy for advanced linting
<leader>drsc
```

Clippy runs with `cargo clippy -- -W clippy::all` and provides warnings for:
- Code style improvements
- Performance suggestions
- Correctness issues
- Complexity reduction

## Debugging Workflow

### Basic Debugging
1. Set breakpoints: `<leader>db`
2. Show debug targets: `<leader>drsD`
3. Select and run target
4. Use debug controls:
   - Continue: `<leader>dc`
   - Step over: `<leader>dO`
   - Step into: `<leader>di`
   - Step out: `<leader>do`
5. View variables in debug UI

### Debug Current Target
Position cursor on a test or main function and press `<leader>drsx` to debug it directly.

## Code Navigation

### Go to Definition
- `gd` - Opens definition in custom preview window
- `<C-]>` - Jump to definition
- `<C-o>` - Jump back

### Find References
- `gr` - List all references to symbol

### Symbol Outline
- `<leader>co` - Toggle outline showing all functions, types, traits, etc.

## Code Generation

While rustaceanvim supports various code generation features through rust-analyzer:

### Derive Macros
Place cursor on struct name and use code actions (`<leader>ca`) to:
- Add derive macros
- Implement traits
- Generate getters/setters

### Import Management
Missing imports are automatically suggested. Use code actions to:
- Import items
- Qualify paths
- Add use statements

## Cargo Integration

### Project Management
```vim
" Update dependencies
<leader>drsu

" Clean build artifacts
<leader>drso

" Open Cargo.toml
<leader>drsC
```

### Running Targets
```vim
" Show all runnable targets
<leader>drsR

" Run current project
<leader>drsr
```

## Floating Windows

All Rust development commands that produce output use custom floating windows:
- Beautiful rounded borders with titles
- Syntax highlighting for Rust output
- Scrollable content with `<C-d>`/`<C-u>`
- Easy dismissal with `q`, `<Esc>`, or `<C-c>`
- Status indicators (✅ success, ❌ failure)
- Footer showing "Press q to close"

## Additional Features

### Intelligent Test Detection
- Tests current file by extracting filename
- Tests specific functions using treesitter to find function names
- All test output displayed in floating windows with colored output

### LSP Enhancements
Standard LSP features work with rustaceanvim:
- `gd` - Go to definition with custom preview
- `gr` - Find references (opens in quickfix)
- `<leader>ca` - Code actions
- `<leader>cr` - Rename
- `gy` - Type definition
- `gI` - Implementation

## Tips & Tricks

### Quick Type Info
Hover over any symbol and press `K` to see type information and documentation.

### Macro Expansion
Confused by a macro? Place cursor on it and press `<leader>drse` to see the expanded code.

### Smart Joins
Use `<leader>drsj` to join lines intelligently, preserving Rust syntax rules.

### Test Output
Test output windows can be:
- Scrolled with mouse or `<C-d>`/`<C-u>`
- Closed with `q` or `<Esc>`
- Resized by dragging borders

### Workspace Support
rustaceanvim automatically detects and handles Cargo workspaces:
- Member crate detection
- Cross-crate navigation
- Workspace-wide operations

## Troubleshooting

### rust-analyzer not starting
```vim
:LspInfo          " Check if rust-analyzer is running
:LspLog           " View error logs
:Mason            " Reinstall rust-analyzer
```

### Tests not running
- Ensure you're in a Cargo project: check for `Cargo.toml`
- Check for compilation errors: `<leader>drsk`
- Verify test module structure: `#[cfg(test)]`

### Debugging not working
```vim
:checkhealth      " Check overall health
:Mason            " View/update Mason packages (codelldb is auto-installed)
```

CodeLLDB paths on macOS:
- Adapter: `~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb`
- LLDB library: `~/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib`

### Clippy not available
```bash
rustup component add clippy
```

## Configuration

The Rust setup is in `lua/plugins/rust.lua`. Key settings:
- Plugin: mrcjkb/rustaceanvim (loaded for Rust files only)
- Format on save: enabled via conform.nvim
- Clippy: enabled for check command with all warnings
- Features: all cargo features enabled by default
- Proc macros: enabled
- Hover actions: rounded borders

---
[← Back to Python Development](python.md) | [Shell Scripting →](shell.md)