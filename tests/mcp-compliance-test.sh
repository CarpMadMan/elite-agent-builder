#!/bin/bash
#===============================================================================
# MCP Compliance Test
# Tests MCP server compliance with the Model Context Protocol specification
#
# Usage:
#   ./tests/mcp-compliance-test.sh <server_command> <server_args...>
#
# Example:
#   ./tests/mcp-compliance-test.sh node dist/server.js
#===============================================================================

set -euo pipefail

# Configuration
TIMEOUT=5
MAX_TOOLS=100
MAX_RESOURCES=100

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
PASSED=0
FAILED=0
SKIPPED=0

# Server process
SERVER_PID=""
SERVER_OUTPUT=""

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

# Cleanup on exit
cleanup() {
    if [[ -n "$SERVER_PID" ]]; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT INT TERM

#===============================================================================
# Server Management
#===============================================================================

start_server() {
    local cmd="$1"
    shift

    # Start server in background
    SERVER_OUTPUT=$(mktemp)
    "$cmd" "$@" > "$SERVER_OUTPUT" 2>&1 &
    SERVER_PID=$!

    # Wait for server to start
    sleep 2

    # Check if server is running
    if ! kill -0 "$SERVER_PID" 2>/dev/null; then
        cat "$SERVER_OUTPUT"
        return 1
    fi

    echo "$SERVER_PID"
}

send_mcp_request() {
    local request="$1"

    # Send request via stdin
    echo "$request" | timeout "$TIMEOUT" cat | nc -U /tmp/mcp-stdio.sock 2>/dev/null || echo ""
}

#===============================================================================
# Test Cases
#===============================================================================

test_tools_list() {
    log_test "tools/list responds within ${TIMEOUT}s"

    local request='{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    if [[ -z "$response" ]]; then
        log_fail "tools/list: No response"
        return 1
    fi

    # Validate JSON-RPC response
    if ! echo "$response" | jq -e '.result' > /dev/null 2>&1; then
        log_fail "tools/list: Invalid JSON-RPC response"
        echo "Response: $response"
        return 1
    fi

    # Check tools array
    local tools
    tools=$(echo "$response" | jq -r '.result.tools // []')

    if [[ "$tools" == "[]" ]]; then
        log_skip "tools/list: No tools defined"
        return 0
    fi

    local tool_count
    tool_count=$(echo "$response" | jq '.result.tools | length')

    if [[ "$tool_count" -gt "$MAX_TOOLS" ]]; then
        log_fail "tools/list: Too many tools ($tool_count > $MAX_TOOLS)"
        return 1
    fi

    log_pass "tools/list: Responded with $tool_count tools"
}

test_tool_schemas() {
    log_test "Tool schemas are valid"

    local request='{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    local tools
    tools=$(echo "$response" | jq -r '.result.tools // []')

    if [[ "$tools" == "[]" ]]; then
        log_skip "No tools to validate"
        return 0
    fi

    local tool_count
    tool_count=$(echo "$tools" | jq '. | length')

    for ((i=0; i<tool_count; i++)); do
        local tool_name
        tool_name=$(echo "$tools" | jq -r ".[$i].name // empty")

        if [[ -z "$tool_name" ]]; then
            log_fail "Tool at index $i: Missing name"
            continue
        fi

        local description
        description=$(echo "$tools" | jq -r ".[$i].description // empty")

        if [[ -z "$description" ]]; then
            log_fail "Tool '$tool_name': Missing description"
            continue
        fi

        local schema
        schema=$(echo "$tools" | jq ".[$i].inputSchema // {}")

        # Validate JSON schema
        if ! echo "$schema" | jq -e '.type == "object"' > /dev/null 2>&1; then
            log_fail "Tool '$tool_name': Invalid inputSchema (must be object type)"
            continue
        fi

        local required
        required=$(echo "$schema" | jq -r '.required // []')

        # Check that required fields exist in properties
        for req in $(echo "$required" | jq -r '.[]'); do
            if ! echo "$schema" | jq -e ".properties.$req" > /dev/null 2>&1; then
                log_fail "Tool '$tool_name': Required field '$req' not in properties"
            fi
        done
    done

    log_pass "Tool schemas validated"
}

test_resources_list() {
    log_test "resources/list responds"

    local request='{"jsonrpc":"2.0","id":1,"method":"resources/list","params":{}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    if [[ -z "$response" ]]; then
        log_fail "resources/list: No response"
        return 1
    fi

    if ! echo "$response" | jq -e '.result' > /dev/null 2>&1; then
        log_fail "resources/list: Invalid JSON-RPC response"
        return 1
    fi

    local resources
    resources=$(echo "$response" | jq -r '.result.resources // []')

    if [[ "$resources" == "[]" ]]; then
        log_skip "resources/list: No resources defined"
        return 0
    fi

    local resource_count
    resource_count=$(echo "$response" | jq '.result.resources | length')

    if [[ "$resource_count" -gt "$MAX_RESOURCES" ]]; then
        log_fail "resources/list: Too many resources ($resource_count > $MAX_RESOURCES)"
        return 1
    fi

    log_pass "resources/list: Responded with $resource_count resources"
}

test_prompts_list() {
    log_test "prompts/list responds"

    local request='{"jsonrpc":"2.0","id":1,"method":"prompts/list","params":{}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    if [[ -z "$response" ]]; then
        log_fail "prompts/list: No response"
        return 1
    fi

    if ! echo "$response" | jq -e '.result' > /dev/null 2>&1; then
        log_fail "prompts/list: Invalid JSON-RPC response"
        return 1
    fi

    log_pass "prompts/list: Responded correctly"
}

test_initialize() {
    log_test "initialize handshake"

    local request='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test-client","version":"1.0.0"}}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    if [[ -z "$response" ]]; then
        log_fail "initialize: No response"
        return 1
    fi

    if ! echo "$response" | jq -e '.result.serverInfo' > /dev/null 2>&1; then
        log_fail "initialize: Invalid response (missing serverInfo)"
        return 1
    fi

    local server_name
    server_name=$(echo "$response" | jq -r '.result.serverInfo.name // empty')

    if [[ -z "$server_name" ]]; then
        log_fail "initialize: Missing server name"
        return 1
    fi

    local server_version
    server_version=$(echo "$response" | jq -r '.result.serverInfo.version // empty')

    if [[ -z "$server_version" ]]; then
        log_fail "initialize: Missing server version"
        return 1
    fi

    log_pass "initialize: Server '$server_name' v$server_version"
}

test_json_rpc_format() {
    log_test "JSON-RPC format compliance"

    local request='{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    # Check for JSON-RPC version
    local jsonrpc_version
    jsonrpc_version=$(echo "$response" | jq -r '.jsonrpc // empty')

    if [[ "$jsonrpc_version" != "2.0" ]]; then
        log_fail "JSON-RPC version mismatch (got: $jsonrpc_version, expected: 2.0)"
        return 1
    fi

    # Check for id
    local id
    id=$(echo "$response" | jq -e '.id' > /dev/null 2>&1 && echo "present" || echo "missing")

    if [[ "$id" == "missing" ]]; then
        log_fail "JSON-RPC: Missing id field"
        return 1
    fi

    log_pass "JSON-RPC format compliant"
}

test_error_response() {
    log_test "Error response format"

    # Call invalid method
    local request='{"jsonrpc":"2.0","id":1,"method":"invalid_method","params":{}}'
    local response
    response=$(echo "$request" | timeout "$TIMEOUT" "$@" 2>&1 || echo "")

    if echo "$response" | jq -e '.result' > /dev/null 2>&1; then
        log_fail "Error response: Got result instead of error"
        return 1
    fi

    if ! echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        log_fail "Error response: Missing error field"
        return 1
    fi

    local error_code
    error_code=$(echo "$response" | jq -r '.error.code // empty')

    if [[ -z "$error_code" ]]; then
        log_fail "Error response: Missing error code"
        return 1
    fi

    log_pass "Error response format valid (code: $error_code)"
}

#===============================================================================
# Main
#===============================================================================

main() {
    echo "=========================================="
    echo "MCP Compliance Test Suite"
    echo "=========================================="
    echo ""

    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <server_command> <server_args...>"
        echo ""
        echo "Example:"
        echo "  $0 node dist/server.js"
        exit 1
    fi

    local server_cmd="$*"
    echo "Testing server: $server_cmd"
    echo ""

    # Run tests
    test_initialize "$@"
    test_json_rpc_format "$@"
    test_tools_list "$@"
    test_tool_schemas "$@"
    test_resources_list "$@"
    test_prompts_list "$@"
    test_error_response "$@"

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
