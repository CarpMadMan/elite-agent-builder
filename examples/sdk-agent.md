# ARD: Autonomous Agent for Task Management

## Overview
Create an Agent SDK agent that autonomously manages tasks using tool calls, with goal-seeking behavior and state persistence.

## Agent Pattern
Autonomous Loop with goal-seeking behavior

## Features
- **add_task** - Add a new task
- **list_tasks** - List all tasks (with filtering)
- **complete_task** - Mark a task as complete
- **prioritize_tasks** - Auto-organize tasks by priority
- **generate_summary** - Generate task summary

## Tech Stack
- Agent SDK (for autonomous execution)
- @anthropic-ai/sdk
- File-based state (JSON)
- Tool definitions with JSON Schema

## Agent Behavior

### Decision Loop
1. Start with user message/goal
2. Analyze current state (read from file)
3. Decide which tool to call (if any)
4. Execute tool
5. Update state
6. Check if goal achieved
7. If not achieved, continue loop
8. If achieved, return summary

### State Management
```typescript
interface AgentState {
  tasks: Array<{
    id: string;
    title: string;
    priority: number;
    completed: boolean;
    createdAt: string;
  }>;
  checkpoint: number;
  lastAction: string;
}
```

## Success Criteria
- Reaches goal in N turns (autonomous termination)
- Handles tool errors gracefully
- State persists across restarts
- Demonstrates goal-seeking behavior

## Example Conversation
```
User: Add 5 tasks, prioritize them, then complete the top 3.

Agent: I'll help you with that.

[Tool Call] add_task({ title: "Review PR", priority: 1 })
[Tool Call] add_task({ title: "Write tests", priority: 2 })
[Tool Call] add_task({ title: "Update docs", priority: 3 })
[Tool Call] add_task({ title: "Fix bug", priority: 1 })
[Tool Call] add_task({ title: "Refactor code", priority: 2 })

[Tool Call] prioritize_tasks()
-> Tasks reorganized by priority

[Tool Call] complete_task({ id: "1" })
[Tool Call] complete_task({ id: "4" })
[Tool Call] complete_task({ id: "2" })

Summary: Completed 3 high-priority tasks. 2 tasks remaining.
```

## Out of Scope
- Multi-user support
- Task dependencies
- Subtasks
- Reminders/due dates
