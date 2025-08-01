# Python Development

This guide covers Python development in Neovim with manual virtual environment management.

## Overview

Full language support for Python development including:
- Python 3.x support with virtual environments
- LSP features via Pyright (type checking, IntelliSense)
- Linting and formatting with Ruff (replaces black, isort, flake8, etc.)
- Debugging with debugpy
- Package management with UV
- Test runner integration (pytest)

### Auto-installed Components

The following components are automatically installed by Mason when you open Neovim:
- **pyright** - Python Language Server
- **ruff** - Fast Python linter and formatter  
- **debugpy** - Python debugging support (DAP)

## Workflow

### 1. Create a Project
```bash
mkdir my-project
cd my-project
uv init
```

### 2. Add Dependencies
```bash
# Runtime dependencies
uv add flask requests

# Development dependencies (in venv)
uv add --dev ruff mypy pytest pytest-cov
```

### 3. Activate Virtual Environment
```bash
# UV creates .venv automatically
source .venv/bin/activate

# Verify activation
which python  # Should show .venv/bin/python
```

### 4. Open in Neovim
```bash
# With venv activated!
nvim .
```

## Language Server

**Pyright** provides:
- Type checking and inference
- Auto-completion
- Go to definition
- Find references
- Hover documentation
- Code actions and quick fixes
- Diagnostic mode: "openFilesOnly" (only checks open files)
- Type checking mode: "standard"

**Ruff** provides:
- Fast linting (replaces flake8, pylint, etc.)
- Code formatting (replaces black, isort)
- Auto-fixing common issues
- Configured lint rules: F, E, W, I, N, UP, B, C4

## Key Bindings

Python commands use the `<leader>dpy` prefix:

| Key | Description |
|-----|-------------|
| `<leader>dpyr` | Run current file (split window) |
| `<leader>dpyi` | Interactive REPL (floating terminal) |
| `<leader>dpyt` | Test current file with pytest |
| `<leader>dpyT` | Test current function |
| `<leader>dpya` | Run all tests |
| `<leader>dpyc` | Coverage report |
| `<leader>dpym` | Type check with mypy |
| `<leader>dpyl` | Lint with ruff |
| `<leader>dpyf` | Format code |
| `<leader>dpyD` | Start debugging |

### Package Management

| Key | Description |
|-----|-------------|
| `<leader>dpyu` | UV add package |
| `<leader>dpyU` | UV add dev package |
| `<leader>dpys` | UV sync dependencies |
| `<leader>dpyp` | List installed packages |

### Django Support

| Key | Description |
|-----|-------------|
| `<leader>dpyd` | Run Django manage.py command |

### Standard LSP bindings

| Key | Description |
|-----|-------------|
| `K` | Show hover documentation |
| `gd` | Go to definition |
| `gr` | Find references |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code actions |
| `[d` / `]d` | Navigate diagnostics |

## Virtual Environment Support

The configuration automatically detects and uses activated virtual environments:
- Pyright and debugpy automatically use the active venv
- Statusline shows Python version and venv name
- All Python commands respect the `VIRTUAL_ENV` environment variable

**Important**: Always activate your virtual environment before opening Neovim for proper LSP and debugging support.

## Writing Python Code

### Type Hints
```python
from typing import List, Optional, Dict

def process_data(items: List[str]) -> Dict[str, int]:
    """Process items and return counts."""
    counts: Dict[str, int] = {}
    for item in items:
        counts[item] = counts.get(item, 0) + 1
    return counts
```

### Classes with Annotations
```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class User:
    name: str
    email: str
    created_at: datetime = datetime.now()
    
    def display_name(self) -> str:
        return f"{self.name} <{self.email}>"
```

### Async/Await
```python
import asyncio
from typing import List

async def fetch_data(url: str) -> dict:
    # Simulated async operation
    await asyncio.sleep(1)
    return {"url": url, "data": "example"}

async def main():
    urls = ["http://api1.com", "http://api2.com"]
    results = await asyncio.gather(
        *[fetch_data(url) for url in urls]
    )
    return results
```

## Testing with Pytest

### Writing Tests
```python
# test_calculator.py
import pytest
from calculator import Calculator

class TestCalculator:
    def test_addition(self):
        calc = Calculator()
        assert calc.add(2, 3) == 5
    
    def test_division_by_zero(self):
        calc = Calculator()
        with pytest.raises(ZeroDivisionError):
            calc.divide(10, 0)
    
    @pytest.mark.parametrize("a,b,expected", [
        (10, 5, 2),
        (9, 3, 3),
        (7, 7, 1),
    ])
    def test_division(self, a, b, expected):
        calc = Calculator()
        assert calc.divide(a, b) == expected
```

### Running Tests
- `<leader>dpyt` - Test current file (with verbose output)
- `<leader>dpyT` - Test current function (searches for `test_` functions)
- `<leader>dpya` - Run all tests in project
- `<leader>dpyc` - Coverage report (requires pytest-cov)

All test commands run in a split window showing output and exit codes.

## Package Management with UV

UV is the preferred package manager, offering faster dependency resolution than pip.

### Project Structure
```
my-project/
├── pyproject.toml      # Project configuration
├── uv.lock            # Locked dependencies
├── .venv/             # Virtual environment
├── src/my_project/    # Source code
├── tests/             # Test files
└── README.md
```

### Common UV Commands
```bash
# Initialize project
uv init

# Add dependencies (also available via keybindings)
uv add flask sqlalchemy       # or use <leader>dpyu
uv add --dev pytest ruff mypy # or use <leader>dpyU

# Sync environment
uv sync                        # or use <leader>dpys

# Update dependencies
uv update

# Show installed packages
uv pip list                   # or use <leader>dpyp
```

## Debugging

### Setting Breakpoints
1. Place cursor on desired line
2. Press `<leader>db` to toggle breakpoint
3. Press `<leader>dpyD` to start debugging

### Debug Configurations
The debugger supports:
- Basic file execution
- File with arguments
- Django projects
- Flask applications

### Debug Controls
- `<leader>dc` - Continue
- `<leader>dO` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>dt` - Terminate

## Ruff Configuration

Create `pyproject.toml`:
```toml
[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings  
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
]
ignore = []

# Note: These rules match the LSP configuration

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

## Mypy Configuration

Add to `pyproject.toml`:
```toml
[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

## Django Development

### Quick Start
```bash
# Create Django project
uv add django
python -m django startproject mysite .

# Run migrations
<leader>dpyd  # Then type: migrate

# Run server  
<leader>dpyd  # Then type: runserver
```

**Note**: The Django debug configuration runs with `--noreload` to work properly with the debugger.

### Common Django Commands
- `makemigrations` - Create migrations
- `migrate` - Apply migrations
- `createsuperuser` - Create admin user
- `shell` - Django shell
- `test` - Run Django tests

## Flask Development

### Quick Start
```bash
# Create Flask app
uv add flask
# Create app.py with your Flask code

# Run with debugging
<leader>dpyD  # Select "Flask" configuration
```

**Note**: The Flask debug configuration sets `FLASK_ENV=development` automatically.

## Docker Integration

### Dockerfile Example
```dockerfile
FROM python:3.12-slim
WORKDIR /app

# Install UV
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application
COPY . .

# Run the application
CMD ["python", "-m", "myapp"]
```

### docker-compose.yaml
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - PYTHONUNBUFFERED=1
    volumes:
      - .:/app
    command: python manage.py runserver 0.0.0.0:8000

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Tips

### Virtual Environment Best Practices
1. Always activate venv before opening Neovim
2. Name your venv `.venv` for consistency
3. Add `.venv/` to `.gitignore`
4. Use UV for reproducible environments

### Performance
- Ruff is much faster than traditional linters
- Pyright provides better type checking than pylsp
- Use `uv` instead of `pip` for faster installs

### Common Issues

**Import not found**
- Ensure venv is activated
- Check if package is installed: `pip list`
- Restart LSP: `:LspRestart`

**Formatter not working**
- Install ruff in venv: `uv add --dev ruff`
- Check ruff config in `pyproject.toml`

**Debugger not starting**
- debugpy is auto-installed by Mason
- Ensure your venv is activated before starting Neovim
- The debugger automatically uses `vim.env.VIRTUAL_ENV` if available
- Falls back to `/usr/bin/python3` if no venv is active

---
[← Back to PowerShell](powershell.md) | [Rust Development →](rust.md)