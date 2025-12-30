# Quick Mode Questions (5-7 Core Questions)

These questions are designed for experienced users who want to quickly generate an ARD without extensive discussion.

---

## Question 1: Core Concept

**Prompt:**
"What is the core problem your agent system will solve? Please provide a brief 1-2 sentence description."

**Follow-up (if needed):**
"Think about: What pain point does it address? Who will use it?"

**Captures:** Executive summary foundation

---

## Question 2: Agent Type

**Prompt:**
"What type of agent pattern best fits your needs?"

**Options to present:**
1. **Request-Response** - Simple question-answer interactions
2. **Autonomous Loop** - Agent makes decisions and acts independently
3. **Event-Driven** - Responds to triggers/webhooks
4. **Multi-Agent Workflow** - Multiple specialized agents coordinating

**Follow-up (if needed):**
"If you're unsure, describe how you envision the agent working and I'll suggest a pattern."

**Captures:** Agent type selection

---

## Question 3: Key Features & Tools

**Prompt:**
"What are the 3-5 key capabilities your agent needs? For each, briefly describe what it should do."

**Example format:**
"1. Fetch GitHub issues - Retrieve issues from a repository
2. Summarize changes - Generate concise summaries of PR diffs
3. Post to Slack - Send notifications to a channel"

**Follow-up (if needed):**
"Think about: What external APIs will it call? What data will it process?"

**Captures:** Tools definition

---

## Question 4: Tech Stack

**Prompt:**
"What are your technical preferences?"

**Questions:**
1. Programming language (TypeScript, Python, other)?
2. Any specific frameworks or libraries you prefer?
3. Should it run as an MCP server, standalone agent, or both?

**Follow-up (if needed):**
"If unsure, I can suggest defaults based on your requirements."

**Captures:** Tech stack, language, framework, MCP transport

---

## Question 5: Success Criteria

**Prompt:**
"How will you know the agent is working correctly? List 2-3 measurable outcomes."

**Examples:**
- "Agent correctly processes 95% of test cases"
- "Response time under 2 seconds for typical queries"
- "Successfully handles edge case X"

**Follow-up (if needed):**
"Think about: What would constitute a failure? What are the must-haves?"

**Captures:** Success criteria

---

## Optional Question 6: Resources (if applicable)

**Prompt:**
"Will the agent need access to any static resources or data files?"

**Examples:**
- Configuration files
- Reference documents
- Data lookup tables
- Cached information

**Follow-up (if none):**
"That's fine - we can add resources later if needed."

**Captures:** Resources (optional)

---

## Optional Question 7: Usage Example

**Prompt:**
"Provide one concrete example of how you'd use this agent in practice."

**Example:**
"User asks: 'What's the status of the authentication bug?'
Agent responds: 'Issue #123 is in progress, assigned to @jane, ETA Friday'"

**Follow-up (if needed):**
"Think about a realistic interaction from end to end."

**Captures:** Usage examples

---

## Quick Mode Completion

After these questions, generate the ARD using the template with:
- Sensible defaults for unspecified fields
- "To be determined" placeholders for optional items
- Concise but complete content for provided answers
