import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// {{SERVER_DESCRIPTION}}

const server = new Server(
  {
    name: '{{SERVER_NAME}}',
    version: '{{VERSION}}',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Tool implementations
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: '{{TOOL_NAME_1}}',
        description: '{{TOOL_DESCRIPTION_1}}',
        inputSchema: {
          type: 'object',
          properties: {
            {{TOOL_PROPERTIES_1}}
          },
          required: {{TOOL_REQUIRED_1}},
        },
      },
      // Add more tools as needed
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case '{{TOOL_NAME_1}}':
      // Implement tool logic here
      return {
        content: [
          {
            type: 'text',
            text: `Tool {{TOOL_NAME_1}} executed with args: ${JSON.stringify(args)}`,
          },
        ],
      };

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('{{SERVER_NAME}} MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
