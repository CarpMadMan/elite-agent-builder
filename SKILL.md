---
name: agent-mode
description: Multi-agent autonomous system for building Claude Code agent systems. Triggers on "Agent Mode". Orchestrates 21 specialized agents across architecture, implementation, integration, testing, and documentation swarms. Takes requirements from simple descriptions to full ARD (Agent Requirements Document) and generates: MCP servers, Claude Agent SDK agents, Skills, Hooks, and multi-agent workflows. Features Task tool for subagent dispatch, parallel code review with 3 specialized reviewers, severity-based issue triage, distributed task queue with dead letter handling, automatic testing, and self-healing. Handles rate limits via distributed state checkpoints and auto-resume with exponential backoff. Supports Simple Mode (individual developers) and Advanced Mode (teams/enterprises).
---

# Agent Mode - Multi-Agent System for Building Claude Code Agent Systems

## Prerequisites

```bash
# Verify Claude Code is installed
which claude || echo "Install Claude Code first"

# Launch with autonomous permissions
claude --dangerously-skip-permissions

# Verify permissions on startup (orchestrator checks this)
# If permission denied errors occur, system halts with clear message
```

## CRITICAL: Fully Autonomous Execution

**This system runs with ZERO human intervention.** You MUST:

1. **NEVER ask questions** - Do not say "Would you like me to...", "Should I...", or "What would you prefer?"
2. **Make decisions autonomously** - Use the requirements, `.elite/state/`, web search, and best practices to decide
3. **Take immediate action** - If something needs to be done, do it. Don't wait for confirmation
4. **Self-reflect and course-correct** - If stuck, read the requirements again, check state, search the web
5. **Mark completion properly** - When all requirements are met:
   - Set `currentPhase: "finalized"` in `.elite/state/orchestrator.json`
   - Create `.elite/COMPLETED` marker file
   - The wrapper script will detect this and exit cleanly

**Decision Priority Order:**
1. Requirements (primary source of truth)
2. Current state in `.elite/` (what's done, what's pending)
3. Code quality gates (tests, lint, build must pass)
4. Web search for best practices when uncertain
5. Conservative defaults (security, stability over speed)

**If project is complete:** Do NOT ask "What would you like to do next?" Instead, create the `.elite/COMPLETED` file and provide a final status report. The system will exit cleanly.

---

## Mode Detection

Agent Mode operates in two modes based on trigger and requirements complexity:

### Simple Mode (Individual Developers)

**Triggers:**
- "Agent Mode: [simple description]"
- "Agent Mode" without requirements document
- Requirements document < 100 lines

**Features:**
- Preset agent patterns (single MCP server, simple skill, basic hook)
- Quick-start templates
- Minimal configuration
- Autonomous decisions with sensible defaults
- Fast execution

**Default Choices:**
- Agent Pattern: Request-response (simplest)
- MCP Transport: stdio (most compatible)
- State Management: File-based (no DB needed)
- Tool Composition: Single MCP server
- Hook Placement: post-tool
- Skill Scope: Single-purpose

**Example:**
```
User: "Agent Mode: Create an MCP server for GitHub issues"

→ System generates complete MCP server using preset pattern
→ No questions asked, uses sensible defaults
→ Output: Working MCP server with tools for listing issues, creating issues, etc.
```

### Advanced Mode (Teams/Enterprises)

**Triggers:**
- "Agent Mode Advanced" or "Agent Mode: Advanced [description]"
- Detailed ARD (Agent Requirements Document) > 100 lines
- Explicit multi-agent workflow requirements

**Features:**
- Custom agent patterns (autonomous loop, event-driven, etc.)
- Multi-agent workflows
- Governance features (code reviews, compliance)
- Collaboration support
- Fine-grained control
- Comprehensive documentation

**Example:**
```
User: "Agent Mode Advanced with requirements.md"

→ System analyzes detailed requirements
→ Designs custom multi-agent system architecture
→ Implements with parallel development and 3-way review
→ Generates comprehensive documentation and testing
→ Output: Production-ready agent system
```

---

## Codebase Analysis Mode (No Requirements Provided)

When Agent Mode is invoked WITHOUT requirements, it operates in **Codebase Analysis Mode**:

### Step 1: Requirements Auto-Detection
The runner script automatically searches for existing requirements files:
- `ARD.md`, `ard.md`, `REQUIREMENTS.md`, `requirements.md`
- `SPEC.md`, `spec.md`, `PROJECT.md`, `project.md`
- `docs/ARD.md`, `docs/requirements.md`
- `.github/ARD.md`

If found, that file is used as the requirements.

### Step 2: Codebase Analysis (if no requirements found)
Perform a comprehensive analysis of the existing codebase:

```bash
# 1. Understand project structure
tree -L 3 -I 'node_modules|.git|dist|build|coverage'
ls -la

# 2. Identify tech stack
cat package.json 2>/dev/null     # Node.js
cat requirements.txt 2>/dev/null  # Python
cat go.mod 2>/dev/null            # Go
cat Cargo.toml 2>/dev/null        # Rust

# 3. Read existing documentation
cat README.md 2>/dev/null
cat CONTRIBUTING.md 2>/dev/null
```

**Analysis Output:** Create detailed notes about:
1. **Project Overview** - What does this agent system do?
2. **Components** - MCP servers, agents, skills, hooks
3. **Architecture** - How components interact
4. **Current Features** - List all capabilities
5. **Code Quality** - Test coverage, linting, types, documentation
6. **Areas for Improvement** - Missing tests, security gaps, tech debt

### Step 3: Generate Requirements
Create a comprehensive ARD at `.elite/generated-ard.md`:

```markdown
# Generated ARD: [Project Name]

## Executive Summary
[2-3 sentence overview based on codebase analysis]

## Current State
- **Components:** [MCP servers, agents, skills, hooks]
- **Architecture:** [How components interact]
- **Features:** [list of implemented features]

## Requirements (Baseline)
These are the inferred requirements based on existing implementation:
1. [Component 1 - how it should work]
2. [Component 2 - how it should work]
...

## Identified Gaps
- [ ] Missing tests for: [list]
- [ ] Security issues: [list]
- [ ] Missing documentation: [list]
- [ ] Performance concerns: [list]

## Recommended Improvements
1. [Improvement 1]
2. [Improvement 2]
...
```

---

## Agent Swarm Architecture (21 Agents)

```
                              ┌─────────────────────┐
                              │   ORCHESTRATOR      │
                              │   (Primary Agent)   │
                              └──────────┬──────────┘
                                         │
      ┌──────────────┬──────────────┬────┴────┬──────────────┬──────────────┐
      │              │              │         │              │              │
 ┌────▼────┐   ┌─────▼─────┐  ┌─────▼─────┐ ┌─▼───┐   ┌──────▼──────┐ ┌─────▼─────┐
 │ARCH (4) │  │ IMPL (6)  │  │ INTEG (4) │ │TEST │   │    DOC     │ │ REVIEW (3)│
 │ Swarm   │  │   Swarm   │  │   Swarm   │ │(4)  │   │   (3)      │ │   Swarm   │
 └────┬────┘   └─────┬─────┘  └─────┬─────┘ └──┬──┘   └──────┬──────┘ └─────┬─────┘
      │              │              │          │             │              │
 ┌────┴────┐   ┌─────┴─────┐  ┌─────┴─────┐ ┌──┴──┐   ┌──────┴──────┐ ┌─────┴─────┐
 │MCP Arch │   │MCP Impl   │  │Agent Coord│ │Conv │   │SDK Documenter│ │ Code      │
 │SDK Arch │   │SDK Impl   │  │MCP Integ  │ │Tool │   │Schema Gen    │ │ Business  │
 │Hook Des │   │Hook Impl  │  │Skill Pub  │ │MCP  │   │Usage Guide   │ │ Security  │
 │Skill Des│   │Skill Impl │  │Hook Life  │ │Integ│   │              │ │           │
          │   │Tool Comp  │  │           │ │     │   │              │ │           │
          │   │Workflow   │  │           │ │     │   │              │ │           │
          └───┴───────────┘  └───────────┘ └─────┘   └──────────────┘ └───────────┘
```

### Architecture Swarm (4 Agents)
| Agent | Purpose |
|-------|---------|
| `arch-mcp` | Design MCP server interfaces, tool schemas, resources |
| `arch-sdk-agent` | Design Claude Agent SDK agents, decision flows |
| `arch-hook` | Design Claude Code hooks, lifecycle integration |
| `arch-skill` | Design portable skills, documentation structure |

### Implementation Swarm (6 Agents)
| Agent | Purpose |
|-------|---------|
| `impl-mcp` | Implement TypeScript MCP servers |
| `impl-sdk-agent` | Implement Claude Agent SDK agents |
| `impl-hook` | Implement bash/python hook scripts |
| `impl-skill` | Write SKILL.md with embedded code |
| `impl-tool-composer` | Compose multiple tools together |
| `impl-workflow-orchestrator` | Design multi-agent workflows |

### Integration Swarm (4 Agents)
| Agent | Purpose |
|-------|---------|
| `integ-agent-coordinator` | Integrate multi-agent systems |
| `integ-mcp-integrator` | Connect MCP servers to agents |
| `integ-skill-publisher` | Package and publish skills |
| `integ-hook-lifecycle` | Manage hook installation/activation |

### Testing Swarm (4 Agents)
| Agent | Purpose |
|-------|---------|
| `test-conversation` | Test agent conversation flows |
| `test-tool-invocation` | Validate MCP/tool calls |
| `test-mcp-compliance` | Verify MCP protocol adherence |
| `test-integration` | End-to-end system testing |

### Documentation Swarm (3 Agents)
| Agent | Purpose |
|-------|---------|
| `doc-sdk` | Document agent SDK usage |
| `doc-mcp-schema` | Generate MCP JSON schemas |
| `doc-usage-guide` | Create user guides and tutorials |

### Review Swarm (3 Agents - Reused)
| Agent | Purpose |
|-------|---------|
| `review-code` | Code quality, patterns, maintainability |
| `review-business` | Requirements alignment, edge cases |
| `review-security` | Vulnerabilities, auth, data exposure |

---

## Output Artifacts

### MCP Server
```typescript
project/
├── src/
│   └── server.ts          # MCP server implementation
├── package.json
├── tsconfig.json
└── README.md
```

### Claude Agent SDK Agent
```
project/
├── src/
│   ├── agent.ts           # Agent with decision loop
│   └── tools/
│       ├── github.ts
│       └── slack.ts
├── package.json
└── Dockerfile
```

### Skill
```
my-skill/
├── SKILL.md               # Main documentation
├── calculator.py          # Executable code
└── examples.txt           # Usage examples
```

### Hook
```
.claude/hooks/
└── post-tool.sh           # Hook script
```

---

## Quality Gates

| Gate | Agent | Pass Criteria |
|------|-------|---------------|
| MCP Compliance | test-mcp-compliance | tools/list responds in <5s |
| MCP Schema Validation | test-mcp-compliance | All schemas valid |
| Agent Loop Test | test-conversation | Reaches goal in N turns |
| Hook Execution | test-conversation | Runs without errors |
| Skill Load | test-integration | Loads in Claude Code |
| TypeScript Compile | impl-mcp | No type errors |
| Tool Invocation | test-tool-invocation | Tools return valid results |

---

## SDLC Phases

### PHASE_1: REQUIREMENTS_ANALYSIS
Parse agent workflow needs from requirements or simple description.

### PHASE_2: ARCHITECTURE_DESIGN
Design agent patterns, MCP transport, state management.

### PHASE_3: MCP_IMPLEMENTATION
Build MCP server with tools, resources, prompts.

### PHASE_4: AGENT_IMPLEMENTATION
Build Agent SDK agents with decision loops.

### PHASE_5: HOOK_IMPLEMENTATION
Build hooks for lifecycle events.

### PHASE_6: SKILL_CREATION
Create portable skills with documentation.

### PHASE_7: INTEGRATION_TESTING
Test all components working together.

### PHASE_8: DOCUMENTATION
Generate schemas, usage guides, API docs.

### PHASE_9: DEPLOYMENT
Publish skills, deploy agents, verify installation.

---

## Architecture Decision Framework

### Decision Tree

```
┌─ Agent Pattern: Autonomous loop vs Request-response vs Event-driven
├─ MCP Transport: stdio vs SSE
├─ State Management: File-based vs Database-backed
├─ Tool Composition: Single MCP vs Multiple specialized MCPs
├─ Subagent Strategy: Parallel Task tools vs Sequential
├─ Hook Placement: pre-tool vs post-tool vs session-start
└─ Skill Scope: Single-purpose vs Multi-capability
```

### Default Choices (Simple Mode)
- Agent Pattern: Request-response (simplest)
- MCP Transport: stdio (most compatible)
- State Management: File-based (no DB needed)
- Tool Composition: Single MCP server
- Hook Placement: post-tool
- Skill Scope: Single-purpose

---

## Directory Structure

```
.elite/
├── state/
│   ├── orchestrator.json       # Master state
│   ├── agents/                  # Per-agent state files
│   ├── checkpoints/             # Recovery snapshots
│   └── locks/                   # File-based mutex locks
├── queue/
│   ├── pending.json             # Task queue
│   ├── in-progress.json         # Active tasks
│   ├── completed.json           # Done tasks
│   ├── failed.json              # Failed tasks
│   └── dead-letter.json         # Unrecoverable tasks
├── messages/
│   ├── inbox/                   # Per-agent inboxes
│   ├── outbox/                  # Outgoing messages
│   └── broadcast/               # System-wide announcements
├── logs/
│   ├── ELITE-LOG.md             # Master audit log
│   ├── agents/                  # Per-agent logs
│   └── archive/                 # Rotated logs
├── config/
│   ├── circuit-breakers.yaml    # Failure thresholds
│   ├── thresholds.yaml          # Quality gates
│   └── modes.yaml               # Simple vs Advanced config
├── prompts/
│   ├── knowledge/               # Self-updating knowledge store
│   │   ├── mcp-protocol-spec.md
│   │   ├── claude-sdk-patterns.md
│   │   ├── hook-lifecycle.md
│   │   ├── best-practices.md
│   │   └── version.json
│   ├── orchestrator.md          # Orchestrator system prompt
│   └── {agent-type}.md          # Per-agent role prompts
├── artifacts/
│   ├── releases/                # Versioned releases
│   ├── reports/                 # Generated reports
│   └── backups/                 # State backups
└── templates/                   # Code generation templates
    ├── mcp-server/
    ├── sdk-agent/
    ├── skill/
    ├── hook/
    └── workflow/
```

---

## Self-Updating Knowledge System

### Knowledge Store
Located in `.elite/prompts/knowledge/`:

```
knowledge/
├── mcp-protocol-spec.md       # MCP protocol (versioned)
├── claude-sdk-patterns.md      # Agent SDK patterns (versioned)
├── hook-lifecycle.md           # Hook documentation (versioned)
├── best-practices.md           # Agent dev best practices (versioned)
└── version.json                # Knowledge version tracking
```

### Version Tracking
```json
{
  "mcpProtocol": { "version": "2024-12", "lastUpdated": "2024-12-30" },
  "claudeSDK": { "version": "1.5.0", "lastUpdated": "2024-12-28" },
  "hooks": { "version": "2.1.0", "lastUpdated": "2024-12-25" }
}
```

### Weekly Knowledge Update
A dedicated agent periodically:
1. Web searches "MCP protocol latest spec 2024"
2. Fetches official docs via web reader
3. Compares with current knowledge
4. Updates if newer found
5. Keeps last 3 versions for rollback

---

## Agent Spawning via Task Tool

### Parallel Code Review (3 Reviewers Simultaneously)

**CRITICAL: Dispatch all 3 reviewers in a SINGLE message with 3 Task tool calls.**

```markdown
[Task tool call 1: review-code]
- description: "Code quality review"
- instructions: Review for code quality, patterns, maintainability
- model: "opus"

[Task tool call 2: review-business]
- description: "Requirements alignment review"
- instructions: Review for correctness, edge cases, requirements
- model: "opus"

[Task tool call 3: review-security]
- description: "Security review"
- instructions: Review for vulnerabilities, auth issues, data exposure
- model: "opus"
```

---

## Severity-Based Issue Handling

| Severity | Action | Tracking |
|----------|--------|----------|
| **Critical** | BLOCK. Fix immediately. Re-run ALL 3 reviewers. | None |
| **High** | BLOCK. Fix immediately. Re-run ALL 3 reviewers. | None |
| **Medium** | BLOCK. Fix immediately. Re-run ALL 3 reviewers. | None |
| **Low** | PASS. Add TODO comment, continue. | `# TODO(review): ...` |
| **Cosmetic** | PASS. Add FIXME comment, continue. | `# FIXME(nitpick): ...` |

---

## Invocation

**"Agent Mode"** or **"Agent Mode: [description]"** or **"Agent Mode Advanced with [path]"**

### Startup Sequence
```
╔════════════════════════════════════════════════════════════════╗
║                    AGENT MODE ACTIVATED                        ║
║              Multi-Agent System for Building                   ║
║              Claude Code Agent Systems                         ║
╠════════════════════════════════════════════════════════════════╣
║ Mode:         [SIMPLE | ADVANCED]                               ║
║ Requirements: [path | Codebase Analysis Mode]                  ║
║ State:        [NEW | RESUMING]                                  ║
║ Agents:       [0 active, spawning initial pool...]              ║
╠════════════════════════════════════════════════════════════════╣
║ Initializing distributed task queue...                           ║
║ Spawning orchestrator agents...                                  ║
║ Beginning autonomous build cycle...                              ║
╚════════════════════════════════════════════════════════════════╝
```

---

## Red Flags - Never Do These

### Implementation Anti-Patterns
- **NEVER** skip code review between tasks
- **NEVER** proceed with unfixed Critical/High/Medium issues
- **NEVER** dispatch reviewers sequentially (always parallel)
- **NEVER** implement without reading task requirements first
- **NEVER** try to fix issues in orchestrator context (dispatch fix subagent)

### Always Do These
- **ALWAYS** launch all 3 reviewers in single message
- **ALWAYS** specify model: "opus" for each reviewer
- **ALWAYS** wait for all reviewers before aggregating
- **ALWAYS** fix Critical/High/Medium immediately
- **ALWAYS** re-run ALL 3 reviewers after fixes
- **ALWAYS** checkpoint state before spawning subagents

---

## Exit Conditions

| Condition | Action |
|-----------|--------|
| Agent system complete, tested | Create .elite/COMPLETED, exit cleanly |
| Unrecoverable failure | Save state, halt, request human |
| Requirements updated | Diff, create delta tasks, continue |
| Max retries exceeded | Halt with error message |

---

## References

- `references/agents.md`: Complete agent type definitions and capabilities
- `.elite/prompts/knowledge/`: Self-updating knowledge store
- `.elite/templates/`: Code generation templates

---

## Skill Metadata

| Field | Value |
|-------|-------|
| **Trigger** | "Agent Mode", "Agent Mode: [description]", "Agent Mode Advanced with [path]" |
| **Skip When** | Need human approval between tasks, want to review plan first |
| **Uses Skills** | test-driven-development, requesting-code-review |
| **Modes** | Simple (individuals), Advanced (teams/enterprises) |
