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

### Sprint Selection

**Current Sprint State File**: `/asaf/.current-sprint.json`

```json
{
  "sprint": "sprint-name",
  "selected_at": "2025-10-31T12:00:00Z",
  "type": "full"
}
```

This file tracks which sprint is currently active. All sprint-context commands check this file before operating.

### Auto-Selection Algorithm

**When to use**: Commands that require sprint context should run this algorithm if `/asaf/.current-sprint.json` is missing or points to a deleted sprint.

**Algorithm**:

**Step 1: Scan for valid sprints**
```
1. List all subdirectories in /asaf/
2. Exclude /asaf/express/ (express sprints not tracked in selection)
3. Filter to valid full sprints: must have .state.json file
```

**Step 2: Handle edge cases**

If **0 valid sprints** found:
```
🔴 ERROR: No valid sprints found

No full sprints exist in this repository.

To create a sprint:
  /asaf-init <sprint-name>

To see existing folders:
  ls -la asaf/
```
**STOP execution** - Cannot proceed without a valid sprint.

If **1 valid sprint** found:
- Select that sprint automatically
- Proceed to Step 3

If **multiple valid sprints** found:
- Sort by `.state.json` modification time (newest first)
- **Tiebreaker**: If multiple sprints have identical modification times, use alphabetical order
- Select the most recently modified sprint
- Proceed to Step 3

**Step 3: Create selection file**
```
Read selected sprint's .state.json to get type field.

Create /asaf/.current-sprint.json:
{
  "sprint": "<selected-sprint-name>",
  "selected_at": "<current-ISO-8601-timestamp>",
  "type": "full"
}
```

**Step 4: Log and continue**
```
🔵 INFO: Auto-selected sprint '<sprint-name>' (most recently modified)
```

Continue with command execution using selected sprint.

**Rationale for .state.json modification time**:
- Reflects actual sprint work (only ASAF commands update this file)
- Ignores noise from file viewing or IDE activity
- Already required for validation (every valid sprint has it)

### Sprint Selection Validation Pattern

**Commands that require sprint context** should include this at the beginning:

```markdown
## Step 0: Verify Active Sprint

1. Check if /asaf/.current-sprint.json exists
   - If NO: Run auto-selection algorithm (see above)
   - If YES: Read sprint name from file

2. Validate selected sprint exists at /asaf/<sprint-name>/
   - If NO: Sprint was deleted
     - Delete stale /asaf/.current-sprint.json
     - Log: "Selected sprint no longer exists, auto-selecting..."
     - Run auto-selection algorithm
   - If YES: Continue

3. Validate sprint has .state.json
   - Check /asaf/<sprint-name>/.state.json exists
   - If NO but sprint folder exists:
     - LENIENT WARNING: Log "Sprint has no .state.json (may be incomplete)"
     - Continue anyway (developer may be fixing)
   - If sprint folder missing: Already handled in step 2

4. Set context: All subsequent operations use /asaf/<sprint-name>/
```

**Commands that do NOT require sprint context**:
- `/asaf-list` (lists all sprints independently)
- `/asaf-help` (shows help)
- `/asaf-select` (sets sprint selection)

**Special case**:
- `/asaf-init` (creates new sprint, prompts to set as current)

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

## Interactive Question Patterns

ASAF commands use the **AskUserQuestion tool** for structured user input. This provides better UX than text-based prompts.

### When to Use Interactive Prompts

| Question Type | Use Interactive? | Tool Feature |
|---------------|------------------|--------------|
| Yes/No/Partial | ✅ Always | Single select |
| Multiple choice (2-4 options) | ✅ Always | Single select |
| Multi-select (non-exclusive) | ✅ Always | multiSelect: true |
| Rating scale | ✅ Always | Single select with ranges |
| Open-ended exploration | ❌ Use text | N/A |
| Follow-up clarification | ❌ Use text | N/A |

### Standard Patterns

**Pattern 1: Confirmation**
```yaml
AskUserQuestion:
  questions:
    - question: "[Your question]?"
      header: "Confirm"
      multiSelect: false
      options:
        - label: "Yes"
          description: "Proceed with this"
        - label: "Partially"
          description: "Some corrections needed"
        - label: "No"
          description: "Let me clarify"
```

**Pattern 2: Choice Selection**
```yaml
AskUserQuestion:
  questions:
    - question: "Which [thing] should we use?"
      header: "[Short label]"
      multiSelect: false
      options:
        - label: "[Option A]"
          description: "[Brief explanation]"
        - label: "[Option B]"
          description: "[Brief explanation]"
        - label: "Other"
          description: "I have a different preference"
```

**Pattern 3: Multi-Select**
```yaml
AskUserQuestion:
  questions:
    - question: "Which [things] apply?"
      header: "[Category]"
      multiSelect: true
      options:
        - label: "[Option 1]"
          description: "[Description]"
        - label: "[Option 2]"
          description: "[Description]"
```

**Pattern 4: Rating Scale**
```yaml
AskUserQuestion:
  questions:
    - question: "How [metric] was this?"
      header: "Rating"
      multiSelect: false
      options:
        - label: "1-3 (Low)"
          description: "[Low description]"
        - label: "4-6 (Medium)"
          description: "[Medium description]"
        - label: "7-10 (High)"
          description: "[High description]"
```

### Guidelines

1. **Headers must be ≤12 characters** (displayed as chips/tags)
2. **2-4 options per question** (too many overwhelms users)
3. **Descriptions should be brief** (1 sentence max)
4. **Always include "Other" for choices** (user can type custom answer)
5. **Use multiSelect: true for non-exclusive choices**
6. **Mix interactive with text questions** (don't make it feel like a form)

### Example Flow

```
Claude: "Let me understand the problem. What are you trying to solve?"
User: [types explanation]  ← Open-ended, use text

Claude: [Uses AskUserQuestion]
   "Is my understanding correct?"
   Options: Yes / Partially / No
User: [clicks "Yes"]  ← Closed-ended, use selection

Claude: [Uses AskUserQuestion]
   "Which authentication approach?"
   Options: JWT / Sessions / Other
User: [clicks "JWT"]  ← Multiple choice, use selection

Claude: "Why do you prefer JWT over sessions?"
User: [types explanation]  ← Open-ended, use text
```

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
