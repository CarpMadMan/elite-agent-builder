# Changelog

All notable changes to ELITE will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.9.0] - 2025-12-30

### Added
- **PRD Coach Skill** - Interactive requirements development assistant:
  - Guides users from rough ideas to complete ARD (Agent Requirements Document)
  - Two modes: Quick (5-7 questions) or Deep dive (15-20 questions)
  - Conversational Q&A with follow-ups and clarifications
  - Auto-generates properly formatted ARDs ready for ELITE
  - Review and refine workflow - edit sections, regenerate, or approve
  - Seamless ELITE integration - one-click execution after approval
  - Trigger phrases: "PRD Coach", "Help me write a PRD/ARD"

### New Files
- `skills/prd-coach/SKILL.md` - Main PRD Coach skill
- `skills/prd-coach/templates/ard-template.md` - ARD output format
- `skills/prd-coach/templates/quick-mode.md` - Quick mode questions
- `skills/prd-coach/templates/deep-dive-mode.md` - Deep dive questions
- `skills/prd-coach/prompts/conversation-flow.md` - Conversation orchestration

### Documentation
- `docs/prd-coach-guide.md` - Complete PRD Coach usage guide
- `docs/tutorial.md` - Step-by-step tutorial: From idea to working agent
- Updated README.md with PRD Coach section and getting started guide

### Improved
- README now includes PRD Coach as the recommended starting point for new users
- Added PRD Coach workflow diagram
- Added mode comparison table (Quick vs Deep dive)
- Added example session transcripts

## [2.8.0] - 2025-12-29

### Added
- **Smart Rate Limit Detection** - Automatically detects rate limit messages and waits until reset:
  - Parses "resets Xam/pm" from Claude output
  - Calculates exact wait time until reset (+ 2 min buffer)
  - Shows human-readable countdown (e.g., "4h 30m")
  - Longer countdown intervals for multi-hour waits (60s vs 10s)
  - No more wasted retry attempts during rate limits

### Changed
- Countdown display now shows human-readable format (e.g., "Resuming in 4h 28m...")

## [2.7.0] - 2025-12-28

### Added
- **Codebase Analysis Mode** - When no ARD is provided, ELITE now:
  1. **Auto-detects ARD files** - Searches for `ARD.md`, `REQUIREMENTS.md`, `SPEC.md`, `PROJECT.md`
  2. **Analyzes existing codebase** - If no ARD found:
     - Scans directory structure and identifies tech stack
     - Reads package.json, requirements.txt, go.mod, etc.
     - Examines README and entry points
     - Identifies current features and architecture
  3. **Generates ARD** - Creates `.elite/generated-ard.md` with:
     - Project overview and current state
     - Inferred requirements from implementation
     - Identified gaps (missing tests, security, docs)
     - Recommended improvements
  4. **Proceeds with build** - Uses generated ARD as baseline

### Fixed
- Dashboard 404 errors - Server now runs from `.elite/` root to properly serve queue/state JSON files

## [2.6.0] - 2025-12-28

### Added
- **Complete SDLC Testing Phases** - 11 comprehensive testing phases (all enabled by default):
  - `ELITE_PHASE_UNIT_TESTS` - Run existing unit tests with coverage
  - `ELITE_PHASE_API_TESTS` - Functional API testing with real HTTP requests
  - `ELITE_PHASE_E2E_TESTS` - End-to-end UI testing with Playwright/Cypress
  - `ELITE_PHASE_SECURITY` - OWASP scanning, auth flow verification, dependency audit
  - `ELITE_PHASE_INTEGRATION` - SAML, OIDC, Entra ID, Slack, Teams testing
  - `ELITE_PHASE_CODE_REVIEW` - 3-reviewer parallel code review (Security, Architecture, Performance)
  - `ELITE_PHASE_WEB_RESEARCH` - Competitor analysis, feature gap identification
  - `ELITE_PHASE_PERFORMANCE` - Load testing, benchmarking, Lighthouse audits
  - `ELITE_PHASE_ACCESSIBILITY` - WCAG 2.1 AA compliance testing
  - `ELITE_PHASE_REGRESSION` - Compare against previous version, detect regressions
  - `ELITE_PHASE_UAT` - User acceptance testing simulation, bug hunting
- **Phase Skip Options** - Each phase can be disabled via environment variables

## [2.5.0] - 2025-12-28

### Added
- **Real-time Streaming Output** - Claude's output now streams live using `--output-format stream-json`
  - Parses JSON stream in real-time to display text, tool calls, and results
  - Shows `[Tool: name]` when Claude uses a tool
  - Shows `[Session complete]` when done
- **Web Dashboard** - Visual task board with Anthropic design language
  - Auto-starts at `http://127.0.0.1:57374` and opens in browser
  - Shows task counts and Kanban-style columns
  - Auto-refreshes every 3 seconds
  - Disable with `ELITE_DASHBOARD=false`
  - Configure port with `ELITE_DASHBOARD_PORT=<port>`

## [2.4.0] - 2025-12-28

### Added
- **Live Output** - Claude's output now streams in real-time
  - Visual separator shows when Claude is working
- **Status Monitor** - `.elite/STATUS.txt` updates every 5 seconds
  - Monitor with: `watch -n 2 cat .elite/STATUS.txt`

## [2.3.0] - 2025-12-27

### Added
- **Unified Autonomy Runner** (`autonomy/run.sh`) - Single script that does everything:
  - Prerequisite checks (Claude CLI, Python, Git, curl, Node.js, jq)
  - Skill installation verification
  - `.elite/` directory initialization
  - Autonomous execution with auto-resume
  - Exponential backoff with jitter
  - State persistence across restarts

## [2.2.0] - 2025-12-27

### Added
- **Vibe Kanban Integration** - Optional visual dashboard for monitoring agents:
  - `scripts/export-to-vibe-kanban.sh` - Export ELITE tasks to Vibe Kanban format
  - Task status mapping (ELITE queues → Kanban columns)

## [2.1.0] - 2025-12-27

### Added
- **Autonomous Wrapper Script** (`scripts/elite-wrapper.sh`) - True autonomy with auto-resume:
  - Monitors Claude Code process and detects when session ends
  - Automatically resumes from checkpoint on rate limits or interruptions
  - Exponential backoff with jitter (configurable)
  - State persistence in `.elite/wrapper-state.json`

## [2.0.0] - 2025-12-27

### Added
- **Initial Release** of ELITE (Multi-Agent Autonomous System for Claude Code)

- **21 Specialized Agents** across 5 swarms:
  - Architecture Swarm (4 agents): MCP, SDK Agent, Hook, Skill design
  - Implementation Swarm (6 agents): MCP, SDK, Hook, Skill, Tool Composer, Workflow Orchestrator
  - Integration Swarm (4 agents): Coordination, MCP Integration, Skill Publisher, Hook Lifecycle
  - Testing Swarm (4 agents): Conversation, Tools, MCP Compliance, Integration
  - Documentation Swarm (3 agents): SDK, MCP Schema, Usage Guide

- **Output Artifacts**:
  - MCP Servers - Model Context Protocol servers
  - Agent SDK Agents - Autonomous agents with decision loops
  - Skills - Portable markdown + code tools
  - Hooks - Bash/Python lifecycle scripts
  - Multi-Agent Workflows - Coordinated systems

- **Quality Gates**:
  - MCP compliance testing
  - Schema validation
  - Conversation flow testing
  - Parallel 3-way code review

- **Two Modes**:
  - Simple Mode - Individual developers, preset patterns
  - Advanced Mode - Teams/enterprises, custom architectures

[2.9.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.8.0...v2.9.0
[2.8.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.7.0...v2.8.0
[2.7.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.6.0...v2.7.0
[2.6.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/yourusername/elite-agent-builder/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/yourusername/elite-agent-builder/releases/tag/v2.0.0
