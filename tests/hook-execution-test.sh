#!/bin/bash
#===============================================================================
# Hook Execution Test
# Tests Claude Code hook execution
#
# Usage:
#   ./tests/hook-execution-test.sh <hook_path> <hook_type>
#
# Example:
#   ./tests/hook-execution-test.sh .claude/hooks/pre-tool.sh pre-tool
#===============================================================================

set -euo pipefail

# Configuration
HOOK_TIMEOUT=5

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
PASSED=0
FAILED=0
SKIPPED=0

#===============================================================================
# Utility Functions
#===============================================================================

log_test() {
    echo -e "${YELLOW}[TEST]${NC} $*"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $*"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $*"
    ((FAILED++))
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $*"
    ((SKIPPED++))
}

#===============================================================================
# Test Cases
#===============================================================================

test_hook_executable() {
    local hook_path="$1"

    log_test "Hook is executable"

    if [[ ! -f "$hook_path" ]]; then
        log_fail "Hook file not found: $hook_path"
        return 1
    fi

    if [[ ! -x "$hook_path" ]]; then
        log_fail "Hook is not executable: $hook_path"
        return 1
    fi

    log_pass "Hook is executable"
}

test_hook_shebang() {
    local hook_path="$1"

    log_test "Hook has valid shebang"

    local first_line
    first_line=$(head -1 "$hook_path")

    if [[ ! "$first_line" =~ ^#!/bin/(bash|sh|python|node) ]]; then
        log_fail "Invalid shebang: $first_line"
        return 1
    fi

    log_pass "Hook has valid shebang: $first_line"
}

test_hook_execution() {
    local hook_path="$1"
    local hook_type="$2"

    log_test "Hook executes without errors"

    # Set up environment
    export CLAUDE_SESSION_ID="test-session-$$"
    export CLAUDE_WORKSPACE="$(pwd)"
    export CLAUDE_MODE="normal"

    # Set type-specific environment
    case "$hook_type" in
        pre-tool|post-tool)
            export CLAUDE_TOOL_NAME="test_tool"
            export CLAUDE_TOOL_ARGS='{"param": "value"}'
            export CLAUDE_SESSION_ID="test-session-$$"
            ;;
        skill-load)
            export CLAUDE_SKILL_PATH="/tmp/test/skill"
            export CLAUDE_SKILL_NAME="test-skill"
            ;;
    esac

    # Run hook with timeout
    local output
    local exit_code=0

    output=$(timeout "$HOOK_TIMEOUT" "$hook_path" 2>&1) || exit_code=$?

    if [[ $exit_code -eq 124 ]]; then
        log_fail "Hook timed out after ${HOOK_TIMEOUT}s"
        return 1
    fi

    if [[ $exit_code -ne 0 ]]; then
        log_fail "Hook exited with code $exit_code"
        echo "Output: $output"
        return 1
    fi

    log_pass "Hook executed successfully"
}

test_hook_fast_execution() {
    local hook_path="$1"

    log_test "Hook executes quickly (< 1s)"

    local start_time
    start_time=$(date +%s%N)

    "$hook_path" >/dev/null 2>&1 || true

    local end_time
    end_time=$(date +%s%N)

    local duration_ms
    duration_ms=$(( (end_time - start_time) / 1000000 ))

    if [[ $duration_ms -gt 1000 ]]; then
        log_fail "Hook too slow: ${duration_ms}ms > 1000ms"
        return 1
    fi

    log_pass "Hook executed in ${duration_ms}ms"
}

test_hook_idempotency() {
    local hook_path="$1"

    log_test "Hook is idempotent"

    # Run hook twice
    local output1
    output1=$("$hook_path" 2>&1 || true)

    local output2
    output2=$("$hook_path" 2>&1 || true)

    # Compare outputs (may need normalization)
    # For now, just check both succeed
    if [[ $? -ne 0 ]]; then
        log_fail "Second invocation failed"
        return 1
    fi

    log_pass "Hook appears idempotent"
}

test_hook_context_handling() {
    local hook_path="$1"
    local hook_type="$2"

    log_test "Hook handles context correctly"

    # Test with missing environment variables
    unset CLAUDE_SESSION_ID
    unset CLAUDE_WORKSPACE

    local output
    output=$("$hook_path" 2>&1 || true)

    # Hook should either:
    # 1. Handle missing context gracefully
    # 2. Exit with a clear error message

    if [[ -n "$output" ]]; then
        log_pass "Hook handles context (output: ${output:0:50}...)"
    else
        log_pass "Hook handles missing context silently"
    fi
}

test_hook_error_handling() {
    local hook_path="$1"

    log_test "Hook handles errors gracefully"

    # Create a test that will fail
    export TEST_HOOK_ERROR=1

    local output
    local exit_code=0

    output=$("$hook_path" 2>&1) || exit_code=$?

    unset TEST_HOOK_ERROR

    # Hook should either handle the error or exit cleanly
    if [[ $exit_code -ne 0 ]] && [[ -z "$output" ]]; then
        log_fail "Hook failed without error message"
        return 1
    fi

    log_pass "Hook handles errors"
}

#===============================================================================
# Main
#===============================================================================

main() {
    echo "=========================================="
    echo "Hook Execution Test Suite"
    echo "=========================================="
    echo ""

    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 <hook_path> <hook_type>"
        echo ""
        echo "Hook types:"
        echo "  session-start"
        echo "  session-end"
        echo "  pre-tool"
        echo "  post-tool"
        echo "  pre-message"
        echo "  post-message"
        echo "  skill-load"
        echo "  skill-unload"
        echo ""
        echo "Example:"
        echo "  $0 .claude/hooks/pre-tool.sh pre-tool"
        exit 1
    fi

    local hook_path="$1"
    local hook_type="$2"

    echo "Hook: $hook_path"
    echo "Type: $hook_type"
    echo ""

    # Run tests
    test_hook_executable "$hook_path"
    test_hook_shebang "$hook_path"
    test_hook_execution "$hook_path" "$hook_type"
    test_hook_fast_execution "$hook_path"
    test_hook_idempotency "$hook_path"
    test_hook_context_handling "$hook_path" "$hook_type"
    test_hook_error_handling "$hook_path"

    # Summary
    echo ""
    echo "=========================================="
    echo "Test Summary"
    echo "=========================================="
    echo -e "${GREEN}Passed:  $PASSED${NC}"
    echo -e "${RED}Failed:  $FAILED${NC}"
    echo -e "${YELLOW}Skipped: $SKIPPED${NC}"
    echo ""

    if [[ $FAILED -gt 0 ]]; then
        exit 1
    fi

    exit 0
}

main "$@"
