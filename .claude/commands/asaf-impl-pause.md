# ASAF Implementation Pause Command

**Command**: `/asaf-impl-pause`

**Purpose**: Gracefully pause implementation to investigate or make manual changes

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

Check `.state.json`:
- phase must be "implementation"
- status must be "in-progress"

If not in progress:
```
ℹ️ Implementation not running

Current status: [status]

[If complete]
Implementation already complete.

[If not started]
Implementation hasn't started yet. Run: /asaf-impl

[If blocked]
Implementation is already paused due to blocking issue.
Use: /asaf-impl-review
```

---

## Pause Implementation

### Save Current State

Update `.state.json`:
```json
{
  "phase": "implementation",
  "status": "paused",
  "paused_at": "[timestamp]",
  "current_task": [N],
  "current_iteration": [X],
  "pause_reason": "manual"
}
```

### Add Pause Note to progress.md

```markdown
---
**⏸️  Implementation Paused**

Paused at: [timestamp]
Current task: Task [N] - [Name]
Current iteration: [X]/[max]
Reason: Manual pause by user

Resume with: /asaf-impl-resume
---
```

---

## Display Message

```
⏸️ Implementation paused

Current state:
  - Task [N]/[total]: [Task Name]
  - Iteration: [X]/[max]
  - Status: [Executor completed / Waiting for review / etc.]

Progress saved to:
  asaf/[sprint]/implementation/progress.md
  asaf/[sprint]/.state.json

You can now:
  - Investigate the issue manually
  - Make code changes
  - Review progress.md for details
  - Run tests manually: [test command]

When ready to resume:
  /asaf-impl-resume

Or:
  /asaf-impl-review  - Review current task in detail
  /asaf-status       - Check overall status
  /asaf-cancel       - Cancel sprint
```

---

## What Happens After Pause

- All progress is saved
- Current task state preserved
- No data loss
- Can resume anytime
- Can make manual changes
- Can investigate issues

---

## Use Cases

**When to pause**:
- Need to investigate a failing test
- Want to try a different approach manually
- Context switch (meeting, break, etc.)
- Review implementation before continuing
- Check something in the codebase
- Discuss approach with team

**Resume when**:
- Investigation complete
- Manual changes made
- Ready to continue
- Issues resolved

---

_Pause allows flexible workflow without losing progress._
