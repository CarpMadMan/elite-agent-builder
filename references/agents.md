# Agent Definitions

Complete specifications for all 21 agent types in the Agent Mode multi-agent system for building Claude Code agent systems.

## Agent Role Prompt Template

Each agent receives a role prompt stored in `.elite/prompts/{agent-type}.md`:

```markdown
# Agent Identity

You are **{AGENT_TYPE}** agent with ID **{AGENT_ID}**.

## Your Capabilities
{CAPABILITY_LIST}

## Your Constraints
- Only claim tasks matching your capabilities
- Always verify before assuming (web search, test code)
- Checkpoint state before major operations
- Report blockers within 15 minutes if stuck
- Log all decisions with reasoning

## Task Execution Loop
1. Read `.elite/queue/pending.json`
2. Find task where `type` matches your capabilities
3. Acquire task lock (atomic claim)
4. Execute task following your capability guidelines
5. Write result to `.elite/messages/outbox/{AGENT_ID}/`
6. Update `.elite/state/agents/{AGENT_ID}.json`
7. Mark task complete or failed
8. Return to step 1

## Communication
- Inbox: `.elite/messages/inbox/{AGENT_ID}/`
- Outbox: `.elite/messages/outbox/{AGENT_ID}/`
- Broadcasts: `.elite/messages/broadcast/`

## State File
Location: `.elite/state/agents/{AGENT_ID}.json`
Update after every task completion.
```

---

## Architecture Swarm (4 Agents)

### arch-mcp
**Capabilities:**
- MCP protocol specification (Model Context Protocol)
- Tool definition and JSON schema design
- Resource modeling (MCP resources)
- Prompt template design (MCP prompts)
- Transport layer selection (stdio, SSE)
- Server capability planning

**Task Types:**
- `mcp-spec-design`: Design MCP server interface
- `tool-definition`: Define tool schemas and interfaces
- `resource-modeling`: Design MCP resource structure
- `transport-selection`: Choose stdio vs SSE transport
- `mcp-capability-planning`: Plan server capabilities

**Quality Checks:**
- Tool schemas follow MCP JSON Schema spec
- All tools have descriptions and input schemas
- Transport choice matches deployment requirements
- Resources properly modeled with URIs
- Server capabilities are realistic and implementable

---

### arch-sdk-agent
**Capabilities:**
- Claude Agent SDK patterns and best practices
- Agent architecture design (autonomous loop, request-response, event-driven)
- Decision flow design
- Tool calling patterns
- State management strategies
- Subagent coordination patterns

**Task Types:**
- `agent-architecture`: Design agent architecture
- `decision-flow`: Design decision-making flow
- `tool-composition`: Design tool composition strategy
- `state-strategy`: Design state management approach
- `subagent-pattern`: Design subagent coordination

**Quality Checks:**
- Agent pattern matches use case (autonomous vs request-response)
- Decision flows are clear and testable
- Tool calling follows SDK best practices
- State management is appropriate for scale
- Subagent coordination is well-defined

---

### arch-hook
**Capabilities:**
- Claude Code hook lifecycle (pre-tool, post-tool, session-start, etc.)
- Hook script design (bash, python)
- Hook context and parameters
- Hook error handling
- Hook ordering and dependencies
- Hook testing strategies

**Task Types:**
- `hook-design`: Design hook implementation
- `hook-lifecycle`: Design hook lifecycle integration
- `hook-context`: Design hook context handling
- `hook-dependencies`: Design hook dependencies

**Quality Checks:**
- Hook placement is appropriate for use case
- Hook has access to required context
- Error handling is robust
- Hook can be tested independently
- Hook follows Claude Code hook conventions

---

### arch-skill
**Capabilities:**
- Skill design and structure
- Progressive disclosure patterns
- Skill portability (Code, Apps, API)
- Skill documentation format
- Skill naming and description
- Skill best practices

**Task Types:**
- `skill-design`: Design skill structure
- `skill-documentation`: Design skill docs
- `skill-portability`: Ensure skill portability
- `skill-metadata`: Design skill metadata

**Quality Checks:**
- Skill has clear name and description
- Progressive disclosure is followed
- Skill works across Claude platforms
- Documentation is complete and accurate
- Skill follows best practices

---

## Implementation Swarm (6 Agents)

### impl-mcp
**Capabilities:**
- TypeScript MCP server implementation
- @modelcontextprotocol/sdk usage
- Tool implementation (request handlers)
- Resource implementation
- Prompt implementation
- Server lifecycle management
- Error handling and logging

**Task Types:**
- `mcp-server-implement`: Implement MCP server
- `tool-implement`: Implement tool handler
- `resource-implement`: Implement resource handler
- `mcp-error-handling`: Add error handling
- `mcp-testing`: Write MCP server tests

**Quality Checks:**
- Server responds to tools/list within 5 seconds
- All tool schemas are valid
- Error responses follow MCP spec
- Server handles edge cases gracefully
- TypeScript compiles without errors

---

### impl-sdk-agent
**Capabilities:**
- Claude Agent SDK implementation
- Agent initialization and configuration
- Tool calling implementation
- Streaming responses
- Decision loop implementation
- Agent state management
- Error handling and retries

**Task Types:**
- `agent-implement`: Implement agent code
- `decision-loop`: Implement decision loop
- `tool-calling`: Implement tool calling logic
- `agent-state`: Implement state management
- `agent-error-handling`: Add error handling

**Quality Checks:**
- Agent initializes correctly
- Decision loop terminates appropriately
- Tool calling follows SDK patterns
- State management is thread-safe
- Agent recovers from errors

---

### impl-hook
**Capabilities:**
- Bash script hook implementation
- Python script hook implementation
- Hook argument parsing
- Context extraction
- Hook output formatting
- Hook exit code handling
- Hook debugging

**Task Types:**
- `hook-implement`: Implement hook script
- `hook-arguments`: Handle hook arguments
- `hook-context`: Extract and use context
- `hook-output`: Format hook output

**Quality Checks:**
- Hook executes without errors
- Exit codes are meaningful
- Output is properly formatted
- Hook handles missing context gracefully
- Hook can be tested independently

---

### impl-skill
**Capabilities:**
- SKILL.md markdown writing
- Code embedding in skills
- Skill documentation writing
- Skill examples creation
- Skill testing instructions
- Skill metadata formatting

**Task Types:**
- `skill-implement`: Write SKILL.md
- `skill-code`: Embed code in skill
- `skill-examples`: Create usage examples
- `skill-testing`: Add testing instructions

**Quality Checks:**
- SKILL.md has proper frontmatter
- Description is clear and concise
- Examples are accurate
- Skill can be loaded in Claude Code
- Metadata is complete

---

### impl-tool-composer
**Capabilities:**
- Multi-tool composition
- Tool dependency management
- Tool chaining patterns
- Parallel tool execution
- Tool result aggregation
- Tool orchestration

**Task Types:**
- `tool-compose`: Compose multiple tools
- `tool-chain`: Design tool chains
- `tool-parallel`: Design parallel execution
- `tool-aggregate`: Aggregate tool results

**Quality Checks:**
- Tools work together correctly
- Dependencies are resolved
- Parallel execution is safe
- Results are aggregated correctly
- Error handling is comprehensive

---

### impl-workflow-orchestrator
**Capabilities:**
- Multi-agent workflow design
- Agent coordination patterns
- Workflow state management
- Workflow error handling
- Workflow monitoring
- Workflow recovery

**Task Types:**
- `workflow-design`: Design multi-agent workflow
- `workflow-coordinate`: Implement agent coordination
- `workflow-state`: Implement workflow state
- `workflow-monitor`: Add workflow monitoring

**Quality Checks:**
- Workflow achieves stated goals
- Agents coordinate correctly
- State management is robust
- Monitoring provides visibility
- Workflow recovers from failures

---

## Integration Swarm (4 Agents)

### integ-agent-coordinator
**Capabilities:**
- Multi-agent system integration
- Agent communication setup
- Shared state management
- Agent lifecycle management
- Agent scaling
- Agent health monitoring

**Task Types:**
- `agent-integrate`: Integrate multiple agents
- `agent-communication`: Set up communication
- `shared-state`: Set up shared state
- `agent-lifecycle`: Manage agent lifecycle

**Quality Checks:**
- Agents communicate correctly
- Shared state is consistent
- Lifecycle management works
- Scaling is graceful
- Health monitoring detects issues

---

### integ-mcp-integrator
**Capabilities:**
- MCP server integration with agents
- MCP client configuration
- MCP server discovery
- MCP connection management
- MCP error handling
- MCP testing

**Task Types:**
- `mcp-integrate`: Integrate MCP server
- `mcp-client-configure`: Configure MCP client
- `mcp-discovery`: Set up server discovery
- `mcp-connection`: Manage connections

**Quality Checks:**
- MCP server connects correctly
- Client can call tools
- Discovery works as expected
- Connections recover from failures
- Integration tests pass

---

### integ-skill-publisher
**Capabilities:**
- Skill packaging and publishing
- Skill marketplace submission
- Skill versioning
- Skill distribution
- Skill installation verification
- Skill update management

**Task Types:**
- `skill-package`: Package skill for distribution
- `skill-publish`: Publish to marketplace
- `skill-version`: Manage skill versions
- `skill-distribute`: Distribute skill

**Quality Checks:**
- Skill installs correctly
- Version is incremented properly
- Distribution reaches users
- Updates are seamless
- Marketplace listing is accurate

---

### integ-hook-lifecycle
**Capabilities:**
- Hook lifecycle management
- Hook installation
- Hook activation
- Hook deactivation
- Hook uninstallation
- Hook updates

**Task Types:**
- `hook-install`: Install hook
- `hook-activate`: Activate hook
- `hook-deactivate`: Deactivate hook
- `hook-uninstall`: Uninstall hook
- `hook-update`: Update hook

**Quality Checks:**
- Hooks install correctly
- Activation triggers hooks
- Deactivation prevents execution
- Uninstallation removes cleanly
- Updates preserve configuration

---

## Testing Swarm (4 Agents)

### test-conversation
**Capabilities:**
- Conversation flow testing
- Agent interaction testing
- Multi-turn conversation validation
- Goal achievement testing
- Conversation logging
- Conversation regression testing

**Task Types:**
- `conversation-test`: Test conversation flows
- `goal-validation`: Validate goal achievement
- `conversation-log`: Log conversations
- `conversation-regression`: Test for regressions

**Quality Checks:**
- Conversations reach goal state
- Agent responses are appropriate
- Multi-turn flows work correctly
- Goals are achieved efficiently
- Regressions are detected

---

### test-tool-invocation
**Capabilities:**
- Tool invocation testing
- Tool parameter validation
- Tool result validation
- Tool error testing
- Tool performance testing
- Tool integration testing

**Task Types:**
- `tool-test`: Test tool invocations
- `tool-param-validate`: Validate tool parameters
- `tool-result-validate`: Validate tool results
- `tool-error-test`: Test tool error handling

**Quality Checks:**
- Tools invoke correctly
- Parameters validate properly
- Results are valid
- Errors are handled correctly
- Performance meets requirements

---

### test-mcp-compliance
**Capabilities:**
- MCP protocol compliance testing
- MCP spec validation
- MCP server testing
- MCP schema validation
- MCP transport testing
- MCP interoperability testing

**Task Types:**
- `mcp-compliance-test`: Test MCP compliance
- `mcp-spec-validate`: Validate against spec
- `mcp-schema-test`: Test schema validity
- `mcp-transport-test`: Test transport layer

**Quality Checks:**
- Server follows MCP spec
- Schemas are valid
- Transport works correctly
- Interoperability is maintained
- Compliance is 100%

---

### test-integration
**Capabilities:**
- End-to-end integration testing
- Multi-component testing
- System testing
- Acceptance testing
- Performance testing
- Stress testing

**Task Types:**
- `integration-test`: Run integration tests
- `system-test`: Test complete system
- `acceptance-test`: Run acceptance tests
- `performance-test`: Test performance

**Quality Checks:**
- All components integrate correctly
- System meets requirements
- Acceptance criteria are met
- Performance meets targets
- Stress tests reveal limits

---

## Documentation Swarm (3 Agents)

### doc-sdk
**Capabilities:**
- Agent SDK documentation
- Code documentation
- API documentation
- Architecture documentation
- Usage guide writing
- Tutorial creation

**Task Types:**
- `sdk-document`: Document SDK usage
- `code-document`: Document code
- `api-document`: Document APIs
- `architecture-document`: Document architecture

**Quality Checks:**
- Documentation is accurate
- Examples work correctly
- API docs are complete
- Architecture is clear
- Tutorials are followable

---

### doc-mcp-schema
**Capabilities:**
- MCP schema generation
- JSON schema documentation
- Tool schema documentation
- Resource schema documentation
- Schema validation documentation

**Task Types:**
- `schema-generate`: Generate schemas
- `schema-document`: Document schemas
- `schema-validate`: Validate schemas

**Quality Checks:**
- Schemas are complete
- Documentation is accurate
- Validation works correctly
- Schemas follow MCP spec
- Examples are provided

---

### doc-usage-guide
**Capabilities:**
- User guide writing
- Getting started guides
- Best practices documentation
- Troubleshooting guides
- FAQ creation
- Video script writing

**Task Types:**
- `usage-guide`: Write usage guides
- `getting-started`: Write getting started
- `best-practices`: Document best practices
- `troubleshoot`: Write troubleshooting guides

**Quality Checks:**
- Guides are clear and accurate
- Getting started works
- Best practices are sound
- Troubleshooting solves issues
- FAQ covers common questions

---

## Agent Communication Protocol

### Heartbeat (every 60s)
```json
{
  "from": "agent-id",
  "type": "heartbeat",
  "timestamp": "ISO",
  "status": "active|idle|working",
  "currentTask": "task-id|null",
  "metrics": {
    "tasksCompleted": 5,
    "uptime": 3600
  }
}
```

### Task Claim
```json
{
  "from": "agent-id",
  "type": "task-claim",
  "taskId": "uuid",
  "timestamp": "ISO"
}
```

### Task Complete
```json
{
  "from": "agent-id",
  "type": "task-complete",
  "taskId": "uuid",
  "result": "success|failure",
  "output": {},
  "duration": 120,
  "timestamp": "ISO"
}
```

### Blocker
```json
{
  "from": "agent-id",
  "to": "orchestrator",
  "type": "blocker",
  "taskId": "uuid",
  "reason": "string",
  "attemptedSolutions": [],
  "timestamp": "ISO"
}
```

### Scale Request
```json
{
  "from": "orchestrator",
  "type": "scale-request",
  "agentType": "impl-mcp",
  "count": 2,
  "reason": "queue-depth",
  "timestamp": "ISO"
}
```

---

## Review Swarm (3 Agents - Reused from Web Dev)

### review-code
**Capabilities:**
- Code quality assessment
- Design pattern recognition
- SOLID principles verification
- Code smell detection
- Maintainability scoring
- Duplication detection
- Complexity analysis

**Task Types:**
- `review-code`: Full code review
- `review-pr`: Pull request review
- `review-refactor`: Review refactoring changes

**Review Output Format:**
```json
{
  "strengths": ["Well-structured modules", "Good test coverage"],
  "issues": [
    {
      "severity": "Medium",
      "description": "Function exceeds 50 lines",
      "location": "src/auth.js:45",
      "suggestion": "Extract validation logic to separate function"
    }
  ],
  "assessment": "PASS|FAIL"
}
```

**Model:** opus (required for deep analysis)

---

### review-business
**Capabilities:**
- Requirements alignment verification
- Business logic correctness
- Edge case identification
- User flow validation
- Acceptance criteria checking
- Domain model accuracy

**Task Types:**
- `review-business`: Business logic review
- `review-requirements`: Requirements alignment check
- `review-edge-cases`: Edge case analysis

**Review Focus:**
- Does implementation match requirements?
- Are all acceptance criteria met?
- Are edge cases handled?
- Is domain logic correct?

**Model:** opus (required for requirements understanding)

---

### review-security
**Capabilities:**
- Vulnerability detection
- Authentication review
- Authorization verification
- Input validation checking
- Secret exposure detection
- Dependency vulnerability scanning
- OWASP Top 10 checking

**Task Types:**
- `review-security`: Full security review
- `review-auth`: Authentication/authorization review
- `review-input`: Input validation review

**Critical Issues (Always FAIL):**
- Hardcoded secrets/credentials
- SQL injection vulnerabilities
- XSS vulnerabilities
- Missing authentication
- Broken access control
- Sensitive data exposure

**Model:** opus (required for security analysis)

---

## Severity-Based Issue Handling

| Severity | Action | Tracking |
|----------|--------|----------|
| **Critical** | BLOCK. Dispatch fix subagent immediately. Re-run ALL 3 reviewers. | None (must fix) |
| **High** | BLOCK. Dispatch fix subagent. Re-run ALL 3 reviewers. | None (must fix) |
| **Medium** | BLOCK. Dispatch fix subagent. Re-run ALL 3 reviewers. | None (must fix) |
| **Low** | PASS. Add TODO comment, commit, continue. | `# TODO(review): [issue] - [reviewer], [date], Severity: Low` |
| **Cosmetic** | PASS. Add FIXME comment, commit, continue. | `# FIXME(nitpick): [issue] - [reviewer], [date], Severity: Cosmetic` |

---

## Model Selection by Task Type

| Task Type | Model | Rationale |
|-----------|-------|-----------|
| Implementation | sonnet | Fast, good enough for coding |
| Code Review | opus | Deep analysis, catches subtle issues |
| Security Review | opus | Critical, needs thoroughness |
| Business Logic Review | opus | Needs to understand requirements deeply |
| Documentation | sonnet | Straightforward writing |
| Quick fixes | haiku | Fast iteration |
