# JavaScript/TypeScript Development

Full JavaScript and TypeScript support with LSP, formatting, linting, and debugging capabilities.

## Features

- **Full LSP Support**: IntelliSense, hover docs, go-to-definition, find references
- **TypeScript Support**: Full TypeScript language features including type checking
- **Auto-formatting**: Prettier on save with proper configuration
- **Linting**: ESLint with auto-fix capabilities
- **Run Files**: Execute JavaScript and TypeScript files directly
- **Package Management**: npm/yarn/pnpm integration
- **Framework Support**: Vue 3 (partial), Electron, Tailwind CSS

## Installation

All dependencies are project-based (install per project as needed):
```bash
npm install --save-dev typescript tsx
# or with other package managers:
yarn add -D typescript tsx
pnpm add -D typescript tsx
```

LSP servers are automatically installed via Mason:
- `vtsls` (Visual Studio Code TypeScript Language Server - bundles its own TypeScript)
- `eslint` (ESLint Language Server)
- `tailwindcss` (Tailwind CSS Language Server)
- `prettierd` (via Mason for faster formatting)

**Important Setup Notes**:
- **ESLint**: Install globally with `npm install -g eslint` for system-wide availability
- **TypeScript**: No global install needed - `vtsls` bundles its own TypeScript version
- **Project Tools**: Install TypeScript, tsx, and other tools per-project as needed

## Keybindings

All JavaScript keybindings use the `<leader>djs` prefix:

| Key | Description |
|-----|-------------|
| `<leader>djsr` | Run current file (auto-detects JS/TS) |
| `<leader>djsf` | Format file (Prettier) |
| `<leader>djsl` | Lint and fix file (ESLint) |
| `<leader>djsi` | Install dependencies (npm/yarn/pnpm) |
| `<leader>djsb` | Build project |
| `<leader>djsd` | Start dev server (Vite) |
| `<leader>djsp` | Preview production build |
| `<leader>djse` | Start Electron app |
| `<leader>djsa` | Run all tests |
| `<leader>djst` | Test current file |
| `<leader>djsT` | Test current function (runs single test under cursor) |
| `<leader>djsD` | Debug current file |
| `<leader>djsA` | Attach debugger to process |

Standard LSP keybindings also work:
- `K` - Hover documentation
- `gd` - Go to definition
- `gr` - Find references
- `<leader>cr` - Rename symbol
- `<leader>ca` - Code actions

## Configuration

### ESLint

ESLint can be configured using either:
1. `.eslintrc.json` (traditional config)
2. `eslint.config.js` (new flat config - takes precedence)

Example `.eslintrc.json` with auto-fixable rules:
```json
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {
    "quotes": ["error", "single"],
    "semi": ["error", "always"],
    "indent": ["error", 2],
    "comma-dangle": ["error", "always-multiline"],
    "no-unused-vars": "warn",
    "no-console": "off"
  }
}
```

### Prettier

Configure with `.prettierrc` or `.prettierrc.json`:
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

### TypeScript

TypeScript configuration via `tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

## Workflow

### Running JavaScript/TypeScript Files

The run command (`<leader>djsr`) automatically detects the file type:
- `.js` files run with `node`
- `.ts` and `.tsx` files run with project-local `tsx` or `ts-node`
- `.mjs` files run with `node`
- Saves the file before running
- Shows output in a terminal split with proper title

### Debugging

Full debugging support is available for JavaScript and TypeScript:

#### Node.js/JavaScript Debugging
- Set breakpoints with `<leader>db`
- Start debugging with `<leader>djsD`
- Debug controls:
  - `<leader>dc` - Continue
  - `<leader>dO` - Step over
  - `<leader>di` - Step into
  - `<leader>do` - Step out
  - `<leader>de` - Evaluate expression

#### TypeScript Debugging
- Works with project-local TypeScript (no global install needed)
- Source maps are automatically handled
- Install per project: `npm install --save-dev typescript tsx`
- Debugging compiles TypeScript and runs the JavaScript output

#### Browser Debugging (Vue/React)

**Launch Mode** (Recommended):
- Start your dev server first (`npm run dev`)
- Use `<leader>djsD` and select a browser:
  - "Launch Brave" - Starts new Brave instance with debugging
  - "Launch Chrome" - Starts new Chrome instance with debugging
  - "Launch Edge" - Starts new Edge instance with debugging
- Set breakpoints in your source files
- The browser will launch automatically with debugging enabled

**Attach Mode** (For existing browser sessions):
- First, start your browser with debugging enabled:
  - Brave: `brave --remote-debugging-port=9222`
  - Chrome: `google-chrome --remote-debugging-port=9222`
  - Edge: `microsoft-edge --remote-debugging-port=9222`
- Start your dev server (`npm run dev`)
- Use `<leader>djsD` and select "Attach to [Browser]"
- Set breakpoints in your source files

Note: Launch mode is easier as it handles everything automatically. Use attach mode when you need to debug an existing browser session or have specific browser settings.

#### Test Debugging (Jest/Vitest)

**Note**: Vitest debugging configurations are hidden from the debug menu because they require manual setup. Use the manual process below:

**Manual Process**:
1. Open a test file (`.test.ts`, `.spec.ts`, etc.)
2. Set breakpoints with `<leader>db` where you want to pause
3. In a terminal, start the test runner with debugging:
   ```bash
   cd ~/your-project
   node --inspect-brk ./node_modules/.bin/vitest run path/to/test.ts
   ```
4. You'll see: `Debugger listening on ws://127.0.0.1:9229/...`
5. In Neovim, run `<leader>djsA` (attach debugger)
6. Select "Attach to Port 9229"
7. The debugger will connect and pause at your breakpoints

**Debug Controls**:
- `<leader>dc` - Continue execution
- `<leader>dO` - Step over
- `<leader>di` - Step into  
- `<leader>do` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>de` - Evaluate expression

**Note**: The launch configurations for test files are currently not working reliably. Use the manual attach process above.

### Formatting vs Linting

- **Formatting** (`<leader>djsf`): Prettier handles code style (spacing, line breaks)
- **Linting** (`<leader>djsl`): ESLint handles code quality and fixable style rules

Both can work together:
1. ESLint fixes code quality issues and some style rules
2. Prettier formats the code for consistency

### Error Handling

- **Syntax errors** must be fixed manually (tools will detect but not auto-fix)
- **Style issues** are auto-fixed by ESLint and Prettier
- **Type errors** are shown by TypeScript but don't prevent running

## Package Managers

The configuration automatically detects your package manager:
- Looks for `yarn.lock` → uses yarn
- Looks for `pnpm-lock.yaml` → uses pnpm
- Looks for `bun.lockb` → uses bun
- Otherwise → uses npm

## Troubleshooting

### ESLint not fixing issues
1. Check for syntax errors first (ESLint won't fix files with syntax errors)
2. Ensure ESLint is installed globally or in your project
3. Verify your ESLint configuration file is valid
4. Try the manual command: `npx eslint --fix yourfile.js`

### Prettier not formatting
1. Check for syntax errors (Prettier requires valid JavaScript)
2. Ensure you have a Prettier config file (`.prettierrc`, `.prettierrc.json`, etc.)
3. Check `:ConformInfo` for formatter status
4. Prettier only activates when a config file is present

### TypeScript errors in JavaScript files
Add a `jsconfig.json` to your project:
```json
{
  "compilerOptions": {
    "checkJs": false
  }
}
```

## Vue 3 Support

Vue 3 has partial support through vtsls and @vue/typescript-plugin. See [Vue Limitations](../vue-limitations.md) for detailed information.

### What Works:
- **Script Section**: Full TypeScript/JavaScript support in `<script>` blocks
- **Treesitter**: Full syntax highlighting for template, script, and style sections
- **Prettier**: Automatic formatting of `.vue` files
- **ESLint**: Linting with Vue-specific rules (with proper config)
- **Tailwind CSS**: Class completions in templates
- **TypeScript in Script**: Full TypeScript support in `<script>` sections

### Current Limitations:
- **No template IntelliSense**: Auto-completion doesn't work in template sections
- **No component hover**: No hover information for Vue components
- **Limited go-to-definition**: Only works for imports, not components or props
- **No props auto-completion**: Component props aren't suggested in templates
- **No template validation**: Template expressions aren't type-checked

### Why These Limitations?
The Vue language server ecosystem is currently fragmented:
- Volar (vue-language-server) has breaking changes between versions
- vtsls with @vue/typescript-plugin provides only partial support
- Full support requires complex setup that's still unstable

### Vue Project Setup

1. Create a Vue 3 project:
   ```bash
   npm create vite@latest my-vue-app -- --template vue-ts
   ```

2. Install required dependencies:
   ```bash
   npm install -D @vue/typescript-plugin eslint-plugin-vue
   ```

3. Configure TypeScript (`tsconfig.json`):
   ```json
   {
     "compilerOptions": {
       // ... other options
       "plugins": [
         { "name": "@vue/typescript-plugin" }
       ]
     }
   }
   ```

4. Configure ESLint (`.eslintrc.json`):
   ```json
   {
     "extends": ["eslint:recommended", "plugin:vue/vue3-essential"],
     "plugins": ["vue"]
   }
   ```

5. Development commands work normally:
   - `<leader>djsd` - Start Vite dev server
   - `<leader>djsb` - Build for production
   - `<leader>djsp` - Preview production build

### How it Works
- Uses `vtsls` (Visual Studio Code's TypeScript Language Server)
- Automatically detects and loads `@vue/typescript-plugin` from node_modules
- Provides partial Vue support (script sections work well, templates have limitations)

## Testing

### Running Tests
- `<leader>djsa` - Run all tests (auto-detects Jest/Vitest)
- `<leader>djst` - Test current file
- `<leader>djsT` - Test single function under cursor

The test runner is automatically detected based on your project configuration.

## Docker Integration

Many commands automatically detect Docker and run inside containers when `docker-compose.yml` is present. See [Docker Integration](docker.md) for details.

---
[← Back to Go Development](go.md) | [PHP/WordPress Development →](php.md)