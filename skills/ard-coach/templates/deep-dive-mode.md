# Deep Dive Mode Questions (15-20 Comprehensive Questions)

These questions provide comprehensive exploration of all ARD sections with opportunities for clarification and refinement.

---

## Section 1: Project Overview

### Question 1: Problem Statement
**Prompt:** "Describe the problem your agent system will solve in detail. What pain points does it address? Who are the target users?"

**Follow-ups:**
- "What is the current workaround or solution?"
- "Why is this problem worth solving?"
- "What happens if this problem isn't solved?"

**Captures:** Executive summary, project context

### Question 2: Vision & Goals
**Prompt:** "What does success look like for this project? If everything works perfectly, what would the experience be?"

**Follow-ups:**
- "What's the minimum viable version?"
- "What's the ideal future state?"

**Captures:** Success criteria, vision

---

## Section 2: Agent Architecture

### Question 3: Agent Pattern Selection
**Prompt:** "Which agent pattern best fits your use case?"

**Detailed options:**
1. **Request-Response** - Simple Q&A, stateless interactions
2. **Autonomous Loop** - Agent observes, decides, acts in a loop
3. **Event-Driven** - Triggered by external events (webhooks, messages)
4. **Multi-Agent Workflow** - Specialized agents collaborating
5. **Hybrid** - Combination of patterns

**Follow-ups:**
- "How frequently will the agent need to act?"
- "Does it need to maintain state between interactions?"
- "Will multiple agents work together?"

**Captures:** Agent type, architecture decisions

### Question 4: Agent Behavior
**Prompt:** "Describe how the agent should behave in key scenarios. Walk me through a typical interaction."

**Follow-ups:**
- "What should happen on error?"
- "How should it handle unexpected inputs?"
- "Are there any guardrails or constraints?"

**Captures:** Behavior specification, edge cases

---

## Section 3: Features & Capabilities

### Question 5: Primary Tools (Capabilities)
**Prompt:** "List all the tools/capabilities your agent needs. For each, provide:
- Tool name
- What it does
- What inputs it requires
- What it returns"

**Follow-ups:**
- "Which tools are essential vs nice-to-have?"
- "Do any tools depend on others?"
- "Are there external APIs to integrate?"

**Captures:** Tools definition

### Question 6: Secondary Tools & Helpers
**Prompt:** "What supporting capabilities might be needed? Examples: validation, formatting, logging, monitoring."

**Follow-ups:**
- "How should debugging work?"
- "Is observability needed?"

**Captures:** Additional tools

### Question 7: Resources & Data
**Prompt:** "Will the agent need access to static resources or reference data?"

**Examples:**
- Configuration files
- Lookup tables
- Documentation/knowledge bases
- Templates
- Cached data

**Follow-ups:**
- "How often does this data change?"
- "Who maintains it?"

**Captures:** Resources definition

---

## Section 4: Technical Specifications

### Question 8: Programming Language
**Prompt:** "What programming language should be used? Consider:
- Your team's expertise
- Existing codebase language
- Ecosystem/library availability"

**Options:** TypeScript, Python, Go, Rust, Other

**Follow-ups:**
- "Any specific version requirements?"
- "Why this language over alternatives?"

**Captures:** Language selection

### Question 9: Frameworks & Libraries
**Prompt:** "Are there specific frameworks, libraries, or packages you want to use or avoid?"

**Follow-ups:**
- "Any dependencies on existing systems?"
- "Prefer lightweight vs feature-rich frameworks?"

**Captures:** Framework, dependencies

### Question 10: Transport & Communication
**Prompt:** "How should the agent communicate?"

**Options:**
- **stdio** - Standard input/output (simplest)
- **SSE** - Server-Sent Events (for streaming)
- **HTTP/WebSocket** - For web-based interactions

**Follow-ups:**
- "Does it need real-time updates?"
- "Any firewall or network constraints?"

**Captures:** MCP transport

### Question 11: State Management
**Prompt:** "How should the agent manage state?"

**Options:**
- **Stateless** - No memory between requests
- **File-based** - Simple persistence to files
- **Database** - SQL or NoSQL database
- **In-memory** - With periodic persistence

**Follow-ups:**
- "What data needs to be persisted?"
- "How long should state be kept?"

**Captures:** State management approach

---

## Section 5: Prompts & Instructions

### Question 12: System Prompts
**Prompt:** "What instructions should guide the agent's behavior? Think about:
- Personality/tone
- Behavioral guidelines
- Response format expectations"

**Follow-ups:**
- "Any format requirements for outputs?"
- "Should it adopt a specific persona?"

**Captures:** Prompt templates

### Question 13: Prompt Engineering
**Prompt:** "Are there specific prompt patterns or techniques to use?"

**Examples:**
- Few-shot examples
- Chain-of-thought reasoning
- Output formatting (JSON, markdown, etc.)
- Safety constraints

**Captures:** Prompt strategies

---

## Section 6: Boundaries & Constraints

### Question 14: Out of Scope
**Prompt:** "What should the agent NOT do? What's explicitly out of scope?"

**Examples:**
- Features for future versions
- Things the agent should refuse to do
- Domains it shouldn't touch

**Follow-ups:**
- "What are common misconceptions about its capabilities?"

**Captures:** Out of scope items

### Question 15: Technical Constraints
**Prompt:** "Are there any technical limitations or constraints?"

**Examples:**
- API rate limits
- Memory/CPU constraints
- Compliance requirements
- Security restrictions

**Captures:** Technical constraints

### Question 16: Security Considerations
**Prompt:** "What security measures are needed?"

**Considerations:**
- Authentication/authorization
- Data privacy
- PII handling
- API key management
- Input sanitization

**Captures:** Security requirements

---

## Section 7: Success & Validation

### Question 17: Success Criteria
**Prompt:** "List the specific, measurable criteria for success. What must work for this to be considered complete?"

**Framework:** SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound)

**Examples:**
- "Agent accurately classifies 95% of inputs"
- "Response time P95 under 500ms"
- "Zero critical security vulnerabilities"

**Captures:** Success criteria

### Question 18: Testing Strategy
**Prompt:** "How should this be tested?"

**Considerations:**
- Unit tests
- Integration tests
- E2E scenarios
- Manual testing

**Follow-ups:**
- "What are the critical test cases?"
- "How will edge cases be covered?"

**Captures:** Testing approach (informs success criteria)

---

## Section 8: Usage Examples

### Question 19: Typical Usage Scenarios
**Prompt:** "Provide 2-3 concrete examples of how the agent will be used in practice. Walk through the entire interaction."

**Format:**
```
User input: [...]
Agent action: [...]
Agent output: [...]
```

**Follow-ups:**
- "What's the most common use case?"
- "What's a power user scenario?"

**Captures:** Usage examples

### Question 20: Edge Cases
**Prompt:** "What unusual or challenging scenarios might the agent encounter?"

**Examples:**
- Empty or malformed input
- External service failures
- Conflicting requests
- Resource exhaustion

**Captures:** Edge cases, behavior under stress

---

## Deep Dive Mode Completion

After these questions:
1. Generate a comprehensive ARD with all sections filled
2. Highlight any areas that need clarification
3. Offer to iterate on specific sections
4. Ensure consistency across all responses
5. Validate that all ARD sections have appropriate content
