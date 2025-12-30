# ARD: Complete Multi-Component Agent System

## Overview
Build a complete agent system for GitHub issue management, integrating:
1. MCP Server for GitHub API access
2. Agent SDK orchestrator for autonomous workflows
3. Custom skill for Claude Code integration
4. Hooks for lifecycle events

## Components

### 1. MCP Server (github-mcp)

**Purpose:** Provide GitHub API access as tools and resources

**Tools:**
- `list_issues` - List repository issues
- `create_issue` - Create a new issue
- `update_issue` - Update issue status/labels
- `add_comment` - Comment on an issue

**Resources:**
- `issues://list` - All issues
- `repos:///info` - Repository metadata

**Tech Stack:**
- TypeScript
- @modelcontextprotocol/sdk
- Octokit (GitHub API)
- stdio transport

### 2. Agent SDK (issue-agent)

**Purpose:** Autonomous agent that manages issues using MCP tools

**Capabilities:**
- Analyze issue patterns
- Auto-label issues
- Triage new issues
- Generate issue summaries
- Suggest assignees based on code ownership

**Agent Pattern:** Autonomous Loop with goal-seeking

**Tech Stack:**
- Agent SDK
- @anthropic-ai/sdk
- File-based checkpoints
- MCP tool integration

### 3. Skill (github-skill)

**Purpose:** Claude Code skill for GitHub operations

**Trigger:** "GitHub Mode"

**Features:**
- Quick access to common GitHub operations
- Issue templates
- PR review assistance
- Release notes generation

**Structure:**
```
SKILL.md (with YAML frontmatter)
README.md (usage guide)
templates/ (issue templates)
```

### 4. Hooks

**pre-tool-hook** - Validate GitHub tokens
```bash
#!/bin/bash
# Check if GITHUB_TOKEN is valid
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN not set"
  return 1
fi
# Validate token
curl -f -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user || return 1
```

**post-tool-hook** - Log API calls
```bash
#!/bin/bash
# Log all GitHub API calls for audit
echo "[$(date)] GitHub API: $@" >> .github-audit.log
```

**session-start-hook** - Initialize environment
```bash
#!/bin/bash
# Set up GitHub CLI
gh auth status
export GITHUB_TOKEN=$(gh auth token)
```

## Tech Stack

| Component | Language/Framework |
|-----------|-------------------|
| MCP Server | TypeScript, @modelcontextprotocol/sdk |
| Agent SDK | Agent SDK, @anthropic-ai/sdk |
| Skill | Markdown + Bash |
| Hooks | Bash/Python |

## Success Criteria

### MCP Server
- tools/list responds in <5s
- All tools work with real GitHub API
- MCP compliance test passes

### Agent SDK
- Reaches goals autonomously
- Handles rate limits gracefully
- State persists across restarts

### Skill
- Loads in Claude Code
- Trigger phrase works
- Help text is clear

### Hooks
- Execute on lifecycle events
- Run in <1s each
- Idempotent
- Error handling works

### Integration
- All components work together
- Agent can use MCP tools
- Hooks validate/supplement operations
- Skill provides unified interface

## Out of Scope
- Web UI
- Database persistence
- Multi-repo management
- Real-time notifications

## Testing Strategy

1. **MCP Compliance:** `./tests/mcp-compliance-test.sh`
2. **Conversation Flow:** Test agent with various goals
3. **Hook Execution:** `./tests/hook-execution-test.sh`
4. **Integration:** End-to-end workflow test

## Deployment

```bash
# Install MCP server
npm install -g github-mcp

# Configure Claude Code
echo "github-mcp" >> ~/.claude/mcp-servers.json

# Install skill
cp -r github-skill ~/.claude/skills/

# Install hooks
cp hooks/* ~/.claude/hooks/
```
