# ASAF Groom Approve Command

**Command**: `/asaf-groom-approve`

**Purpose**: Lock grooming phase and trigger task planning

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

## Prerequisites

### Validate State

Read `.state.json`:
- phase must be "grooming"
- status must be "complete"

If not:
```
🔴 ERROR: Cannot approve grooming

Current state: [phase] - [status]

Grooming must be complete before approval.

[If grooming not started]
Run: /asaf-groom

[If grooming in progress]
Complete the grooming session first.

[If wrong phase]
This sprint is in [phase] phase, grooming already approved.
```
**STOP execution.**

---

## Validate Grooming Completeness

Check that all required documents exist and meet minimum standards:

### Required Documents Check

```
grooming/design.md          - Must exist
grooming/edge-cases.md      - Must exist
grooming/acceptance-criteria.md - Must exist
grooming/decisions.md       - Must exist
grooming/conversation-log.md - Must exist
```

If any missing:
```
🔴 ERROR: Incomplete grooming

Missing documents:
- [list missing files]

All grooming documents must be generated before approval.

Run: /asaf-groom-continue
```
**STOP execution.**

---

### Content Quality Check

**Edge Cases**:
```
Read grooming/edge-cases.md
Count edge cases (look for numbered items)

Read .state.json to determine grooming_mode (if present)
Default to "standard" if not specified

Mode-based minimums:
- Quick mode: 3 edge cases
- Standard mode: 8 edge cases
- Deep mode: 15 edge cases

If count < minimum for mode:
```
🔴 ERROR: Insufficient edge cases for [mode] mode

Found: [N] edge cases
Required for [mode] mode: Minimum [X]

Edge cases are critical for quality implementation.

[If mode is Quick and < 3]
Even for simple features, at least 3 critical edge cases should be identified.

[If mode is Standard and < 8]
Standard grooming requires comprehensive edge case coverage.

Options:
  /asaf-groom-continue  - Add more edge cases
  /asaf-groom-force     - Proceed anyway (not recommended)
```
**STOP execution (unless forced).**

---

**Acceptance Criteria**:
```
Read grooming/acceptance-criteria.md
Count acceptance criteria (look for ## AC headers)

Read .state.json to determine grooming_mode (if present)
Default to "standard" if not specified

Mode-based minimums:
- Quick mode: 2 acceptance criteria
- Standard mode: 5 acceptance criteria
- Deep mode: 8 acceptance criteria

If count < minimum for mode:
```
🔴 ERROR: Insufficient acceptance criteria for [mode] mode

Found: [N] acceptance criteria
Required for [mode] mode: Minimum [X]

Acceptance criteria define what "done" means.

[If mode is Quick and < 2]
Even for simple features, at least 2 acceptance criteria should be defined.

[If mode is Standard and < 5]
Standard grooming requires comprehensive acceptance criteria.

Options:
  /asaf-groom-continue  - Add more criteria
  /asaf-groom-force     - Proceed anyway (not recommended)
```
**STOP execution (unless forced).**

---

**Executor Profile**:
```
Read grooming/decisions.md
Look for "Executor Profile" section

If not found or empty:
```
🔴 ERROR: Executor profile not configured

decisions.md must specify which executor profile to use.

Options:
  /asaf-groom-continue  - Configure executor
  /asaf-groom-force     - Use default (typescript-fullstack-executor)
```
**STOP execution (unless forced).**

---

## Lock Grooming

Update `.state.json`:
```json
{
  "sprint": "[sprint-name]",
  "type": "full",
  "phase": "planning",
  "status": "in-progress",
  "grooming_approved": true,
  "grooming_locked": true,
  "grooming_approved_at": "[timestamp]",
  "created": "[original]",
  "updated": "[current timestamp]"
}
```

**Note**: Once locked, grooming documents cannot be modified (to prevent drift).

---

## Generate Task Breakdown

**Note**: Task planning is deterministic - you do this directly, NOT via Task tool.

Display:
```
✅ Grooming approved and locked

Generating task breakdown...
```

### Task Planning Process

**Read**:
- grooming/design.md (components, flows)
- grooming/edge-cases.md (what to handle)
- grooming/acceptance-criteria.md (success definition)
- grooming/decisions.md (stack, patterns)

**Create**:
1. Break feature into 3-8 executable tasks
2. Order by dependency
3. Estimate complexity per task using story points
4. Define execution pattern per task
5. Set max iterations per task (based on complexity)

---

### Generate tasks.md

```markdown
# Task Breakdown: [Sprint Name]

Generated: [timestamp]
Total Tasks: [N]
Total Story Points: [sum of all task points]

---

## Task 1: [Task Name]

**Complexity**: [1|2|4|8] story points

**Complexity Rationale**:
[Brief explanation of why this complexity]

**Description**:
[Clear description of what needs to be implemented]

**Execution Pattern**: executor → test → reviewer → executor

**Max Iterations**: [based on complexity mapping below]
- 1 point → 2 iterations
- 2 points → 3 iterations
- 4 points → 4 iterations
- 8 points → 5 iterations (or consider breaking down)

**Executor Profile**: [from decisions.md]

**Files to Create/Modify**:
- `path/to/file` (create/modify) - [purpose]

**Edge Cases to Handle**:
- Edge case #[N]: [name]
- Edge case #[N]: [name]

**Acceptance Criteria Link**:
- Contributes to AC[N]: [criterion name]

**Definition of Done**:
- [ ] [Implementation requirement]
- [ ] [Test requirement]
- [ ] [Edge case requirement]
- [ ] All tests passing

**Special Considerations**:
[Any notes for executor - security, performance, etc.]

---

[Repeat for each task]

---

## Task Dependencies

```
Task 1 (Foundation) → Task 2 (Uses Task 1) → Task 4 (Integrates)
                   ↘ Task 3 (Uses Task 1) ↗
```

## Sprint Complexity Summary

- Total tasks: [N]
- Total story points: [sum]
- Breakdown:
  - 1-point tasks: [count] ([sum] points)
  - 2-point tasks: [count] ([sum] points)
  - 4-point tasks: [count] ([sum] points)
  - 8-point tasks: [count] ([sum] points)
- Average complexity: [avg] points/task
- Expected iterations: ~[N] total

**Story Point Scale**:
- **1 point (Trivial)**: Simple config, single file edit, well-defined change
- **2 points (Simple)**: Straightforward implementation, clear requirements, minimal unknowns
- **4 points (Complex)**: Multiple components, design decisions, integration points, many edge cases
- **8 points (Very Complex)**: Architecture changes, high uncertainty, cross-cutting concerns, may need breakdown

---

_Task breakdown generated by Task Planner Agent_
```

---

### Initialize progress.md

```markdown
# Implementation Progress: [Sprint Name]

Started: [timestamp]

---

## Overall Status

- **Total Tasks**: [N]
- **Completed**: 0
- **In Progress**: None
- **Blocked**: None

---

[For each task, create empty section]

## Task 1: [Task Name]
**Status**: Ready to Start
**Current Iteration**: 0/[max]
**Assigned To**: Awaiting executor

### Executor Notes
_Executor will document implementation here_

### Test Results
_Test results will appear here_

### Reviewer Notes
_Reviewer feedback will appear here_

---

[Repeat for all tasks]

---

_This file will be updated continuously during implementation_
```

---

## Update SUMMARY.md

Add task breakdown section:

```markdown
## 📋 Task Breakdown

**Total Tasks**: [N]
**Total Story Points**: [sum]

### Tasks

1. **[Task name]** ([N] story points)
   - [Brief description]
   - Files: [count] files
   - Max iterations: [N]
   - DoD: [key requirement]

[Repeat for all tasks]

**Complexity Distribution**:
- 1-point: [count] tasks
- 2-point: [count] tasks
- 4-point: [count] tasks
- 8-point: [count] tasks

[See implementation/tasks.md for full details]

---

## 📊 Sprint Progress

- [x] Initialization
- [x] Grooming
- [x] Planning ← _Just completed_
- [ ] Implementation
- [ ] Demo
- [ ] Retrospective

---

_Updated after task planning on [date]_
```

---

## Success Message

```
✅ Grooming approved and locked

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task Planner Agent completed successfully!

Generated:
  ✓ implementation/tasks.md ([N] tasks defined)
  ✓ implementation/progress.md (tracking initialized)

Updated SUMMARY.md with task breakdown.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Summary:

[For each task, show one line]
1. [Task name] ([N] points, [max iter] max iterations)
2. [Task name] ([N] points, [max iter] max iterations)
...

**Total Story Points**: [sum]
**Average Complexity**: [avg] points/task
**Ready to implement**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next step: Run `/asaf-impl` to begin implementation

This will execute all tasks automatically with:
- Executor Agent implementing each task
- Reviewer Agent reviewing after each implementation
- Automatic iteration on feedback (up to [max] per task)
- Progress updates in real-time

You can monitor with `/asaf-status` or pause with `/asaf-impl-pause`
```

**STOP HERE. Wait for user to run `/asaf-impl` when ready.**

---

## Error Handling

### Task Planning Fails

If Task Planner cannot generate tasks:

```
🔴 CRITICAL: Task planning failed

Error: [Technical details]

The grooming documents may have insufficient detail.

Options:
  /asaf-groom-continue  - Add more detail to grooming
  [Manual task creation] - Create implementation/tasks.md manually

Cannot proceed to implementation without task breakdown.
```

---

### File Write Error

If cannot create implementation/ files:

```
🔴 CRITICAL: Cannot create implementation files

Failed to create: implementation/[file]

Error: [System error]

Check:
- Write permissions on asaf/[sprint]/ folder
- Disk space available
- File system not read-only

Cannot proceed without ability to write files.
```

---

## Force Approval

If user runs `/asaf-groom-force`:

```
⚠️ WARNING: Forcing approval with incomplete grooming

Quality checks failed:
- Edge cases: [N] found (recommended: 8+)
- Acceptance criteria: [N] found (recommended: 5+)

This may result in:
- Incomplete implementation
- Missing edge case handling
- Unclear success criteria

Proceed anyway? (y/n)

[If yes]
Proceeding with forced approval...
[Continue with task planning]

[If no]
Approval cancelled. Run /asaf-groom-continue to complete properly.
```

---

## Design Notes

### Why Lock Grooming?

- Prevents design drift during implementation
- Creates clear handoff point
- Grooming docs become source of truth
- Changes require new sprint (intentional friction)

### Why Auto-Trigger Planning?

- Seamless workflow (one command)
- Planning is deterministic (no user input needed)
- Immediate feedback on task breakdown
- User sees tasks before implementation starts

### Why Quality Checks?

- Enforce minimum standards
- Prevent poor implementations
- Investment in grooming pays off
- Can force if needed (escape hatch)

---

_Remember: Approval is a one-way gate. Once locked, grooming is frozen and implementation begins._
