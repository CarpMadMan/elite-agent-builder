# Claude Code Hook Lifecycle

**Version:** 2.1.0
**Last Updated:** 2024-12-30
**Source:** https://docs.anthropic.com/en/docs/claude-code/hooks

## Overview

Hooks in Claude Code allow you to execute custom scripts at specific points during the Claude Code execution lifecycle. Hooks enable automation, validation, and custom behavior without modifying Claude Code itself.

## Hook Types

### 1. Session Hooks
Run at session-level events.

#### session-start
Runs when a new Claude Code session begins.

**Use cases:**
- Initialize environment
- Validate prerequisites
- Load session configuration

**Location:** `.claude/hooks/session-start.sh`

**Context available:**
- `CLAUDE_SESSION_ID`: Unique session identifier
- `CLAUDE_WORKSPACE`: Current workspace directory
- `CLAUDE_MODE`: Current mode (plan, normal, etc.)

**Example:**
```bash
#!/bin/bash
# .claude/hooks/session-start.sh

echo "Session started: $CLAUDE_SESSION_ID" >> .claude/hooks/session.log
echo "Workspace: $CLAUDE_WORKSPACE" >> .claude/hooks/session.log

# Check prerequisites
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js not found" >&2
    exit 1
fi
```

#### session-end
Runs when a Claude Code session ends.

**Use cases:**
- Cleanup temporary files
- Generate session reports
- Update metrics

**Location:** `.claude/hooks/session-end.sh`

### 2. Tool Hooks
Run around tool invocations.

#### pre-tool
Runs immediately before any tool is invoked.

**Use cases:**
- Validate tool parameters
- Add logging/auditing
- Implement rate limiting

**Location:** `.claude/hooks/pre-tool.sh`

**Context available:**
- `CLAUDE_TOOL_NAME`: Name of tool being called
- `CLAUDE_TOOL_ARGS`: Tool arguments (JSON)
- `CLAUDE_SESSION_ID`: Session identifier

**Example:**
```bash
#!/bin/bash
# .claude/hooks/pre-tool.sh

TOOL_NAME="$CLAUDE_TOOL_NAME"
TOOL_ARGS="$CLAUDE_TOOL_ARGS"

# Log tool invocation
echo "[$(date)] Invoking: $TOOL_NAME" >> .claude/hooks/tool-log.json
echo "Args: $TOOL_ARGS" >> .claude/hooks/tool-log.json

# Validate sensitive operations
if [[ "$TOOL_NAME" == "Edit" ]] && [[ "$TOOL_ARGS" == *"SKILL.md"* ]]; then
    echo "WARNING: Editing skill file" >&2
fi

exit 0
```

#### post-tool
Runs immediately after a tool completes.

**Use cases:**
- Process tool results
- Trigger follow-up actions
- Collect metrics

**Location:** `.claude/hooks/post-tool.sh`

**Context available:**
- `CLAUDE_TOOL_NAME`: Name of tool that was called
- `CLAUDE_TOOL_RESULT`: Result of tool execution
- `CLAUDE_TOOL_ERROR`: Error message if tool failed

**Example:**
```bash
#!/bin/bash
# .claude/hooks/post-tool.sh

TOOL_NAME="$CLAUDE_TOOL_NAME"
TOOL_RESULT="$CLAUDE_TOOL_RESULT"

# Track file edits
if [[ "$TOOL_NAME" == "Edit" ]]; then
    echo "$TOOL_RESULT" >> .claude/hooks/edit-history.log
fi

# Send notifications on errors
if [[ -n "$CLAUDE_TOOL_ERROR" ]]; then
    echo "Tool $TOOL_NAME failed: $CLAUDE_TOOL_ERROR" >&2
    # Send to monitoring service
fi
```

### 3. Message Hooks
Run around message processing.

#### pre-message
Runs before processing a user message.

**Use cases:**
- Message validation
- Input sanitization
- Command expansion

**Location:** `.claude/hooks/pre-message.sh`

#### post-message
Runs after processing a user message.

**Use cases:**
- Response logging
- Analytics collection
- Custom formatting

**Location:** `.claude/hooks/post-message.sh`

### 4. Skill Hooks
Run around skill operations.

#### skill-load
Runs when a skill is loaded.

**Use cases:**
- Validate skill syntax
- Cache skill data
- Initialize skill resources

**Location:** `.claude/hooks/skill-load.sh`

**Context available:**
- `CLAUDE_SKILL_PATH`: Path to skill being loaded
- `CLAUDE_SKILL_NAME`: Name of skill

#### skill-unload
Runs when a skill is unloaded.

**Use cases:**
- Cleanup skill resources
- Save skill state
- Log skill usage

## Hook Execution Order

```
session-start
  |
  +-- pre-message (for each message)
  |     |
  |     +-- pre-tool (for each tool)
  |     |     |
  |     |     +-- [Tool Execution]
  |     |     |
  |     |     +-- post-tool
  |     |
  |     +-- post-message
  |
  +-- session-end
```

## Hook Return Values

### Exit Codes
- `0`: Success, continue execution
- `1`: Error, may block operation
- `2+:` Error, may block operation

**Note:** Non-zero exit codes on `pre-*` hooks may block the associated operation.

### Output to STDOUT
Becomes part of Claude's context for the current operation.

### Output to STDERR
Passed to Claude Code's error logging system.

## Hook Best Practices

### 1. Idempotency
Hooks should be idempotent - running them multiple times should have the same effect:

```bash
#!/bin/bash
# Create directory only if it doesn't exist
mkdir -p .claude/hooks/cache
```

### 2. Fast Execution
Hooks should execute quickly (< 1 second) to avoid blocking Claude:

```bash
#!/bin/bash
# Use background jobs for long-running tasks
if needs_long_running_task; then
    long_running_task &
    echo "Background task started: $!"
fi
```

### 3. Error Handling
Always handle errors gracefully:

```bash
#!/bin/bash

set -euo pipefail

trap 'echo "Hook failed at line $LINENO" >&2' ERR

# Hook logic here
```

### 4. Logging
Log hook activity for debugging:

```bash
#!/bin/bash

LOG_FILE=".claude/hooks/hooks.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log "Hook started with: $*"
```

### 5. Environment Validation
Validate environment before executing:

```bash
#!/bin/bash

# Check required commands
for cmd in git node npm; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERROR: Required command not found: $cmd" >&2
        exit 1
    fi
done
```

## Hook Configuration

### Disabling Hooks
To temporarily disable all hooks:
```bash
export CLAUDE_HOOKS_ENABLED=false
```

To disable a specific hook:
```bash
chmod -x .claude/hooks/pre-tool.sh
```

### Hook Debugging
Enable hook debugging:
```bash
export CLAUDE_HOOKS_DEBUG=true
```

This will output additional information about hook execution.

## Advanced Patterns

### Conditional Hooks
Execute hooks based on conditions:

```bash
#!/bin/bash
# .claude/hooks/pre-tool.sh

# Only run for Edit tool
if [[ "$CLAUDE_TOOL_NAME" != "Edit" ]]; then
    exit 0
fi

# Edit-specific logic
```

### Chained Hooks
Chain multiple hook scripts:

```bash
#!/bin/bash
# .claude/hooks/pre-tool.sh

for hook in .claude/hooks/pre-tool-*.d/*.sh; do
    if [[ -x "$hook" ]]; then
        "$hook" "$@" || exit $?
    fi
done
```

### Asynchronous Hooks
Run hooks asynchronously:

```bash
#!/bin/bash
# .claude/hooks/post-tool.sh

# Queue notification for later
echo "$CLAUDE_TOOL_NAME:$CLAUDE_TOOL_RESULT" >> .claude/hooks/notification-queue.txt
```

## Hook Security

### Input Validation
Always validate hook inputs:

```bash
#!/bin/bash

# Validate file paths
validate_path() {
    local path="$1"
    # Prevent directory traversal
    if [[ "$path" == *".."* ]]; then
        echo "ERROR: Invalid path" >&2
        exit 1
    fi
}

validate_path "$CLAUDE_TOOL_ARGS"
```

### Permission Checks
Check file permissions:

```bash
#!/bin/bash

# Verify file is writable before Edit
if [[ "$CLAUDE_TOOL_NAME" == "Edit" ]]; then
    FILE_PATH=$(echo "$CLAUDE_TOOL_ARGS" | jq -r '.filePath')
    if [[ -f "$FILE_PATH" && ! -w "$FILE_PATH" ]]; then
        echo "ERROR: File not writable: $FILE_PATH" >&2
        exit 1
    fi
fi
```

## Troubleshooting

### Hook Not Running
1. Check execute permissions: `ls -la .claude/hooks/`
2. Check shebang: `head -1 .claude/hooks/hook-name.sh`
3. Run manually: `.claude/hooks/hook-name.sh`

### Hook Blocking Operations
1. Check exit code: `echo $?`
2. Check stderr output
3. Run with debug: `CLAUDE_HOOKS_DEBUG=true claude`

### Performance Issues
1. Profile hook: `time .claude/hooks/hook-name.sh`
2. Optimize slow operations
3. Use background jobs for long tasks

## Further Reading

- [Claude Code Hooks Documentation](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [Custom Hooks Guide](https://docs.anthropic.com/en/docs/claude-code/custom-hooks)
