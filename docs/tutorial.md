# ELITE Tutorial: From Idea to Working Agent System

A complete step-by-step guide to building your first agent system using PRD Coach and ELITE.

## What You'll Build

In this tutorial, you'll build a **Weather Agent MCP Server** that:
- Fetches weather data for any location
- Provides current conditions and forecasts
- Returns data in a structured format

**Time Required:** 30-45 minutes
**Difficulty:** Beginner

---

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] Claude Code CLI installed
- [ ] Node.js 18+ installed
- [ ] TypeScript installed (`npm install -g typescript`)
- [ ] Internet connection
- [ ] Terminal/Command Prompt access

**Verify Claude Code:**
```bash
claude --version
```

If not installed, see [Claude Code Documentation](https://claude.ai/code).

---

## Step 1: Install ELITE and PRD Coach

### 1.1 Clone or Download ELITE

```bash
# Clone the repository
git clone https://github.com/yourusername/elite-agent-builder.git
cd elite-agent-builder

# Or download and extract from releases
```

### 1.2 Install ELITE Skill

```bash
# Create skills directory
mkdir -p ~/.claude/skills/agent-mode

# Install main ELITE skill
ln -s "$(pwd)/SKILL.md" ~/.claude/skills/agent-mode/
```

### 1.3 Install PRD Coach Skill

```bash
# Create PRD Coach directory
mkdir -p ~/.claude/skills/prd-coach

# Install PRD Coach skill
ln -s "$(pwd)/skills/prd-coach/SKILL.md" ~/.claude/skills/prd-coach/
```

### 1.4 Verify Installation

```bash
# Check ELITE skill
cat ~/.claude/skills/agent-mode/SKILL.md | grep "name:"
# Should output: name: agent-mode

# Check PRD Coach skill
cat ~/.claude/skills/prd-coach/SKILL.md | grep "name:"
# Should output: name: prd-coach
```

---

## Step 2: Launch Claude Code

```bash
# Navigate to ELITE directory
cd elite-agent-builder

# Launch Claude Code with autonomous permissions
claude --dangerously-skip-permissions
```

You should see the Claude Code welcome message.

---

## Step 3: Start PRD Coach

In the Claude Code terminal, type:

```
PRD Coach
```

You should see:

```
Welcome to PRD Coach! I'll help you develop a complete ARD for your agent system.

Which mode would you prefer?

1. Quick mode: 5-7 core questions (for experienced users)
2. Deep dive: 15-20 comprehensive questions with iterative refinement
```

---

## Step 4: Select Quick Mode

Type:

```
Quick mode
```

PRD Coach will respond and begin the questioning process.

---

## Step 5: Answer Questions

### Question 1: Core Concept

**Coach:** "What is the core problem your agent system will solve?"

**Your Answer:**
```
I want an MCP server that fetches weather data for any location.
Users provide a city name, and the agent returns current weather
conditions and forecast information.
```

---

### Question 2: Agent Type

**Coach:** "What type of agent pattern best fits your needs?"

**Your Answer:**
```
Request-response - simple question-answer interactions
```

---

### Question 3: Key Features

**Coach:** "What are the 3-5 key capabilities your agent needs?"

**Your Answer:**
```
1. Get current weather - Fetch current conditions for a city
2. Get forecast - Retrieve 5-day weather forecast
3. Search cities - Find city coordinates from city name
4. Format response - Return weather data in readable format
```

---

### Question 4: Tech Stack

**Coach:** "What are your technical preferences?"

**Your Answer:**
```
Language: TypeScript
Transport: stdio
Framework: None needed, simple MCP server
```

---

### Question 5: Success Criteria

**Coach:** "How will you know the agent is working correctly?"

**Your Answer:**
```
1. Successfully fetches weather data from API
2. Returns valid weather data for test cities
3. Handles invalid city names gracefully
```

---

### Question 6: Usage Example

**Coach:** "Provide one concrete example of how you'd use this agent."

**Your Answer:**
```
User asks: "What's the weather like in San Francisco?"
Agent responds: "Current weather in San Francisco: 65°F, partly cloudy,
with a high of 70°F and low of 55°F expected today."
```

---

## Step 6: Review Your ARD

PRD Coach will now generate and display your complete ARD:

```markdown
# Weather Agent MCP Server - Agent Requirements Document

## Executive Summary
An MCP server that fetches weather data for any location. Users provide a
city name, and the agent returns current weather conditions and forecast
information.

## Agent Type
Request-response - Simple question-answer interactions

## Features

### Tools
| Tool Name | Description | Input | Output |
|-----------|-------------|-------|--------|
| get_current_weather | Fetch current conditions for a city | city_name | Current weather data |
| get_forecast | Retrieve 5-day weather forecast | city_name | Forecast data |
| search_cities | Find city coordinates from city name | city_name | City coordinates |
| format_response | Return weather data in readable format | weather_data | Formatted string |

### Resources
None specified

### Prompts
None specified

## Tech Stack
- Language: TypeScript
- Framework: None
- MCP Transport: stdio
- State Management: Not applicable (stateless)

## Success Criteria
- [ ] Successfully fetches weather data from API
- [ ] Returns valid weather data for test cities
- [ ] Handles invalid city names gracefully

## Out of Scope
- Historical weather data
- Weather alerts/warnings
- Multiple locations in single request
- User authentication

## Usage Examples

### Example 1: Get Current Weather
User asks: "What's the weather like in San Francisco?"
Agent responds: "Current weather in San Francisco: 65°F, partly cloudy,
with a high of 70°F and low of 55°F expected today."
```

---

## Step 7: Approve the ARD

**Coach:** "What would you like to do?"

Type:

```
Approve
```

---

## Step 8: Execute ELITE

**Coach:** "Your ARD is ready! Would you like me to execute ELITE now?"

Type:

```
yes
```

ELITE will now begin autonomous execution. You'll see:

```
╔════════════════════════════════════════════════════════════════╗
║                    ELITE AUTONOMOUS RUNNER                     ║
╠════════════════════════════════════════════════════════════════╣
║ Mode:         SIMPLE                                            ║
║ ARD:          .elite/prd-coach-ard.md                           ║
║ Phase:        BOOTSTRAP                                         ║
╚════════════════════════════════════════════════════════════════╝

Initializing...
Starting autonomous build cycle...
```

---

## Step 9: Monitor Progress

### In Another Terminal

```bash
# Watch status live
watch -n 2 cat .elite/STATUS.txt
```

You'll see progress through phases:

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

## Step 10: Completion

After 15-30 minutes, ELITE will complete:

```
╔════════════════════════════════════════════════════════════════╗
║                    BUILD COMPLETE                              ║
╠════════════════════════════════════════════════════════════════╣
║ Duration: 23 minutes                                            ║
║ Tasks:    18 completed, 0 failed                                 ║
╚════════════════════════════════════════════════════════════════╝

Your agent system is ready!

Location: .elite/artifacts/releases/weather-agent-mcp-server/
```

---

## Step 11: Test Your Agent

### Navigate to Output

```bash
cd .elite/artifacts/releases/weather-agent-mcp-server/
```

### Install Dependencies

```bash
npm install
```

### Build the Server

```bash
npm run build
```

### Test the Server

```bash
# Start the server
npm start

# In another terminal, test with Claude Code
claude --dangerously-skip-permissions

# Then in Claude:
> Use the weather MCP server to get current weather for London
```

---

## Summary: What You Built

| Component | Description |
|-----------|-------------|
| **MCP Server** | TypeScript server with weather tools |
| **Tools** | 4 tools for weather operations |
| **Documentation** | Complete usage guide and API docs |
| **Tests** | Unit tests and integration tests |
| **Package** | Ready-to-publish npm package |

---

## What's Next?

### Try More Examples

```bash
# Build a simple skill
./autonomy/run.sh examples/simple-skill.md

# Build a complete agent system
./autonomy/run.sh examples/complete-agent-system.md
```

### Customize Your Agent

1. Edit the generated code in `.elite/artifacts/releases/`
2. Add custom features
3. Modify tools and resources
4. Update documentation

### Learn More

- [PRD Coach Guide](prd-coach-guide.md) - Deep dive into PRD Coach
- [ELITE README](../README.md) - Complete ELITE documentation
- [Example ARDs](../examples/) - Sample requirements documents

---

## Troubleshooting

### ELITE Fails to Start

```bash
# Check prerequisites
./autonomy/run.sh --help

# Verify skill installation
ls ~/.claude/skills/agent-mode/SKILL.md
ls ~/.claude/skills/prd-coach/SKILL.md
```

### Build Errors

```bash
# Check ELITE logs
cat .elite/logs/ELITE-LOG.md

# View agent-specific logs
ls .elite/logs/agents/
```

### Server Won't Start

```bash
# Verify Node.js version
node --version  # Should be 18+

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

---

## Common Questions

**Q: Can I modify the ARD after ELITE starts?**
A: No, but you can stop ELITE (Ctrl+C), edit the ARD, and restart. ELITE will resume from the last checkpoint.

**Q: How long does ELITE take?**
A: 15-60 minutes depending on complexity. Simple MCP servers take ~15 minutes; complete multi-agent systems take 60+ minutes.

**Q: Can I use my own API keys?**
A: Yes! Edit the generated code to add your API credentials. See the generated documentation for details.

**Q: What if I don't like the generated code?**
A: You can edit the ARD with more specific requirements, then regenerate. Or edit the code directly - it's yours!

---

## Congratulations!

You've successfully built your first agent system with ELITE!

From a simple idea, you:
1. Used PRD Coach to create a complete ARD
2. Executed ELITE to build the system autonomously
3. Tested your working MCP server

**Share your experience** and join the community!
