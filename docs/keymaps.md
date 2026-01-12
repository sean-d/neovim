# Key Mappings

Complete keybinding reference for this Neovim configuration.

> **Leader key**: `<Space>`

## Table of Contents
- [Essential Navigation](#essential-navigation)
- [Window Management](#window-management)
- [File Operations](#file-operations)
- [Code Navigation](#code-navigation)
- [Text Editing](#text-editing)
- [Development](#development)
- [Git Integration](#git-integration)
- [Terminal](#terminal)
- [Special Features](#special-features)
- [Utilities & Toggles](#utilities--toggles)

## Essential Navigation

### Buffer Management
| Key | Description |
|-----|-------------|
| `<leader><leader>` | Switch buffers (double tap space) |
| `<leader>/` | Search in project (grep) |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete other buffers (keep current only) |
| `<leader>ba` | Delete all buffers |
| `<leader>bD` | Delete multiple buffers interactively |
| `<leader>bb` | Switch to last buffer |
| `<leader>bl` | Pick buffer (shows letters for quick jump) |
| `<leader>bp` | Pin/unpin current buffer |
| `<leader>bP` | Close other buffers |
| `<leader>bc` | Pick buffer to close |
| `<leader>br` | Reload bufferline config |
| `[b` / `]b` | Previous/next buffer |
| `<S-h>` / `<S-l>` | Previous/next buffer (alternative) |
| `<A-h>` / `<A-l>` | Move buffer left/right (reorder) |
| Mouse drag | Drag tabs to reorder |
| Left click | Switch to buffer |
| Right click | Close buffer |

### File Navigation
| Key | Description |
|-----|-------------|
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files in project |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fc` | Find config files |
| `<leader>fF` | Find files (from cwd) |

### Dashboard (Start Screen)
| Key | Description |
|-----|-------------|
| `f` | Find file |
| `n` | New file |
| `g` | Find text (grep) |
| `r` | Recent files |
| `c` | Config files |
| `L` | Lazy plugin manager |
| `q` | Quit |
| `h` | Help (README in Neovim) |
| `H` | Help (README in browser) |

## Window Management

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>w-` | Split window horizontally |
| `<leader>w\|` | Split window vertically |
| `<leader>wd` | Close window |

### Tmux Integration
If using tmux, `<C-h/j/k/l>` seamlessly navigates between Neovim windows and tmux panes.

## File Operations

### File Explorer
| Key | Description |
|-----|-------------|
| `<leader>e` | Toggle file explorer |
| `j`/`k` | Navigate up/down |
| `<Enter>` | Open file/folder |
| `h` | Collapse folder |
| `l` | Expand folder |
| `/` | Jump to search/filter |
| `<Esc>` | Exit search, return to tree |
| `a` | Create new file/folder |
| `d` | Delete file/folder |
| `r` | Rename file/folder |
| `y` | Copy file/folder |
| `x` | Cut file/folder |
| `p` | Paste file/folder |
| `q` | Close explorer |

### File Management
| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Browse buffers |
| `<leader>fc` | Find config files |
| `<leader>?` | Show keybindings (which-key) |

### Harpoon (Quick File Navigation)
| Key | Description |
|-----|-------------|
| `<leader>ha` | Add current file to Harpoon |
| `<leader>hh` | Toggle Harpoon menu |
| `<leader>1-5` | Jump to Harpoon file 1-5 |
| `[h` / `]h` | Previous/next Harpoon file |

**In Harpoon menu**: Use `d` to delete entries

## Code Navigation

### LSP Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition (custom preview window) |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation (custom modal) |
| `gK` | Signature help |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file |
| `<leader>cd` | Line diagnostics |
| `<leader>ss` | LSP symbols |
| `[d` / `]d` | Previous/next diagnostic |

### Code Actions & Docker
| Key | Description |
|-----|-------------|
| `<leader>cdi` | Docker Info 📊 |
| `<leader>cdb` | Build Docker image 🔨 |
| `<leader>cds` | Start Docker container 🐳 |
| `<leader>cda` | Attach to Docker container 🔗 |
| `<leader>cdA` | Attach to Docker container (floating window) 🪟 |
| `<leader>cdx` | Stop Docker container 🛑 |
| `<leader>cdl` | Show Docker logs 📋 (Use `<C-c>` to stop following, then `<C-q>`, `<Esc>` or `q` to close) |
| `<leader>cdd` | Open LazyDocker 🐳 |
| `<leader>cR` | Rename file |

### Code Outline
| Key | Description |
|-----|-------------|
| `<leader>co` | Toggle code outline |
| `<CR>` | Jump to symbol |
| `o` | Preview symbol (stay in outline) |
| `K` | Toggle preview window |
| `h`/`l` | Fold/unfold section |
| `<Tab>` | Toggle fold |
| `<S-Tab>` | Toggle all folds |
| `q` or `<Esc>` | Close outline |
| `?` | Show help |

### Trouble (Code Issues & Navigation)
| Key | Description |
|-----|-------------|
| `<leader>cxx` | Toggle trouble (all diagnostics) |
| `<leader>cxX` | Buffer diagnostics only |
| `<leader>cxs` | Document symbols |
| `<leader>cxl` | LSP references/definitions |
| `<leader>cxq` | Quickfix list |
| `<leader>cxL` | Location list |
| `<leader>cxt` | Todo comments |
| `]t` | Next todo comment |
| `[t` | Previous todo comment |

### Code Folding
| Key | Description |
|-----|-------------|
| `za` | Toggle fold under cursor |
| `zc` | Close fold under cursor |
| `zo` | Open fold under cursor |
| `zM` | Close ALL folds in file |
| `zR` | Open ALL folds in file |
| `zm` | Increase fold level (close more) |
| `zr` | Decrease fold level (open more) |
| `zp` | Peek folded content without opening |

## Text Editing

### Basic Editing
| Key | Description |
|-----|-------------|
| `gcc` | Comment/uncomment line |
| `gc` | Comment/uncomment selection (visual mode) |
| `<leader><leader>s` | Source/reload current file |

### Surround Operations
| Key | Description |
|-----|-------------|
| `sa` | Add surrounding (e.g., `saiw"` adds quotes around word) |
| `sd` | Delete surrounding (e.g., `sd"` deletes quotes) |
| `sr` | Replace surrounding (e.g., `sr"'` changes " to ') |
| `sf` | Find surrounding to the right |
| `sF` | Find surrounding to the left |
| `sh` | Highlight surrounding |

### Flash Navigation (Lightning-fast jumps)
| Key | Description |
|-----|-------------|
| `/` | Standard Vim search with Flash enhancements |
| `s` | Flash jump (type 2+ chars for jump labels) |
| `S` | Flash jump to Treesitter nodes |
| `f/F/t/T` | Enhanced f/F/t/T motions with Flash |
| `;` / `,` | Repeat last f/F/t/T motion |
| `r` | Remote Flash (operator mode) |
| `R` | Treesitter search (operator/visual mode) |
| `<C-s>` | Toggle Flash during search |

### Picker Navigation
| Key | Description |
|-----|-------------|
| `<C-f>` | Toggle focus between list and preview |
| `<C-p>` | Scroll preview up |
| `<C-n>` | Scroll preview down |
| `<Enter>` | Open selected file |
| `<Esc>` | Close picker |

## Development

### Go Development (`<leader>dgo`)
| Key | Description |
|-----|-------------|
| `<leader>dgot` | Test current file |
| `<leader>dgoT` | Test current function |
| `<leader>dgoa` | Test all |
| `<leader>dgoc` | Show test coverage |
| `<leader>dgoC` | Clear test coverage |
| `<leader>dgof` | Format check (shows diff) |
| `<leader>dgov` | Run go vet |
| `<leader>dgob` | Build project |
| `<leader>dgoi` | Organize imports |
| `<leader>dgom` | Run go mod tidy |
| `<leader>dgod` | Show Go documentation |
| `<leader>dgoD` | Start debugger |
| `<leader>dgox` | Stop debugger |
| `<leader>dgoX` | Debug current test |

### JavaScript/TypeScript Development (`<leader>djs`)
| Key | Description |
|-----|-------------|
| `<leader>djsr` | Run current file |
| `<leader>djsf` | Format file |
| `<leader>djsl` | Lint with ESLint |
| `<leader>djsi` | Install dependencies |
| `<leader>djsb` | Build project |
| `<leader>djsd` | Start dev server |
| `<leader>djsp` | Preview production build |
| `<leader>djsa` | Test all |
| `<leader>djst` | Test current file |
| `<leader>djsT` | Test current function |
| `<leader>djse` | Start Electron app |
| `<leader>djsD` | Debug current file |
| `<leader>djsA` | Attach debugger |

### PHP Development (`<leader>dph`)
| Key | Description |
|-----|-------------|
| `<leader>dphs` | Syntax check |
| `<leader>dphr` | Run current file |
| `<leader>dpht` | Run PHPUnit tests |
| `<leader>dphw` | Check WordPress standards |
| `<leader>dphi` | Interactive shell |
| `<leader>dphp` | WP-CLI interface |
| `<leader>dphf` | Format file |
| `<leader>dphD` | Debug current file |
| `<leader>dphci` | Composer install |
| `<leader>dphcu` | Composer update |
| `<leader>dphcr` | Composer require |

### PowerShell Development (`<leader>dps`)
| Key | Description |
|-----|-------------|
| `<leader>dpsr` | Run script |
| `<leader>dpsc` | Analyze with PSScriptAnalyzer |
| `<leader>dpsf` | Format file |
| `<leader>dpsi` | Run interactive |
| `<leader>dpsd` | Debug run |
| `<leader>dpsh` | Get help for word |
| `<leader>dpsm` | List modules |
| `<leader>dpst` | Run Pester tests |
| `<leader>dpsS` | Check syntax |

### Python Development (`<leader>dpy`)
| Key | Description |
|-----|-------------|
| `<leader>dpyr` | Run file |
| `<leader>dpyt` | Test file |
| `<leader>dpyT` | Test function |
| `<leader>dpya` | Test all |
| `<leader>dpyc` | Coverage report |
| `<leader>dpym` | Type check (mypy) |
| `<leader>dpyl` | Lint (ruff) |
| `<leader>dpyf` | Format file |
| `<leader>dpyi` | Interactive REPL |
| `<leader>dpyu` | UV add package |
| `<leader>dpyU` | UV add dev package |
| `<leader>dpys` | UV sync |
| `<leader>dpyp` | List packages |
| `<leader>dpyd` | Django manage.py |
| `<leader>dpyD` | Start debugger |

### Rust Development (`<leader>drs`)
| Key | Description |
|-----|-------------|
| `<leader>drst` | Test current file |
| `<leader>drsT` | Test current function |
| `<leader>drsa` | Test all |
| `<leader>drsc` | Clippy check |
| `<leader>drsf` | Format check (shows diff) |
| `<leader>drsb` | Build project (debug) |
| `<leader>drsB` | Build release |
| `<leader>drsk` | Check (fast type check) |
| `<leader>drsr` | Run project |
| `<leader>drsR` | Show runnable targets |
| `<leader>drse` | Expand macro |
| `<leader>drsm` | Rebuild proc macros |
| `<leader>drsp` | Go to parent module |
| `<leader>drsj` | Join lines (smart) |
| `<leader>drsu` | Update dependencies |
| `<leader>drsC` | Open Cargo.toml |
| `<leader>drso` | Clean build artifacts |
| `<leader>drsd` | Generate documentation |
| `<leader>drsh` | Open docs.rs for crate |
| `<leader>drsD` | Show debug targets |
| `<leader>drsx` | Debug current target |
| `<leader>drsi` | View MIR (Mid-level IR) |
| `<leader>drsI` | View HIR (High-level IR) |

### Shell Development (`<leader>dzs`)
| Key | Description |
|-----|-------------|
| `<leader>dzsr` | Run script |
| `<leader>dzsc` | Check with shellcheck |
| `<leader>dzsx` | Make executable (chmod +x) |
| `<leader>dzsf` | Format with shfmt |
| `<leader>dzsd` | Debug run (bash -x) |

### Debugging (DAP)
| Key | Description |
|-----|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle debug UI |
| `<leader>de` | Evaluate expression |

### Scratch Buffers (Notes/Experiments)
| Key | Description |
|-----|-------------|
| `<leader>xn` | New scratch buffer (prompts for name) |
| `<leader>xa` | All scratch buffers (browse/select) |
| `<leader>xx` | Open last used scratch buffer |

**In scratch buffer list**: Use `d` to delete, `<Enter>` to open

## Git Integration

### Git Commands
| Key | Description |
|-----|-------------|
| `<leader>gg` | Open Lazygit |
| `<leader>gf` | Lazygit file history |
| `<leader>gl` | Lazygit log (cwd) |
| `<leader>gb` | Git blame current line |
| `<leader>gB` | Open in Git browser |

### Git Hunks
| Key | Description |
|-----|-------------|
| `<leader>ghs` | Stage hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghr` | Reset hunk |
| `<leader>ghR` | Reset buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line (full) |
| `<leader>ghB` | Blame buffer |
| `<leader>ghd` | Diff this |
| `<leader>ghD` | Diff this ~ |
| `]h` / `[h` | Next/previous git hunk |

### Lazygit Navigation (when open)
| Key | Description |
|-----|-------------|
| `Tab` | Next section |
| `Shift+Tab` | Previous section |
| `1-5` | Jump to section |
| `h/l` or `←/→` | Navigate tabs |
| `j/k` or `↑/↓` | Navigate items |
| `Enter` | Select/expand item |
| `?` | Show help |
| `x` | Open command menu |
| `q` | Quit Lazygit |

## REST API Testing

| Key | Description |
|-----|-------------|
| `<leader>rr` | Send REST request |
| `<leader>ra` | Run all requests |
| `<leader>rp` | Replay last request |
| `<leader>rq` | Close response |
| `<leader>rc` | Copy as curl |
| `<leader>ri` | Import from curl |
| `<leader>rs` | Open REST scratchpad |
| `<leader>re` | Select environment |
| `<leader>rv` | Show request stats |

**Note**: Use `.http` or `.rest` files for REST API testing.

## Terminal

| Key | Description |
|-----|-------------|
| `<leader>tt` | Toggle floating terminal |
| `<leader>tf` | New floating terminal |
| `<leader>th` | Terminal split below |
| `<leader>tv` | Terminal split right |
| `<C-q>` | Hide terminal (while in terminal) |

## Special Features

### Markdown
| Key | Description |
|-----|-------------|
| `<leader>mp` | Toggle markdown preview in browser |
| `<leader>mi` | Paste image from clipboard |
| `<leader>mc` | Toggle checkbox [ ] ↔ [x] |
| `<Tab>` | Indent list item |
| `<S-Tab>` | Outdent list item |
| `<CR>` | Continue list on new line |

### Treesitter Context
| Key | Description |
|-----|-------------|
| `<leader>tc` | Toggle treesitter context |
| `[c` | Jump to context (current function/class) |

### Search
| Key | Description |
|-----|-------------|
| `<leader>s"` | Search registers |
| `<leader>sa` | Search autocmds |
| `<leader>sc` | Search command history |
| `<leader>sC` | Search commands (Command Palette) |
| `<leader>sd` | Search diagnostics |
| `<leader>sh` | Search help pages |
| `<leader>sH` | Search highlights |
| `<leader>sj` | Search jumps |
| `<leader>sk` | Search keymaps |
| `<leader>sl` | Search location list |
| `<leader>sM` | Search man pages |
| `<leader>sm` | Search marks |
| `<leader>sR` | Resume last search |
| `<leader>sq` | Search quickfix list |

## Session Management

| Key | Description |
|-----|-------------|
| `<leader>Ss` | Save current session |
| `<leader>Sr` | Restore session for current directory |
| `<leader>Sd` | Delete current session |
| `<leader>SD` | Delete orphaned sessions |
| `<leader>Sl` | Search/list all sessions |
| `<leader>St` | Toggle auto-save |

**Note**: Sessions are saved per directory and auto-save every 30 seconds.

## Database Operations

| Key | Description |
|-----|-------------|
| `<leader>Dt` | Toggle database UI 🗄️ |
| `<leader>Da` | Add database connection 🔌 |
| `<leader>Df` | Find database buffer 🔍 |

**In Database UI**:
- `o` or `Enter` - Open/expand item
- `d` - Delete buffer/query
- `A` - Add connection
- `q` - Close UI

## Utilities & Toggles

| Key | Description |
|-----|-------------|
| `<leader>ub` | Toggle bufferline visibility (hidden by default) |
| `<leader>ud` | Toggle diagnostics |
| `<leader>ul` | Toggle line numbers |
| `<leader>uL` | Toggle relative line numbers |
| `<leader>us` | Toggle spelling |
| `<leader>uT` | Toggle treesitter |
| `<leader>uh` | Toggle inlay hints |
| `<leader>uC` | Browse colorschemes |
| `<leader>un` | Dismiss all notifications |
| `<leader>n` | Show notification history |

## Tips

1. **Which-key**: Press `<leader>` and wait to see available commands
2. **Flash Jump**: Press `s` + 2 characters to jump anywhere visible
3. **Quick Search**: Use `/` for normal search, `s` for quick jumps
4. **Buffer Pinning**: Pin important buffers with `<leader>bp`
5. **Harpoon**: Use for frequently accessed files in a project
6. **Scratch Buffers**: Great for temporary notes, all markdown-enabled

---
[← Back to Installed Plugins](plugins.md)