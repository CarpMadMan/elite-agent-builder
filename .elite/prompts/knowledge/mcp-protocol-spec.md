# MCP (Model Context Protocol) Specification

**Version:** 2024-12
**Last Updated:** 2024-12-30
**Source:** https://modelcontextprotocol.io/specification

## Overview

MCP is an open protocol that enables AI models to connect to external tools and data sources. It provides a standardized way for AI applications to expose capabilities (tools, resources, prompts) to AI assistants like Claude.

## Architecture

```
┌─────────────────────┐
│   Claude Client     │
│  (Claude Code/App)  │
└──────────┬──────────┘
           │
           │ JSON-RPC 2.0
           │
┌──────────▼──────────┐
│   MCP Client        │
│  (Transport Layer)  │
└──────────┬──────────┘
           │
           │ stdio / SSE
           │
┌──────────▼──────────┐     ┌──────────────────┐
│   MCP Server 1      │     │   MCP Server 2    │
│  (e.g., GitHub)     │ ... │  (e.g., Filesystem)│
└─────────────────────┘     └──────────────────┘
```

## Transport Layers

### stdio (Standard Input/Output)
- Most common for local development
- Server reads JSON-RPC from stdin, writes to stdout
- Simple and reliable
- Used by most CLI-based MCP servers

### SSE (Server-Sent Events)
- Used for web-based connections
- Enables HTTP-based communication
- Supports browser environments
- More complex setup

## Server Capabilities

### Tools
Tools are functions that the AI can call:

```typescript
{
  name: "get_weather",
  description: "Get current weather for a location",
  inputSchema: {
    type: "object",
    properties: {
      location: {
        type: "string",
        description: "City name or ZIP code"
      }
    },
    required: ["location"]
  }
}
```

### Resources
Resources are read-only data that the AI can access:

```typescript
{
  uri: "file:///path/to/file.txt",
  name: "README",
  description: "Project README",
  mimeType: "text/plain"
}
```

### Prompts
Prompts are pre-defined prompt templates:

```typescript
{
  name: "summarize",
  description: "Summarize the current file",
  arguments: {
    filePath: "src/main.ts"
  }
}
```

## JSON-RPC Messages

### Request Format
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/list",
  "params": {}
}
```

### Response Format
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "tools": [...]
  }
}
```

### Error Format
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32601,
    "message": "Method not found",
    "data": null
  }
}
```

## Standard Methods

### tools/list
List all available tools.

**Request:**
```json
{
  "method": "tools/list",
  "params": {}
}
```

**Response:**
```json
{
  "result": {
    "tools": [
      {
        "name": "tool_name",
        "description": "Tool description",
        "inputSchema": {...}
      }
    ]
  }
}
```

### tools/call
Execute a tool.

**Request:**
```json
{
  "method": "tools/call",
  "params": {
    "name": "tool_name",
    "arguments": {
      "param1": "value1"
    }
  }
}
```

### resources/list
List all available resources.

### resources/read
Read a resource's content.

### prompts/list
List all available prompts.

### prompts/get
Get a specific prompt with arguments filled in.

## Implementation Best Practices

### 1. Tool Schema Design
- Use clear, descriptive names
- Provide detailed descriptions
- Use appropriate JSON Schema types
- Mark required fields explicitly

### 2. Error Handling
- Always return valid JSON-RPC error responses
- Include meaningful error messages
- Use appropriate error codes
- Log errors for debugging

### 3. Performance
- tools/list should respond in < 5 seconds
- Implement caching where appropriate
- Use streaming for large responses
- Handle concurrent requests safely

### 4. Security
- Validate all input parameters
- Sanitize user input
- Implement rate limiting
- Never expose sensitive data in error messages

## TypeScript SDK

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: "my-server",
  version: "1.0.0"
}, {
  capabilities: {
    tools: {}
  }
});

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [...]
}));

const transport = new StdioServerTransport();
await server.connect(transport);
```

## Configuration (.mcp.json)

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["path/to/server.js"],
      "env": {
        "API_KEY": "your-key"
      }
    }
  }
}
```

## Common Pitfalls

1. **Blocking operations**: Never block the event loop
2. **Missing error handling**: Always handle errors
3. **Invalid schemas**: Validate JSON schemas
4. **Slow responses**: Optimize tools/list
5. **Memory leaks**: Clean up resources properly

## Further Reading

- [MCP Specification](https://spec.modelcontextprotocol.io/)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Servers](https://modelcontextprotocol.io/servers)
