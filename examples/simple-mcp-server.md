# ARD: Simple MCP Server for Weather Data

## Overview
Create an MCP (Model Context Protocol) server that provides weather data tools and resources for Claude Code.

## Agent Type
MCP Server (Model Context Protocol)

## Features

### Tools
- **get_weather** - Get current weather for a city
  - Input: `city` (string) - City name
  - Output: Current temperature, conditions, humidity

- **get_forecast** - Get weather forecast
  - Input: `city` (string), `days` (number, 1-7)
  - Output: Daily forecast with high/low temps

### Resources
- **cities_list** - List of supported cities
  - URI: `weather:///cities`
  - Returns: Array of city names

## Tech Stack
- TypeScript
- @modelcontextprotocol/sdk
- stdio transport
- OpenWeatherMap API (or mock data)

## Success Criteria
- `tools/list` responds in <5s
- All tool schemas are valid JSON Schema
- MCP compliance test passes
- Server can be invoked from Claude Code
- Resources are accessible via `resources/list`

## Out of Scope
- Authentication
- Caching
- Multiple weather providers
- Historical data

## Usage Example
```typescript
// In Claude Code, the tools would be available as:
await mcp.tools.get_weather({ city: "San Francisco" });
await mcp.tools.get_forecast({ city: "New York", days: 5 });
```
