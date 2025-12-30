#===============================================================================
# ELITE Setup Script (Windows PowerShell)
# Automated dependency checking and installation
#===============================================================================

param(
    [switch]$SkipNpmInstall = $false
)

$ErrorActionPreference = "Stop"

# Get project directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir

#===============================================================================
# Color Output Functions
#===============================================================================

function Write-Success {
    Write-Host "✓ $args" -ForegroundColor Green
}

function Write-Error {
    Write-Host "✗ $args" -ForegroundColor Red
}

function Write-Warning {
    Write-Host "⚠ $args" -ForegroundColor Yellow
}

function Write-Info {
    Write-Host "→ $args" -ForegroundColor Cyan
}

function Write-Bold {
    Write-Host $args -ForegroundColor White -Bold
}

#===============================================================================
# Print Header
#===============================================================================

function Print-Header {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║          ELITE Setup - Automated Installation           ║" -ForegroundColor Cyan
    Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Detected OS: Windows" -ForegroundColor White -Bold
    Write-Host ""
}

#===============================================================================
# Claude Code Installation
#===============================================================================

function Test-ClaudeCode {
    Write-Info "Checking Claude Code CLI..."

    # Check if claude command exists
    try {
        $null = & claude --version 2>&1
        $version = & claude --version 2>&1 | Select-Object -First 1
        Write-Success "Claude Code CLI installed: $version"
        return $true
    } catch {
        Write-Error "Claude Code CLI not found"
        Write-Host ""
        Write-Bold "Claude Code is required for ELITE."
        Write-Host ""
        Write-Host "Install options:"
        Write-Host ""
        Write-Host "  1. NPM (recommended):" -ForegroundColor Cyan
        Write-Host "     npm install -g @anthropic-ai/claude-code" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  2. Download from:" -ForegroundColor Cyan
        Write-Host "     https://claude.ai/code" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "After installation, run this script again."
        return $false
    }
}

#===============================================================================
# Node.js Installation
#===============================================================================

function Test-NodeJs {
    Write-Info "Checking Node.js..."

    try {
        $version = & node --version 2>&1
        if ($version -match 'v(\d+)') {
            $major = [int]$matches[1]

            if ($major -ge 18) {
                Write-Success "Node.js installed: $version"
                return $true
            } else {
                Write-Warning "Node.js $version (18+ required)"
                Write-Host ""
                Write-Host "Download Node.js 18+ from:" -ForegroundColor Cyan
                Write-Host "https://nodejs.org/" -ForegroundColor Cyan
                return $false
            }
        }
    } catch {
        Write-Error "Node.js not found (18+ required)"
        Write-Host ""
        Write-Host "Download from: https://nodejs.org/" -ForegroundColor Cyan
        return $false
    }
    return $false
}

#===============================================================================
# Python Installation
#===============================================================================

function Test-Python {
    Write-Info "Checking Python 3..."

    # Try python first, then python3
    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($null -eq $pythonCmd) {
        $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
    }

    if ($null -ne $pythonCmd) {
        try {
            $version = & $pythonCmd.Source --version 2>&1
            Write-Success "$version"
            return $true
        } catch {
            # Fall through to error
        }
    }

    Write-Error "Python 3 not found"
    Write-Host ""
    Write-Host "Download from: https://python.org/" -ForegroundColor Cyan
    Write-Warning "Note: Check 'Add Python to PATH' during installation"
    return $false
}

#===============================================================================
# TypeScript Installation
#===============================================================================

function Test-TypeScript {
    Write-Info "Checking TypeScript..."

    try {
        $version = & tsc --version 2>&1
        Write-Success "TypeScript installed: $version"
        return $true
    } catch {
        Write-Warning "TypeScript not found (installing globally)"

        try {
            & npm install -g typescript 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                $version = & tsc --version 2>&1
                Write-Success "TypeScript installed successfully: $version"
                return $true
            }
        } catch {
            # Fall through to error
        }

        Write-Error "Failed to install TypeScript"
        Write-Host "Install manually: npm install -g typescript" -ForegroundColor Yellow
        return $false
    }
}

#===============================================================================
# Git Installation
#===============================================================================

function Test-Git {
    Write-Info "Checking Git..."

    try {
        $version = & git --version 2>&1
        Write-Success "$version"
        return $true
    } catch {
        Write-Warning "Git not found (optional but recommended)"
        Write-Host ""
        Write-Host "Download from: https://git-scm.com/" -ForegroundColor Cyan
        return $true  # Git is optional, don't fail
    }
}

#===============================================================================
# Skill Installation
#===============================================================================

function Install-Skill {
    Write-Host ""
    Write-Info "Installing ELITE skill..."

    $skillDir = "$env:USERPROFILE\.claude\skills\agent-mode"

    # Create directory
    New-Item -ItemType Directory -Force -Path $skillDir | Out-Null

    # Copy files
    try {
        Copy-Item "$ProjectDir\SKILL.md" -Destination "$skillDir\" -Force
        if (Test-Path "$ProjectDir\references") {
            Copy-Item "$ProjectDir\references" -Destination "$skillDir\" -Recurse -Force
        }
        Write-Success "ELITE skill installed to: $skillDir"
        return $true
    } catch {
        Write-Error "Failed to install skill: $_"
        Write-Host "Try copying manually:"
        Write-Host "  mkdir `$env:USERPROFILE\.claude\skills\agent-mode" -ForegroundColor Yellow
        Write-Host "  copy SKILL.md `$env:USERPROFILE\.claude\skills\agent-mode\" -ForegroundColor Yellow
        Write-Host "  xcopy /E /I references `$env:USERPROFILE\.claude\skills\agent-mode\references" -ForegroundColor Yellow
        return $false
    }
}

#===============================================================================
# ARD Coach Skill Installation
#===============================================================================

function Install-ARDCoach {
    Write-Host ""
    Write-Info "Installing ARD Coach skill..."

    $ardCoachSrc = "$ProjectDir\skills\ard-coach\SKILL.md"
    $ardCoachDir = "$env:USERPROFILE\.claude\skills\ard-coach"

    # Check if ARD Coach exists
    if (-not (Test-Path $ardCoachSrc)) {
        Write-Warning "ARD Coach skill not found (optional)"
        return $true
    }

    # Create directory and copy
    try {
        New-Item -ItemType Directory -Force -Path $ardCoachDir | Out-Null
        Copy-Item $ardCoachSrc -Destination "$ardCoachDir\" -Force
        Write-Success "ARD Coach skill installed to: $ardCoachDir"
        return $true
    } catch {
        Write-Warning "Failed to install ARD Coach skill (optional)"
        return $true
    }
}

#===============================================================================
# Environment Template
#===============================================================================

function New-EnvTemplate {
    Write-Host ""
    Write-Info "Creating environment template..."

    $envFile = "$ProjectDir\.env.example"

    if (-not (Test-Path $envFile)) {
        @"
# ELITE Configuration
# Copy this file to .env and customize as needed

#===============================================================================
# Autonomous Runner Settings
#===============================================================================

# Maximum number of retry attempts before giving up
# Default: 50
ELITE_MAX_RETRIES=50

# Base wait time in seconds between retries (uses exponential backoff)
# Default: 60
ELITE_BASE_WAIT=60

# Maximum wait time in seconds (capped at this value)
# Default: 3600 (1 hour)
ELITE_MAX_WAIT=3600

# Skip prerequisite checks (not recommended)
# Set to 'true' only if you're sure all dependencies are installed
# Default: false
ELITE_SKIP_PREREQS=false

#===============================================================================
# Dashboard Settings
#===============================================================================

# Enable/disable web dashboard
# Default: true
ELITE_DASHBOARD=true

# Port for web dashboard
# Default: 57374
ELITE_DASHBOARD_PORT=57374

#===============================================================================
# SDLC Phase Controls
#===============================================================================

# All phases are enabled by default. Set any to 'false' to skip.
# Most users should leave these enabled.

# Run unit tests
ELITE_PHASE_UNIT_TESTS=true

# Run functional API tests
ELITE_PHASE_API_TESTS=true

# Run end-to-end tests
ELITE_PHASE_E2E_TESTS=true

# Run security scanning
ELITE_PHASE_SECURITY=true

# Run integration tests
ELITE_PHASE_INTEGRATION=true

# Run parallel 3-reviewer code review
ELITE_PHASE_CODE_REVIEW=true

# Run web research for latest patterns
ELITE_PHASE_WEB_RESEARCH=true

# Run performance testing
ELITE_PHASE_PERFORMANCE=true

# Run accessibility compliance tests
ELITE_PHASE_ACCESSIBILITY=true

# Run regression testing
ELITE_PHASE_REGRESSION=true

# Run user acceptance testing simulation
ELITE_PHASE_UAT=true

#===============================================================================
# API Keys (for Generated Agents)
#===============================================================================

# If your generated agents need API keys, add them here.
# ELITE will use these when building/testing your agents.

# Example: OpenAI API key for agents that use GPT models
# OPENAI_API_KEY=sk-your-key-here

# Example: GitHub token for repository operations
# GITHUB_TOKEN=ghp-your-token-here

# Example: Weather API key
# WEATHER_API_KEY=your-key-here

#===============================================================================
# Development Settings (Optional)
#===============================================================================

# Log level for debugging
# Options: debug, info, warn, error
# Default: info
# ELITE_LOG_LEVEL=info

# Enable verbose output
# Default: false
# ELITE_VERBOSE=false

# Custom Claude Code binary path (if not in PATH)
# ELITE_CLAUDE_BINARY=/path/to/claude
"@ | Out-File -FilePath $envFile -Encoding UTF8

        Write-Success "Created .env.example"
        Write-Host "  Note: Copy to .env if you need custom configuration" -ForegroundColor Yellow
    }
}

#===============================================================================
# Verification
#===============================================================================

function Test-Installation {
    Write-Host ""
    Write-Info "Verifying installation..."

    $allGood = $true

    # Test Claude Code
    try {
        $null = & claude --version 2>&1
        Write-Success "Claude Code accessible"
    } catch {
        Write-Error "Claude Code not accessible"
        $allGood = $false
    }

    # Test skill
    $skillPath = "$env:USERPROFILE\.claude\skills\agent-mode\SKILL.md"
    if (Test-Path $skillPath) {
        Write-Success "ELITE skill installed"
    } else {
        Write-Error "ELITE skill not found"
        $allGood = $false
    }

    return $allGood
}

#===============================================================================
# Main
#===============================================================================

Print-Header

# Track issues
$hasIssues = $false

# Check dependencies
if (-not (Test-ClaudeCode)) { $hasIssues = $true }
if (-not (Test-NodeJs)) { $hasIssues = $true }
if (-not (Test-Python)) { $hasIssues = $true }
if (-not (Test-TypeScript)) { $hasIssues = $true }
Test-Git  # Git is optional, won't set hasIssues

# Exit if critical dependencies missing
if ($hasIssues) {
    Write-Host ""
    Write-Bold "Please install missing dependencies and run again."
    exit 1
}

# Install skill and create templates
Install-Skill
Install-ARDCoach
New-EnvTemplate

# Verify
if (Test-Installation) {
    Write-Host ""
    Write-Bold "Setup complete!"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host ""
    Write-Host "  1. Read QUICKSTART.md for a 3-minute guide"
    Write-Host "  2. Run: claude --dangerously-skip-permissions"
    Write-Host "  3. Say: ARD Coach or Agent Mode"
    Write-Host ""
    Write-Host "Need help? See README.md or docs/tutorial.md"
} else {
    Write-Host ""
    Write-Warning "Setup completed with warnings. See above."
    exit 1
}
