import { Anthropic } from '@anthropic-ai/sdk';

// {{AGENT_DESCRIPTION}}

interface Tool {
  name: string;
  description: string;
  input_schema: Record<string, unknown>;
}

interface AgentConfig {
  maxIterations?: number;
  timeout?: number;
  tools?: Tool[];
}

interface AgentState {
  iterations: number;
  lastAction: string | null;
  context: Record<string, unknown>;
}

export class {{AGENT_CLASS_NAME}} {
  private client: Anthropic;
  private config: Required<AgentConfig>;
  private state: AgentState;

  constructor(config: AgentConfig = {}) {
    this.client = new Anthropic();
    this.config = {
      maxIterations: config.maxIterations ?? 10,
      timeout: config.timeout ?? 300000, // 5 minutes
      tools: config.tools ?? [],
    };
    this.state = {
      iterations: 0,
      lastAction: null,
      context: {},
    };
  }

  async run(userMessage: string): Promise<string> {
    const startTime = Date.now();

    while (this.state.iterations < this.config.maxIterations) {
      // Check timeout
      if (Date.now() - startTime > this.config.timeout) {
        throw new Error('Agent execution timeout');
      }

      // Build messages with context
      const messages: Array<{role: string; content: string}> = [
        {role: 'user', content: userMessage},
      ];

      // Add context if available
      if (Object.keys(this.state.context).length > 0) {
        messages[0].content += `\n\nContext: ${JSON.stringify(this.state.context)}`;
      }

      // Call Claude with tools
      const response = await this.client.messages.create({
        model: 'claude-3-5-sonnet-{{DATE}}',
        max_tokens: 4096,
        tools: this.config.tools,
        messages: messages,
      });

      // Process response
      const stopReason = response.stop_reason;

      if (stopReason === 'tool_use') {
        // Execute tools
        for (const block of response.content) {
          if (block.type === 'tool_use') {
            this.state.lastAction = block.name;
            // TODO: Implement tool execution
            // const toolResult = await this.executeTool(block.name, block.input);
            // Update state with tool result
          }
        }
        this.state.iterations++;
      } else if (stopReason === 'end_turn') {
        // Agent completed
        for (const block of response.content) {
          if (block.type === 'text') {
            return block.text;
          }
        }
      }
    }

    throw new Error('Max iterations exceeded');
  }

  updateContext(key: string, value: unknown): void {
    this.state.context[key] = value;
  }

  getContext(): Record<string, unknown> {
    return {...this.state.context};
  }

  reset(): void {
    this.state = {
      iterations: 0,
      lastAction: null,
      context: {},
    };
  }
}

// Example usage
// const agent = new {{AGENT_CLASS_NAME}}({
//   tools: [
//     {
//       name: 'tool_name',
//       description: 'Tool description',
//       input_schema: {
//         type: 'object',
//         properties: {
//           param: {type: 'string'},
//         },
//       },
//     },
//   ],
// });
//
// const result = await agent.run('User message');
// console.log(result);
