# ASAF Help Command

**Command**: `/asaf-help` or `/asaf-help <topic>`

**Purpose**: Show command reference and help

---

## General Help

When user runs `/asaf-help`:

```
📚 ASAF: Agile Scrum Agentic Flow

Structured workflow for coding tasks with AI agents.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Quick Start

**Full Workflow** (features, learning):
  /asaf-init <name>        Initialize sprint
  /asaf-groom              Design (30-45 min)
  /asaf-groom-approve      Approve & plan
  /asaf-impl               Implement (3-6 hrs)
  /asaf-demo               Present work
  /asaf-retro              Reflect & learn

**Express Mode** (quick tasks):
  /asaf-express "<req>"    Quick implementation (<2 hrs)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## All Commands

### Initialization
  /asaf-init <name>        Start new sprint
  /asaf-user <name>        Set active developer

### Grooming
  /asaf-groom              Design conversation
  /asaf-groom-approve      Lock & proceed
  /asaf-groom-view         View grooming docs

### Implementation
  /asaf-impl               Execute tasks
  /asaf-impl-pause         Pause execution
  /asaf-impl-resume        Resume paused
  /asaf-impl-review        Review blocked task
  /asaf-impl-approve       Approve & continue

### Express Mode
  /asaf-express "<req>"    Quick implementation
  /asaf-express --auto     Fully autonomous

### Demo & Retro
  /asaf-demo               Generate demo
  /asaf-retro              Retrospective

### Utilities
  /asaf-status             Current sprint status
  /asaf-summary            View SUMMARY.md
  /asaf-list               List all sprints
  /asaf-resume <name>      Resume sprint
  /asaf-cancel             Cancel sprint
  /asaf-help               This help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Get Help on Specific Topic

  /asaf-help init          Initialization commands
  /asaf-help groom         Grooming phase
  /asaf-help impl          Implementation
  /asaf-help express       Express mode
  /asaf-help concepts      Core concepts
  /asaf-help workflow      Full workflow guide

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Documentation

  GitHub: https://github.com/your-repo/asaf
  Quick Start: README.md in repo

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ASAF: Structure without bureaucracy, AI without black boxes.
```

---

## Topic-Specific Help

### /asaf-help init

```
📚 Initialization Commands

## /asaf-init <name>

Initialize a new ASAF sprint.

**Usage**:
  /asaf-init add-authentication
  /asaf-init @specs/feature.md

**What it does**:
  1. Creates asaf/<name>/ folder structure
  2. Prompts for feature description
  3. Sets up initial.md and SUMMARY.md
  4. Prepares for grooming

**Next step**: /asaf-groom

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-user <name>

Set active developer (for personal goals).

**Usage**:
  /asaf-user james

**What it does**:
  - Loads personal-goals.md for developer
  - Configures reviewer mode based on goals
  - Tracks learning progress

**Optional**: ASAF works without personal goals.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

More help:
  /asaf-help groom         Next phase
  /asaf-help workflow      Full workflow
```

---

### /asaf-help groom

```
📚 Grooming Phase

Grooming is collaborative design with AI.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-groom

**Duration**: 30-45 minutes (interactive)

**What happens**:
  1. Requirements clarification
  2. Technical design
  3. Edge case identification (min 10)
  4. Acceptance criteria (min 5)
  5. Execution planning

**Generates**:
  - grooming/design.md
  - grooming/edge-cases.md
  - grooming/acceptance-criteria.md
  - grooming/decisions.md
  - grooming/conversation-log.md

**Next**: /asaf-groom-approve

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-groom-approve

Lock grooming and trigger task planning.

**What happens**:
  1. Validates grooming completeness
  2. Locks documents (no changes after)
  3. Auto-generates task breakdown
  4. Creates implementation/tasks.md

**Next**: /asaf-impl

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tips:
  - Take your time with grooming
  - Think through edge cases
  - Investment here pays off later
  - Can pause and resume conversation

More help:
  /asaf-help impl          Next phase
```

---

### /asaf-help impl

```
📚 Implementation Phase

Autonomous execution with quality gates.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-impl

**Duration**: 3-6 hours (mostly autonomous)

**What happens**:
  For each task:
    1. Executor implements code
    2. Writes tests
    3. Runs tests
    4. Reviewer analyzes
    5. Iterates if needed (max 3x)
  
  Updates progress.md continuously.

**You can**:
  - Monitor progress (/asaf-status)
  - Pause anytime (/asaf-impl-pause)
  - Step away (it continues)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-impl-pause

Pause implementation gracefully.

**When to use**:
  - Need to investigate issue
  - Context switch (meeting, break)
  - Want to make manual changes

**Resume**: /asaf-impl-resume

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-impl-review

Review blocked task in detail.

**Shows**:
  - All iteration history
  - Test failures
  - Reviewer feedback
  - Pattern analysis
  - Recommended actions

**Options**:
  - Retry with more iterations
  - Fix manually
  - Skip task

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-impl-approve

Approve completed implementation.

**Validates**:
  - All tasks complete
  - Tests passing
  - Calculates metrics

**Next**: /asaf-demo

More help:
  /asaf-help express       Quick mode
```

---

### /asaf-help express

```
📚 Express Mode

Lightweight workflow for quick tasks (<2 hrs).

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## When to Use Express

✅ Good for:
  - Bug fixes
  - Small enhancements
  - Simple features
  - Quick tasks (<2 hours)
  - Daily productivity

❌ Use Full ASAF for:
  - New features
  - Complex changes
  - Learning opportunities
  - Security-sensitive work

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## /asaf-express "<requirements>"

**Usage**:
  /asaf-express "Add email field with validation"
  /asaf-express @specs/quick-fix.md

**What happens**:
  1. Quick analysis (2 min)
  2. Show plan & confirm
  3. Execute (1-2 hours)
  4. Lightweight docs

**Differences from Full**:
  - No grooming conversation
  - Faster review (Quick mode)
  - Max 2 iterations per task
  - Minimal documentation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Auto Mode

  /asaf-express --auto "Fix typo"

**Fully autonomous** for trivial tasks:
  - No confirmation
  - No interaction
  - Just get notification when done

**Only works for**:
  - Very simple changes
  - 1-2 tasks
  - <30 minutes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tips:
  - 80% of daily work: Express
  - 20% of features: Full ASAF
  - Can upgrade Express → Full if needed

More help:
  /asaf-help workflow      Full workflow
```

---

### /asaf-help concepts

```
📚 Core Concepts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## What is ASAF?

Structured workflow using AI agents to:
  1. Prevent context loss (organized phases)
  2. Maintain quality (review cycles)
  3. Foster learning (personal growth)
  4. Create docs (automatic)

**No backend. Just markdown files.**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Phases

**Full ASAF**:
  1. Init → Create sprint
  2. Groom → Design (30-45 min)
  3. Plan → Task breakdown (auto)
  4. Implement → Build (3-6 hrs)
  5. Demo → Present
  6. Retro → Learn

**Express**:
  1. Analyze → Quick (2 min)
  2. Execute → Build (1-2 hrs)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Agents

**Grooming Agent**: Design mentor
**Executor Agent**: Implements code
**Reviewer Agent**: Reviews quality
**Task Planner**: Breaks down work

Agents are Claude with different instructions.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## State Storage

**SUMMARY.md**: Human-readable overview
**.state.json**: Machine-readable state
**progress.md**: Detailed execution log

All in asaf/<sprint>/ folder.
Version controllable.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Personal Goals

Optional file: personal-goals.md

Benefits:
  - Connects work to learning
  - Configures reviewer mode
  - Tracks skill growth

Can be global (~/.claude/) or local (project).

More help:
  /asaf-help workflow      Full guide
```

---

### /asaf-help workflow

```
📚 Complete Workflow Guide

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Full ASAF Workflow

**Step 1: Initialize** (2 min)
  /asaf-init add-authentication
  → Describe feature
  → Creates sprint folder

**Step 2: Groom** (30-45 min)
  /asaf-groom
  → Design conversation
  → Edge cases identified
  → Acceptance criteria defined
  → Generates docs

**Step 3: Approve** (instant)
  /asaf-groom-approve
  → Validates completeness
  → Auto-generates tasks
  → Ready for implementation

**Step 4: Implement** (3-6 hrs)
  /asaf-impl
  → Executor builds each task
  → Reviewer checks quality
  → Iterates up to 3x per task
  → Can pause/resume

**Step 5: Approve Implementation** (instant)
  /asaf-impl-approve
  → Validates completion
  → Calculates metrics
  → Move to demo

**Step 6: Demo** (10 min)
  /asaf-demo
  → Generates presentation
  → Shows what was built

**Step 7: Retrospective** (10-15 min)
  /asaf-retro
  → Reflect on learnings
  → Update personal goals
  → Identify improvements

**Total Time**: 4-7 hours

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Express Workflow

**One Command** (1-2 hrs total):
  /asaf-express "Add email field"
  → Quick analysis (2 min)
  → Confirm plan
  → Execute tasks
  → Done!

**Auto Mode** (<30 min):
  /asaf-express --auto "Fix typo"
  → Fully autonomous
  → No interaction

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## When Things Go Wrong

**Implementation blocked**:
  /asaf-impl-review
  → See details
  → Choose: retry, fix, skip

**Need to pause**:
  /asaf-impl-pause
  → Investigate
  → Make changes
  → /asaf-impl-resume

**Lost context**:
  /asaf-status
  → See where you are
  → /asaf-summary for details

More help:
  /asaf-help <topic>       Specific help
```

---

## Error: Invalid Topic

```
❓ Unknown help topic: <topic>

Valid topics:
  init          Initialization
  groom         Grooming phase
  impl          Implementation
  express       Express mode
  concepts      Core concepts
  workflow      Full workflow

Try:
  /asaf-help <topic>
  /asaf-help            (general help)
```

---

_Help command provides guidance for all ASAF features._
