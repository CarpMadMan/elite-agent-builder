# ELITE

**Multi-Agent Autonomous System for Claude Code**

[![Claude Code](https://img.shields.io/badge/Claude-Code-orange)](https://claude.ai)
[![Agents](https://img.shields.io/badge/Agents-21-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> Transform an ARD (Agent Requirements Document) into a complete Claude Code agent system with zero human intervention.

## Quick Start

**New here?** Start with the [Quick Start Guide](QUICKSTART.md) - get running in 3 minutes.

```bash
# Automated setup (recommended)
./scripts/setup.sh

# Then run ELITE
claude --dangerously-skip-permissions
> Agent Mode
```

**Experienced users?** Jump to [Usage](#usage) or [Modes](#modes).

## What is ELITE?

ELITE is a Claude Code skill that orchestrates **21 specialized AI agents** across **5 swarms** to autonomously build Claude Code agent systems.

```
ARD → Architecture → Implementation → Integration → Testing → Documentation → Complete Agent System
```

## Why `--dangerously-skip-permissions`?

You'll see this flag throughout ELITE's documentation. Here's why it's required:

### What It Does

The `--dangerously-skip-permissions` flag allows Claude Code to execute commands **without interactive confirmation prompts**. Without this flag, Claude Code would stop at every file write, directory creation, or command execution to ask for permission.

### Why ELITE Needs It

ELITE is a **fully autonomous system** that orchestrates 21 specialized agents. A typical build involves:
- Creating 50+ directories and files
- Running 20+ npm/git/bash commands
- Executing multiple test suites
- Generating documentation

With interactive permissions, this would require **hundreds of manual confirmations**, defeating ELITE's autonomous purpose.

### Is It Safe?

**Within this repository:** Yes. Here's why:
- ELITE only operates within the `.elite/` directory and project output folders
- It doesn't modify system files or your personal data
- All generated code is in your project directory, not system directories

**General caution:** This flag should **only** be used with trusted code/repositories. Never run with this flag for untrusted AI agents or code from unknown sources.

### Best Practices

1. **Review the ARD first** - Understand what will be built
2. **Check .elite/ directory** - See what's being created
3. **Read generated code** - Review before deploying
4. **Use version control** - Commit before running, rollback if needed

## What ELITE Builds

ELITE creates complete agent systems including:
- **MCP Servers** - Model Context Protocol servers for tool/resource access

> **Important:** ELITE **generates** MCP servers as output. This is different from "configuring MCP" in Claude Code settings. ELITE builds the actual server code that you can then integrate with Claude Code.

- **Agent SDK Agents** - Autonomous agents with decision loops
- **Skills** - Portable markdown + code tools for Claude Code
- **Hooks** - Bash/Python scripts for Claude Code lifecycle events
- **Multi-Agent Workflows** - Coordinated agent systems

## Features

| Category | Capabilities |
|----------|-------------|
| **Multi-Agent System** | 21 agents across Architecture, Implementation, Integration, Testing, and Documentation swarms |
| **Parallel Code Review** | 3 specialized reviewers (code, business logic, security) running simultaneously |
| **Quality Gates** | MCP compliance, schema validation, conversation flow testing |
| **Two Modes** | Simple Mode (individuals) and Advanced Mode (teams/enterprises) |
| **Self-Updating** | Agents periodically research and update knowledge from latest docs |
| **Reliability** | Circuit breakers, dead letter queues, exponential backoff, state recovery |
| **Observability** | Web dashboard, status monitor, detailed logs |

## Agent Swarms

### Architecture Swarm (4 Agents)
- `arch-mcp` - MCP protocol specification and tool design
- `arch-sdk-agent` - Agent SDK patterns and architecture
- `arch-hook` - Hook lifecycle and design
- `arch-skill` - Skill structure and portability

### Implementation Swarm (6 Agents)
- `impl-mcp` - MCP server implementation (TypeScript)
- `impl-sdk` - Agent SDK implementation
- `impl-hook` - Hook implementation (bash/python)
- `impl-skill` - Skill creation and documentation
- `comp-tool` - Tool composition and integration
- `orch-workflow` - Multi-agent workflow orchestration

### Integration Swarm (4 Agents)
- `int-coord` - Agent coordination and communication
- `int-mcp` - MCP server integration testing
- `int-skill` - Skill packaging and publishing
- `int-hook` - Hook lifecycle integration

### Testing Swarm (4 Agents)
- `test-mcp` - MCP compliance and schema validation
- `test-conversation` - Conversation flow testing
- `test-tools` - Tool invocation testing
- `test-integration` - End-to-end integration testing

### Documentation Swarm (3 Agents)
- `doc-sdk` - SDK documentation generation
- `doc-mcp` - MCP schema and resource documentation
- `doc-guide` - Usage guides and examples

## Installation

### Skill File Structure

```
SKILL.md              # ← THE SKILL (required) - contains YAML frontmatter
references/
├── agents.md         # Agent definitions (21 agents)
└── templates/        # Code generation templates
```

### For Claude.ai (Web)

1. Go to [Releases](https://github.com/yourusername/elite-agent-builder/releases)
2. Download `elite-X.X.X.zip` or `elite-X.X.X.skill`
3. Go to **Claude.ai → Settings → Features → Skills**
4. Upload the zip/skill file

The zip has `SKILL.md` at the root level as Claude.ai expects.

### For Claude Code (CLI)

**Recommended: Use setup script (cross-platform)**
```bash
# Unix/macOS/Linux
./scripts/setup.sh

# Windows PowerShell
.\scripts\setup.ps1
```

This will check dependencies, install the ELITE skill, and create configuration templates.

**Manual Installation**

**Unix/macOS/Linux:**
```bash
# For personal use (all projects)
mkdir -p ~/.claude/skills/agent-mode
cp SKILL.md ~/.claude/skills/agent-mode/
cp -r references ~/.claude/skills/agent-mode/

# For a specific project only
mkdir -p .claude/skills/agent-mode
cp SKILL.md .claude/skills/agent-mode/
cp -r references .claude/skills/agent-mode/
```

**Windows:**
```powershell
# For personal use (all projects)
mkdir $env:USERPROFILE\.claude\skills\agent-mode
copy SKILL.md $env:USERPROFILE\.claude\skills\agent-mode\
xcopy /E /I references $env:USERPROFILE\.claude\skills\agent-mode\references

# For a specific project only
mkdir .claude\skills\agent-mode
copy SKILL.md .claude\skills\agent-mode\
xcopy /E /I references .claude\skills\agent-mode\references
```

**Option A: Download from Releases**
```bash
# Download the Claude Code version
cd ~/.claude/skills

# Get latest version number
VERSION=$(curl -s https://api.github.com/repos/yourusername/elite-agent-builder/releases/latest | grep tag_name | cut -d'"' -f4 | tr -d 'v')

# Download and extract
curl -L -o elite.zip "https://github.com/yourusername/elite-agent-builder/releases/download/v${VERSION}/elite-claude-code-${VERSION}.zip"
unzip elite.zip && rm elite.zip
# Creates: ~/.claude/skills/agent-mode/SKILL.md
```

**Option B: Git Clone**
```bash
# For personal use (all projects)
git clone https://github.com/yourusername/elite-agent-builder.git ~/.claude/skills/agent-mode

# For a specific project only
git clone https://github.com/yourusername/elite-agent-builder.git .claude/skills/agent-mode
```

**Option C: Minimal Install (curl)**
```bash
mkdir -p ~/.claude/skills/agent-mode/references
curl -o ~/.claude/skills/agent-mode/SKILL.md https://raw.githubusercontent.com/yourusername/elite-agent-builder/main/SKILL.md
curl -o ~/.claude/skills/agent-mode/references/agents.md https://raw.githubusercontent.com/yourusername/elite-agent-builder/main/references/agents.md
```

### Verify Installation

```bash
# Check the skill is in place
cat ~/.claude/skills/agent-mode/SKILL.md | head -5
# Should show YAML frontmatter with name: agent-mode
```

## Usage

### Quick Start (Recommended)

Use the autonomous runner - it handles everything:

```bash
# Run with an ARD (fully autonomous with auto-resume)
./autonomy/run.sh ./docs/requirements.md

# Run interactively
./autonomy/run.sh
```

The autonomous runner will:
1. Check all prerequisites (Claude CLI, Python, Git, etc.)
2. Verify skill installation
3. Initialize the `.elite/` directory
4. Start **status monitor** (updates `.elite/STATUS.txt` every 5s)
5. Start Claude Code with **live output** (see what's happening)
6. Auto-resume on rate limits or interruptions
7. Continue until completion or max retries

### Live Output

No more staring at a blank screen! Claude's output is displayed in real-time:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CLAUDE CODE OUTPUT (live)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[You see Claude working in real-time here...]
```

### Status Monitor

Monitor task progress in another terminal:

```bash
# Watch status updates live
watch -n 2 cat .elite/STATUS.txt
```

Output:
```
╔════════════════════════════════════════════════════════════════╗
║                    ELITE STATUS                                ║
╚════════════════════════════════════════════════════════════════╝

Phase: DEVELOPMENT

Tasks:
  ├─ Pending:     10
  ├─ In Progress: 1
  ├─ Completed:   5
  └─ Failed:      0
```

### Manual Mode

If you prefer manual control:

```bash
# Launch Claude Code with autonomous permissions
claude --dangerously-skip-permissions

# Then say:
> Agent Mode

# Or with a specific ARD:
> Agent Mode with ARD at ./docs/requirements.md
```

## Getting Started with ARD Coach

New to ELITE? Start with **ARD Coach** - an interactive skill that helps you develop your ARD (Agent Requirements Document) before building.

### What is ARD Coach?

ARD Coach is a conversational assistant that guides you from a rough idea to a complete, well-structured ARD ready for ELITE execution.

**Benefits:**
- No need to understand ARD format upfront
- Interactive questioning tailored to your experience level
- Immediate feedback and refinement
- Generates properly formatted ARDs automatically

### Using ARD Coach

```bash
# Launch Claude Code
claude --dangerously-skip-permissions

# Trigger ARD Coach
> ARD Coach
```

**Or try these trigger phrases:**
- "Help me write a PRD"
- "Help me write requirements"
- "Help me write an ARD"

### ARD Coach Workflow

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ 1. Select Mode  │ -> │ 2. Answer Q&A    │ -> │ 3. Review ARD   │
│ Quick or Deep   │    │ Conversational   │    │ Edit/Regenerate │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                            │
                                                            v
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ 5. ELITE Build  │ <- │ 4. Approve ARD   │ <- │    Generated    │
│ Autonomous      │    │ Execute or Save  │    │    Complete     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Mode Selection

| Mode | Questions | Best For |
|------|-----------|----------|
| **Quick** | 5-7 | Experienced users, simple projects |
| **Deep Dive** | 15-20 | Complex systems, comprehensive planning |

### Example Session

```
You: ARD Coach

Coach: Welcome to ARD Coach! Which mode would you prefer?
       1. Quick mode: 5-7 core questions
       2. Deep dive: 15-20 comprehensive questions

You: Quick mode

Coach: What is the core problem your agent system will solve?

You: I want an agent that monitors GitHub repositories and alerts
     on new issues matching specific keywords.

Coach: Great! What type of agent pattern best fits your needs?
       [Explains options...]

[... continues through questions ...]

Coach: Here's your ARD. Please review:
       [Displays complete ARD]

Coach: What would you like to do?
       1. Approve - Ready for ELITE
       2. Edit section
       3. Regenerate

You: Approve

Coach: Your ARD is ready! Would you like me to execute ELITE now?
       [If yes: runs ./autonomy/run.sh .elite/ard-coach-ard.md]
```

### Installing ARD Coach

ARD Coach is included with ELITE. Install it alongside the main skill:

```bash
# Create symlink for ARD Coach
mkdir -p ~/.claude/skills/ard-coach
ln -s "$(pwd)/skills/ard-coach/SKILL.md" ~/.claude/skills/ard-coach/
```

See [ARD Coach Documentation](docs/ard-coach-guide.md) for complete usage guide.

---

## Modes

### Simple Mode (Individual Developers)

**Trigger:** "Agent Mode" or "Agent Mode: [simple description]"

**Features:**
- Preset agent patterns (single MCP server, simple skill)
- Quick-start templates
- Minimal configuration
- Autonomous decisions

**Example:**
```
User: "Agent Mode: Create an MCP server for GitHub issues"
→ System generates complete MCP server using preset pattern
→ No questions asked, uses sensible defaults
```

### Advanced Mode (Teams/Enterprises)

**Trigger:** "Agent Mode Advanced" or provide detailed ARD (Agent Requirements Document)

**Features:**
- Multi-agent workflows
- Custom agent patterns
- Governance features (code reviews, compliance)
- Collaboration support
- Fine-grained control

**Example:**
```
User: "Agent Mode Advanced with requirements.md"
→ System analyzes requirements, designs custom multi-agent system
→ Parallel implementation with 3-way review
→ Full documentation and testing
```

## Configuration

Environment variables to customize the autonomous runner:

```bash
# Example with custom settings
ELITE_MAX_RETRIES=100 \
ELITE_BASE_WAIT=120 \
ELITE_MAX_WAIT=7200 \
./autonomy/run.sh ./docs/requirements.md
```

| Variable | Default | Description |
|----------|---------|-------------|
| `ELITE_MAX_RETRIES` | 50 | Maximum retry attempts before giving up |
| `ELITE_BASE_WAIT` | 60 | Base wait time in seconds |
| `ELITE_MAX_WAIT` | 3600 | Maximum wait time (1 hour) |
| `ELITE_SKIP_PREREQS` | false | Skip prerequisite checks |
| `ELITE_DASHBOARD` | true | Enable web dashboard |
| `ELITE_DASHBOARD_PORT` | 57374 | Dashboard port |

### SDLC Phase Controls

All enabled by default, set to 'false' to skip:

| Variable | Description |
|----------|-------------|
| `ELITE_PHASE_UNIT_TESTS` | Run unit tests |
| `ELITE_PHASE_API_TESTS` | Functional API testing |
| `ELITE_PHASE_E2E_TESTS` | E2E/UI testing |
| `ELITE_PHASE_SECURITY` | Security scanning |
| `ELITE_PHASE_INTEGRATION` | Integration tests |
| `ELITE_PHASE_CODE_REVIEW` | 3-reviewer parallel code review |
| `ELITE_PHASE_WEB_RESEARCH` | Web research for latest patterns |
| `ELITE_PHASE_PERFORMANCE` | Load/performance testing |
| `ELITE_PHASE_ACCESSIBILITY` | Accessibility compliance |
| `ELITE_PHASE_REGRESSION` | Regression testing |
| `ELITE_PHASE_UAT` | UAT simulation |

## How It Works

### Phase Execution

| Phase | Description |
|-------|-------------|
| **0. Bootstrap** | Create `.elite/` directory structure, initialize state |
| **1. Requirements Analysis** | Parse ARD, understand agent system needs |
| **2. Architecture Design** | Agent patterns, MCP transport, state management |
| **3. MCP Implementation** | Build MCP server |
| **4. Agent Implementation** | Build Agent SDK code |
| **5. Hook Implementation** | Build hooks |
| **6. Skill Creation** | Create skills |
| **7. Integration Testing** | Test all components together |
| **8. Documentation** | Generate schemas and guides |
| **9. Deployment** | Publish skills, deploy agents |

### Parallel Code Review Pattern

Every task goes through 3 reviewers simultaneously:

```
IMPLEMENT → REVIEW (3 parallel) → AGGREGATE → FIX → RE-REVIEW → COMPLETE
                │
                ├─ code-reviewer (code quality)
                ├─ business-logic-reviewer (requirements)
                └─ security-reviewer (security issues)
```

### Severity-Based Issue Handling

| Severity | Action |
|----------|--------|
| Critical/High/Medium | Block. Fix immediately. Re-review. |
| Low | Add `// TODO(review): ...` comment, continue |
| Cosmetic | Add `// FIXME(nitpick): ...` comment, continue |

## Directory Structure

When running, ELITE creates:

```
.elite/
├── state/          # Orchestrator and agent states
├── queue/          # Task queue (pending, in-progress, completed, dead-letter)
├── messages/       # Inter-agent communication
├── logs/           # Audit logs
├── config/         # Configuration files
├── prompts/        # Agent role prompts
├── artifacts/      # Releases, reports, backups
└── scripts/        # Helper scripts
```

## Example ARDs

Test the skill with these pre-built ARDs in the `examples/` directory:

| ARD | Complexity | Time | Description |
|-----|------------|------|-------------|
| `simple-mcp-server.md` | Low | ~10 min | MCP server for weather data |
| `sdk-agent.md` | Low | ~10 min | Task management autonomous agent |
| `complete-agent-system.md` | Medium | ~30-60 min | Full system with MCP + Agent + Skill + Hooks |
| `simple-hook.md` | Low | ~5 min | Pre-tool validation hook |

```bash
# Example: Test with simple MCP server
claude --dangerously-skip-permissions
> Agent Mode with ARD at examples/simple-mcp-server.md
```

## Running Tests

The skill includes a comprehensive test suite:

```bash
# Run all tests
./tests/run-all-tests.sh

# Run individual test suites
./tests/mcp-compliance-test.sh        # MCP protocol compliance
./tests/conversation-flow-test.sh     # Agent conversation testing
./tests/hook-execution-test.sh        # Hook execution tests
```

## Requirements

- Claude Code with `--dangerously-skip-permissions` flag
- Internet access for web research and documentation
- Python 3 (for state management)
- Node.js 18+ (for MCP server builds)
- TypeScript (for MCP server development)

## Comparison

| Feature | Basic Skills | ELITE |
|---------|-------------|-------|
| Agents | 1 | 21 |
| Swarms | - | 5 |
| Code Review | Manual | Parallel 3-reviewer |
| Components | Single | MCP + Agent + Skill + Hooks |
| State Recovery | None | Checkpoint/resume |
| Testing | Manual | Automated compliance + flow |
| Documentation | Manual | Auto-generated |

## Integrations

### Vibe Kanban (Visual Dashboard)

Optionally integrate with [Vibe Kanban](https://github.com/BloopAI/vibe-kanban) for a visual kanban board to monitor ELITE's agents:

```bash
# Install Vibe Kanban
npx vibe-kanban

# Export ELITE tasks to Vibe Kanban
./scripts/export-to-vibe-kanban.sh
```

Benefits:
- Visual progress tracking of all 21 agents
- Manual intervention/prioritization when needed
- Code review with visual diffs
- Multi-project dashboard

## Contributing

Contributions welcome! Please read the skill and open issues for bugs or feature requests.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by [LerianStudio/ring](https://github.com/LerianStudio/ring) subagent-driven-development pattern
- Built for the [Claude Code](https://claude.ai) ecosystem
- Adapted from [claude-loki](https://github.com/asklokesh/claudeskill-loki-mode) web app builder

---

**Keywords:** claude-code, claude-skills, ai-agents, mcp-servers, agent-sdk, multi-agent-system, autonomous-development, skill-development
