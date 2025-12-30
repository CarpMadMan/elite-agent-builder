#!/bin/bash
#
# {{HOOK_NAME}} - {{HOOK_DESCRIPTION}}
# Hook Type: {{HOOK_TYPE}}
# Trigger: {{HOOK_TRIGGER}}
#

set -euo pipefail

# Configuration
HOOK_NAME="${HOOK_NAME:-{{HOOK_NAME}}}"
HOOK_VERSION="${HOOK_VERSION:-1.0.0}}"
LOG_FILE="${HOOK_LOG_FILE:-.claude/hooks/${HOOK_NAME}.log}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging function
log() {
    local level="$1"
    shift
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*"
    echo "$message" | tee -a "$LOG_FILE"
}

log_info() { log "INFO" "$*"; }
log_warn() { log "WARN" "$*"; }
log_error() { log "ERROR" "$*"; }

# Main hook logic
{{HOOK_MAIN_FUNCTION}}

# Entry point
main() {
    log_info "Hook ${HOOK_NAME} v${HOOK_VERSION} starting"

    # Parse arguments if needed
    {{HOOK_ARGUMENT_PARSING}}

    # Execute hook logic
    {{HOOK_EXECUTION}}

    log_info "Hook ${HOOK_NAME} completed successfully"
    return 0
}

# Error handling
trap 'log_error "Hook failed with exit code $?"' ERR

# Run main function
main "$@"
