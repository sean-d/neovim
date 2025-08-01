# Theme & Colors

This configuration uses Catppuccin Macchiato with custom enhancements for a cohesive visual experience.

## Color Scheme

### Base Theme
**Catppuccin Macchiato** - A soothing pastel theme with:
- Soft, eye-friendly colors
- High contrast for readability  
- Consistent color semantics

### Customizations
The theme has been modified with:
- **Darker Background** - Using Mocha's background colors for better contrast
- **Pink Accents** - `#f5c2e7` for borders and special highlights
- **Mauve Elements** - `#ca9ee6` for UI components

## Color Palette

### Primary Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Pink | `#f5c2e7` | Borders, highlights, special elements |
| Mauve | `#c6a0f6`, `#cba6f7`, `#ca9ee6` | Active elements, headers, indent guides |
| Lavender | `#b4befe` | Secondary text, descriptions |
| Blue | `#89b4fa` | Information, DAP log points |
| Green | `#a6e3a1` | Success, additions, DAP stopped |
| Red | `#f38ba8` | Errors, deletions, modified files |
| Yellow | `#f9e2af` | Warnings, Python venv |

### Background Colors
| Layer | Hex | Usage |
|-------|-----|-------|
| Base | `#1e1e2e` | Main background |
| Mantle | `#181825` | Darker areas |
| Crust | `#11111b` | Darkest elements |
| Surface0 | `#313244` | Overlays, floats |
| CursorColumn | `#363849` | Cursor column background |

## Syntax Highlighting

### Treesitter Groups
- **Functions** - Blue (`#89b4fa`)
- **Keywords** - Mauve
- **Strings** - Green (`#a6e3a1`)
- **Comments** - Italic only
- **Conditionals** - Italic only
- **Types** - Yellow (`#f9e2af`)
- **Variables** - Default text

### Language-Specific

#### Go
- **Package** - Pink
- **Imports** - Lavender  
- **Functions** - Blue
- **Types** - Yellow
- **Built-ins** - Red

#### Markdown
- **Headers** - Gradient from pink to green
- **Links** - Blue
- **Code** - Surface background
- **Quotes** - Muted italic

## UI Elements

### Floating Windows
All floating windows share:
```lua
FloatBorder = { fg = "#f5c2e7" }  -- Pink borders
NormalFloat = { link = "Normal" } -- Match background
```

### Status Elements
- **Git Added** - Green
- **Git Modified** - Yellow
- **Git Deleted** - Red
- **Diagnostics Error** - Red
- **Diagnostics Warn** - Yellow
- **Diagnostics Info** - Blue

### Special Highlights

#### Custom Groups
```lua
-- Dashboard
SnacksDashboardHeader = { fg = "#cba6f7" }
SnacksDashboardTitle = { fg = "#cba6f7", bold = true }
SnacksDashboardDesc = { fg = "#b4befe" }

-- Git
GitSignsCurrentLineBlame = { fg = "#f4b8e4" }

-- Navigation
HarpoonBorder = { fg = "#f5c2e7" }
WhichKeyBorder = { fg = "#ca9ee6" }

-- Indent
MiniIndentscopeSymbol = { fg = "#c6a0f6" }
IblIndent = { fg = "#494d64" }
IblScope = { fg = "#c6a0f6" }

-- Flash
FlashBackdrop = { fg = "#545c7e" }
FlashMatch = { bg = "#3e4451", fg = "#cdd6f4" }
FlashCurrent = { bg = "#45475a", fg = "#f5e0dc" }
FlashLabel = { bg = "#f5c2e7", fg = "#11111b", bold = true }

-- Debug
DapBreakpoint = { fg = "#f5c2e7" }
DapLogPoint = { fg = "#89b4fa" }
DapStopped = { fg = "#a6e3a1" }
DapStoppedLine = { bg = "#2e3440" }
```

## Inline Colors

The configuration includes nvim-colorizer for displaying colors inline:
- **Hex** - `#f5c2e7` shows as pink
- **RGB** - `rgb(245, 194, 231)` displays color
- **HSL** - `hsl(316, 70%, 86%)` with color
- **Named** - `red`, `blue`, etc.
- **Tailwind** - `bg-red-500` in Tailwind projects

## Configuration

### Changing Theme Flavor
In `lua/plugins/colorscheme.lua`:
```lua
opts = {
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "macchiato",
  },
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
  },
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
}
```

### Custom Colors
Override specific colors:
```lua
color_overrides = {
  macchiato = {
    base = "#1e1e2e",
    mantle = "#181825",
    -- Add more overrides
  }
}
```

### Integration Settings
```lua
integrations = {
  cmp = true,
  gitsigns = true,
  treesitter = true,
  notify = true,
  mini = {
    enabled = true,
    indentscope_color = "mauve",
  },
  snacks = true,
  which_key = true,
  nvimtree = false,
  telescope = false,
}
```

## Tips

### Creating Custom Highlights
```vim
:highlight MyGroup guifg=#f5c2e7 guibg=#1e1e2e gui=bold
```

### Checking Current Colors
```vim
:highlight                 " List all groups
:highlight MyGroup        " Check specific group
:Inspect                  " Check highlight under cursor
```

### Color Picker
Use `<leader>uC` to open the Catppuccin color picker (via Snacks).

### Applying to Plugins
Most plugins automatically use theme colors through integrations.
For custom plugins:
```lua
vim.api.nvim_set_hl(0, "PluginBorder", { link = "FloatBorder" })
```

## Accessibility

### High Contrast
The darker background provides better contrast than default Macchiato.

### Color Blind Support
- Semantic colors (red=error, green=success)
- Shapes and icons supplement colors
- Configurable diagnostic symbols

### Reduced Motion
- Minimal animations
- Optional cursor line
- Static indent guides available

---
[← Back to UI Overview](index.md) | [Development Overview →](../development/index.md)