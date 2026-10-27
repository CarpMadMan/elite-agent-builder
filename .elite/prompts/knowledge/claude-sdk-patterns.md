# Claude Agent SDK Patterns

**Version:** 0.32.1
**Last Updated:** 2024-12-30
**Source:** https://docs.anthropic.com/en/docs/claude-code/agent-sdk

## Overview

The Claude Agent SDK is used to build deployable, autonomous agents with full decision loops. Unlike Skills (portable tools) or Subagents (parallel work in Claude Code), Agent SDK agents run independently with their own lifecycle.

## When to Use Agent SDK

Use the Agent SDK when you need:
- **Autonomous decision loops**: Agent decides next steps
- **Production deployment**: Runs independently of Claude Code
- **Long-running tasks**: Operates without human interaction
- **Integration workflows**: Orchestrates multiple systems
- **Proactive actions**: Monitors and responds automatically

## Agent Pattern Types

### 1. Request-Response (Simple)
Agent receives a request, processes it, returns a response. No autonomous loop.

**Use cases:**
- Simple query handling
- Single-turn interactions
- Stateless operations

```typescript
import { Anthropic } from '@anthropic-ai/sdk';

const client = new Anthropic();

async function handleRequest(userMessage: string) {
  const response = await client.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 1024,
    messages: [{role: 'user', content: userMessage}]
  });

  return response.content[0].type === 'text' ? response.content[0].text : '';
}
```

### 2. Autonomous Loop (Full Agent)
Agent continuously makes decisions, calls tools, and iterates until goal is reached.

**Use cases:**
- Complex multi-step tasks
- Goal-oriented workflows
- Continuous monitoring

```typescript
import { Anthropic } from '@anthropic-ai/sdk';

class AutonomousAgent {
  private client: Anthropic;
  private maxIterations: number;
  private iteration = 0;

  constructor(maxIterations = 10) {
    this.client = new Anthropic();
    this.maxIterations = maxIterations;
  }

  async run(initialMessage: string): Promise<string> {
    let messages: Array<{role: string; content: string}> = [
      {role: 'user', content: initialMessage}
    ];

    while (this.iteration < this.maxIterations) {
      const response = await this.client.messages.create({
        model: 'claude-3-5-sonnet-20241022',
        max_tokens: 4096,
        messages: messages,
        tools: this.getTools()
      });

      // Process response
      for (const block of response.content) {
        if (block.type === 'tool_use') {
          // Execute tool and add result to messages
          const result = await this.executeTool(block.name, block.input);
          messages.push({role: 'assistant', content: JSON.stringify(block)});
          messages.push({role: 'user', content: JSON.stringify({result})});
        } else if (block.type === 'text' && response.stop_reason === 'end_turn') {
          return block.text;
        }
      }

      this.iteration++;
    }

    throw new Error('Max iterations exceeded');
  }

  getTools() {
    return [
      {
        name: 'search',
        description: 'Search for information',
        input_schema: {
          type: 'object',
          properties: {
            query: {type: 'string'}
          },
          required: ['query']
        }
      }
    ];
  }

  async executeTool(name: string, input: any): Promise<string> {
    // Implement tool execution
    return `Executed ${name} with ${JSON.stringify(input)}`;
  }
}
```

### 3. Event-Driven
Agent responds to external events (webhooks, messages, timers).

**Use cases:**
- Reactive systems
- Notification handling
- Scheduled tasks

```typescript
class EventDrivenAgent {
  private agent: AutonomousAgent;
  private eventQueue: Array<any> = [];

  constructor() {
    this.agent = new AutonomousAgent();
  }

  onEvent(event: any) {
    this.eventQueue.push(event);
    this.processEvents();
  }

  async processEvents() {
    while (this.eventQueue.length > 0) {
      const event = this.eventQueue.shift();
      await this.agent.run(`Handle event: ${JSON.stringify(event)}`);
    }
  }
}
```

## Tool Calling Patterns

### Single Tool Call
```typescript
const response = await client.messages.create({
  model: 'claude-3-5-sonnet-20241022',
  max_tokens: 4096,
  tools: [{
    name: 'get_weather',
    description: 'Get weather for a location',
    input_schema: {
      type: 'object',
      properties: {
        location: {type: 'string'}
      },
      required: ['location']
    }
  }],
  messages: [{role: 'user', content: 'What\'s the weather in Tokyo?'}]
});
```

### Parallel Tool Calls
Claude can call multiple tools in parallel:

```typescript
for (const block of response.content) {
  if (block.type === 'tool_use') {
    // Collect all tool uses
    toolCalls.push(block);
  }
}

// Execute all tools in parallel
const results = await Promise.all(
  toolCalls.map(block =>
    this.executeTool(block.name, block.input)
  )
);
```

### Tool Composition
Chain multiple tools together:

```typescript
async executeWorkflow(query: string) {
  // Step 1: Search
  const searchResults = await this.executeTool('search', {query});

  // Step 2: Process results
  const processed = await this.executeTool('process', {data: searchResults});

  // Step 3: Format output
  const formatted = await this.executeTool('format', {data: processed});

  return formatted;
}
```

## Streaming Responses

```typescript
const stream = await client.messages.create({
  model: 'claude-3-5-sonnet-20241022',
  max_tokens: 4096,
  messages: [{role: 'user', content: 'Tell me a story'}],
  stream: true
});

for await (const event of stream) {
  if (event.type === 'content_block_delta') {
    process.stdout.write(event.delta.text);
  }
}
```

## State Management

### File-Based State
```typescript
import fs from 'fs/promises';

class FileBasedAgent {
  private statePath: string;

  async loadState() {
    const data = await fs.readFile(this.statePath, 'utf-8');
    return JSON.parse(data);
  }

  async saveState(state: any) {
    await fs.writeFile(this.statePath, JSON.stringify(state, null, 2));
  }
}
```

### Database State
```typescript
import { Pool } from 'pg';

class DatabaseAgent {
  private pool: Pool;

  async loadState(agentId: string) {
    const result = await this.pool.query(
      'SELECT state FROM agent_states WHERE id = $1',
      [agentId]
    );
    return result.rows[0]?.state;
  }
}
```

## Error Handling

### Retry Logic
```typescript
async function executeWithRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 3,
  baseDelay = 1000
): Promise<T> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      const delay = baseDelay * Math.pow(2, i);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
  throw new Error('Max retries exceeded');
}
```

### Timeout Handling
```typescript
async function executeWithTimeout<T>(
  fn: () => Promise<T>,
  timeout: number
): Promise<T> {
  return Promise.race([
    fn(),
    new Promise<T>((_, reject) =>
      setTimeout(() => reject(new Error('Timeout')), timeout)
    )
  ]);
}
```

## Deployment

### Docker
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY dist ./dist
ENV NODE_ENV=production
CMD ["node", "dist/agent.js"]
```

### Systemd Service
```ini
[Unit]
Description=Claude Agent
After=network.target

[Service]
Type=simple
User=agent
WorkingDirectory=/opt/agent
ExecStart=/usr/bin/node dist/agent.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## Best Practices

1. **Set timeouts**: Always use timeouts for API calls
2. **Handle errors**: Implement comprehensive error handling
3. **Log decisions**: Log all decisions for debugging
4. **Test thoroughly**: Write tests for agent workflows
5. **Monitor**: Set up monitoring and alerting
6. **Version**: Use semantic versioning
7. **Document**: Document agent behavior and decision flows

## Common Pitfalls

1. **Infinite loops**: Always set max iterations
2. **No state persistence**: Implement checkpointing
3. **Ignoring errors**: Handle all error cases
4. **Hardcoding**: Use environment variables
5. **No monitoring**: Add health checks and metrics

## Further Reading

- [Agent SDK Documentation](https://docs.anthropic.com/en/docs/claude-code/agent-sdk)
- [API Reference](https://docs.anthropic.com/en/api/claude-3)
- [Examples](https://github.com/anthropics/anthropic-sdk-typescript)
