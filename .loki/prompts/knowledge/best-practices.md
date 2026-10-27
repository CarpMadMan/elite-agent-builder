# Agent Development Best Practices

**Version:** 1.0.0
**Last Updated:** 2024-12-30

## Overview

This document compiles best practices for building Claude Code agent systems including MCP servers, Agent SDK agents, Skills, and Hooks.

## MCP Server Best Practices

### 1. Tool Design

**DO:**
- Use clear, descriptive tool names (snake_case)
- Provide detailed descriptions
- Use appropriate JSON Schema types
- Include examples in descriptions

**DON'T:**
- Use abbreviations in tool names
- Create overly complex schemas
- Skip required field validation

```typescript
// Good
{
  name: "create_github_issue",
  description: "Create a new issue in a GitHub repository. Requires repo owner, repo name, title, and optionally a body and labels.",
  inputSchema: {
    type: "object",
    properties: {
      owner: {
        type: "string",
        description: "Repository owner (username or organization)"
      },
      repo: {
        type: "string",
        description: "Repository name"
      },
      title: {
        type: "string",
        description: "Issue title"
      },
      body: {
        type: "string",
        description: "Issue body/description (optional)"
      },
      labels: {
        type: "array",
        items: {type: "string"},
        description: "Array of label names to apply (optional)"
      }
    },
    required: ["owner", "repo", "title"]
  }
}
```

### 2. Error Handling

**DO:**
- Return structured error responses
- Use appropriate HTTP status codes
- Include helpful error messages
- Log errors for debugging

```typescript
try {
  const result = await apiCall(args);
  return { content: [{ type: 'text', text: JSON.stringify(result) }] };
} catch (error) {
  if (error.response?.status === 404) {
    return {
      content: [{ type: 'text', text: 'Resource not found' }],
      isError: true
    };
  }
  throw error;
}
```

### 3. Performance

**DO:**
- Cache expensive operations
- Use streaming for large responses
- Implement timeout handling
- Profile performance bottlenecks

```typescript
// Cache example
const cache = new Map();
const CACHE_TTL = 60000; // 1 minute

async function getCachedData(key: string) {
  const cached = cache.get(key);
  if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
    return cached.data;
  }

  const data = await fetchData(key);
  cache.set(key, { data, timestamp: Date.now() });
  return data;
}
```

### 4. Security

**DO:**
- Validate all input parameters
- Sanitize user input
- Use environment variables for secrets
- Implement rate limiting

```typescript
import { z } from 'zod';

const CreateIssueSchema = z.object({
  owner: z.string().min(1).max(39),
  repo: z.string().min(1).max(100),
  title: z.string().min(1).max(256),
  body: z.string().max(65536).optional(),
  labels: z.array(z.string()).optional()
});

function validateInput(input: unknown) {
  return CreateIssueSchema.parse(input);
}
```

## Agent SDK Best Practices

### 1. Decision Loop Design

**DO:**
- Set clear termination conditions
- Log all decisions
- Implement checkpointing
- Handle all edge cases

```typescript
class WellDesignedAgent {
  private decisions: Array<{timestamp: Date, action: string, reasoning: string}> = [];

  async run(goal: string): Promise<string> {
    this.logDecision('start', `Starting agent with goal: ${goal}`);

    while (!this.isGoalComplete()) {
      this.checkpoint();

      const action = await this.decideNextAction();
      this.logDecision('action', `Executing: ${action.name}`, action.reasoning);

      const result = await this.executeAction(action);
      this.updateState(result);

      if (this.iterationCount > this.maxIterations) {
        throw new Error('Max iterations exceeded');
      }
    }

    return this.formatResult();
  }

  private logDecision(type: string, action: string, reasoning?: string) {
    this.decisions.push({
      timestamp: new Date(),
      action: `${type}: ${action}`,
      reasoning: reasoning || ''
    });
  }
}
```

### 2. Tool Calling

**DO:**
- Handle tool errors gracefully
- Validate tool inputs
- Implement retries with backoff
- Aggregate results properly

```typescript
async function callToolWithRetry(
  toolName: string,
  input: any,
  maxRetries = 3
): Promise<any> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await this.executeTool(toolName, input);
    } catch (error) {
      if (i === maxRetries - 1) throw error;

      const isRetryable = error.status >= 500 || error.status === 429;
      if (!isRetryable) throw error;

      const delay = Math.pow(2, i) * 1000; // Exponential backoff
      await this.sleep(delay);
    }
  }
}
```

### 3. State Management

**DO:**
- Persist state regularly
- Use atomic writes
- Implement versioning
- Handle corruption recovery

```typescript
class StateManager {
  async save(state: any): Promise<void> {
    const tempPath = `${this.statePath}.tmp`;
    await fs.writeFile(tempPath, JSON.stringify(state, null, 2));
    await fs.rename(tempPath, this.statePath); // Atomic
  }

  async load(): Promise<any> {
    try {
      const data = await fs.readFile(this.statePath, 'utf-8');
      return JSON.parse(data);
    } catch (error) {
      if (error.code === 'ENOENT') {
        return this.getInitialState();
      }
      throw error;
    }
  }
}
```

## Skill Best Practices

### 1. Progressive Disclosure

**DO:**
- Keep frontmatter concise
- Load details only when needed
- Structure content hierarchically
- Use clear sections

```markdown
---
name: my-skill
description: Brief one-line description
---

# My Skill

Quick overview (2-3 sentences).

## When to Use
- Use case 1
- Use case 2

## Examples
<!-- Detailed examples only loaded when needed -->

## Implementation Details
<!-- Technical details only loaded when needed -->
```

### 2. Code Embedding

**DO:**
- Keep code snippets focused
- Add explanatory comments
- Use syntax highlighting
- Test code independently

```markdown
## Implementation

\`\`\`python
def calculate_metrics(data):
    """
    Calculate quality metrics from dataset.

    Args:
        data: Dictionary with 'values' key

    Returns:
        Dictionary with 'mean', 'median', 'std' keys
    """
    import statistics
    values = data['values']
    return {
        'mean': statistics.mean(values),
        'median': statistics.median(values),
        'std': statistics.stdev(values) if len(values) > 1 else 0
    }
\`\`\`
```

### 3. Portability

**DO:**
- Avoid platform-specific code
- Use standard libraries when possible
- Document platform requirements
- Test on multiple platforms

```markdown
## Platform Requirements

- Python 3.8+
- Works on Linux, macOS, Windows
- Requires: `requests`, `pandas` packages

Install with: `pip install requests pandas`
```

## Hook Best Practices

### 1. Fast Execution

**DO:**
- Keep hooks under 1 second
- Use background jobs for long tasks
- Cache expensive operations
- Avoid unnecessary I/O

```bash
#!/bin/bash
# Fast hook example

# Use cache
CACHE_FILE=".claude/hooks/cache/state.txt"
CACHE_TTL=60

if [[ -f "$CACHE_FILE" ]]; then
    LAST_UPDATE=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE")
    NOW=$(date +%s)

    if [[ $((NOW - LAST_UPDATE)) -lt $CACHE_TTL ]]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Generate and cache
generate_state > "$CACHE_FILE"
cat "$CACHE_FILE"
```

### 2. Error Handling

**DO:**
- Use `set -euo pipefail`
- Trap errors appropriately
- Provide meaningful error messages
- Clean up on failure

```bash
#!/bin/bash

set -euo pipefail

cleanup() {
    # Clean up temporary files
    rm -f /tmp/hook-temp-$$
}

trap cleanup EXIT INT TERM

# Hook logic here
```

### 3. Idempotency

**DO:**
- Make hooks idempotent
- Use `mkdir -p` instead of `mkdir`
- Check before creating
- Handle existing state

```bash
#!/bin/bash

# Idempotent directory creation
mkdir -p .claude/hooks/{pre,post}

# Idempotent configuration
if ! grep -q "HOOK_CONFIG" .claude/config.json 2>/dev/null; then
    echo '{"HOOK_CONFIG": true}' >> .claude/config.json
fi
```

## Testing Best Practices

### 1. Unit Testing

```typescript
import { describe, it, expect } from 'vitest';

describe('MCP Server', () => {
  it('should list tools', async () => {
    const tools = await server.tools_list();
    expect(tools.tools).toHaveLength(3);
    expect(tools.tools[0].name).toBe('create_issue');
  });

  it('should validate tool input', async () => {
    const result = await server.tools_call({
      name: 'create_issue',
      arguments: {owner: 'test', repo: 'test'}
    });
    expect(result.isError).toBe(true); // Missing title
  });
});
```

### 2. Integration Testing

```typescript
describe('Agent Integration', () => {
  it('should complete workflow', async () => {
    const agent = new TestAgent();
    const result = await agent.run('Create a GitHub issue');

    expect(result).toContain('Issue created');
    expect(mockGitHubAPI.createIssue).toHaveBeenCalled();
  });
});
```

### 3. Conversation Testing

```typescript
describe('Agent Conversation', () => {
  it('should reach goal in N turns', async () => {
    const agent = new ConversationAgent();
    let turns = 0;
    const maxTurns = 10;

    await agent.run('Summarize the file', {
      onTurn: async (response) => {
        turns++;
        if (turns > maxTurns) {
          throw new Error('Max turns exceeded');
        }
      }
    });

    expect(turns).toBeLessThanOrEqual(5);
  });
});
```

## Deployment Best Practices

### 1. Versioning
Use semantic versioning:
- `MAJOR`: Breaking changes
- `MINOR`: New features, backward compatible
- `PATCH`: Bug fixes

### 2. Documentation
- Always update README with version changes
- Document breaking changes prominently
- Provide migration guides
- Keep examples current

### 3. Monitoring
- Log important events
- Track performance metrics
- Set up health checks
- Configure alerts

### 4. Security
- Scan dependencies for vulnerabilities
- Use `npm audit` or equivalent
- Keep dependencies updated
- Review security advisories

## Common Pitfalls to Avoid

### MCP Servers
1. Blocking the event loop
2. Missing error handling
3. Slow tools/list responses
4. Invalid JSON schemas
5. Exposing sensitive data

### Agent SDK
1. Infinite loops (always set max iterations)
2. No state persistence
3. Ignoring errors
4. Hardcoded values
5. No monitoring

### Skills
1. Overly verbose descriptions
2. Platform-specific code
3. Untested code snippets
4. Missing examples
5. Poor organization

### Hooks
1. Slow execution
2. Non-idempotent operations
3. Poor error handling
4. Missing cleanup
5. No logging

## Resources

- [MCP Specification](https://modelcontextprotocol.io/specification)
- [Agent SDK Docs](https://docs.anthropic.com/en/docs/claude-code/agent-sdk)
- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Skills Guide](https://docs.anthropic.com/en/docs/claude-code/skills)
