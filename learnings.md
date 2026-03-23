# ELITE Agent Builder — Learnings

This file captures patterns, decisions, and insights from building the ELITE Agent Builder framework.

## Multi-Agent Orchestration Patterns

### Agent Swarm Architecture
- 21 agents organized into 5 swarms (Architecture, Implementation, Integration, Testing, Documentation) scales well
- Swarm specialization reduces token overhead compared to monolithic agent
- Clear role definitions enable parallel execution and reduce context collisions

### Agent Requirements Documents (ARDs)
- Structured markdown format for system specifications works better than prose
- ARD Coach skill (docs/ard-coach-guide.md) helps users write effective requirements
- ARD structure enables deterministic generation — same input produces consistent output

## Code Generation Strategies

### MCP Server Generation
- Template-driven approach (references/templates/mcp-server/) avoids reimplementing boilerplate
- TypeScript + Zod for type safety in generated tools
- Agent SDK easily integrates generated MCP servers as tool contexts

### Skill Generation
- Markdown-based skill format enables portability across Claude Code instances
- SKILL.md as bootstrap entry point (triggered by "Agent Mode") reduces setup friction
- Hooks (pre/post commit, pre/post build) integrate naturally with Claude Code lifecycle

## Framework Stability

### Testing Architecture
- Comprehensive test suite (tests/ directory) catches regressions early
- MCP compliance testing (mcp-compliance-test.sh) ensures generated servers work
- Conversation flow testing validates agent decision-making consistency
- Hook execution tests verify lifecycle integration

### State Recovery
- Autonomy mode (autonomy/run.sh) includes recovery logic for interrupted runs
- File-based state (not database) enables fast resumption
- Task queue persistence allows continuation from last checkpoint

## Documentation Approach

### README Strategy
- README.md (20,300+ words) serves dual purpose: complete reference + onboarding
- QUICKSTART.md for minimal viable setup
- SKILL.md for autonomous execution documentation
- ARD Coach guide (docs/ard-coach-guide.md) teaches users to write requirements

### Example-Driven Learning
- examples/ directory with sample ARDs (simple-mcp-server.md, etc.)
- Tutorial (docs/tutorial.md) walks through first agent build
- CONTEXT-EXPORT.md explains framework internals

## Implementation Patterns

### ARD → Code Pipeline
1. **Architecture Phase:** Agents design system structure, tool contracts, workflow skeleton
2. **Implementation Phase:** Agents code MCP servers, Agent SDK implementations, hooks
3. **Integration Phase:** Agents coordinate tool availability, hook execution, multi-agent workflows
4. **Testing Phase:** Agents verify compliance, conversation flows, tool invocation, end-to-end paths
5. **Documentation Phase:** Agents generate SDK docs, MCP docs, usage guides

### Code Quality Standards
- Generated code follows TypeScript strict mode
- All tools exported from MCP servers are type-checked
- Hook scripts include error handling and logging
- README and docs are generated with consistent structure

## Agent Framework Insights

### Why Multiple Agents > Single Large Agent
- Token efficiency: 5-10k tokens per agent vs 100k+ for monolithic approach
- Parallelization: Multiple agents can work simultaneously
- Specialization: Each agent has narrow context → clearer decision-making
- Debugging: Easy to test individual agents, isolate failures
- Scaling: Adding new swarms doesn't break existing architecture

### MCP as Inter-Agent Communication
- MCP tools serve as agent-to-agent contracts
- Clear tool schemas reduce misunderstandings
- Tool descriptions guide agent behavior without explicit instructions
- Standard JSON/RPC protocol enables future integrations

## Deployment & Operations

### Autonomous Execution
- run.sh script automates entire pipeline with minimal user input
- Auto-resume capability handles interruptions
- Dangerously-skip-permissions mode enables hands-off operation in trusted environments

### CI/CD Integration
- GitHub Actions workflows (if implemented) can trigger agent-driven builds
- Generated agents can be deployed to production with standard Node.js tooling
- MCP server templates include npm scripts (build, start, dev)

## Lessons for Future Work

1. **ARD Quality Matters** — Well-written requirements produce better agents. Invest in ARD Coach.
2. **Specialization Scales** — Don't try to do everything in one agent. Separate concerns.
3. **Template-Driven Generation** — Code templates (references/templates/) are force multiplier.
4. **Test-Driven Agents** — Agents that validate their own output are reliable.
5. **Documentation Is Product** — Users judge framework by docs quality, not just agent capabilities.

## Unresolved Questions

- How to handle long-running agent operations (>30 min) gracefully?
- Should agents auto-fix generated code if tests fail, or escalate to human?
- Can ARD Coach be extended to generate tests alongside code?
- How to version agents when framework evolves?

## Open Opportunities

1. **Agent Marketplace** — Share generated agents/skills publicly
2. **Visual ARD Editor** — GUI for non-technical ARD authoring
3. **Agent Feedback Loop** — Users rate generated code → train better agents
4. **Multi-Language Support** — Extend templates to Python, Rust, Go
5. **Self-Improving Agents** — Agents that update own prompts based on execution feedback

## Related Frameworks & Projects

- **agent-architect** — Higher-level meta-system for designing agent architectures
- **elite-community-app** — Uses this framework for ELITE platform agents
- **patent-agent** — Built entirely using agent patterns from this framework
