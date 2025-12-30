#!/bin/bash
#===============================================================================
# ELITE Setup Script
# Automated dependency checking and installation
#
# Supports: macOS, Linux, Windows (Git Bash/WSL)
#===============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macOS" ;;
        Linux*)  echo "Linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "Windows" ;;
        *)       echo "Unknown" ;;
    esac
}

OS=$(detect_os)

#===============================================================================
# Print Functions
#===============================================================================

print_header() {
    echo ""
    echo -e "${BOLD}${BLUE}"
    echo "  ╔══════════════════════════════════════════════════════════╗"
    echo "  ║          ELITE Setup - Automated Installation           ║"
    echo "  ╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "Detected OS: ${BOLD}$OS${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}→${NC} $1"
}

print_bold() {
    echo -e "${BOLD}$1${NC}"
}

#===============================================================================
# Claude Code Installation
#===============================================================================

check_claude_code() {
    print_info "Checking Claude Code CLI..."

    if command -v claude &> /dev/null; then
        local version=$(claude --version 2>/dev/null | head -1 || echo "unknown")
        print_success "Claude Code CLI installed: $version"
        return 0
    else
        print_error "Claude Code CLI not found"
        echo ""
        print_bold "Claude Code is required for ELITE."
        echo ""
        echo "Install options:"
        echo ""
        echo "  1. NPM (recommended):"
        echo "       ${YELLOW}npm install -g @anthropic-ai/claude-code${NC}"
        echo ""
        echo "  2. Download from:"
        echo "       ${CYAN}https://claude.ai/code${NC}"
        echo ""
        echo "After installation, run this script again."
        return 1
    fi
}

#===============================================================================
# Node.js Installation
#===============================================================================

check_nodejs() {
    print_info "Checking Node.js..."

    if command -v node &> /dev/null; then
        local version=$(node --version)
        local major=$(echo $version | cut -d'.' -f1 | sed 's/v//')

        if [ "$major" -ge 18 ]; then
            print_success "Node.js installed: $version"
            return 0
        else
            print_warning "Node.js $version (18+ required)"
            echo ""
            echo "Upgrade Node.js:"
            echo ""
            echo "  macOS/Linux:"
            echo "  ${YELLOW}nvm install 18${NC}  # if using nvm"
            echo "  ${YELLOW}brew install node${NC}  # macOS Homebrew"
            echo ""
            echo "  Windows:"
            echo "  Download from: ${CYAN}https://nodejs.org/${NC}"
            return 1
        fi
    else
        print_error "Node.js not found (18+ required)"
        echo ""
        echo "Install Node.js:"
        echo ""
        echo "  macOS/Linux:"
        echo "  ${YELLOW}nvm install 18${NC}  # if using nvm"
        echo "  ${YELLOW}brew install node${NC}  # macOS Homebrew"
        echo ""
        echo "  Windows:"
        echo "  Download from: ${CYAN}https://nodejs.org/${NC}"
        return 1
    fi
}

#===============================================================================
# Python Installation
#===============================================================================

check_python() {
    print_info "Checking Python 3..."

    if command -v python3 &> /dev/null; then
        local version=$(python3 --version 2>&1)
        print_success "$version"
        return 0
    else
        print_error "Python 3 not found"
        echo ""
        echo "Install Python 3:"
        echo ""
        echo "  macOS:"
        echo "  ${YELLOW}brew install python3${NC}"
        echo ""
        echo "  Linux (Ubuntu/Debian):"
        echo "  ${YELLOW}sudo apt-get install python3${NC}"
        echo ""
        echo "  Linux (Fedora/RHEL):"
        echo "  ${YELLOW}sudo dnf install python3${NC}"
        echo ""
        echo "  Windows:"
        echo "  Download from: ${CYAN}https://python.org/${NC}"
        echo "  ${YELLOW}Note:${NC} Check 'Add Python to PATH' during install"
        return 1
    fi
}

#===============================================================================
# TypeScript Installation
#===============================================================================

check_typescript() {
    print_info "Checking TypeScript..."

    if command -v tsc &> /dev/null; then
        local version=$(tsc --version)
        print_success "TypeScript installed: $version"
        return 0
    else
        print_warning "TypeScript not found (installing globally)"
        echo ""
        if npm install -g typescript 2>/dev/null; then
            print_success "TypeScript installed successfully"
            return 0
        else
            print_error "Failed to install TypeScript"
            echo "Install manually: ${YELLOW}npm install -g typescript${NC}"
            return 1
        fi
    fi
}

#===============================================================================
# Git Installation
#===============================================================================

check_git() {
    print_info "Checking Git..."

    if command -v git &> /dev/null; then
        local version=$(git --version 2>&1)
        print_success "$version"
        return 0
    else
        print_warning "Git not found (optional but recommended)"
        echo ""
        echo "Install Git:"
        echo ""
        echo "  macOS:"
        echo "  ${YELLOW}brew install git${NC}"
        echo ""
        echo "  Linux (Ubuntu/Debian):"
        echo "  ${YELLOW}sudo apt-get install git${NC}"
        echo ""
        echo "  Windows:"
        echo "  Download from: ${CYAN}https://git-scm.com/${NC}"
        return 0  # Git is optional, don't fail
    fi
}

#===============================================================================
# Skill Installation
#===============================================================================

install_skill() {
    echo ""
    print_info "Installing ELITE skill..."

    # Determine skill directory based on OS
    local skill_dir=""
    if [ "$OS" = "Windows" ]; then
        # Git Bash on Windows uses HOME
        skill_dir="$HOME/.claude/skills/agent-mode"
    else
        skill_dir="$HOME/.claude/skills/agent-mode"
    fi

    # Create directory
    mkdir -p "$skill_dir"

    # Copy files (cross-platform, no symlinks)
    if cp "$PROJECT_DIR/SKILL.md" "$skill_dir/" 2>/dev/null && \
       cp -r "$PROJECT_DIR/references" "$skill_dir/" 2>/dev/null; then
        print_success "ELITE skill installed to: $skill_dir"
        return 0
    else
        print_error "Failed to install skill"
        echo "Try copying manually:"
        echo "  ${YELLOW}mkdir -p $skill_dir${NC}"
        echo "  ${YELLOW}cp $PROJECT_DIR/SKILL.md $skill_dir/${NC}"
        echo "  ${YELLOW}cp -r $PROJECT_DIR/references $skill_dir/${NC}"
        return 1
    fi
}

#===============================================================================
# ARD Coach Skill Installation
#===============================================================================

install_ard_coach() {
    echo ""
    print_info "Installing ARD Coach skill..."

    local ard_coach_src="$PROJECT_DIR/skills/ard-coach/SKILL.md"
    local ard_coach_dir="$HOME/.claude/skills/ard-coach"

    # Check if ARD Coach exists
    if [ ! -f "$ard_coach_src" ]; then
        print_warning "ARD Coach skill not found (optional)"
        return 0
    fi

    # Create directory and copy
    mkdir -p "$ard_coach_dir"
    if cp "$ard_coach_src" "$ard_coach_dir/" 2>/dev/null; then
        print_success "ARD Coach skill installed to: $ard_coach_dir"
        return 0
    else
        print_warning "Failed to install ARD Coach skill (optional)"
        return 0
    fi
}

#===============================================================================
# Environment Template
#===============================================================================

create_env_template() {
    echo ""
    print_info "Creating environment template..."

    local env_file="$PROJECT_DIR/.env.example"

    if [ ! -f "$env_file" ]; then
        cat > "$env_file" << 'EOF'
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
EOF
        print_success "Created .env.example"
        echo "  ${YELLOW}Note:${NC} Copy to .env if you need custom configuration"
    fi
}

#===============================================================================
# Verification
#===============================================================================

verify_installation() {
    echo ""
    print_info "Verifying installation..."

    local all_good=true

    # Test Claude Code
    if claude --version &> /dev/null 2>&1; then
        print_success "Claude Code accessible"
    else
        print_error "Claude Code not accessible"
        all_good=false
    fi

    # Test skill installation
    if [ -f "$HOME/.claude/skills/agent-mode/SKILL.md" ]; then
        print_success "ELITE skill installed"
    else
        print_error "ELITE skill not found"
        all_good=false
    fi

    return $([ "$all_good" = true ] && echo 0 || echo 1)
}

#===============================================================================
# Main
#===============================================================================

main() {
    print_header

    # Track issues
    local has_issues=false

    # Check dependencies
    check_claude_code || has_issues=true
    check_nodejs || has_issues=true
    check_python || has_issues=true
    check_typescript || has_issues=true
    check_git  # Git is optional, won't set has_issues

    # If missing critical deps, exit
    if [ "$has_issues" = true ]; then
        echo ""
        print_bold "Please install missing dependencies and run again."
        exit 1
    fi

    # Install skill and create templates
    install_skill
    install_ard_coach
    create_env_template

    # Verify
    if verify_installation; then
        echo ""
        echo -e "${GREEN}${BOLD}✓ Setup complete!${NC}"
        echo ""
        echo "Next steps:"
        echo ""
        echo "  1. Read ${CYAN}QUICKSTART.md${NC} for a 3-minute guide"
        echo "  2. Run: ${YELLOW}claude --dangerously-skip-permissions${NC}"
        echo "  3. Say: ${YELLOW}ARD Coach${NC} or ${YELLOW}Agent Mode${NC}"
        echo ""
        echo "Need help? See README.md or docs/tutorial.md"
    else
        echo ""
        print_warning "Setup completed with warnings. See above."
        exit 1
    fi
}

main "$@"
