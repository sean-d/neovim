#!/bin/bash

# Neovim Configuration Setup Script

echo "🚀 Setting up Neovim configuration..."

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo "❌ Neovim is not installed. Please install Neovim 0.9+ first."
    echo "   macOS: brew install neovim"
    echo "   Ubuntu: sudo apt install neovim"
    exit 1
fi

# Check Neovim version
NVIM_VERSION=$(nvim --version | head -n1 | cut -d ' ' -f2)
echo "✓ Found Neovim $NVIM_VERSION"

# Check for required tools
echo ""
echo "Checking for recommended tools..."

# Git
if command -v git &> /dev/null; then
    echo "✓ Git is installed"
else
    echo "⚠️  Git is not installed (required for plugin management)"
fi

# Ripgrep
if command -v rg &> /dev/null; then
    echo "✓ Ripgrep is installed"
else
    echo "⚠️  Ripgrep is not installed (recommended for fast searching)"
    echo "   Install: brew install ripgrep"
fi

# Go
if command -v go &> /dev/null; then
    echo "✓ Go is installed ($(go version | cut -d ' ' -f3))"
else
    echo "⚠️  Go is not installed (required for Go development)"
fi

# Node (for some LSP servers)
if command -v node &> /dev/null; then
    echo "✓ Node.js is installed"
else
    echo "⚠️  Node.js is not installed (required for some language servers)"
fi

echo ""
echo "📦 Installing plugins..."
echo "When Neovim opens, plugins will automatically install."
echo "This may take a minute on first run."
echo ""
echo "Press Enter to open Neovim and complete setup..."
read -r

# Open Neovim
nvim +':echo "Installing plugins... Please wait."' +':Lazy sync'

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open Neovim: nvim"
echo "2. Run :checkhealth to verify setup"
echo "3. For Go development, run :GoInstallBinaries"
echo "4. See README.md for keybindings and usage"