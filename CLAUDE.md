# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## What is ASAF?

**ASAF (Agile Scrum Agentic Flow)** is a markdown-based workflow system for Claude Code that structures software development into organized phases with AI agent collaboration.

**Key principle**: ASAF is conventions + prompts + file structure, NOT code. It's a set of slash commands (markdown files) that guide conversations and generate documentation.

---

## Architecture Overview

### Core Concept
- **Commands** = Markdown instruction files in `.claude/commands/`
- **Agents** = Personas (prompts) defined in `.claude/commands/shared/`
- **State** = Markdown files + `.state.json` for machine-readable tracking
- **No backend, no database** - Just file-based conventions

### Agent Personas
Each agent is Claude adopting a different persona via markdown instructions:

1. **Grooming Agent** (`grooming-agent.md`) - Senior engineering mentor conducting design sessions
2. **Executor Agent** (`executor-agent.md`) - Expert developer implementing code with specific tech stack profiles
3. **Reviewer Agent** (`reviewer-agent.md`) - Code reviewer with multiple modes (Harsh Critic, Supportive Mentor, Educational, Quick Review)
4. **Task Planner Agent** - Breaks features into executable tasks

### Workflow Phases
```
Init → Groom → Plan → Implement → Demo → Retro
```

Each phase:
- Validates state via `.state.json`
- Reads context from previous phases
- Generates documentation
- Updates state for next phase

---

## Repository Structure

**This repository** contains the ASAF command system:

```
asaf/
├── .claude/
│   └── commands/
│       ├── asaf-init.md
│       ├── asaf-groom.md
│       ├── asaf-groom-approve.md
│       ├── asaf-impl.md
│       ├── asaf-impl-pause.md
│       ├── asaf-impl-resume.md
│       ├── asaf-impl-review.md
│       ├── asaf-impl-approve.md
│       ├── asaf-express.md
│       ├── asaf-demo.md
│       ├── asaf-retro.md
│       ├── asaf-status.md
│       ├── asaf-select.md
│       ├── asaf-list.md
│       ├── asaf-help.md
│       ├── asaf-summary.md
│       └── shared/
│           ├── asaf-core.md         # Core principles
│           ├── grooming-agent.md    # Design conversation persona
│           ├── executor-agent.md    # Implementation persona
│           └── reviewer-agent.md    # Code review persona
├── README.md
├── CONTRIBUTING.md
├── LICENSE
├── install.sh        # Global installation script
├── uninstall.sh      # Uninstallation script
└── .gitignore
```

### User Project Structure (After Using ASAF)

When users run ASAF commands in their projects, this structure is created:

```
user-project/
├── asaf/                    # Created by /asaf-init
│   ├── .current-sprint.json # Sprint selection state (auto-created)
│   ├── <sprint-name>/       # Full ASAF sprint
│   │   ├── SUMMARY.md       # Single source of truth (human-readable)
│   │   ├── .state.json      # Machine-readable state
│   │   ├── initial.md       # Feature description
│   │   ├── grooming/        # Design phase outputs
│   │   │   ├── design.md
│   │   │   ├── edge-cases.md   # Min 10 edge cases
│   │   │   ├── acceptance-criteria.md  # Min 5 criteria
│   │   │   ├── decisions.md     # Technical choices + executor/reviewer config
│   │   │   └── conversation-log.md
│   │   ├── implementation/  # Execution phase
│   │   │   ├── tasks.md
│   │   │   └── progress.md  # Real-time implementation log
│   │   ├── demo/
│   │   └── retro/
│   └── express/             # Quick tasks (lightweight)
│       └── <task-name>/
├── personal-goals.md        # Optional: developer learning goals
└── src/                     # User's actual code
```

---

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
  "grooming_approved": true,
  "implementation_complete": false
}
```

**Critical**: All commands MUST validate state before execution. Check phase and prerequisites.

---

## Sprint Selection State

### .current-sprint.json Format

Located at `/asaf/.current-sprint.json`, this file tracks which sprint is currently active:

```json
{
  "sprint": "sprint-name",
  "selected_at": "2025-10-31T12:00:00Z",
  "type": "full"
}
```

### Auto-Selection Algorithm

When `.current-sprint.json` is missing, commands automatically:
1. Scan `/asaf/` for valid full sprints (have `.state.json`)
2. Sort by `.state.json` modification time (most recent first)
3. Use alphabetical order as tiebreaker
4. Create `.current-sprint.json` with selected sprint
5. Log: "Auto-selected sprint '<name>' (most recently modified)"
6. Continue execution

### Sprint Selection Validation Pattern (Step 0)

All sprint-context commands include this as Step 0:

```markdown
## Step 0: Verify Active Sprint

1. Check if /asaf/.current-sprint.json exists
   - If NO: Run auto-selection algorithm (see asaf-core.md)
   - If YES: Read sprint name from file

2. Validate selected sprint exists at /asaf/<sprint-name>/
   - If NO: Delete stale file, run auto-selection
   - If YES: Continue

3. Validate sprint has .state.json
   - LENIENT: Warn but continue if missing

4. Set context: All operations use /asaf/<sprint-name>/
```

### Commands Requiring Sprint Context

All commands EXCEPT:
- `/asaf-list` (lists all sprints)
- `/asaf-help` (shows help)
- `/asaf-select` (sets selection)
- `/asaf-init` (creates new sprint, prompts to set as current)

### Git Behavior

`.current-sprint.json` can be:
- **Committed**: Share active sprint across team/machines
- **Ignored**: Add to `.gitignore` for local-only selection (recommended for solo work)

---

## Implementation Loop Pattern

The `/asaf-impl` command runs autonomously with this pattern:

```
For each task:
  iteration = 1
  while iteration <= max_iterations:

    1. EXECUTOR PHASE
       - Adopt executor-agent.md persona
       - Read task + design + edge cases
       - Implement code
       - Write tests
       - Run tests
       - Document in progress.md

    2. REVIEWER PHASE
       - Adopt reviewer-agent.md persona
       - Review code against design
       - Verify edge case coverage
       - Check test coverage
       - APPROVE or REQUEST CHANGES

    3. DECISION
       if APPROVED:
         Mark task complete, move to next
       else if iteration < max:
         iteration++, executor addresses feedback
       else:
         Mark BLOCKED, pause, require human intervention
```

**Auto-pause conditions**: Max iterations reached, test framework crashes, file write errors, infinite loop detected.

---

## Key Commands

### Core Workflow
- `/asaf-init <name>` - Initialize sprint, create folder structure
- `/asaf-select [name]` - Select active sprint (interactive if no name)
- `/asaf-groom` - 30-45 min design conversation with Grooming Agent
- `/asaf-groom-approve` - Lock grooming, generate tasks.md
- `/asaf-impl` - Autonomous implementation (3-6 hours)
- `/asaf-impl-pause` / `/asaf-impl-resume` - Control execution
- `/asaf-status` - Current sprint state (shows selected sprint prominently)
- `/asaf-demo` - Generate demo presentation
- `/asaf-retro` - Learning retrospective

### Express Mode
- `/asaf-express "<description>"` - Quick task workflow
- `/asaf-express --auto` - Fully autonomous for trivial tasks

---

## Executor Profiles

Defined in `executor-agent.md`, profiles determine language/framework expertise:

- `typescript-fullstack-executor` - TypeScript, React, Node.js, Express, Prisma
- `typescript-backend-executor` - TypeScript, Node.js, Express, REST APIs
- `typescript-frontend-executor` - TypeScript, React, Next.js
- `python-backend-executor` - Python, FastAPI/Django/Flask, SQLAlchemy, pytest
- `python-data-executor` - Python, pandas, numpy, Jupyter
- `rust-systems-executor` - Rust, systems programming
- `go-microservices-executor` - Go, gRPC, Docker

Auto-detected from codebase (package.json, requirements.txt, etc.) during grooming.

---

## Reviewer Modes

Defined in `reviewer-agent.md`, modes control feedback style:

- **Harsh Critic** - Direct, high standards, minimal praise
- **Supportive Mentor** - Encouraging, constructive, explains rationale
- **Educational** - Deep explanations of "why", learning-focused
- **Quick Review** - Fast, checklist-based

Selected based on `personal-goals.md` (developer experience + learning goals).

---

## Personal Goals Integration

Optional `personal-goals.md` (project root or `~/.claude/`) defines:
- Experience level per domain (backend, frontend, etc.)
- Current learning goals
- Reviewer preferences

Used to:
- Configure reviewer mode
- Align tasks with learning objectives
- Track skill progression in retrospectives

---

## Error Handling Conventions

All commands follow this pattern:

### Severity Levels
- 🔴 CRITICAL - Cannot continue, requires intervention
- 🟡 WARNING - Can continue with degradation
- 🔵 INFO - Informational only

### Error Response Format
```
🔴 ERROR: [Short description]

[Detailed explanation]

Possible reasons:
  - [Reason 1]
  - [Reason 2]

Troubleshooting:
  1. [Step 1]
  2. [Step 2]

[Recovery options or next steps]
```

### Recovery Patterns
1. **Auto-retry** - Transient failures (3 attempts)
2. **Checkpoint & Resume** - Save state before failure
3. **Graceful Degradation** - Continue with reduced functionality
4. **Escalation** - Present options to user

---

## Document Generation Standards

### Grooming Phase Outputs
All documents generated during `/asaf-groom`:
- **design.md** - Architecture, components, data models, user flows, security
- **edge-cases.md** - Minimum 10 scenarios (Input, Auth, System Errors, Security, Performance)
- **acceptance-criteria.md** - Minimum 5 testable criteria
- **decisions.md** - Technical choices with alternatives + rationale, executor/reviewer config
- **conversation-log.md** - Full Q&A transcript

### Implementation Phase Outputs
- **tasks.md** - Sequential tasks with complexity, max iterations, execution pattern
- **progress.md** - Real-time log with executor notes, test results, reviewer feedback

### SUMMARY.md
Always keep updated as single source of truth. Include:
- Current phase and status
- Feature description
- Key decisions
- Progress checklist
- Implementation results (when complete)

---

## Conversation Style Requirements

### Grooming Agent Conversation
- **ONE question at a time** (never overwhelm)
- Acknowledge answers before next question
- Probe ambiguity: "When you say X, do you mean Y or Z?"
- Present options with trade-offs, not single solutions
- Search codebase for existing patterns
- Search web for best practices when needed
- Connect work to personal goals
- Explain reasoning: "I'm asking this because..."

### Executor Agent Behavior
- Follow design from design.md strictly
- Handle ALL edge cases from edge-cases.md
- Write comprehensive tests (happy path + edge cases + error handling)
- Document concerns honestly in progress.md
- Never leave incomplete code without explanation

### Reviewer Agent Behavior
- Check design compliance
- Verify edge case coverage
- Provide specific, actionable feedback
- Use configured mode (Harsh Critic, Supportive Mentor, etc.)
- APPROVE or REQUEST CHANGES with clear priorities

---

## Installation

### From This Repository

**Global Installation (Recommended)**:
```bash
# Run the install script from this repository
./install.sh

# Or manually:
mkdir -p ~/.claude/commands/shared
cp .claude/commands/*.md ~/.claude/commands/
cp .claude/commands/shared/*.md ~/.claude/commands/shared/
```

**Per-Project Installation**:
```bash
# In user's project directory
mkdir -p .claude/commands/shared
cp /path/to/asaf/.claude/commands/*.md .claude/commands/
cp /path/to/asaf/.claude/commands/shared/*.md .claude/commands/shared/
```

Once installed, users can run ASAF commands in any project. Sprint data is always stored locally in `asaf/` within each project.

---

## Testing ASAF Changes

When modifying command files:

1. **Test full workflow**:
   ```
   /asaf-init test-sprint
   /asaf-groom (complete conversation)
   /asaf-groom-approve
   /asaf-impl
   ```

2. **Verify state transitions**:
   - Check `.state.json` updates correctly
   - Verify SUMMARY.md reflects current phase
   - Ensure progress.md captures all iterations

3. **Test error cases**:
   - Invalid state transitions
   - Missing prerequisites
   - Blocked tasks (max iterations)

4. **Test pause/resume**:
   - `/asaf-impl-pause` during execution
   - Verify state preserved
   - `/asaf-impl-resume` continues correctly

---

## Common Patterns

### Command Structure Template
```markdown
# ASAF [Command Name]

**Command**: /asaf-[name] [params]
**Purpose**: [Brief description]

## Prerequisites
Check .state.json: [requirements]
If not: [error message + STOP]

## Execution Steps
### Step 1: [Action]
[Clear instructions]

## Update State
[JSON changes]

## Success Message
[What to show user]

## Error Handling
[Error cases with recovery]
```

### Persona Adoption
When switching to agent persona:
```markdown
**From this point, adopt the [Agent Name] persona** defined in:
`.claude/commands/shared/[agent]-agent.md`

**Context to provide**:
- [Relevant context items]
```

---

## Development Guidelines

### Adding New Command
1. Create `asaf-[name].md` in **this repository's** `.claude/commands/` folder
2. Follow command structure template
3. Validate state before execution
4. Update `.state.json` appropriately
5. Generate clear success/error messages
6. Test with real sprint
7. Update README.md with new command
8. Users must reinstall via `./install.sh` to get the new command

### Adding Executor Profile
1. Edit `.claude/commands/shared/executor-agent.md` **in this repository**
2. Add profile with: expertise, code standards, testing patterns, examples
3. Update decisions.md template in grooming-agent.md
4. Test with real project using that stack
5. Users must reinstall to get the new profile

### Adding Reviewer Mode
1. Edit `.claude/commands/shared/reviewer-agent.md` **in this repository**
2. Define: tone, structure, examples
3. Document when to use
4. Update grooming-agent.md options
5. Users must reinstall to get the new mode

---

## Philosophy

**What ASAF Is**:
- Structured markdown-based workflow
- Prompt engineering + file conventions
- Native to Claude Code

**What ASAF Is NOT**:
- A complex backend system
- A database application
- An API service
- Code that needs debugging

**Why Markdown**:
- Human-readable (developers can inspect/edit)
- Version controllable (git-friendly)
- Portable (works anywhere)
- Durable (outlasts any tool)

**Why Personas**:
- Leverages Claude's strengths
- No orchestration complexity
- Easy to modify
- Transparent

---

## Troubleshooting

### Commands Not Available
Check file locations:
```bash
ls ~/.claude/commands/asaf-*.md
ls ~/.claude/commands/shared/*.md
```

### Sprint Not Creating
Check permissions: `ls -la asaf/`

### State Corrupted
View: `cat asaf/<sprint>/.state.json`
Manually fix invalid JSON

### Implementation Blocked
Use `/asaf-impl-review` to see full iteration history
Consider `/asaf-impl-retry <N>` for more attempts

---

## Important Notes

- **Always validate .state.json** before command execution
- **Save state frequently** during long operations
- **Minimum requirements**: 10 edge cases, 5 acceptance criteria during grooming
- **Max 3 iterations** per task by default (configurable)
- **Auto-pause on block** - never waste iterations
- **SUMMARY.md is king** - single source of truth for humans
- **progress.md is log** - detailed implementation record
- **.state.json is state** - machine-readable current state

---

## Version

ASAF 1.0.0 (Production Ready)
- Full workflow implemented
- All 14 commands complete
- 4 agent personas defined
- Express mode available
- Pause/resume/review/retry capabilities
- from now on, push changes to both repositories