# Markdown

Enhanced markdown editing experience with live preview, beautiful rendering, and smart editing features.

## Features

- **In-buffer Rendering** - See formatted markdown as you type
- **Live Browser Preview** - Synchronized preview in your browser
- **Image Support** - Paste images from clipboard
- **Smart Lists** - Auto-numbering and bullet management
- **Checkbox Support** - Interactive todo lists
- **Table Formatting** - Beautiful table rendering
- **Syntax Highlighting** - Code blocks with proper highlighting
- **Grammar Checking** - Real-time spelling and grammar via harper_ls

## Key Mappings

| Key | Description |
|-----|-------------|
| `<leader>mp` | Toggle browser preview |
| `<leader>mi` | Paste image from clipboard |
| `<leader>mc` | Toggle checkbox [ ] ↔ [x] |
| `<Tab>` | Indent list item (bullets.vim) |
| `<S-Tab>` | Outdent list item (bullets.vim) |
| `<CR>` | Continue list on new line (bullets.vim) |
| `<leader>co` | Toggle document outline |

## Visual Rendering

### Headers
Headers are rendered with:
- Distinct colors for each level (H1-H6)
- Icons for visual distinction (via render-markdown.nvim)
- Enhanced highlighting via Treesitter
- Clear visual hierarchy

### Lists
- Bullet points with custom icons
- Auto-numbering for ordered lists
- Nested list indentation
- Smart list continuation

### Checkboxes
- [ ] Unchecked items appear dimmed
- [x] Checked items show with checkmark
- Interactive toggling with `<leader>mc`

### Code Blocks
```python
# Syntax highlighted code blocks
def hello():
    print("Hello, World!")
```

### Tables
Tables render with:
- Aligned columns
- Distinct header styling
- Border visualization
- Automatic formatting

## Image Workflow

### Pasting Images
1. Copy image to clipboard
2. Position cursor where you want the image
3. Press `<leader>mi`
4. Enter filename (or accept timestamp default)
5. Image is saved to `images/` and link inserted

### Image Management
- Images are stored in `images/` relative to markdown file
- Automatic directory creation
- Configurable naming patterns
- Works with screenshots and copied images

### Prerequisites
- **macOS**: `brew install pngpaste`
- **Linux**: `sudo apt install xclip`
- **Windows**: Works with standard clipboard

## Browser Preview

### Starting Preview
Press `<leader>mp` to:
1. Start local preview server
2. Open browser to preview
3. See live updates as you type

### Preview Features
- Synchronized scrolling
- Auto-refresh on save
- GitHub-flavored markdown
- Mermaid diagram support
- Custom CSS theming

### Stopping Preview
Press `<leader>mp` again or close the browser tab.

## Smart Lists

### Bullet Lists
Bullets.vim provides:
- Auto-continue on `<CR>`
- Indent/outdent with `<Tab>`/`<S-Tab>`
- Multiple bullet styles (-, *, +)
- Automatic renumbering

### Numbered Lists
1. Start with `1.` 
2. Press `<CR>` for next item
3. Numbers auto-update
4. Reorder without renumbering manually

### Checkboxes
Create with `- [ ]`:
- [ ] Pending task
- [x] Completed task
- [.] In progress (custom marker)
- [o] Delegated (custom marker)

## Document Navigation

### Outline View
`<leader>co` shows document structure:
- All headers in hierarchy
- Click to jump
- Collapsible sections
- Real-time updates

### Folding
Markdown files use standard Neovim folding:
- Powered by nvim-ufo for better fold management
- `za` - Toggle fold
- `zM` - Close all folds
- `zR` - Open all folds
- `zp` - Peek folded content

## LSP Features

### Marksman (Markdown LSP)
Provides:
- Document symbols
- Go to definition for links
- Hover for references
- Workspace-wide link validation
- Wiki-link support

### Harper (Grammar/Spelling)
Offers:
- Real-time spell checking
- Grammar suggestions
- Style improvements
- Custom dictionary support

## Scratch Buffers

Scratch buffers are great for markdown notes:
```vim
<leader>xn  " New scratch buffer
<leader>xa  " Browse all scratches
<leader>xx  " Open last scratch
```

Perfect for:
- Quick notes
- Meeting minutes  
- Code experiments
- Documentation drafts

## Configuration

### Render Settings
Located in `lua/plugins/markdown.lua`:
- Header styles and colors
- Bullet symbols
- Code block backgrounds
- Table formatting

### Preview Settings
Customize preview with:
- Port number
- Browser choice
- CSS theme
- Update delay

## Tips & Tricks

### Quick Notes
1. `<leader>xn` - New scratch
2. Type notes with full markdown
3. Images, lists, code blocks all work
4. Scratches persist between sessions

### Documentation Writing
- Use outline (`<leader>co`) for navigation
- Fold sections while working
- Preview side-by-side with browser
- Check grammar with harper_ls

### Meeting Notes
```markdown
# Meeting 2024-01-15

## Attendees
- [ ] John
- [x] Jane
- [x] Bob

## Action Items
1. [ ] Review proposal
2. [ ] Send follow-up
3. [x] Update timeline
```

### Technical Writing
- Code blocks with language highlighting
- Mermaid diagrams in preview
- Tables for comparisons
- Links validated by Marksman

## Troubleshooting

### Preview not working
```vim
:checkhealth markdown-preview
```

### Images not pasting
- Check clipboard tool installed
- Verify image directory exists
- Try manual save first

### Rendering issues
The render-markdown plugin provides commands:
```vim
:RenderMarkdown         " Show status
:RenderMarkdown enable  " Enable rendering
:RenderMarkdown disable " Disable rendering
:RenderMarkdown toggle  " Toggle on/off
```

---
[← Back to Debugging (DAP)](development/debugging.md) | [RESTful Testing →](rest-api.md)