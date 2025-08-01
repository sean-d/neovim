# Dashboard Customization

The startup dashboard provides quick access to common actions with custom ASCII art.

## Features

- **ASCII Art** - Custom sloth artwork in Catppuccin colors
- **Quick Actions** - Single-key shortcuts to common tasks
- **Recent Files** - Jump back into recent work
- **Projects** - Quick project switching
- **Stats** - Startup time display

## Key Shortcuts

When on the dashboard, single keys trigger actions:

| Key | Action | Description |
|-----|--------|-------------|
| `f` | Find File | Open file picker |
| `n` | New File | Create new buffer |
| `g` | Find Text | Search across project |
| `r` | Recent Files | Open recent file list |
| `c` | Config | Browse config files |
| `L` | Lazy | Open plugin manager |
| `h` | Help | Open README in Neovim |
| `H` | Help (Browser) | Open README in browser |
| `q` | Quit | Exit Neovim |

## Visual Design

### ASCII Art
The dashboard features a custom sloth design:
- Displayed in Catppuccin purple (`#cba6f7`)
- Centered on screen
- Maintains aspect ratio on resize

### Color Scheme
- **Header** - Purple (`#cba6f7`)
- **Keys** - Pink (`#f5c2e7`)
- **Descriptions** - Lavender (`#b4befe`)
- **Icons** - Matched to actions

### Layout
```
     [ASCII ART]
     
      Find File        f
      New File         n
      Find Text        g
      Recent Files     r
      Config           c
      Lazy             L
      Quit             q
      Help (README)    h
      Help (Browser)   H
    
    Recent Files:
    • file1.go
    • file2.lua
    
    Projects:
    • ~/projects/app1
    • ~/projects/app2
```

## Configuration

Located in `lua/plugins/snacks.lua`:

### Customizing ASCII Art
```lua
header = [[
  -- Your ASCII art here
]]
```

### Adding Shortcuts
```lua
keys = {
  { icon = "icon", key = "x", desc = "Description", action = ":YourCommand" },
}
```

### Sections
Control what appears:
```lua
sections = {
  { section = "header" },
  { section = "keys", indent = 2 },
  { section = "recent_files", indent = 2 },
  { section = "projects", indent = 2 },
  { section = "startup" },
}
```

## Recent Files

Shows recent edited files:
- Path displayed relative to current directory
- Click to open
- Managed by Snacks picker

## Projects

Automatically detects projects by:
- Git repositories
- Root markers (package.json, go.mod, etc.)
- Previously opened projects

## Startup Stats

Shows at bottom:
- Total startup time in milliseconds

## Tips

### Quick Start
1. Launch Neovim without file: `nvim`
2. Press single key for action
3. No need for leader key on dashboard

### Custom Actions
Add your own shortcuts:
```lua
{ 
  icon = "📝", 
  key = "j", 
  desc = "Journal", 
  action = function()
    -- Create today's journal entry
    vim.cmd("edit ~/journal/" .. os.date("%Y-%m-%d") .. ".md")
  end 
}
```

### Hiding Dashboard
Open any file to dismiss dashboard.
Dashboard appears automatically when all buffers are closed.

### Performance
Dashboard lazy-loads:
- No impact on file opening
- Instant display
- Cached recent files

## Troubleshooting

### Dashboard not showing
- Check launching without file argument
- Verify snacks.nvim enabled
- Run `:checkhealth snacks`

### Missing colors
- Ensure colorscheme loaded first
- Check highlight groups defined
- Try `:Lazy reload snacks.nvim`

### Recent files empty
- Files save to history after editing
- Check file permissions
- Verify not in private/temp directory

### Known Issues
- Filetype detection may need fixing when opening files from dashboard
- Auto-handled by autocmd in configuration

---
[← Back to UI Overview](index.md) | [Theme →](theme.md)
