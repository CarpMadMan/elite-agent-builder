# {{SERVER_NAME}}

{{DESCRIPTION}}

## Installation

```bash
npm install
npm run build
```

## Configuration

Add to your Claude Code `.mcp.json`:

```json
{
  "mcpServers": {
    "{{SERVER_ID}}": {
      "command": "node",
      "args": ["{{PROJECT_PATH}}/dist/server.js"]
    }
  }
}
```

## Available Tools

### {{TOOL_NAME_1}}

{{TOOL_DESCRIPTION_1}}

**Parameters:**
- {{TOOL_PARAMS}}

## Development

```bash
npm run dev    # Build and run
npm run watch  # Watch mode
```

## License

{{LICENSE}}
