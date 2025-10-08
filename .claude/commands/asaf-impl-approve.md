# ASAF Implementation Approve Command

**Command**: `/asaf-impl-approve`

**Purpose**: Approve completed implementation and move to demo phase

---

## Prerequisites

Check `.state.json`:
- phase must be "implementation"
- implementation_complete must be true
- status must be "complete"

If not complete:
```
🔴 ERROR: Cannot approve incomplete implementation

Current status: [status]

[If in-progress]
Implementation is still running.
  - Task [X]/[N] in progress
  - Use /asaf-status to check progress

[If blocked]
Implementation is blocked on Task [X].
  - Use /asaf-impl-review to see details
  - Resolve blocking issue first

[If not started]
Implementation hasn't started yet.
  - Run: /asaf-impl

Wait for implementation to complete before approving.
```
**STOP execution.**

---

## Validate Completeness

### Check All Tasks Complete

Read `implementation/tasks.md` and `implementation/progress.md`:

Count:
- Total tasks
- Completed tasks
- Blocked/skipped tasks

If not all complete:
```
⚠️ WARNING: Not all tasks completed

Status:
  - Total tasks: [N]
  - Completed: [X]
  - Blocked: [Y]
  - Skipped: [Z]

Incomplete tasks:
  - Task [N]: [Name] (blocked)
  - Task [N]: [Name] (skipped)

Options:
  1. Continue anyway: /asaf-impl-approve-force
  2. Review blocked tasks: /asaf-impl-review
  3. Resume implementation: /asaf-impl-resume

Recommendation: Resolve blocked tasks before approval.

Approve anyway? (y/n)
```

If user says no, STOP.
If user says yes or runs with --force, continue.

---

### Check All Tests Passing

Read test results from `progress.md`:

If tests failing:
```
⚠️ WARNING: Some tests failing

Test Results:
  ✅ [X] passing
  ❌ [Y] failing

Failing tests:
  - [test name] in Task [N]
  - [test name] in Task [N]

Having failing tests means the implementation may not work correctly.

Options:
  1. Fix tests first: /asaf-impl-resume
  2. Continue anyway: /asaf-impl-approve-force

Recommendation: Fix failing tests before approval.

Approve anyway? (y/n)
```

If user says no, STOP.
If user says yes or runs with --force, continue.

---

## Calculate Final Metrics

From `progress.md`:
- Total tasks: [N]
- Completed: [X]
- Total iterations: [sum]
- Average iterations per task: [total / completed]
- Tests written: [count]
- Tests passing: [count]
- Tests failing: [count]
- Code coverage: [% if available]
- Duration: [start to finish timestamps]

---

## Update State

```json
{
  "phase": "demo",
  "status": "ready",
  "implementation_approved": true,
  "implementation_approved_at": "[timestamp]",
  "demo_ready": true
}
```

---

## Update SUMMARY.md

Add final implementation summary:

```markdown
## ✅ Implementation Complete

**Completed**: [date/time]
**Duration**: [hours minutes]
**Status**: Approved and ready for demo

### Final Results

**Tasks**:
- Total: [N]
- Completed: [X] ([%]%)
- Blocked: [Y] (if any)
- Skipped: [Z] (if any)

**Iterations**:
- Total: [X]
- Average per task: [Y]
- Min: [min iterations for any task]
- Max: [max iterations for any task]

**Quality**:
- Tests written: [X]
- Tests passing: [X] ([%]%)
- Code coverage: [%]% (if available)

### Task Breakdown

1. Task 1: [Name] ✅ (1 iteration, [duration])
2. Task 2: [Name] ✅ (2 iterations, [duration])
3. Task 3: [Name] ✅ (1 iteration, [duration])
...

[If any blocked/skipped]
**Deferred**:
- Task [N]: [Name] ⚠️ (marked as TODO)

### Files Changed

**Created** ([N] files):
- `path/to/file` - [purpose]

**Modified** ([N] files):
- `path/to/file` - [changes]

**Tests** ([N] files):
- `path/to/test` - [coverage]

### Notable Achievements

[If any tasks completed in 1 iteration]
- ✨ [X] tasks completed perfectly on first try

[If high test coverage]
- ✨ Excellent test coverage: [%]%

[If all tests passing]
- ✨ 100% test pass rate

[If any challenges overcome]
- 💪 Overcame [challenge description]

---

## 📊 Sprint Progress

- [x] Initialization
- [x] Grooming
- [x] Planning
- [x] Implementation ← _Approved_
- [ ] Demo
- [ ] Retrospective

---

_Implementation approved on [date]_
```

---

## Success Message

```
✅ Implementation approved!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Final Implementation Summary:

**Duration**: [hours minutes]

**Tasks**: [X]/[N] completed ([%]%)
**Iterations**: [X] total (avg [Y] per task)
**Tests**: [X] written, [X] passing ([%]%)
**Coverage**: [%]%

[If perfect execution]
🌟 Perfect execution: All tasks on first try!

[If all tests passing]
🌟 All tests passing!

[If high coverage]
🌟 Excellent test coverage!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Implementation artifacts:
   Code: [N] files created/modified
   Tests: [N] test files
   Docs: implementation/progress.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:

  /asaf-demo          - Generate demo presentation
  /asaf-summary       - View full sprint summary
  /asaf-status        - Check sprint status

[If tasks skipped/blocked]
⚠️  Note: [X] tasks were skipped/blocked
    Review: implementation/progress.md
    Consider follow-up sprint for deferred items

Great work! Ready for demo and retrospective.
```

---

## Force Approval

If user runs `/asaf-impl-approve --force`:

Skip validation checks, but document issues:

```
⚠️ Implementation approved with warnings

Issues noted:
  - [X] tasks incomplete
  - [Y] tests failing

These issues are documented in SUMMARY.md.

Consider addressing in a follow-up sprint.

Proceeding to demo phase...
```

---

## Error Handling

### Cannot Approve - Files Missing

```
🔴 ERROR: Cannot approve - missing files

Required files not found:
  - implementation/tasks.md
  - implementation/progress.md

The sprint may be incomplete or corrupted.

Options:
  /asaf-status     - Check sprint status
  /asaf-cancel     - Cancel sprint

Cannot approve without complete implementation data.
```

---

## Context to Include

- Full implementation results from progress.md
- Task completion status
- Test results
- Metrics calculations
- SUMMARY.md content

---

_Approval marks implementation complete and transitions to demo phase._
