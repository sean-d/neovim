# PowerShell Development

This guide covers PowerShell scripting support in Neovim.

## Overview

Full language support for PowerShell scripting including:
- PowerShell 7+ (pwsh) support
- LSP features via PowerShell Editor Services
- PSScriptAnalyzer integration for linting
- Module support (VMware, Active Directory, etc.)
- Formatting and code style enforcement

## Prerequisites

### Required Software
- PowerShell 7+ (`pwsh`) - PowerShell Core, not Windows PowerShell
- PowerShell Editor Services - Auto-installed via Mason

### Required Modules
```powershell
# Install PSScriptAnalyzer for code analysis
Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser

# Install Pester for unit testing (optional)
Install-Module -Name Pester -Force -Scope CurrentUser
```

## Language Server

**PowerShell Editor Services** provides:
- IntelliSense for cmdlets, parameters, and variables
- Real-time script analysis via PSScriptAnalyzer
- Go to definition for functions and cmdlets
- Hover documentation for cmdlets
- Code formatting with OTBS (One True Brace Style)
- Integrated console support (banner disabled for cleaner output)

The LSP is configured with:
- Code formatting style: OTBS (braces on same line)
- Whitespace handling around operators and separators
- Alignment of property value pairs
- PSScriptAnalyzer integration enabled

## Features

### Syntax Support
- Full PowerShell syntax highlighting via vim's built-in support
- Support for:
  - Cmdlets and parameters
  - Variables and automatic variables
  - Functions and advanced functions
  - Classes and enums
  - DSC resources
  - Module manifests (.psd1, .psm1, .ps1 files)

### Script Analysis
PSScriptAnalyzer provides warnings for:
- Best practice violations
- Code style issues
- Security concerns
- Performance problems
- Compatibility issues

### Auto-completion
- Cmdlet names and aliases
- Parameter names and values
- Variable names
- Module commands
- File paths
- Type names

## Key Bindings

PowerShell commands use the `<leader>dps` prefix:

| Key | Description |
|-----|-------------|
| `<leader>dpsr` | Run current script (split window) |
| `<leader>dpsi` | Run script interactive (floating terminal) |
| `<leader>dpsd` | Debug run with trace (split window) |
| `<leader>dpsc` | Analyze with PSScriptAnalyzer (split window) |
| `<leader>dpsf` | Format code |
| `<leader>dpsh` | Get help for word under cursor (split window) |
| `<leader>dpsm` | List available modules (split window) |
| `<leader>dpst` | Run Pester tests (split window) |
| `<leader>dpsS` | Check syntax using PowerShell parser |

### Standard LSP bindings

| Key | Description |
|-----|-------------|
| `K` | Show hover documentation |
| `gd` | Go to definition |
| `gr` | Find references |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code actions |
| `[d` / `]d` | Navigate diagnostics |

## Writing Scripts

### Best Practices
```powershell
#Requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path,
    
    [Parameter()]
    [ValidateSet('Info', 'Warning', 'Error')]
    [string]$LogLevel = 'Info'
)

begin {
    # Setup code
    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version Latest
}

process {
    try {
        # Main logic
        if (-not (Test-Path $Path)) {
            throw "Path not found: $Path"
        }
        
        # Process file
        Get-Content $Path | ForEach-Object {
            # Process each line
        }
    }
    catch {
        Write-Error "Failed to process: $_"
        throw
    }
}

end {
    # Cleanup code
}
```

### Advanced Functions
```powershell
function Get-SystemHealth {
    <#
    .SYNOPSIS
        Gets system health metrics
    
    .DESCRIPTION
        Retrieves CPU, memory, and disk usage statistics
    
    .PARAMETER ComputerName
        Target computer name(s)
    
    .EXAMPLE
        Get-SystemHealth -ComputerName Server01
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$ComputerName = 'localhost'
    )
    
    process {
        foreach ($computer in $ComputerName) {
            [PSCustomObject]@{
                ComputerName = $computer
                CPU = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
                Memory = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB
                Disk = (Get-PSDrive C).Free / 1GB
            }
        }
    }
}
```

## Module Development

### Module Structure
```
MyModule/
├── MyModule.psd1       # Module manifest
├── MyModule.psm1       # Root module
├── Public/            # Exported functions
│   ├── Get-Something.ps1
│   └── Set-Something.ps1
├── Private/           # Internal functions
│   └── Helper-Function.ps1
└── Tests/            # Pester tests
    └── MyModule.Tests.ps1
```

### Loading Modules
```powershell
# Import module
Import-Module MyModule

# Check for specific modules
if (Get-Module -ListAvailable -Name VMware.PowerCLI) {
    Import-Module VMware.PowerCLI
}

# Module development
$env:PSModulePath += ";$HOME/MyModules"
```

## VMware PowerCLI

For VMware administration:
```powershell
# Connect to vCenter
Connect-VIServer -Server vcenter.domain.com

# Get VM information
Get-VM | Select-Object Name, PowerState, NumCpu, MemoryGB

# Start VMs
Get-VM -Name "Test*" | Start-VM

# Snapshot management
New-Snapshot -VM $vm -Name "Pre-Update" -Description "Before updates"
```

## Active Directory

For AD administration:
```powershell
# Import AD module
Import-Module ActiveDirectory

# User management
Get-ADUser -Filter * -SearchBase "OU=Users,DC=domain,DC=com"
New-ADUser -Name "John Doe" -SamAccountName jdoe

# Group management
Add-ADGroupMember -Identity "IT Staff" -Members jdoe
```

## Running Scripts

### From Neovim
- `<leader>dpsr` - Run script normally (opens in split window)
- `<leader>dpsi` - Run with interactive console (opens in floating terminal with -NoExit)
- `<leader>dpsd` - Debug with trace output (Set-PSDebug -Trace 1)

**Note**: All split windows show:
- Clear title indicating the operation
- Formatted output (120 character width)
- Exit code for debugging
- Press 'q' to close

The interactive mode uses a floating terminal for better interaction, which can be closed with `<Esc>` or `<C-\><C-n>` then `:q`.

**Important**: Scripts run with `pwsh -NoProfile` to avoid profile conflicts.

### Execution Policy
```powershell
# Check current policy
Get-ExecutionPolicy

# Set for current user (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Debugging

### Built-in Debugging

Use `<leader>dpsd` to run scripts with PowerShell trace debugging enabled automatically.

### Manual Debugging
```powershell
# Enable debugging
Set-PSDebug -Trace 1  # Basic trace
Set-PSDebug -Trace 2  # Detailed trace

# Add breakpoints in code
Set-PSBreakpoint -Script script.ps1 -Line 10

# Write debug output
Write-Debug "Variable value: $myVar"
Write-Verbose "Processing item: $item" -Verbose
```

### Error Handling
```powershell
try {
    # Risky operation
    $result = Invoke-RestMethod -Uri $apiUrl
} catch [System.Net.WebException] {
    Write-Error "Network error: $_"
} catch {
    Write-Error "Unexpected error: $_"
    throw
} finally {
    # Cleanup
}
```

## PSScriptAnalyzer

### Configuration
Create `PSScriptAnalyzerSettings.psd1`:
```powershell
@{
    Severity = @('Error', 'Warning', 'Information')
    
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'  # If you need Write-Host
    )
    
    Rules = @{
        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true  # Matches OTBS style in LSP
        }
        PSUseConsistentIndentation = @{
            Enable = $true
            IndentationSize = 4
        }
    }
}
```

### Common Warnings
- Use approved verbs (Get, Set, New, Remove, etc.)
- Avoid aliases in scripts
- Use full parameter names
- Declare output types
- Avoid positional parameters

## Tips

### Performance
```powershell
# Use filtering at source
Get-Process | Where-Object { $_.CPU -gt 10 }  # Slower
Get-Process -Name chrome*  # Faster

# Use .NET methods for speed
[System.IO.File]::ReadAllLines($path)  # Fast
Get-Content $path  # Slower for large files
```

### Cross-Platform
```powershell
# Check OS
if ($IsWindows) {
    # Windows-specific code
} elseif ($IsLinux -or $IsMacOS) {
    # Unix-specific code
}

# Use Join-Path for paths
$configPath = Join-Path $HOME '.config' 'app.json'
```

## Troubleshooting

### LSP Not Working
1. Check PowerShell is installed: `pwsh --version` (must be PowerShell 7+)
2. Verify LSP installation: `:Mason` and check powershell_es
3. Check logs: `:LspLog`
4. Restart LSP: `:LspRestart`

### Script Analysis Not Working
1. Ensure PSScriptAnalyzer is installed (see Prerequisites)
2. Use `<leader>dpsc` to run analysis manually
3. Check for custom `PSScriptAnalyzerSettings.psd1` in project root

### Module Import Issues
```powershell
# Check module path
$env:PSModulePath -split ':'

# Find module location
Get-Module -ListAvailable -Name ModuleName

# Force reload
Remove-Module ModuleName -Force -ErrorAction SilentlyContinue
Import-Module ModuleName
```

---
[← Back to PHP/WordPress Development](php.md) | [Python Development →](python.md)