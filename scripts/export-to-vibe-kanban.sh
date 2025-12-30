#!/bin/bash
# Export ELITE tasks to Vibe Kanban format
# Usage: ./scripts/export-to-vibe-kanban.sh [export_dir]

set -uo pipefail

ELITE_DIR=".elite"
EXPORT_DIR="${1:-${VIBE_KANBAN_DIR:-$HOME/.vibe-kanban/elite-tasks}}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

# Check if .elite directory exists
if [ ! -d "$ELITE_DIR" ]; then
    log_warn "No .elite directory found. Run ELITE first."
    exit 1
fi

mkdir -p "$EXPORT_DIR"

# Get current phase from orchestrator
CURRENT_PHASE="UNKNOWN"
if [ -f "$ELITE_DIR/state/orchestrator.json" ]; then
    CURRENT_PHASE=$(python3 -c "import json; print(json.load(open('$ELITE_DIR/state/orchestrator.json')).get('currentPhase', 'UNKNOWN'))" 2>/dev/null || echo "UNKNOWN")
fi

# Map ELITE phases to Vibe Kanban columns
phase_to_column() {
    case "$1" in
        BOOTSTRAP|REQUIREMENTS_ANALYSIS|ARCHITECTURE_DESIGN) echo "planning" ;;
        MCP_IMPLEMENTATION|AGENT_IMPLEMENTATION|INTEGRATION_TESTING) echo "in-progress" ;;
        DOCUMENTATION) echo "review" ;;
        DEPLOYMENT) echo "deploying" ;;
        COMPLETED) echo "done" ;;
        *) echo "backlog" ;;
    esac
}

# Export tasks from all queues
export_queue() {
    local queue_file="$1"
    local status="$2"

    if [ ! -f "$queue_file" ]; then
        return
    fi

    python3 << EOF
import json
import os
from datetime import datetime

try:
    with open("$queue_file") as f:
        content = f.read().strip()
        if not content or content == "[]":
            tasks = []
        else:
            tasks = json.loads(content)
except (json.JSONDecodeError, FileNotFoundError):
    tasks = []

export_dir = os.path.expanduser("$EXPORT_DIR")
exported = 0

for task in tasks:
    task_id = task.get('id', 'unknown')

    # Determine status based on queue and claimed state
    if "$status" == "pending":
        vibe_status = "todo"
    elif "$status" == "in-progress":
        vibe_status = "doing"
    elif "$status" == "completed":
        vibe_status = "done"
    elif "$status" == "failed":
        vibe_status = "blocked"
    else:
        vibe_status = "todo"

    # Build description from payload
    payload = task.get('payload', {})
    if isinstance(payload, dict):
        desc_parts = []
        if 'action' in payload:
            desc_parts.append(f"Action: {payload['action']}")
        if 'description' in payload:
            desc_parts.append(payload['description'])
        if 'command' in payload:
            desc_parts.append(f"Command: {payload['command']}")
        description = "\n".join(desc_parts) if desc_parts else json.dumps(payload, indent=2)
    else:
        description = str(payload)

    # Get agent type for tagging
    agent_type = task.get('type', 'unknown')
    swarm = agent_type.split('-')[0] if '-' in agent_type else 'general'

    # Priority mapping (ELITE uses 1-10, higher is more important)
    priority = task.get('priority', 5)
    if priority >= 8:
        priority_tag = "priority-high"
    elif priority >= 5:
        priority_tag = "priority-medium"
    else:
        priority_tag = "priority-low"

    vibe_task = {
        "id": f"elite-{task_id}",
        "title": f"[{agent_type}] {payload.get('action', 'Task')}",
        "description": description,
        "status": vibe_status,
        "agent": "claude-code",
        "tags": [
            agent_type,
            f"swarm-{swarm}",
            priority_tag,
            f"phase-$CURRENT_PHASE".lower()
        ],
        "metadata": {
            "eliteTaskId": task_id,
            "eliteType": agent_type,
            "elitePriority": priority,
            "elitePhase": "$CURRENT_PHASE",
            "eliteRetries": task.get('retries', 0),
            "createdAt": task.get('createdAt', datetime.utcnow().isoformat() + 'Z'),
            "claimedBy": task.get('claimedBy'),
            "lastError": task.get('lastError')
        }
    }

    # Write task file
    task_file = os.path.join(export_dir, f"{task_id}.json")
    with open(task_file, 'w') as out:
        json.dump(vibe_task, out, indent=2)
    exported += 1

print(f"EXPORTED:{exported}")
EOF
}

log_info "Exporting ELITE tasks to Vibe Kanban..."
log_info "Export directory: $EXPORT_DIR"
log_info "Current phase: $CURRENT_PHASE"

TOTAL=0

# Export from each queue
for queue in pending in-progress completed failed dead-letter; do
    queue_file="$ELITE_DIR/queue/${queue}.json"
    if [ -f "$queue_file" ]; then
        result=$(export_queue "$queue_file" "$queue")
        count=$(echo "$result" | grep "EXPORTED:" | cut -d: -f2)
        if [ -n "$count" ] && [ "$count" -gt 0 ]; then
            log_info "  $queue: $count tasks"
            TOTAL=$((TOTAL + count))
        fi
    fi
done

# Create summary file
cat > "$EXPORT_DIR/_elite_summary.json" << EOF
{
    "exportedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "currentPhase": "$CURRENT_PHASE",
    "totalTasks": $TOTAL,
    "eliteVersion": "$(cat VERSION 2>/dev/null || echo 'unknown')",
    "column": "$(phase_to_column "$CURRENT_PHASE")"
}
EOF

log_info "Exported $TOTAL tasks total"
log_info "Summary written to $EXPORT_DIR/_elite_summary.json"
