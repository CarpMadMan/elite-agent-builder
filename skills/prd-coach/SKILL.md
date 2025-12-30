---
name: prd-coach
description: Interactive PRD/ARD development coach. Helps users refine ideas into complete Agent Requirements Documents before executing ELITE. Supports Quick mode (5-7 core questions for experienced users) and Deep dive mode (15-20 comprehensive questions with iterative refinement). Features conversational requirements gathering, ARD generation, review and refinement workflow, and seamless ELITE integration.
triggers:
  - "PRD Coach"
  - "Help me write a PRD"
  - "Help me write requirements"
  - "Help me write an ARD"
---

# PRD Coach - Interactive Requirements Development

## Overview

PRD Coach is an interactive skill that helps you transform rough ideas into complete, well-structured ARD (Agent Requirements Document) files ready for ELITE execution.

## How It Works

1. **Mode Selection** - Choose Quick mode or Deep dive based on your experience level
2. **Conversational Questions** - Answer questions about your agent system
3. **ARD Generation** - Receive a complete ARD formatted for ELITE
4. **Review & Refine** - Edit, regenerate, or approve the ARD
5. **ELITE Integration** - Execute ELITE with your approved ARD

## Modes

### Quick Mode (5-7 Questions)
Best for:
- Experienced users who understand agent systems
- Simple, straightforward agent ideas
- Users who want to get started quickly

Questions cover:
- Core concept and purpose
- Agent type selection
- Key features and tools
- Tech stack preferences
- Success criteria

### Deep Dive Mode (15-20 Questions)
Best for:
- New users exploring agent development
- Complex multi-agent systems
- Projects requiring comprehensive planning

Questions cover:
- All Quick mode topics (expanded)
- Detailed feature specifications
- Resource definitions
- Prompt engineering requirements
- Edge cases and constraints
- Out-of-scope items
- Usage examples and scenarios

## Conversation Flow

### Phase 1: Welcome
```
Welcome to PRD Coach! I'll help you develop a complete ARD for your agent system.

Which mode would you prefer?
- Quick mode: 5-7 core questions (for experienced users)
- Deep dive: 15-20 comprehensive questions with iterative refinement
```

### Phase 2: Questioning
Based on your mode selection, I'll ask questions to understand:
- What problem your agent system solves
- What type of agent(s) you need
- What tools and resources are required
- Technical preferences and constraints
- Success criteria and boundaries

### Phase 3: ARD Generation
I'll generate a complete ARD document formatted for ELITE execution.

### Phase 4: Review & Refine
```
Here's your ARD. Please review:

[ARD content]

Options:
1. Approve - Ready for ELITE
2. Edit specific section - I'll help you refine
3. Regenerate - Start with different answers
4. Start over - Begin fresh
```

### Phase 5: ELITE Handoff
When you approve:
```
Your ARD is ready! To execute ELITE, run:

./autonomy/run.sh .elite/prd-coach-ard.md

Would you like me to execute ELITE now with this ARD?
```

## ARD Format

The generated ARD follows ELITE's standard format:

```markdown
# [Project Name] - Agent Requirements Document

## Executive Summary
[Brief 2-3 sentence overview]

## Agent Type
[Request-response | Autonomous loop | Event-driven | Multi-agent workflow]

## Features

### Tools
[List of tools with descriptions]

### Resources
[List of resources with descriptions]

### Prompts
[Prompt templates and system instructions]

## Tech Stack
[Language, framework, dependencies]

## Success Criteria
[Measurable outcomes and validation criteria]

## Out of Scope
[What will NOT be implemented]

## Usage Examples
[Concrete usage scenarios]
```

## Integration with ELITE

After approving your ARD:
1. The ARD is saved to `.elite/prd-coach-ard.md`
2. ELITE command is displayed for review
3. Confirm to execute ELITE with your ARD
4. ELITE autonomously builds your agent system

## Tips for Best Results

- **Be Specific**: Detailed answers lead to better ARDs
- **Think Examples**: Provide concrete usage scenarios
- **Know Constraints**: Identify technical limitations upfront
- **Iterate**: Use the review phase to refine your ARD
- **Ask Questions**: If you're unsure, ask for clarification

## Prerequisites

- Claude Code CLI installed
- ELITE framework available
- Basic understanding of what you want to build

## See Also

- [ELITE README](../../README.md) - Main ELITE documentation
- [ELITE Examples](../../examples/) - Sample ARD files for reference
- [Agent Mode Skill](../../SKILL.md) - ELITE's autonomous build system

## Skill Metadata

| Field | Value |
|-------|-------|
| **Trigger** | "PRD Coach", "Help me write a PRD/ARD" |
| **Output** | ARD file at `.elite/prd-coach-ard.md` |
| **Next Step** | Execute ELITE with generated ARD |
| **Modes** | Quick (5-7 questions), Deep dive (15-20 questions) |
