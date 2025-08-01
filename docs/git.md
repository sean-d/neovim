# Git Integration

Comprehensive Git integration with Lazygit, Gitsigns, and inline blame.

## Features

- **Lazygit Integration** - Full TUI git client in Neovim
- **Inline Blame** - See commit info without leaving editor
- **Gutter Signs** - Visual git status in sign column
- **Hunk Navigation** - Jump between changes
- **Stage/Reset** - Manage changes from editor
- **Diff Views** - See changes inline
- **Git Browser** - Open files in GitHub/GitLab

## Key Mappings

### Lazygit
| Key | Description |
|-----|-------------|
| `<leader>gg` | Open Lazygit |
| `<leader>gf` | File history in Lazygit |
| `<leader>gl` | Git log for current directory |
| `<leader>gb` | Git blame current line |
| `<leader>gB` | Open in Git browser |

### Gitsigns (Hunks)
| Key | Description |
|-----|-------------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghR` | Reset buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line (full) |
| `<leader>ghB` | Blame buffer |
| `<leader>ghd` | Diff this |
| `<leader>ghD` | Diff this ~ |

## Lazygit

### Overview
Lazygit provides a complete Git interface within Neovim:
- Stage/unstage files
- Commit with message
- Push/pull/fetch
- Branch management
- Merge/rebase
- Stash changes
- View history

### Navigation in Lazygit
| Key | Description |
|-----|-------------|
| `Tab` | Next section |
| `Shift+Tab` | Previous section |
| `1-5` | Jump to section (Status/Files/Branches/Commits/Stash) |
| `h`/`l` | Switch tabs in section |
| `j`/`k` | Navigate items |
| `Enter` | Select/expand |
| `Space` | Stage/unstage |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `?` | Help |
| `q` | Quit |

### Common Workflows

#### Quick Commit
1. `<leader>gg` - Open Lazygit
2. `Space` - Stage files
3. `c` - Commit
4. Type message and confirm
5. `p` - Push changes

#### Branch Management
1. `<leader>gg` - Open Lazygit
2. `3` - Jump to branches
3. `n` - New branch
4. Enter name
5. `Space` - Checkout

#### Stashing
1. `<leader>gg` - Open Lazygit
2. `s` - Stash changes
3. Enter stash message
4. `5` - View stashes
5. `Space` - Apply stash

### Customization
Lazygit uses a pink border theme matching the Neovim config.

## Gitsigns

### Visual Indicators
The sign column shows:
- `▎` - Added lines (green)
- `▎` - Changed lines (yellow)
- `▎` - Removed lines (red)
- `▎` - Top delete (red)
- `▎` - Untracked files (gray)

Signs also show for staged changes with different colors.

### Inline Blame
After 1 second of inactivity, see:
- Commit author
- Commit date (relative)
- Commit message
- All in pink text (#f4b8e4) at end of line

### Hunk Operations

#### Navigate Changes
```vim
]h  " Next change
[h  " Previous change
```

#### Stage/Unstage
```vim
<leader>ghs  " Stage hunk under cursor
<leader>ghr  " Reset hunk under cursor
<leader>ghS  " Stage entire file
<leader>ghR  " Reset entire file
```

#### Preview Changes
```vim
<leader>ghp  " Preview hunk in floating window
<leader>ghd  " Diff against index
```

### Virtual Text
Blame information appears as virtual text:
```go
func main() {  // John Doe, 2 days ago: Add main function
```

## Git Browser Integration

`<leader>gB` opens the current file in:
- GitHub
- GitLab  
- Bitbucket
- Custom git hosts

Opens at the current line number with permalink to commit.

## Advanced Features

### Diff View
View changes side-by-side:
```vim
:Gitsigns diffthis              " Diff against index
:Gitsigns diffthis ~1           " Diff against previous commit
:Gitsigns toggle_word_diff      " Word-level diff
```

### Blame View
Full blame information:
```vim
:Gitsigns blame_line            " Blame current line
:Gitsigns toggle_current_line_blame  " Toggle auto blame
```

### Text Objects
Git hunks as text objects:
- `ih` - Inner hunk
- `ah` - Around hunk

Use with operations:
```vim
yih  " Yank hunk
dih  " Delete hunk
vih  " Select hunk
```

## Integration with Other Features

### Bufferline
Git status shown in buffer tabs:
- Green: New/modified files
- Yellow: Unstaged changes
- Red: Merge conflicts

### Status Line
Current branch shown in statusline.

### File Explorer
Git status indicators:
- `M` - Modified
- `A` - Added
- `D` - Deleted
- `?` - Untracked

## Configuration

### Settings Location
- Gitsigns: `lua/plugins/editor.lua`
- Lazygit: `lua/plugins/snacks.lua`

### Custom Commands
Add git aliases:
```lua
vim.cmd("command! -nargs=0 Gpush :!git push")
vim.cmd("command! -nargs=0 Gpull :!git pull")
```

## Tips & Tricks

### Quick Status Check
`<leader>gg` gives instant repository overview.

### Selective Staging
In Lazygit:
1. Navigate to file
2. `Enter` to see diff
3. `Space` on specific lines to stage

### Undo Last Commit
In Lazygit:
1. Go to commits (`4`)
2. Navigate to last commit
3. `g` for reset options
4. Choose soft reset

### Interactive Rebase
1. In commits section
2. Navigate to target commit
3. `e` to start interactive rebase
4. Reorder, squash, edit as needed

### Conflict Resolution
When in conflict:
1. `<leader>gg` to see conflicts
2. Navigate to file
3. `Enter` to open
4. Use Neovim to resolve
5. Stage resolved file

## Troubleshooting

### Lazygit not opening
```bash
# Check installation
lazygit --version

# Reinstall
brew install lazygit  # macOS
```

### Gitsigns not showing
```vim
:Gitsigns toggle_signs     " Toggle signs
:Gitsigns refresh          " Force refresh
:checkhealth gitsigns      " Check setup
```

### Blame not appearing
- Check delay setting (default 1000ms)
- Ensure file is in git repository
- Verify not in .gitignore

---
[← Back to Navigation](navigation.md) | [Docker Integration →](development/docker.md)