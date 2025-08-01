# Trouble - Code Issues & Navigation

This guide covers how to work with diagnostics, errors, todos, and code navigation using Trouble.nvim.

## What is Trouble?

Trouble provides a beautiful and functional interface for navigating:
- Diagnostics (errors, warnings, info, hints)
- Todo comments (TODO, FIXME, HACK, etc.)
- LSP references and definitions
- Quickfix and location lists
- Document symbols

### Opening Trouble

All Trouble commands are under `<leader>cx` ("code examine" or "code trouble"):

| Key | Description |
|-----|-------------|
| `<leader>cxx` | Toggle trouble (all diagnostics) |
| `<leader>cxX` | Toggle diagnostics for current buffer only |
| `<leader>cxs` | Show document symbols outline |
| `<leader>cxl` | Show LSP references/definitions |
| `<leader>cxq` | Show quickfix list in Trouble |
| `<leader>cxL` | Show location list in Trouble |
| `<leader>cxt` | Show all TODO/FIXME/HACK comments |

### Navigating in Trouble

Once Trouble is open (appears on the right side with 30% width):

| Key | Action |
|-----|--------|
| `j`/`k` or `<Tab>`/`<S-Tab>` | Move down/up |
| `<CR>` | Jump to location |
| `o` | Jump and close Trouble |
| `p` | Preview location |
| `P` | Toggle auto-preview (enabled by default) |
| `q`/`<Esc>` | Close Trouble |
| `r` | Refresh |
| `dd` | Delete item |
| `i` | Inspect |
| `gb` | Toggle current buffer filter |
| `?` | Show help |

### Folding in Trouble

| Key | Action |
|-----|--------|
| `za` | Toggle fold |
| `zo` | Open fold |
| `zc` | Close fold |
| `zO` | Open fold recursively |
| `zC` | Close fold recursively |
| `zA` | Toggle all folds |
| `zM` | Close all folds |
| `zR` | Open all folds |
| `zm` | Fold more |
| `zr` | Fold less |

## Todo Comments

Special comments are highlighted and searchable:

### Supported Keywords

- `TODO:` - General todos (blue)
- `FIXME:` / `BUG:` - Things that need fixing (red)
- `HACK:` - Temporary workarounds (yellow)
- `WARN:` / `WARNING:` / `XXX:` - Warnings (yellow)
- `PERF:` / `OPTIMIZE:` - Performance notes
- `NOTE:` / `INFO:` - Information (green)
- `TEST:` - Test-related notes

### Navigation

| Key | Action |
|-----|--------|
| `]t` | Jump to next todo comment |
| `[t` | Jump to previous todo comment |
| `<leader>cxt` | Show all todos in Trouble |
| `<leader>st` | Search todos with picker |

Note: Todo comments support multiline and are highlighted with custom colors.

## Native Diagnostics

Even without Trouble open, you can navigate diagnostics:

| Key | Action |
|-----|--------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<leader>cd` | Show line diagnostics |

For quickfix and location lists, use:
- `<leader>cxq` - Open quickfix in Trouble
- `<leader>cxL` - Open location list in Trouble

## Tips

### Filter by Severity
In Trouble, diagnostics are grouped by severity:
- 🔴 Errors - Must fix
- 🟡 Warnings - Should fix
- 🔵 Info - Suggestions
- 💡 Hints - Optional improvements

### Workspace Diagnostics
Use `<leader>cxx` to see issues across all open files. Great for:
- Finding all errors before committing
- Refactoring across multiple files
- Code review

### Project-wide Todos
Use `<leader>cxt` to find all TODO comments in your project:
```lua
-- TODO: Add error handling
-- FIXME: Memory leak here
-- HACK: Temporary fix until v2.0
```

### Integration with Git
Trouble shows file paths relative to project root, making it easy to see which files need attention before committing.

## Examples

### Quick Error Fix Workflow
1. `<leader>cxX` - Show buffer diagnostics
2. Navigate with `j`/`k`
3. `<CR>` to jump to error
4. Fix the issue
5. `<leader>cxx` - Check if any errors remain

### Code Review Workflow
1. `<leader>cxt` - Show all TODOs
2. Review what needs to be done
3. `o` to jump to each TODO and fix
4. `]t` to find any remaining todos

### Refactoring Workflow
1. Make changes across files
2. `<leader>cxx` - See all resulting errors
3. Fix errors one by one
4. `r` in Trouble to refresh after fixes

---
[← Back to RESTful Testing](rest-api.md) | [UI Overview →](ui/index.md)