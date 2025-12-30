# Vibe Kanban Integration

ELITE can optionally integrate with [Vibe Kanban](https://github.com/BloopAI/vibe-kanban) to provide a visual dashboard for monitoring autonomous execution.

## Why Use Vibe Kanban with ELITE?

| Feature | ELITE Alone | + Vibe Kanban |
|---------|-------------|---------------|
| Task visualization | File-based queues | Visual kanban board |
| Progress monitoring | Log files | Real-time dashboard |
| Manual intervention | Edit queue files | Drag-and-drop tasks |
| Code review | Automated 3-reviewer | + Visual diff review |
| Parallel agents | Background subagents | Isolated git worktrees |

## Setup

### 1. Install Vibe Kanban

```bash
npx vibe-kanban
```

### 2. Export ELITE Tasks

Use the export script to sync ELITE tasks to Vibe Kanban:

```bash
./scripts/export-to-vibe-kanban.sh
```

By default, exports to `~/.vibe-kanban/elite-tasks/`

## How It Works

### Task Sync Flow

```
ELITE                              Vibe Kanban
    │                                   │
    ├─ Creates task ──────────────────► Task appears on board
    │                                   │
    ├─ Agent claims task ─────────────► Status: "In Progress"
    │                                   │
    │ ◄─────────────────── User pauses ─┤ (optional intervention)
    │                                   │
    ├─ Task completes ────────────────► Status: "Done"
    │                                   │
    └─ Review results ◄─────────────── User reviews diffs
```

### Task Export Format

ELITE exports tasks in Vibe Kanban compatible format:

```json
{
  "id": "elite-arch-mcp-001",
  "title": "Design MCP server architecture",
  "description": "Create MCP server with weather data tools",
  "status": "todo",
  "agent": "claude-code",
  "tags": ["arch-mcp", "phase-2", "priority-high"],
  "metadata": {
    "eliteTaskId": "arch-mcp-001",
    "eliteType": "arch-mcp",
    "elitePhase": "ARCHITECTURE_DESIGN",
    "createdAt": "2025-01-15T10:00:00Z"
  }
}
```

### Mapping ELITE Phases to Kanban Columns

| ELITE Phase | Kanban Column |
|-------------|---------------|
| BOOTSTRAP | Backlog |
| REQUIREMENTS_ANALYSIS | Planning |
| ARCHITECTURE_DESIGN | Planning |
| MCP_IMPLEMENTATION | In Progress |
| AGENT_IMPLEMENTATION | In Progress |
| INTEGRATION_TESTING | Review |
| DOCUMENTATION | Review |
| DEPLOYMENT | Deploying |
| COMPLETED | Done |

## Export Script

The export script is included at `scripts/export-to-vibe-kanban.sh`:

```bash
# Export to default location
./scripts/export-to-vibe-kanban.sh

# Export to custom location
./scripts/export-to-vibe-kanban.sh ~/my-kanban-dir/
```

The script:
- Reads from `.elite/queue/*.json`
- Creates Vibe Kanban compatible JSON files
- Generates a summary file `_elite_summary.json`

## Real-Time Sync (Advanced)

For real-time sync, run the watcher alongside ELITE:

```bash
#!/bin/bash
# scripts/vibe-sync-watcher.sh

ELITE_DIR=".elite"

# Watch for queue changes and sync
while true; do
    # Use fswatch on macOS, inotifywait on Linux
    if command -v fswatch &> /dev/null; then
        fswatch -1 "$ELITE_DIR/queue/"
    else
        inotifywait -e modify,create "$ELITE_DIR/queue/" 2>/dev/null
    fi

    ./scripts/export-to-vibe-kanban.sh
    sleep 2
done
```

## Benefits of Combined Usage

### 1. Visual Progress Tracking
See all 21 ELITE agents as tasks moving across your kanban board.

### 2. Safe Isolation
Vibe Kanban runs each agent in isolated git worktrees, perfect for ELITE's parallel development.

### 3. Human-in-the-Loop Option
Pause autonomous execution, review changes visually, then resume.

### 4. Multi-Project Dashboard
If running ELITE on multiple projects, see all in one Vibe Kanban instance.

## Comparison: When to Use What

| Scenario | Recommendation |
|----------|----------------|
| Fully autonomous, no monitoring | ELITE + Wrapper only |
| Need visual progress dashboard | Add Vibe Kanban |
| Want manual task prioritization | Use Vibe Kanban to reorder |
| Code review before merge | Use Vibe Kanban's diff viewer |
| Multiple concurrent ARDs | Vibe Kanban for project switching |

## Future Integration Ideas

- [ ] Bidirectional sync (Vibe → ELITE)
- [ ] Vibe Kanban MCP server for agent communication
- [ ] Shared agent profiles between tools
- [ ] Unified logging dashboard
