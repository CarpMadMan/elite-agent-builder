# ARD: Pre-Tool Hook for Validation

## Overview
Create a Claude Code hook that validates tool parameters before execution, preventing dangerous operations.

## Hook Type
pre-tool

## Features

### Validations
1. **File Path Validation**
   - Reject paths with directory traversal (`../..`)
   - Reject paths outside project directory
   - Validate file extensions

2. **Permission Check**
   - Verify file exists before editing
   - Check write permissions
   - Warn about read-only files

3. **Parameter Validation**
   - Type checking
   - Range validation
   - Required field checking

### Security Checks
- Prevent editing sensitive files (.env, .ssh/, etc.)
- Block destructive operations on core files
- Warn about large file operations

## Tech Stack
- Bash (for Claude Code compatibility)

## Hook Script

```bash
#!/usr/bin/env bash
# pre-tool-hook: Validate tool parameters before execution

# Security checks
validate_file_path() {
    local path="$1"

    # Block directory traversal
    if [[ "$path" == *".."* ]]; then
        echo "Error: Directory traversal not allowed"
        return 1
    fi

    # Block sensitive files
    local sensitive=(".env" ".ssh" ".aws/credentials")
    for file in "${sensitive[@]}"; do
        if [[ "$path" == *"$file"* ]]; then
            echo "Error: Cannot edit sensitive file: $file"
            return 1
        fi
    done

    return 0
}

# Check write permissions
check_write_permission() {
    local path="$1"

    if [ -f "$path" ] && [ ! -w "$path" ]; then
        echo "Warning: No write permission for $path"
        return 1
    fi

    return 0
}

# Main validation
main() {
    local tool_name="$1"
    shift
    local params=("$@")

    # Validate file paths in parameters
    for param in "${params[@]}"; do
        if [[ "$param" == *"file="* ]] || [[ "$param" == *"path="* ]]; then
            local file_path="${param#*=}"
            validate_file_path "$file_path" || exit 1
            check_write_permission "$file_path"
        fi
    done

    return 0
}

main "$@"
```

## Success Criteria
- Executes in <1s (Claude Code requirement)
- Idempotent (running multiple times is safe)
- Handles errors gracefully
- Returns appropriate exit codes
- Clear error messages

## Installation

```bash
# Place in Claude Code hooks directory
cp pre-tool-hook.sh ~/.claude/hooks/pre-tool-hook
chmod +x ~/.claude/hooks/pre-tool-hook
```

## Configuration

```bash
# Enable hook in Claude Code config
echo "pre-tool-hook: enabled" >> ~/.claude/config.json
```

## Out of Scope
- Post-tool validation
- Async validation
- Remote validation
- Caching

## Testing

```bash
# Test execution speed
time ./pre-tool-hook.sh edit file_path=/etc/passwd
# Should reject in <1s

# Test idempotency
./pre-tool-hook.sh edit file_path=test.txt
./pre-tool-hook.sh edit file_path=test.txt
# Both runs should have same result
```
