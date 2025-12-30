# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ELITE** (Emergent Layered Intelligence for Technical Execution) is a multi-agent autonomous system that transforms Agent Requirements Documents (ARDs) into complete Claude Code agent systems with zero human intervention. It orchestrates 21 specialized AI agents across 5 swarms: Architecture, Implementation, Integration, Testing, and Documentation.

The system generates:
- **MCP Servers** - Model Context Protocol servers (TypeScript)
- **Agent SDK Agents** - Autonomous agents using Anthropic SDK
- **Skills** - Portable markdown + code tools for Claude Code
- **Hooks** - Bash/Python scripts for Claude Code lifecycle events
- **Multi-Agent Workflows** - Coordinated agent systems

## Key Commands

### Autonomous Execution (Recommended)
```bash
# Fully autonomous with auto-resume
./autonomy/run.sh ./docs/requirements.md

# Interactive mode
./autonomy/run.sh
```

### Manual Mode (for debugging)
```bash
# Launch with autonomous permissions
claude --dangerously-skip-permissions

# Trigger agent mode
> Agent Mode
> Agent Mode with ARD at ./examples/simple-mcp-server.md
```

### ARD Coach (for requirements development)
```bash
# Launch Claude Code
claude --dangerously-skip-permissions

# Trigger ARD Coach
> ARD Coach
> Help me write a PRD
```

### Testing
```bash
# Run complete test suite
./tests/run-all-tests.sh

# Individual tests
./tests/mcp-compliance-test.sh
./tests/conversation-flow-test.sh
./tests/hook-execution-test.sh
./tests/state-recovery.sh
./tests/task-queue.sh
./tests/circuit-breaker.sh
./tests/agent-timeout.sh
./tests/test-bootstrap.sh
./tests/test-wrapper.sh
```

### Generated MCP Server (from templates)
```bash
cd project
npm run build    # Compile TypeScript
npm run start    # Run server
npm run dev      # Build and run in development
```

### Generated Agent SDK (from templates)
```bash
cd project
npm run build
npm start
```

## Architecture

### Agent Swarms (21 Total Agents)

1. **Architecture Swarm (4)**
   - `arch-mcp` - MCP protocol and tool design
   - `arch-sdk-agent` - Agent SDK patterns
   - `arch-hook` - Hook lifecycle design
   - `arch-skill` - Skill structure design

2. **Implementation Swarm (6)**
   - `impl-mcp` - MCP server implementation
   - `impl-sdk` - Agent SDK implementation
   - `impl-hook` - Hook implementation
   - `impl-skill` - Skill creation
   - `comp-tool` - Tool composition
   - `orch-workflow` - Workflow orchestration

3. **Integration Swarm (4)**
   - `int-coord` - Agent coordination
   - `int-mcp` - MCP integration testing
   - `int-skill` - Skill packaging
   - `int-hook` - Hook integration

4. **Testing Swarm (4)**
   - `test-mcp` - MCP compliance testing
   - `test-conversation` - Conversation flow testing
   - `test-tools` - Tool invocation testing
   - `test-integration` - End-to-end testing

5. **Documentation Swarm (3)**
   - `doc-sdk` - SDK documentation
   - `doc-mcp` - MCP documentation
   - `doc-guide` - Usage guides

### Directory Structure

```
SKILL.md                 # Main skill definition (triggered by "Agent Mode")
references/
├── agents.md           # 21 agent specifications
└── templates/          # Code generation templates
    ├── mcp-server/     # MCP server template (TypeScript)
    ├── sdk-agent/      # Agent SDK template
    ├── hook/           # Hook templates
    ├── skill/          # Skill templates
    └── workflow/       # Workflow templates
examples/               # Sample ARDs for testing
autonomy/
└── run.sh              # Main autonomous execution script
skills/ard-coach/       # ARD development coach
tests/                  # Comprehensive test suite
scripts/                # Helper scripts
docs/                   # Documentation
```

### Runtime State Directory (.elite/)

Created during execution:
```
.elite/
├── state/          # Orchestrator and agent states
├── queue/          # Task queue (pending, in-progress, completed, dead-letter)
├── messages/       # Inter-agent communication
├── logs/           # Audit logs
├── config/         # Configuration files
├── prompts/        # Agent role prompts
└── artifacts/      # Releases, reports, backups
```

## Critical Autonomous Execution Rules

The system runs with **ZERO human intervention**. When working in this codebase:

1. **NEVER ask questions** - Do not say "Would you like me to...", "Should I...", or "What would you prefer?"
2. **Make decisions autonomously** - Use requirements, `.elite/state/`, web search, and best practices
3. **Take immediate action** - Don't wait for confirmation
4. **Self-reflect and course-correct** - If stuck, read requirements, check state, search web
5. **Mark completion properly** - When done:
   - Set `currentPhase: "finalized"` in `.elite/state/orchestrator.json`
   - Create `.elite/COMPLETED` marker file

### Decision Priority Order
1. Requirements (primary source of truth)
2. Current state in `.elite/` (what's done, what's pending)
3. Code quality gates (tests, lint, build must pass)
4. Web search for best practices when uncertain
5. Conservative defaults (security, stability over speed)

## Operation Modes

### Simple Mode (Individual Developers)
**Triggers:** "Agent Mode: [simple description]" or no ARD provided

**Features:**
- Preset agent patterns (single MCP server, simple skill)
- Quick-start templates
- Sensible defaults (stdio transport, file-based state)

### Advanced Mode (Teams/Enterprises)
**Triggers:** "Agent Mode Advanced" or detailed ARD (>100 lines)

**Features:**
- Custom agent patterns
- Multi-agent workflows
- Governance features (code reviews, compliance)
- Comprehensive documentation

## Code Quality and Testing

### Parallel Code Review Pattern
Every task goes through 3 reviewers simultaneously:
- `code-reviewer` - Code quality
- `business-logic-reviewer` - Requirements
- `security-reviewer` - Security issues

### Severity-Based Issue Handling
- **Critical/High/Medium** - Block, fix immediately, re-review
- **Low** - Add `// TODO(review): ...` comment, continue
- **Cosmetic** - Add `// FIXME(nitpick): ...` comment, continue

### Quality Gates
- MCP compliance testing (`tests/mcp-compliance-test.sh`)
- Schema validation
- Conversation flow testing (`tests/conversation-flow-test.sh`)
- Hook execution testing (`tests/hook-execution-test.sh`)

## Configuration

Environment variables for the autonomous runner:

```bash
ELITE_MAX_RETRIES=50        # Maximum retry attempts
ELITE_BASE_WAIT=60          # Base wait time (seconds)
ELITE_MAX_WAIT=3600         # Maximum wait time
ELITE_DASHBOARD=true        # Enable web dashboard
ELITE_DASHBOARD_PORT=57374  # Dashboard port
```

### SDLC Phase Controls (all enabled by default)
Set to 'false' to skip: `ELITE_PHASE_UNIT_TESTS`, `ELITE_PHASE_API_TESTS`, `ELITE_PHASE_CODE_REVIEW`, etc.

## Dependencies

- **Claude Code CLI** with `--dangerously-skip-permissions`
- **Python 3** (for state management)
- **Node.js 18+** (for MCP server builds)
- **TypeScript** (for MCP server development)

## Key Technologies

- **MCP SDK:** `@modelcontextprotocol/sdk` for MCP servers
- **Anthropic SDK:** `@anthropic-ai/sdk` for agents
- **TypeScript:** For type safety in generated code

## Monitoring

```bash
# Watch status updates live
watch -n 2 cat .elite/STATUS.txt
```

## Example ARDs for Testing

Located in `examples/`:
- `simple-mcp-server.md` - MCP server for weather data (~10 min)
- `sdk-agent.md` - Task management autonomous agent (~10 min)
- `complete-agent-system.md` - Full system (~30-60 min)
- `simple-hook.md` - Pre-tool validation hook (~5 min)
