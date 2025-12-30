# Multi-Agent Workflow Template

## Workflow Overview

**Workflow Name:** {{WORKFLOW_NAME}}
**Description:** {{WORKFLOW_DESCRIPTION}}
**Agents Involved:** {{AGENT_LIST}}

## Workflow Graph

```
{{WORKFLOW_GRAPH}}
```

## Phase Breakdown

### Phase 1: {{PHASE_1_NAME}}
**Agent:** {{PHASE_1_AGENT}}
**Input:** {{PHASE_1_INPUT}}
**Output:** {{PHASE_1_OUTPUT}}
**Dependencies:** {{PHASE_1_DEPS}}

### Phase 2: {{PHASE_2_NAME}}
**Agent:** {{PHASE_2_AGENT}}
**Input:** {{PHASE_2_INPUT}}
**Output:** {{PHASE_2_OUTPUT}}
**Dependencies:** {{PHASE_2_DEPS}}

### Phase 3: {{PHASE_3_NAME}}
**Agent:** {{PHASE_3_AGENT}}
**Input:** {{PHASE_3_INPUT}}
**Output:** {{PHASE_3_OUTPUT}}
**Dependencies:** {{PHASE_3_DEPS}}

## State Management

**State Store:** {{STATE_STORE_TYPE}}
**Key State Variables:**
- `{{STATE_VAR_1}}`: {{STATE_VAR_1_DESC}}
- `{{STATE_VAR_2}}`: {{STATE_VAR_2_DESC}}
- `{{STATE_VAR_3}}`: {{STATE_VAR_3_DESC}}

## Error Handling

**Retry Strategy:** {{RETRY_STRATEGY}}
**Circuit Breakers:** {{CIRCUIT_BREAKERS}}
**Fallback Actions:** {{FALLBACK_ACTIONS}}

## Monitoring

**Metrics to Track:**
- {{METRIC_1}}
- {{METRIC_2}}
- {{METRIC_3}}

**Alerting:**
- {{ALERT_CONDITION_1}}: {{ALERT_ACTION_1}}
- {{ALERT_CONDITION_2}}: {{ALERT_ACTION_2}}

## Testing

**Test Scenarios:**
1. {{TEST_SCENARIO_1}}
2. {{TEST_SCENARIO_2}}
3. {{TEST_SCENARIO_3}}

## Deployment

**Deploy Command:** {{DEPLOY_COMMAND}}
**Health Check:** {{HEALTH_CHECK}}
**Rollback:** {{ROLLBACK_COMMAND}}
