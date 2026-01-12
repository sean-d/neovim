# Navigation

Master file navigation and movement in this Neovim configuration.

## Table of Contents
- [File Finding](#file-finding)
- [File Explorer](#file-explorer)
- [Buffer Navigation](#buffer-navigation)
- [Quick Navigation with Harpoon](#quick-navigation-with-harpoon)
- [Flash Navigation](#flash-navigation)
- [Code Navigation](#code-navigation)
- [Search & Replace](#search--replace)

## File Finding

### Fuzzy Finding with Snacks.picker

The configuration uses snacks.picker for all fuzzy finding needs.

| Key | Description |
|-----|-------------|
| `<leader><leader>` | Switch buffers (double tap space) |
| `<leader>ff` | Find files in project |
| `<leader>fg` | Find git files only |
| `<leader>fr` | Recent files |
| `<leader>/` | Search text in project (grep) |
| `<leader>fb` | Browse open buffers |
| `<leader>fc` | Find config files |

### Picker Controls
When in picker:
- Type to filter results
- `<C-p>`/`<C-n>` - Navigate up/down
- `<C-f>` - Toggle preview focus
- `<Enter>` - Open file
- `<C-v>` - Open in vertical split
- `<C-x>` - Open in horizontal split
- `<C-t>` - Open in new tab
- `<Esc>` - Cancel

### Search Tips
- Use spaces for fuzzy matching: `user controller` finds `UserController.go`
- Start with `'` for exact matching: `'exact phrase`
- Use `!` to exclude: `controller !test` finds controllers but not tests

## File Explorer

### Basic Navigation
| Key | Description |
|-----|-------------|
| `<leader>e` | Toggle explorer |
| `j`/`k` | Move down/up |
| `h`/`l` | Collapse/expand folders |
| `<Enter>` | Open file/folder |
| `/` | Search in explorer |
| `<Esc>` | Exit search mode |

### File Operations
| Key | Description |
|-----|-------------|
| `a` | Add file/folder (end with `/` for folder) |
| `d` | Delete |
| `r` | Rename |
| `y` | Copy |
| `x` | Cut |
| `p` | Paste |

### Explorer Features
- Shows git status with colors
- Icons for file types
- Hidden files shown by default (dotfiles visible)
- Automatic refresh on file system changes
- Rounded border style
- Opens on the left side (width 30)

## Buffer Navigation

### Bufferline Features
Bufferline is **hidden by default** to keep the interface clean. Enable it with `<leader>ub` when you need visual buffer tabs.

When enabled, buffers appear as tabs at the top with:
- File type icons
- Modified indicators `[+]`
- Diagnostic counts
- Git status colors
- Automatic grouping by type

### Buffer Commands
| Key | Description |
|-----|-------------|
| `<leader><leader>` | Quick buffer switcher |
| `<S-h>`/`<S-l>` | Previous/next buffer |
| `[b`/`]b` | Previous/next buffer (alternative) |
| `<A-h>`/`<A-l>` | Move buffer left/right |
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>ba` | Delete all buffers |
| `<leader>bb` | Switch to last buffer |

### Interactive Buffer Management
| Key | Description |
|-----|-------------|
| `<leader>bD` | Delete buffers interactively |
| `<leader>bl` | Pick buffer with letter hints |
| `<leader>bc` | Pick buffer to close |

### Buffer Pinning
| Key | Description |
|-----|-------------|
| `<leader>bp` | Pin/unpin buffer |
| `<leader>bP` | Close all unpinned buffers |

Pinned buffers:
- Stay in place when reordering
- Survive "close others" commands
- Show a pin icon 📌

## Quick Navigation with Harpoon

Harpoon provides blazing-fast navigation between frequently used files.

### Setting Up Harpoon
| Key | Description |
|-----|-------------|
| `<leader>ha` | Add current file to Harpoon |
| `<leader>hh` | Open Harpoon menu |

### Using Harpoon
| Key | Description |
|-----|-------------|
| `<leader>1-5` | Jump to Harpoon file 1-5 |
| `[h`/`]h` | Cycle through Harpoon files |

In Harpoon menu:
- `<CR>` - Jump to file
- `d` - Remove from list
- `q` - Close menu

### Harpoon Tips
- Marks are project-specific (based on working directory)
- Persist between sessions
- Great for main files you're actively working on
- Limited to 5-10 files for efficiency

## Flash Navigation

Lightning-fast cursor movement anywhere visible.

### Basic Flash
| Key | Description |
|-----|-------------|
| `s` | Start Flash jump (2+ chars) |
| `S` | Flash to Treesitter nodes |
| `/` | Enhanced search with Flash |

### How Flash Works
1. Press `s`
2. Type 2+ characters of target
3. Jump labels appear
4. Press label key to jump

### Enhanced Motions
| Key | Description |
|-----|-------------|
| `f`/`F` | Enhanced find forward/backward |
| `t`/`T` | Enhanced till forward/backward |
| `;`/`,` | Repeat last f/F/t/T |

### Flash Modes
- **Jump Mode** (`s`) - Jump anywhere
- **Treesitter Mode** (`S`) - Jump to code structures
- **Search Mode** (`/`) - Standard search enhanced
- **Remote Mode** (`r`) - Operate on remote text

## Code Navigation

### Symbol Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition (preview) |
| `gr` | Find references |
| `gy` | Go to type definition |
| `<leader>ss` | Search symbols |

### Code Outline
| Key | Description |
|-----|-------------|
| `<leader>co` | Toggle outline |
| `<C-w>l` | Focus outline window |

In outline:
- `<CR>` - Jump to symbol
- `o` - Preview (stay in outline)
- `<Tab>` - Toggle fold
- Tree navigation with `h`/`j`/`k`/`l`

### Jump Lists
| Key | Description |
|-----|-------------|
| `<C-o>` | Jump back |
| `<C-i>` | Jump forward |
| `:jumps` | Show jump list |

### Marks
| Key | Description |
|-----|-------------|
| `ma` | Set mark 'a' |
| `'a` | Jump to mark 'a' |
| `:marks` | Show all marks |

## Search & Replace

### Project-wide Search
| Key | Description |
|-----|-------------|
| `<leader>/` | Search in project |
| `<leader>sw` | Search word under cursor |
| `<leader>sW` | Search WORD under cursor |

### Search Commands
| Key | Description |
|-----|-------------|
| `<leader>sR` | Resume last search |
| `<leader>sb` | Search current buffer lines |
| `<leader>sB` | Search all open buffers |
| `<leader>sg` | Grep files (alternative) |
| `<leader>sG` | Grep from current directory |
| `<leader>s"` | Search registers |
| `<leader>sa` | Search autocmds |
| `<leader>sc` | Search command history |
| `<leader>sC` | Search commands |
| `<leader>sd` | Search diagnostics |
| `<leader>sh` | Search help pages |
| `<leader>sH` | Search highlights |
| `<leader>sj` | Search jump list |
| `<leader>sk` | Search keymaps |
| `<leader>sl` | Search location list |
| `<leader>sM` | Search man pages |
| `<leader>sm` | Search marks |
| `<leader>sq` | Search quickfix list |
| `q/` | Search history window |

### Quick Fix Navigation
After search results:
| Key | Description |
|-----|-------------|
| `:cn` | Next result |
| `:cp` | Previous result |
| `:cc` | Current result |
| `:copen` | Open quickfix |

## Navigation Tips

### Efficient Workflow
1. Use Harpoon for core files you're actively editing
2. Use Flash (`s`) for visible jumps
3. Use fuzzy finder for everything else
4. Pin important buffers to keep them accessible

### Speed Tips
- `<leader><space>` is fastest for known files
- `s` + 2 chars beats scrolling every time
- Harpoon + number keys for instant switching
- Recent files (`<leader>fr`) for previous work

### Organization
- Let bufferline group your files automatically
- Use explorer for understanding project structure
- Outline for navigating within large files
- Marks for specific code locations

---
[← Back to Customization Guide](customization.md) | [Git Integration →](git.md)