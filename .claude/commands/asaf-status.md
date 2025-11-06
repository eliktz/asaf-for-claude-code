# ASAF Status Command

**Command**: `/asaf-status`

**Purpose**: Display current sprint status and progress

---

## Step 0: Verify Active Sprint

1. Check if /asaf/.current-sprint.json exists
   - If NO: Run auto-selection algorithm (see asaf-core.md)
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

---

## Read Current Sprint Selection

After Step 0, you have the active sprint name.

Read `/asaf/.current-sprint.json`:
```json
{
  "sprint": "sprint-name",
  "selected_at": "2025-10-31T12:00:00Z",
  "type": "full"
}
```

Calculate:
- **Selection timestamp**: Convert to human-readable ("2 hours ago", "3 days ago")
- **Selection method**: Was it auto-selected or explicitly selected?
  - Check if selection timestamp is very recent (< 1 second ago) → auto-selected
  - Otherwise → explicitly selected (or persisted from previous session)

---

## Load Sprint State

Read:
- `.state.json` (current phase, status)
- `SUMMARY.md` (high-level info)
- Phase-specific files (for detailed status)

---

## Display Status

**IMPORTANT**: Always display current sprint info prominently at the top of ALL status outputs.

Format varies by phase, but all include the **Current Sprint** header first:

### During Grooming

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 ASAF Status: [sprint-name]

Status: Grooming in Progress
Started: [human-readable date/time]
Elapsed: [duration since start]

├─ ✅ Initialization (completed [date])
├─ 🔵 Grooming (in progress)
│   ├─ [✅/⬜] Requirements clarified
│   ├─ [✅/⬜] Technical design
│   ├─ [✅/⬜] Edge cases ([N] identified, need [M] more)
│   ├─ [✅/⬜] Acceptance criteria ([N] defined)
│   └─ [✅/⬜] Execution planning
├─ ⬜ Planning
├─ ⬜ Implementation
├─ ⬜ Demo
└─ ⬜ Retrospective

Current: [What's happening now]

Quick actions:
  /asaf-groom-continue  - Continue grooming
  /asaf-groom-approve   - Approve and proceed
  /asaf-summary         - View full summary
```

---

### After Grooming, Before Implementation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 ASAF Status: [sprint-name]

Status: Ready for Implementation
Started: [date]
Grooming completed: [date] ([duration])

├─ ✅ Initialization
├─ ✅ Grooming (approved [date])
├─ ✅ Planning ([N] tasks created)
├─ ⬜ Implementation
├─ ⬜ Demo
└─ ⬜ Retrospective

📋 Tasks: [N] total
   [Brief list of task names]

⏱️ Estimated time: [hours]

Quick actions:
  /asaf-impl            - Start implementation
  /asaf-summary         - View task details
  /asaf-view tasks      - See full task breakdown
```

---

### During Implementation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 ASAF Status: [sprint-name]

Status: Implementation in Progress
Started: [date]
Implementation started: [date/time]
Elapsed: [duration]

├─ ✅ Initialization
├─ ✅ Grooming (approved [date])
├─ ✅ Planning ([N] tasks)
├─ 🔵 Implementation (in progress)
│   ├─ ✅ Task 1: [Name] (1 iteration)
│   ├─ ✅ Task 2: [Name] (2 iterations)
│   ├─ 🔵 Task 3: [Name] (iteration 2/3)
│   ├─ ⬜ Task 4: [Name]
│   └─ ⬜ Task 5: [Name]
├─ ⬜ Demo
└─ ⬜ Retrospective

Progress: [X]/[N] tasks complete ([%]%)

Current: [Specific status - e.g., "Waiting for code review on Task 3"]

Tests: [X] passing, [Y] failing
[If tests failing: Link to /asaf-impl-review]

Quick actions:
  /asaf-impl-pause      - Pause implementation
  /asaf-impl-view       - View detailed progress
  /asaf-summary         - View full summary
```

---

### Implementation Blocked

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ ASAF Status: [sprint-name]

Status: Implementation Blocked
Started: [date]
Blocked since: [time]

├─ ✅ Initialization
├─ ✅ Grooming
├─ ✅ Planning
├─ 🔴 Implementation (blocked)
│   ├─ ✅ Task 1: [Name]
│   ├─ ✅ Task 2: [Name]
│   ├─ 🔴 Task 3: [Name] (BLOCKED after 3 iterations)
│   ├─ ⬜ Task 4: [Name]
│   └─ ⬜ Task 5: [Name]
├─ ⬜ Demo
└─ ⬜ Retrospective

Blocked Task: Task 3 - [Name]
Issue: [Last error message]

Action needed:
  /asaf-impl-review     - Review issue and decide next steps

Options:
  /asaf-impl-retry [N]  - Give more attempts
  [Fix manually]        - Fix code and /asaf-impl-resume
  /asaf-impl-skip       - Skip this task for now
```

---

### Implementation Complete

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ ASAF Status: [sprint-name]

Status: Implementation Complete
Duration: [total time from start to finish]

├─ ✅ Initialization
├─ ✅ Grooming ([duration])
├─ ✅ Planning ([N] tasks)
├─ ✅ Implementation ([duration])
│   └─ [N]/[N] tasks complete (100%)
├─ ⬜ Demo
└─ ⬜ Retrospective

📊 Results:
   Tasks: [N]/[N] completed
   Iterations: [X] total (avg [Y] per task)
   Tests: [X] written, [X] passing
   Coverage: [%]%

Quick actions:
  /asaf-impl-approve    - Approve and move to demo
  /asaf-impl-view       - Review implementation details
  /asaf-summary         - View full summary
```

---

### During Demo/Retro

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 ASAF Status: [sprint-name]

Status: [Demo/Retrospective] in Progress
Total duration: [time since start]

├─ ✅ Initialization
├─ ✅ Grooming
├─ ✅ Planning
├─ ✅ Implementation
├─ [🔵/✅] Demo
└─ [🔵/⬜] Retrospective

[Phase-specific status]

Quick actions:
  [Phase-specific commands]
```

---

### Sprint Complete

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [sprint-name]
   Type: Full Sprint
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ ASAF Status: [sprint-name]

Status: Complete 🎉
Total Duration: [start to finish]

├─ ✅ Initialization
├─ ✅ Grooming ([duration])
├─ ✅ Planning ([N] tasks)
├─ ✅ Implementation ([duration])
├─ ✅ Demo
└─ ✅ Retrospective

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Final Results:

**Implementation**:
  - Tasks: [N]/[N] completed (100%)
  - Iterations: [X] total (avg [Y] per task)
  - Tests: [X] written, [X] passing
  - Coverage: [%]%
  - Time: [hours]

**Learning**:
  - Personal goals advanced: [goal names]
  - Key learnings: [count] documented
  - Patterns identified: [count]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Summary available: asaf/[sprint-name]/SUMMARY.md

Start a new sprint: /asaf-init <name>
```

---

## Additional Information

### Show Elapsed Time

Calculate from .state.json timestamps:
- started_at to current (if in progress)
- started_at to completed_at (if complete)

Format: "2h 30m" or "4 days 3 hours"

---

### Show Task Progress Details

For each task in implementation:
- ✅ Complete (green checkmark)
- 🔵 In progress (blue circle)
- ⬜ Not started (empty square)
- 🔴 Blocked (red circle)
- ⚠️ Issues (yellow warning)

Include iteration count for completed/in-progress tasks.

---

### Show Current Action

Be specific about what's happening:
- "Executor implementing Task 3..."
- "Waiting for code review on Task 3"
- "Running tests for Task 2..."
- "Blocked: Task 4 failed after 3 iterations"
- "Ready to start implementation"

---

### Show Next Actions

Always provide clear next commands:
- Current phase commands
- View commands
- `/asaf-select` - Switch to different sprint (if multiple sprints exist)
- Help command

---

## Status for Multiple Sprints

If multiple sprints active/paused:

```
🔄 ASAF Status

Active Sprints: 2

1. 🔵 add-authentication (Implementation, Task 3/5)
   Last active: 2 hours ago
   
2. ⏸️ add-oauth (Grooming, paused)
   Last active: 2 days ago

Commands:
  /asaf-status add-authentication  - Show specific sprint
  /asaf-list                       - See all sprints
  /asaf-resume <name>              - Resume a sprint
```

---

## Express Sprint Status

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: [task-name]
   Type: Express Sprint (lightweight)
   Selected: [timestamp] ([auto-selected/explicitly selected])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 ASAF Express Status: [task-name]

Status: [In Progress/Complete]
Started: [time]
Elapsed: [duration]

Progress: [X]/[N] tasks complete

Current: [What's happening]

Quick actions:
  [Relevant commands]
```

---

## Error Handling

### Cannot Read State

```
🔴 ERROR: Cannot read sprint state

Sprint: [sprint-name]
Issue: .state.json is corrupted or missing

Try:
  /asaf-list                    - See all sprints
  /asaf-summary [sprint-name]   - View summary instead
  
Or manually check: asaf/[sprint-name]/.state.json
```

---

### Sprint Folder Exists But Incomplete

```
⚠️ WARNING: Sprint data incomplete

Sprint: [sprint-name]
Missing: [list missing files]

This sprint may have been interrupted or corrupted.

Options:
  /asaf-cancel       - Cancel and start over
  /asaf-resume       - Attempt to continue
```

---

## Context to Include

When displaying status:
- Read .state.json for phase/status
- Read SUMMARY.md for high-level info
- Read implementation/progress.md for task details (if in implementation)
- Calculate time differences from timestamps
- Check for error conditions

---

## Design Notes

### Why Different Formats per Phase?

Each phase has different relevant information:
- Grooming: What's decided vs. what's left
- Implementation: Task progress, current action
- Complete: Final metrics, learnings

### Why Show Quick Actions?

Reduce cognitive load - user always knows what they can do next.

### Why Elapsed Time?

Helps estimate remaining time, track productivity, adjust process.

---

_Status command provides at-a-glance view of sprint progress without opening files._
