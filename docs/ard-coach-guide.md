# ARD Coach - Complete Usage Guide

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Mode Comparison](#mode-comparison)
- [Complete Session Examples](#complete-session-examples)
- [ARD Format Reference](#ard-format-reference)
- [Tips & Best Practices](#tips--best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

**ARD Coach** is an interactive skill that helps you transform rough ideas into complete, well-structured ARD (Agent Requirements Document) files ready for ELITE execution.

### Why Use ARD Coach?

| Without ARD Coach | With ARD Coach |
|-------------------|----------------|
| Need to learn ARD format | Guided conversational questions |
| Unsure what to include | Targeted questions for each section |
| Manual formatting | Auto-generated properly formatted ARD |
| Risk of missing requirements | Comprehensive coverage |
| Edit-retry cycle | Review and refine before ELITE |

### Key Features

- **Two Modes**: Quick (5-7 questions) or Deep dive (15-20 questions)
- **Interactive**: Conversational Q&A with follow-ups
- **Adaptive**: Switch modes anytime, edit any section
- **Validated**: Ensures ARD meets ELITE requirements
- **Integrated**: One-click ELITE execution after approval

---

## Installation

### Prerequisites

1. Claude Code CLI installed
2. ELITE framework available
3. Basic understanding of what you want to build

### Install ARD Coach

```bash
# Navigate to ELITE directory
cd /path/to/elite-agent-builder

# Create symlink for ARD Coach
mkdir -p ~/.claude/skills/ard-coach
ln -s "$(pwd)/skills/ard-coach/SKILL.md" ~/.claude/skills/ard-coach/

# Verify installation
cat ~/.claude/skills/ard-coach/SKILL.md | head -5
# Should show: name: ard-coach
```

### Verify Installation

```bash
# Launch Claude Code
claude --dangerously-skip-permissions

# Test trigger
> ARD Coach

# Should respond with welcome message
```

---

## Quick Start

### Step 1: Launch Claude Code

```bash
claude --dangerously-skip-permissions
```

### Step 2: Trigger ARD Coach

Say any of these phrases:
- "ARD Coach"
- "Help me write a PRD"
- "Help me write requirements"
- "Help me write an ARD"

### Step 3: Select Mode

```
Welcome to ARD Coach! Which mode would you prefer?

1. Quick mode: 5-7 core questions (for experienced users)
2. Deep dive: 15-20 comprehensive questions
```

Type your choice and continue.

### Step 4: Answer Questions

ARD Coach will ask questions about your agent system. Answer in your own words - ARD Coach will interpret and format your responses.

### Step 5: Review ARD

After answering all questions, ARD Coach will generate and display your complete ARD.

### Step 6: Approve or Refine

Choose:
1. **Approve** - Ready to execute ELITE
2. **Edit section** - Modify specific parts
3. **Regenerate** - Start over with different answers
4. **Save for later** - Save ARD without executing ELITE

---

## Mode Comparison

### Quick Mode

**Best For:**
- Experienced users familiar with agent systems
- Simple, straightforward projects
- Quick prototyping and iteration

**Questions (5-7):**
1. Core concept - What problem does it solve?
2. Agent type - Request-response, autonomous, event-driven, or multi-agent?
3. Key features - What tools/capabilities are needed?
4. Tech stack - Language, framework, preferences?
5. Success criteria - How will you know it works?

**Time:** 5-10 minutes

**Output:** Concise ARD with sensible defaults

### Deep Dive Mode

**Best For:**
- New users exploring agent development
- Complex multi-agent systems
- Projects requiring comprehensive planning
- Team collaborations needing detailed specs

**Questions (15-20):**

| Section | Questions |
|---------|-----------|
| Project Overview | 2 - Problem statement, vision |
| Agent Architecture | 2 - Agent pattern, behavior |
| Features & Capabilities | 3 - Primary tools, helpers, resources |
| Technical Specifications | 4 - Language, framework, transport, state |
| Prompts & Instructions | 2 - System prompts, engineering |
| Boundaries & Constraints | 3 - Out of scope, constraints, security |
| Success & Validation | 2 - Success criteria, testing |
| Usage Examples | 2 - Typical scenarios, edge cases |

**Time:** 15-30 minutes

**Output:** Comprehensive ARD with detailed specifications

---

## Complete Session Examples

### Example 1: Quick Mode - GitHub Issue Monitor

```
You: ARD Coach

Coach: Welcome to ARD Coach! Which mode would you prefer?
       1. Quick mode: 5-7 core questions
       2. Deep dive: 15-20 comprehensive questions

You: Quick mode

Coach: Great! Let's start with the core concept.
       What is the core problem your agent system will solve?

You: I want an agent that monitors GitHub repositories and sends
     alerts to Slack when new issues match specific keywords.

Coach: Got it. What type of agent pattern best fits your needs?

       1. Request-Response - Simple question-answer interactions
       2. Autonomous Loop - Agent observes, decides, acts independently
       3. Event-Driven - Triggered by external events (webhooks, messages)
       4. Multi-Agent Workflow - Specialized agents collaborating

You: Event-driven - it should poll GitHub periodically and alert when
     matching issues are found.

Coach: Perfect for your use case. What are the key capabilities
       your agent needs? Please list 3-5 tools with descriptions.

You: 1. Fetch GitHub issues - Get issues from a repository
     2. Filter by keywords - Match issue titles/body against keywords
     3. Send Slack notification - Post alert to a Slack channel
     4. Track processed issues - Avoid duplicate alerts

Coach: Excellent. What are your technical preferences?
       Programming language, frameworks, any specific requirements?

You: TypeScript is fine. Use stdio transport. No special frameworks.

Coach: How will you know the agent is working correctly?
       List 2-3 measurable success criteria.

You: 1. Successfully fetches issues from GitHub API
     2. Correctly filters by keywords (verified with test cases)
     3. Sends Slack notifications without duplicates

Coach: Will the agent need access to any static resources or data?

You: Just a config file for GitHub token, Slack webhook, and keywords.

Coach: Provide one concrete example of how you'd use this agent.

You: Config specifies keywords "bug,crash,critical" for repo "acme/app".
     Agent runs every 5 minutes, finds issue #42 titled "Crash on startup",
     sends Slack alert: "New issue matching keywords: #42 - Crash on startup"

Coach: Here's your ARD. Please review it carefully:
       [Displays complete ARD...]

Coach: What would you like to do?
       1. Approve - Ready for ELITE
       2. Edit section - Modify a specific section
       3. Regenerate - Start over
       4. Save for later

You: Approve

Coach: Your ARD is ready! It has been saved to:
       .elite/ard-coach-ard.md

       To execute ELITE with your ARD, run:
       ./autonomy/run.sh .elite/ard-coach-ard.md

       Would you like me to execute ELITE now? [yes/no]

You: yes

Coach: [Executes ELITE autonomously...]
```

### Example 2: Deep Dive Mode - Code Review System

```
You: ARD Coach

Coach: Welcome to ARD Coach! Which mode would you prefer?

You: Deep dive - I need to plan a comprehensive system

Coach: Excellent! Let's explore your requirements thoroughly.
       Describe the problem your agent system will solve in detail.
       What pain points does it address? Who are the target users?

You: My team spends hours reviewing pull requests for basic issues.
       I want an automated code review system that catches common
       problems before human review. Target users are our development
       team of ~20 engineers.

Coach: What does success look like for this project?
       If everything works perfectly, what would the experience be?

You: Developers push code, agent reviews automatically within 2 minutes,
       provides feedback on our pull request. Humans focus on logic/design
       instead of syntax/style issues. Quality improves, review time
       decreases.

Coach: Which agent pattern best fits your use case?
       [Explains all patterns with pros/cons...]

You: Multi-agent workflow - different specialists for different checks.
       One for security, one for performance, one for style.

[... continues through 18 more comprehensive questions ...]

Coach: Here's your ARD. Please review it carefully:
       [Displays comprehensive ARD with all sections...]

Coach: What would you like to do?
       1. Approve - Ready for ELITE
       2. Edit section - I want to modify the Tools section
       3. Regenerate - Start over
       4. Save for later

You: Edit section - Tools

Coach: Which specific tool would you like to modify?

You: The security analysis tool - I want to add OWASP dependency checking

Coach: Got it. Adding OWASP dependency check to security analysis tool.
       [Regenerates ARD...]

Coach: Here's your updated ARD. What would you like to do?

You: Approve

Coach: Your ARD is ready! Would you like me to execute ELITE now?

You: Save for later

Coach: No problem! Your ARD is saved at .elite/ard-coach-ard.md

       You can execute ELITE manually anytime by running:
       ./autonomy/run.sh .elite/ard-coach-ard.md

       Thanks for using ARD Coach!
```

---

## ARD Format Reference

ARD Coach generates ARDs following this structure:

```markdown
# Project Name - Agent Requirements Document

## Executive Summary
2-3 sentence overview of the project

## Agent Type
Request-response | Autonomous loop | Event-driven | Multi-agent workflow

## Features

### Tools
| Tool Name | Description | Input | Output |

### Resources
| Resource Name | Description | Type |

### Prompts
System instructions and prompt templates

## Tech Stack
- Language: TypeScript | Python | Other
- Framework: (if applicable)
- MCP Transport: stdio | SSE
- State Management: File-based | Database | In-memory

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Out of Scope
- Item 1
- Item 2
- Item 3

## Usage Examples
### Example 1: Title
Description and interaction flow

### Example 2: Title
Description and interaction flow
```

---

## Tips & Best Practices

### Before Starting ARD Coach

1. **Have a rough idea** - You don't need a full spec, but know what problem you're solving
2. **Know your constraints** - Tech stack preferences, deadlines, resources
3. **Identify users** - Who will use this? What's their skill level?

### During the Session

1. **Be specific** - Detailed answers lead to better ARDs
2. **Use examples** - Concrete scenarios help ARD Coach understand your needs
3. **Ask questions** - If you're unsure about agent patterns or options, ask ARD Coach to explain
4. **Think edges** - Consider error cases, unusual inputs, constraints
5. **Iterate** - Use the review phase to refine and improve

### Common Pitfalls to Avoid

| Pitfall | Solution |
|---------|----------|
| Too vague | Provide specific examples and concrete scenarios |
| Over-specified | Use Quick mode for simpler projects |
| Under-specified | Use Deep dive for complex systems |
| Ignoring constraints | Mention technical, security, compliance limits |
| Skipping review | Always review the generated ARD before approving |

### Getting Better Results

1. **Start with Quick mode** - Get a baseline ARD quickly
2. **Switch to Deep dive** - If you need more detail, ARD Coach keeps your answers
3. **Edit sections** - Refine specific parts without starting over
4. **Save multiple versions** - "Save for later" lets you iterate separately

---

## Troubleshooting

### ARD Coach Won't Trigger

**Problem:** Saying "ARD Coach" doesn't activate the skill

**Solutions:**
```bash
# Check skill is installed
ls ~/.claude/skills/ard-coach/SKILL.md

# If missing, reinstall:
mkdir -p ~/.claude/skills/ard-coach
ln -s "$(pwd)/skills/ard-coach/SKILL.md" ~/.claude/skills/ard-coach/

# Verify YAML frontmatter
head -5 ~/.claude/skills/ard-coach/SKILL.md
# Should show: name: ard-coach
```

### Generated ARD Looks Wrong

**Problem:** ARD has incorrect or incomplete information

**Solutions:**
1. Choose "Edit section" to fix specific parts
2. Choose "Regenerate" to answer questions again
3. Be more specific in your answers
4. Provide examples to clarify your requirements

### Can't Decide Between Modes

**Guidance:**
- Choose **Quick mode** if: You've built agents before, project is straightforward
- Choose **Deep dive** if: New to agents, complex system, team project

**Tip:** You can switch modes anytime - ARD Coach keeps your answers!

### ELITE Execution Fails

**Problem:** ARD approved but ELITE doesn't run

**Solutions:**
```bash
# Check prerequisites
./autonomy/run.sh --help

# Verify ARD file exists
cat .elite/ard-coach-ard.md

# Run ELITE manually
./autonomy/run.sh .elite/ard-coach-ard.md
```

---

## Next Steps

After ARD Coach generates your ARD:

1. **Review the ARD** - Read through all sections
2. **Edit if needed** - Use "Edit section" to refine
3. **Approve** - Give the go-ahead
4. **Execute ELITE** - Watch your agent system build autonomously

For more information, see:
- [ELITE README](../README.md) - Main ELITE documentation
- [Example ARDs](../examples/) - Sample ARD files
- [Agent Mode Skill](../SKILL.md) - ELITE autonomous build system
