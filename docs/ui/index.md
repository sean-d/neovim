# UI Customization

Overview of UI customization options and visual enhancements.

## Visual Components

- **[Theme & Colors](theme.md)** - Catppuccin colorscheme with custom highlights
- **[Dashboard](dashboard.md)** - Startup screen with ASCII art and quick actions
- **[Status Line](statusline.md)** - Lualine configuration
- **[Buffer Line](bufferline.md)** - Tab-like buffer display with groups

## Visual Enhancements

### Inline Information
- **Git Blame** - Author and commit info at end of lines (#f4b8e4 pink) after 1 second
- **Diagnostics** - Error/warning counts in bufferline
- **LSP Progress** - Loading indicators via Fidget.nvim
- **Virtual Text** - Inline debugging values during debug sessions
- **Language Versions** - Python, Go, Node.js, Rust versions in statusline
- **Docker Status** - Container status indicator in statusline

### Highlighting
- **Active Indent** - Current scope highlighted in mauve
- **Cursor Column** - Vertical line at cursor position
- **Color Codes** - Hex/RGB values shown with actual colors
- **Git Changes** - Modified lines marked in gutter

### Animations
- **Smooth Scrolling** - Cursor stays centered while scrolling (stay-centered.nvim)
- **Indent Animation** - Smooth transitions for indent highlights (25ms animation)

## Color Scheme

Using Catppuccin Macchiato with customizations:
- **Background** - Darker (using Mocha's background)
- **Pink Accents** - `#f5c2e7` for borders and highlights
- **Mauve Elements** - `#ca9ee6` for special UI elements
- **Consistent Palette** - Matching colors across all UI elements

## Window Borders

All floating windows use consistent styling:
- **Rounded Borders** - Smooth corners
- **Pink Color** - #f5c2e7 accent color
- **Centered Titles** - Clean header display
- **Improved UI** - Enhanced select/input via dressing.nvim

## Typography

### Fonts
Requires a Nerd Font for icons:
- File type icons
- Git status symbols
- Diagnostic indicators
- Fold markers

### Text Rendering
- **Bold Headers** - Markdown headers stand out
- **Italic Comments** - Subtle comment styling
- **Syntax Highlighting** - Treesitter-based colors

## Customization

### Changing Colors
Edit `lua/plugins/colorscheme.lua`:
```lua
color_overrides = {
  macchiato = {
    -- Your color overrides
  }
}
```

### UI Element Colors
Key highlight groups:
- `FloatBorder` - Floating window borders
- `NormalFloat` - Floating window background
- `CursorLine` - Current line highlighting
- `Visual` - Visual selection

### Icon Customization
Icons provided by mini.icons, configurable in:
- File type associations
- Default icons
- Icon colors

## Tips

### Consistent Look
All UI elements follow the same design:
- Pink borders for floating windows
- Mauve accents for interactive elements
- Consistent spacing and padding

### Performance
Visual features are optimized:
- Lazy rendering for large files
- Debounced updates for git blame (1 second delay)
- Cached syntax highlighting
- Large file handling via Snacks.nvim bigfile feature

---
[← Back to Trouble - Code Issues & Navigation](../trouble.md) | [Theme →](theme.md) | [Dashboard →](dashboard.md)