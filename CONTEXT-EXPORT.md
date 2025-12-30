# ELITE - Conversation Context Export

**Date:** 2025-12-30
**Version:** 3.0.0
**Repository:** https://github.com/yourusername/elite-agent-builder

---

## Project Overview

**ELITE** is a Claude Code skill that provides a multi-agent autonomous system for building Claude Code agent systems. It orchestrates 21 specialized agents across 5 swarms to take an ARD (Agent Requirements Document) from idea to complete agent system.

### Key Features
- 21 agents across 5 swarms (Architecture, Implementation, Integration, Testing, Documentation)
- Task tool for subagent dispatch with fresh context
- Distributed task queue (pending, in-progress, completed, failed, dead-letter)
- Circuit breakers for per-agent failure handling
- Timeout/stuck agent detection with heartbeat monitoring
- State recovery via checkpoints in `.elite/state/`
- Autonomous execution with auto-resume on rate limits
- Self-updating knowledge from latest documentation

---

## File Structure

```
elite-agent-builder/
├── SKILL.md                    # The main skill file (YAML frontmatter required)
├── VERSION                     # Current version: 3.0.0
├── CHANGELOG.md                # Full version history
├── README.md                   # Main documentation
├── references/
│   ├── agents.md               # 21 agent definitions
│   └── templates/              # Code generation templates
├── examples/
│   ├── simple-mcp-server.md    # MCP server ARD
│   ├── sdk-agent.md            # Agent SDK ARD
│   ├── complete-agent-system.md # Full system ARD
│   └── simple-hook.md          # Hook ARD
├── templates/
│   ├── mcp-server/             # MCP server templates
│   ├── sdk-agent/              # Agent SDK templates
│   ├── skill/                  # Skill templates
│   ├── hook/                   # Hook templates
│   └── workflow/               # Workflow templates
├── .elite/
│   └── prompts/knowledge/      # Versioned documentation
├── tests/
│   ├── mcp-compliance-test.sh  # MCP compliance tests
│   ├── conversation-flow-test.sh # Conversation flow tests
│   └── hook-execution-test.sh  # Hook execution tests
├── scripts/
│   ├── elite-wrapper.sh        # Autonomous wrapper
│   └── export-to-vibe-kanban.sh # Vibe Kanban export
├── integrations/
│   └── vibe-kanban.md          # Vibe Kanban integration guide
├── autonomy/
│   ├── run.sh                  # ⭐ MAIN ENTRY POINT - handles everything
│   └── README.md               # Autonomy documentation
└── .github/workflows/
    └── release.yml             # GitHub Actions for releases
```

---

## How to Use

### Quick Start (Recommended)
```bash
./autonomy/run.sh ./docs/requirements.md
```

### What run.sh Does
1. Checks prerequisites (Claude CLI, Python, Git, curl)
2. Verifies skill installation
3. Initializes `.elite/` directory
4. Starts status monitor (updates `.elite/STATUS.txt` every 5s)
5. Runs Claude Code with live output
6. Auto-resumes on rate limits with exponential backoff
7. Continues until completion or max retries

### Monitor Progress
```bash
# In another terminal
watch -n 2 cat .elite/STATUS.txt
```

---

## Key Technical Details

### Claude Code Invocation
The autonomy runner uses stream-json for live output:
```bash
claude --dangerously-skip-permissions -p "$prompt" --output-format stream-json --verbose
```

**Important:** Using `--output-format stream-json` with Python parsing provides real-time formatted output.

### State Files
- `.elite/state/orchestrator.json` - Current phase, metrics
- `.elite/autonomy-state.json` - Retry count, status, PID
- `.elite/queue/*.json` - Task queues
- `.elite/STATUS.txt` - Human-readable status (updated every 5s)
- `.elite/logs/*.log` - Execution logs

### Environment Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `ELITE_MAX_RETRIES` | 50 | Max retry attempts |
| `ELITE_BASE_WAIT` | 60 | Base wait time (seconds) |
| `ELITE_MAX_WAIT` | 3600 | Max wait time (1 hour) |
| `ELITE_SKIP_PREREQS` | false | Skip prerequisite checks |
| `ELITE_DASHBOARD` | true | Enable web dashboard |
| `ELITE_DASHBOARD_PORT` | 57374 | Dashboard port |

---

## Version History Summary

| Version | Key Changes |
|---------|-------------|
| 3.0.0 | Complete transformation from Loki to ELITE - agent builder for Claude Code |
| 2.8.0 | Smart rate limit detection, Codebase Analysis Mode |
| 2.7.0 | Codebase Analysis Mode for no-ARD scenarios |
| 2.6.0 | Complete SDLC testing phases |
| 2.5.0 | Real streaming output (stream-json), Web dashboard with Anthropic design |
| 2.4.0 | Live output fix (stdin pipe), STATUS.txt monitor |
| 2.3.0 | Unified autonomy runner (`autonomy/run.sh`) |
| 2.2.0 | Vibe Kanban integration |

---

## Known Issues & Solutions

### 1. "Rate limit detected"
**Cause:** API rate limits from too many requests
**Solution:** Auto-resume with exponential backoff, detects exact reset time

### 2. "Vibe Kanban not showing tasks"
**Cause:** Vibe Kanban is UI-driven, doesn't read JSON files automatically
**Solution:** Use `.elite/STATUS.txt` for monitoring, or run Vibe Kanban separately

### 3. "timeout command not found on macOS"
**Cause:** macOS doesn't have GNU coreutils
**Solution:** Perl-based fallback in test scripts

---

## Modes

### Simple Mode (Individual Developers)
Trigger: "Agent Mode" or "Agent Mode: [simple description]"
- Preset agent patterns
- Quick-start templates
- Autonomous decisions

### Advanced Mode (Teams/Enterprises)
Trigger: "Agent Mode Advanced" or detailed ARD
- Multi-agent workflows
- Custom agent patterns
- Governance features
- Fine-grained control

---

## Git Configuration

**Committer:** Your username (never use Claude as co-author)

**Commit format:**
```
Short description (vX.X.X)

Detailed bullet points of changes
```

---

## Test Suite

Run all tests:
```bash
./tests/mcp-compliance-test.sh
./tests/conversation-flow-test.sh
./tests/hook-execution-test.sh
```

---

## Pending/Future Work

1. **Self-updating knowledge system** - Agents periodically fetch latest MCP/SDK docs
2. **Better agent patterns** - More sophisticated autonomous loop patterns
3. **Component library** - Pre-built agent components for quick assembly

---

## Important Files to Read First

When starting a new session, read these files:
1. `SKILL.md` - The actual skill instructions
2. `autonomy/run.sh` - Main entry point
3. `VERSION` and `CHANGELOG.md` - Current state
4. This file (`CONTEXT-EXPORT.md`) - Full context

---

## User Preferences

- Always use your username as committer
- Never use Claude as co-author
- Keep skill files clean, autonomy separate
- Test before pushing
- Live output is important - user wants to see what's happening
- ELITE builds agent systems, not web applications

---

## Last Known State

- **Version:** 3.0.0
- **Transformation:** Complete Loki → ELITE conversion
- **Agents:** 21 (down from 37, focused on agent development)
- **Output:** MCP Servers, Agent SDK agents, Skills, Hooks, Workflows
- **Tests:** MCP compliance, conversation flow, hook execution
