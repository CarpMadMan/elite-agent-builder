#!/bin/bash
#===============================================================================
# Conversation Flow Test
# Tests agent conversation flows and goal achievement
#
# Usage:
#   ./tests/conversation-flow-test.sh <agent_command> <test_scenario>
#
# Example:
#   ./tests/conversation-flow-test.sh node dist/agent.js scenarios/simple-goal.json
#===============================================================================

set -euo pipefail

# Configuration
MAX_TURNS=10
TIMEOUT_PER_TURN=30

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

#===============================================================================
# Test Scenarios
#===============================================================================

run_scenario() {
    local scenario_file="$1"
    shift
    local agent_cmd="$*"

    log_info "Running scenario: $scenario_file"

    # Load scenario
    if [[ ! -f "$scenario_file" ]]; then
        log_fail "Scenario file not found: $scenario_file"
        return 1
    fi

    local initial_prompt
    initial_prompt=$(jq -r '.initialPrompt // ""' "$scenario_file")

    local expected_goal
    expected_goal=$(jq -r '.expectedGoal // ""' "$scenario_file")

    local max_turns
    max_turns=$(jq -r '.maxTurns // "'$MAX_TURNS'"' "$scenario_file")

    local turns=0
    local goal_reached=false

    # Run conversation
    while [[ $turns -lt $max_turns ]]; do
        log_info "Turn $((turns + 1))/$max_turns"

        # Send message to agent
        local response
        response=$(echo "$initial_prompt" | timeout "$TIMEOUT_PER_TURN" $agent_cmd 2>&1 || echo "")

        if [[ -z "$response" ]]; then
            log_fail "No response from agent"
            break
        fi

        log_info "Agent: $response"

        # Check if goal is reached
        if [[ -n "$expected_goal" ]]; then
            if echo "$response" | grep -qi "$expected_goal"; then
                log_pass "Goal reached: $expected_goal"
                goal_reached=true
                break
            fi
        fi

        # Check for completion markers
        if echo "$response" | grep -qi "done\|complete\|finished\|task complete"; then
            log_pass "Agent indicated completion"
            goal_reached=true
            break
        fi

        # Get next prompt from scenario (if defined)
        local next_prompts
        next_prompts=$(jq -r ".turns[$turns].prompt // \"\"" "$scenario_file")

        if [[ "$next_prompts" != "null" && -n "$next_prompts" ]]; then
            initial_prompt="$next_prompts"
        else
            # Use agent's response to generate next prompt
            initial_prompt="What's next?"
        fi

        ((turns++))
    done

    if [[ "$goal_reached" == "false" ]]; then
        log_fail "Goal not reached after $max_turns turns"
        return 1
    fi

    return 0
}

test_tool_invocation() {
    local scenario_file="$1"
    shift
    local agent_cmd="$*"

    log_test "Tool invocation in scenario: $scenario_file"

    # Check if scenario requires tools
    local required_tools
    required_tools=$(jq -r '.requiredTools // []' "$scenario_file")

    if [[ "$required_tools" == "[]" ]]; then
        log_skip "No tools required for this scenario"
        return 0
    fi

    # Run scenario and capture tool calls
    local tool_calls=()
    local turn=0

    while [[ $turn -lt $MAX_TURNS ]]; do
        local response
        response=$(timeout "$TIMEOUT_PER_TURN" $agent_cmd 2>&1 || echo "")

        # Extract tool calls from response
        # (This depends on how your agent outputs tool calls)
        # Adjust pattern as needed

        ((turn++))
    done

    # Verify required tools were called
    for tool in $(echo "$required_tools" | jq -r '.[]'); do
        if [[ ! " ${tool_calls[*]} " =~ " $tool " ]]; then
            log_fail "Required tool '$tool' was not called"
            return 1
        fi
    done

    log_pass "All required tools were called"
}

test_turn_limit() {
    local scenario_file="$1"

    log_test "Agent completes within turn limit"

    local max_turns
    max_turns=$(jq -r '.maxTurns // "'$MAX_TURNS'"' "$scenario_file")

    local suggested_turns
    suggested_turns=$(jq -r '.suggestedTurns // null' "$scenario_file")

    if [[ "$suggested_turns" == "null" ]]; then
        log_skip "No suggested turn limit in scenario"
        return 0
    fi

    if [[ $suggested_turns -lt $max_turns ]]; then
        log_info "Scenario suggests $suggested_turns turns (max: $max_turns)"
    fi
}

#===============================================================================
# Main
#===============================================================================

main() {
    echo "=========================================="
    echo "Conversation Flow Test Suite"
    echo "=========================================="
    echo ""

    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 <agent_command> <scenario_file>"
        echo ""
        echo "Example:"
        echo "  $0 node dist/agent.js scenarios/simple-goal.json"
        exit 1
    fi

    local agent_cmd="$1"
    local scenario_file="$2"

    echo "Agent: $agent_cmd"
    echo "Scenario: $scenario_file"
    echo ""

    # Run tests
    run_scenario "$scenario_file" "$agent_cmd"
    test_tool_invocation "$scenario_file" "$agent_cmd"
    test_turn_limit "$scenario_file"

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
