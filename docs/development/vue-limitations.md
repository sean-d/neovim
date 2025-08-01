# Vue 3 Development Limitations

Due to the current state of the Vue language server ecosystem, Vue support in Neovim is limited compared to other frameworks.

## What Works

### In `<script>` sections:
- ✅ Full TypeScript/JavaScript support
- ✅ Hover information (K)
- ✅ Go-to-definition (gd)
- ✅ Auto-completion
- ✅ Type checking

### Throughout the file:
- ✅ Syntax highlighting (Treesitter)
- ✅ Code formatting (Prettier)
- ✅ Linting (ESLint with vue plugin)
- ✅ Tailwind CSS completions

## What Doesn't Work

### In `<template>` sections:
- ❌ Component hover information
- ❌ Go-to-definition for components
- ❌ Props auto-completion
- ❌ Template expression validation
- ❌ Event handler suggestions
- ❌ Template type checking

### Vue-specific features:
- ❌ Component auto-import
- ❌ Props/emits validation in templates
- ❌ Slot name completion
- ❌ Directive suggestions
- ❌ Scoped slots type checking

## Workarounds

1. **For component definitions**: Use file search (`<leader>ff` or `<leader>fg`) to find component files
2. **For prop validation**: Refer to component files directly
3. **For navigation**: The configuration shows a helpful warning when trying to use `gd` or `K` outside `<script>` sections
4. **For better IntelliSense**: Consider using VS Code for complex Vue projects

## Why These Limitations?

The Vue ecosystem has been in flux:
- Volar (the official Vue language server) has breaking changes between v2 and v3
- The configuration uses `vtsls` with `@vue/typescript-plugin` instead of Volar for stability
- TypeScript plugins for Vue provide only partial support
- The template compiler requires deep integration that's still evolving

## Future Improvements

Keep an eye on:
- Vue Language Tools stabilization
- Neovim LSP improvements
- Community solutions

For now, Vue development is functional but not as feature-rich as React or plain TypeScript development.

## Technical Implementation

This configuration uses:
- **Language Server**: `vtsls` (Visual Studio Code TypeScript Language Server)
- **Vue Plugin**: `@vue/typescript-plugin` (loaded from project's node_modules)
- **Why not Volar?**: Due to stability concerns with Volar's breaking changes

The plugin is automatically detected and configured when found in your project's dependencies.