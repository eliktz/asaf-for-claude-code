# ASAF Core Instructions

**ASAF: Agile Scrum Agentic Flow**

Version: 1.0.0

---

## What is ASAF?

ASAF is a structured workflow for coding tasks that:
1. Prevents context loss through organized phases
2. Uses AI agents for implementation while keeping developer in control
3. Focuses on learning and personal growth
4. Creates comprehensive documentation automatically

## Core Principles

1. **Structured Phases**: Init → Groom → Implement → Demo → Retrospective
2. **Markdown-Based State**: All state stored in human-readable files
3. **Agent-Driven**: AI agents implement, you decide and learn
4. **Learning-Focused**: Every sprint contributes to skill development
5. **No Backend**: Just markdown files, no complex systems

## Folder Structure

```
project-root/
├── .claude/commands/          # ASAF commands (this folder)
├── asaf/                      # Sprint storage
│   ├── <sprint-name>/        # Full ASAF sprint
│   │   ├── SUMMARY.md        # Single source of truth
│   │   ├── .state.json       # Machine-readable state
│   │   ├── initial.md        # Feature description
│   │   ├── grooming/         # Design phase
│   │   ├── implementation/   # Execution phase
│   │   ├── demo/            # Demo phase
│   │   └── retro/           # Retrospective
│   └── express/             # Express sprints (lightweight)
│       └── <task-name>/
└── personal-goals.md         # Developer learning goals (optional)
```

## State Management

### .state.json Format

```json
{
  "sprint": "sprint-name",
  "type": "full" | "express",
  "phase": "grooming" | "planning" | "implementation" | "demo" | "retro",
  "status": "ready" | "in-progress" | "complete" | "blocked",
  "current_task": 3,
  "total_tasks": 5,
  "created": "2025-10-05T14:00:00Z",
  "updated": "2025-10-05T16:30:00Z",
  "grooming_approved": true,
  "implementation_complete": false
}
```

## Workflow Phases

### 1. Initialization
- Create sprint folder structure
- Capture feature description
- Set initial state

### 2. Grooming (Full ASAF only)
- Collaborative design conversation
- Identify edge cases (min 10)
- Define acceptance criteria (min 5)
- Make technical decisions
- Configure execution (executor profile, reviewer mode)

### 3. Planning (Auto-triggered)
- Break work into tasks
- Define execution pattern per task
- Set max iterations

### 4. Implementation
- Execute tasks with agents
- Executor → Test → Reviewer → Iterate
- Max 3 iterations per task (configurable)
- Auto-pause if blocked

### 5. Demo (Optional)
- Generate presentation of work
- Show what was built
- Highlight acceptance criteria met

### 6. Retrospective
- Reflect on learnings
- Update personal goals
- Identify improvements

## Agent Personas

### Grooming Agent
- Senior engineering mentor
- Curious, thorough, educational
- Asks one question at a time
- Connects to personal goals

### Executor Agent
- Expert developer for specific stack
- Implements code following design
- Writes comprehensive tests
- Documents work clearly

### Reviewer Agent
- Code reviewer ensuring quality
- Modes: Harsh Critic, Supportive Mentor, Educational, Quick Review
- Checks design compliance
- Verifies edge case coverage

### Task Planner Agent
- Breaks features into executable tasks
- Orders by dependency
- Estimates complexity
- Defines execution patterns

## Error Handling

### Severity Levels
- 🔴 CRITICAL: Cannot continue, requires intervention
- 🟡 WARNING: Can continue with degradation
- 🔵 INFO: Informational only

### Recovery Patterns
1. **Auto-retry**: Transient failures (3 attempts)
2. **Checkpoint & Resume**: Save state before failure
3. **Graceful Degradation**: Continue with reduced functionality
4. **Escalation**: Present options to user

### Always
- Save state before risky operations
- Provide clear error messages
- Offer recovery options
- Preserve progress

## Command Conventions

### Phase-Prefixed Commands
```
/asaf-groom          # All grooming commands
/asaf-groom-approve
/asaf-groom-view

/asaf-impl           # All implementation commands
/asaf-impl-pause
/asaf-impl-resume
```

### State Validation
All commands must:
1. Check .state.json for current phase
2. Validate prerequisites
3. Show clear error if invalid state

### Context Loading
Always load:
- Current sprint's .state.json
- Relevant markdown files for phase
- Personal goals (if exists)

## Best Practices

### For Command Writers
- Keep instructions clear and sequential
- Include error handling
- Validate state before proceeding
- Save progress frequently
- Show clear completion messages

### For Users
- Complete grooming before implementation
- Review documents before approving
- Use Express for small tasks (<2 hours)
- Use Full ASAF for learning and features
- Keep personal goals updated

## Quick Reference

**Start a sprint**: `/asaf-init <name>`  
**Design it**: `/asaf-groom`  
**Build it**: `/asaf-impl`  
**Learn from it**: `/asaf-retro`  

**Quick task**: `/asaf-express "<requirements>"`  
**Check status**: `/asaf-status`  
**Get help**: `/asaf-help`

---

_ASAF: Structure without bureaucracy, AI without black boxes, learning without overhead._
