# ASAF Implementation Resume Command

**Command**: `/asaf-impl-resume`

**Purpose**: Resume implementation work on a paused task

**Category**: Implementation

**Agent**: Executor Agent 🔧

---

## When to Use

Run `/asaf-impl-resume` to:
- Continue work after `/asaf-impl-pause`
- Resume after blocker is resolved
- Pick up where you left off after interruption
- Return to paused implementation work

---

## Prerequisites

Check `.task-state.json`:
- Task must exist
- State must be "PAUSED"
- Pause checkpoint must exist

**Required Files**:
- `tasks/<task-name>/.task-state.json`
- `tasks/<task-name>/.pause-checkpoint.json`
- `tasks/<task-name>/.impl-notes.md` (optional)

If not paused:
```
❌ Error: Task not paused

Current state: [IMPLEMENTING/COMPLETED/etc]

[If already active]
Task is already in progress.
Use: /asaf-status <task-name>

[If completed]
Task is already complete.
Use: /asaf-demo <task-name>

[If in different state]
Task cannot be resumed from [state] state.
```

---

## Command Behavior

### 1. Load Pause Checkpoint

Read `.pause-checkpoint.json`:
```json
{
  "pausedAt": "2024-10-08T10:30:00Z",
  "pauseReason": "Waiting for API key from DevOps",
  "progress": {
    "percentComplete": 60,
    "phase": "Implementation",
    "completedSteps": [...],
    "inProgress": {
      "step": "Token generation",
      "percentComplete": 70,
      "currentWork": "JWT signing logic",
      "file": "src/auth/token-generator.ts",
      "line": 45
    },
    "remainingSteps": [...]
  },
  "blockers": [...],
  "codeState": {...}
}
```

### 2. Display Context Restoration

```
Loading paused task: feature-user-authentication

📋 PAUSE CHECKPOINT
Paused: 2024-10-08 10:30 AM (4 hours 15 minutes ago)
Reason: Waiting for API key from DevOps

📊 WORK IN PROGRESS
Phase: Implementation
Progress: 60% complete
Next Steps Remaining: 4

✅ COMPLETED
- Set up authentication middleware
- Created user model
- Implemented login endpoint

⏸️ IN PROGRESS (70% done)
- Token generation
  Working on: JWT signing logic
  File: src/auth/token-generator.ts:45

⏭️ NEXT STEPS
1. Complete JWT token generation
2. Add token refresh mechanism
3. Implement logout endpoint
4. Add rate limiting

🚧 BLOCKERS
- Waiting for API_SECRET env variable
  Status: Added to .env.example, pending DevOps
  
📝 RECENT NOTES
- 10:15 AM: Hit blocker: missing API_SECRET
- 09:30 AM: Implemented token structure
- 09:00 AM: Started token generation
```

### 3. Activate Executor Agent

```
🔧 EXECUTOR AGENT ACTIVATED

I've reviewed the pause checkpoint and understand:
✓ Current progress: 60% complete
✓ Active work: JWT token generation at 70%
✓ Next task: Complete JWT signing logic
✓ Blocker status: API_SECRET env variable

How would you like to proceed?
1. Continue where we left off (JWT signing)
2. Address the API_SECRET blocker first
3. Review completed work before continuing
4. Modify remaining next steps

Your choice:
```

### 4. Wait for User Input

User selects option 1-4 or provides custom instruction

### 5. Resume Implementation

Executor continues with selected approach, following all implementation rules from `asaf-impl.md`

---

## State Updates

Update `asaf-state.json`:
```json
{
  "currentTask": "feature-user-authentication",
  "tasks": {
    "feature-user-authentication": {
      "state": "IMPLEMENTING",
      "lastCommand": "/asaf-impl-resume",
      "lastUpdated": "2024-10-08T14:45:00Z",
      "pausedAt": null,
      "resumedAt": "2024-10-08T14:45:00Z"
    }
  }
}
```

Update `.task-state.json`:
```json
{
  "state": "IMPLEMENTING",
  "implementationStatus": {
    "pausedAt": null,
    "resumedAt": "2024-10-08T14:45:00Z",
    "pauseCount": 1,
    "totalPauseDuration": "4h 15m"
  }
}
```

---

## Intelligent Resume Features

### Blocker Status Check

If blocker may be resolved:
```
🎉 Good news! The blocker may be resolved:
- API_SECRET env variable
- Added to .env 30 minutes ago by DevOps

Would you like to:
1. Verify blocker is resolved and continue ✅
2. Mark blocker as resolved manually
3. Continue without verifying (I'll remind you)
```

### Stale Context Warning

If paused >24 hours:
```
⚠️ Heads up: Task paused for 5 days

Environment may have changed:
- 12 commits to main branch since pause
- 3 files modified in implementation area
- 1 new dependency added

Recommendation:
1. Pull latest: git pull origin main
2. Review for conflicts
3. Run tests before continuing

Proceed anyway? (y/n)
```

### Multiple Pause Pattern

If paused 3+ times:
```
📊 Pattern detected: Task paused 3 times
1. Oct 5 (2h) - Design approval
2. Oct 6 (6h) - API issue
3. Oct 8 (4h) - Current

💡 Consider:
- Breaking into smaller tasks?
- Address root causes?
- Use /asaf-express for simpler work?
```

---

## Error Handling

### Task Not Found
```
❌ Error: Task 'feature-user-authentication' not found

Available tasks:
  /asaf-list --all

Create new task:
  /asaf-init feature-user-authentication
```

### Missing Checkpoint
```
⚠️ Warning: Pause checkpoint not found

Attempting recovery from .task-state.json...

[If successful]
✓ Recovered basic context from task state
⚠️ Some detailed progress may be lost
Continue? (y/n)

[If failed]
❌ Cannot recover checkpoint
Recommendation: Start fresh with /asaf-impl
```

### Corrupted Checkpoint
```
❌ Error: Checkpoint corrupted

Cannot safely resume.

Options:
1. /asaf-impl - Start fresh (keeps approved plan)
2. Manual recovery - Review tasks/<task-name>/

Recommendation: Review completed work first
```

---

## Checkpoint Recovery Details

### What Gets Restored

**Work Progress**:
- Completed steps ✅
- In-progress items with exact status ⏸️
- Remaining next steps ⏭️
- Percentage complete 📊

**Code State**:
- Files modified
- Current file/line
- Uncommitted changes

**Context**:
- Pause reason
- Blocker status
- Implementation notes
- Decisions made

---

## Advanced Options

### Resume with Plan Modification
```
/asaf-impl-resume <task-name> --modify-plan
```
Review and adjust remaining steps before continuing

### Resume with Context Refresh
```
/asaf-impl-resume <task-name> --refresh-context
```
Re-analyze files and dependencies first

### Resume All Paused
```
/asaf-impl-resume --list-paused
```
Show all paused tasks and choose one

---

## Integration with Other Commands

**Works with**:
- `/asaf-impl-pause` - Creates checkpoint this restores
- `/asaf-status` - Check state before resume
- `/asaf-impl` - Alternative if checkpoint lost
- `/asaf-impl-review` - Review after completion

**Workflow**:
```
/asaf-impl          → Start
/asaf-impl-pause    → Pause with checkpoint
[interruption]
/asaf-impl-resume   → Restore and continue
/asaf-impl-review   → Review when done
```

---

## Best Practices

### When to Resume
✅ After short breaks (meetings, lunch)
✅ When blockers resolved
✅ Next day work
✅ After task switching
✅ Post-interruption

### When to Start Fresh
❌ Pause was weeks/months ago
❌ Requirements changed significantly
❌ Approach needs rethinking
❌ Checkpoint corrupted beyond repair

### Tips for Success
💡 **Quick resume**: Use for <1 day pauses
💡 **Review first**: Use `--review` for >1 day pauses
💡 **Check blockers**: Verify resolution before resuming
💡 **Update notes**: Document what happened during pause
💡 **Run tests**: If paused >1 day, test before continuing
💡 **Pull changes**: Check for upstream changes if paused long

---

## Real-World Examples

### Example 1: Lunch Break
```
Morning:
  /asaf-impl feature-auth
  [working...]
  /asaf-impl-pause

After Lunch:
  /asaf-impl-resume feature-auth
  → Quick restore, continue immediately
```

### Example 2: Overnight Work
```
Day 1 Evening:
  /asaf-impl-pause feature-payment

Day 2 Morning:
  /asaf-impl-resume feature-payment --review
  → Full context review, then proceed
```

### Example 3: Blocker Resolved
```
Monday:
  /asaf-impl api-integration
  [hit blocker]
  /asaf-impl-pause

Tuesday (blocker resolved):
  /asaf-impl-resume api-integration
  → Smart detection: "API_SECRET now available!"
  → Verify blocker, continue work
```

---

## Display After Resume

```
✅ Resuming: feature-user-authentication

📊 Progress: 60% complete
🔄 Restored from: 2024-10-08 10:30 AM
⏱️ Paused for: 4 hours 15 minutes

🔧 Executor Agent ready!

Next: Complete JWT token generation
File: src/auth/token-generator.ts:45

[Executor begins implementation following standard process]
```

---

_Resume command enables seamless return to paused work with full context restoration._
