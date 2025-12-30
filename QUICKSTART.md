# ELITE Quick Start

Get ELITE running in under 3 minutes.

## What is ELITE?

ELITE is a multi-agent autonomous system that transforms an **ARD (Agent Requirements Document)** into a complete Claude Code agent system with zero human intervention.

Simply describe what you want to build, and ELITE's 21 specialized agents will:
- Design the architecture
- Write the code
- Run tests
- Generate documentation

**Output:** MCP Servers, Agent SDK agents, Skills, Hooks, and more.

---

## Prerequisites

Before starting, ensure you have:

- **Claude Code CLI** - The command-line interface for Claude
- **Node.js 18+** - For building MCP servers
- **Python 3** - For state management
- **TypeScript** - For MCP server development

> Don't have these? The automated setup script (Step 1) will check and guide you through installation.

---

## Step 1: Run Automated Setup

The setup script checks for dependencies and installs the ELITE skill.

**Unix/macOS/Linux:**
```bash
./scripts/setup.sh
```

**Windows PowerShell:**
```powershell
.\scripts\setup.ps1
```

This will:
- Check Claude Code CLI, Node.js, Python, TypeScript
- Provide installation commands if anything is missing
- Install ELITE skill to `~/.claude/skills/agent-mode/`
- Create `.env.example` for configuration

**If setup fails:** Follow the installation prompts in the output, then run the script again.

---

## Step 2: Verify Installation

```bash
# Check Claude Code is installed
claude --version

# You should see version output
```

If you see "command not found", install Claude Code:
```bash
npm install -g @anthropic-ai/claude-code
```

---

## Step 3: Run Your First Build

### Option A: With ARD Coach (Recommended for Beginners)

ARD Coach is an interactive assistant that helps you create your ARD through conversation.

```bash
# Launch Claude Code with autonomous permissions
claude --dangerously-skip-permissions
```

Then in Claude Code, type:
```
> ARD Coach
```

ARD Coach will ask you questions about what you want to build, then generate a properly formatted ARD. Once you approve, ELITE will automatically start building.

**Trigger phrases for ARD Coach:**
- "ARD Coach"
- "Help me write a PRD"
- "Help me write requirements"
- "Help me write an ARD"

### Option B: With Example ARD

Skip the ARD creation and use a pre-built example:

```bash
# Run autonomous mode with an example ARD
./autonomy/run.sh examples/simple-mcp-server.md
```

This builds a simple weather MCP server in ~10 minutes.

### Option C: Simple Mode

For quick projects with preset patterns:

```bash
claude --dangerously-skip-permissions
```

Then:
```
> Agent Mode: Create an MCP server for GitHub issues
```

---

## What Happens Next?

ELITE will:
1. Initialize the `.elite/` directory
2. Spawn 21 specialized agents across 5 swarms
3. Build your agent system autonomously
4. Complete in 10-60 minutes (depending on complexity)

**Phases:** Bootstrap → Requirements → Architecture → Implementation → Integration → Testing → Documentation → Deployment

---

## Monitor Progress

Open a second terminal to watch progress in real-time:

```bash
# Watch status updates live
watch -n 2 cat .elite/STATUS.txt
```

You'll see:
```
╔════════════════════════════════════════════════════════════════╗
║                    ELITE STATUS                                ║
╚════════════════════════════════════════════════════════════════╝

Phase: IMPLEMENTATION

Tasks:
  ├─ Pending:     3
  ├─ In Progress: 1
  ├─ Completed:   8
  └─ Failed:      0

Current: impl-mcp - Building MCP server implementation
```

---

## Completion

When ELITE finishes, you'll find your built agent system in:

```
.elite/artifacts/releases/your-agent-system/
```

This includes:
- Complete source code
- Package configuration (package.json)
- Documentation (README.md, API docs)
- Tests
- Ready to use/deploy

---

## Next Steps

- **[Full README](README.md)** - Complete ELITE documentation
- **[Tutorial](docs/tutorial.md)** - Step-by-step walkthrough (build a weather agent)
- **[ARD Coach Guide](docs/ard-coach-guide.md)** - Learn ARD Coach in depth
- **[Example ARDs](examples/)** - Pre-built requirements documents to test with

---

## Troubleshooting

### "claude: command not found"

Install Claude Code CLI:

**Option 1 (NPM):**
```bash
npm install -g @anthropic-ai/claude-code
```

**Option 2 (Download):**
Visit https://claude.ai/code

### "ELITE skill not found"

The setup script should handle this automatically. If not:

```bash
# Unix/macOS/Linux
mkdir -p ~/.claude/skills/agent-mode
cp SKILL.md ~/.claude/skills/agent-mode/
cp -r references ~/.claude/skills/agent-mode/
```

### Build fails with errors

Check the logs:
```bash
cat .elite/logs/ELITE-LOG.md
```

Common issues:
- **Missing dependencies:** Run `./scripts/setup.sh` again
- **Node.js version too old:** Ensure Node.js 18+ is installed
- **Permission errors:** Make sure you ran `claude --dangerously-skip-permissions`

### "What does --dangerously-skip-permissions mean?"

This flag allows Claude Code to execute commands without interactive confirmation. ELITE needs it because a typical build involves hundreds of file operations and commands - confirming each one manually would defeat the autonomous purpose.

**Is it safe?** Yes, within this repository. ELITE only operates within the `.elite/` directory and project output folders. It doesn't modify system files or your personal data.

See [README.md - Why --dangerously-skip-permissions?](README.md#why---dangerously-skip-permissions) for details.

---

## Common Questions

**Q: How long does ELITE take?**
A: 10-60 minutes depending on complexity. Simple MCP servers take ~10 minutes; complete multi-agent systems take 60+ minutes.

**Q: Can I use my own API keys?**
A: Yes! Create a `.env` file (copy from `.env.example`) and add your keys. ELITE will use them when building/testing.

**Q: What if I don't like the generated code?**
A: You can edit the ARD with more specific requirements and regenerate, or edit the code directly - it's yours!

**Q: Do I need to configure MCP servers?**
A: No! ELITE **generates** MCP servers as output. The generated server can then be configured in your Claude settings if you want to use it.

---

**Ready to build something amazing?** Run `./scripts/setup.sh` and start with ARD Coach!
