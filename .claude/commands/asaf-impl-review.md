# ASAF Implementation Review Command

**Command**: `/asaf-impl-review`

**Purpose**: Review blocked task in detail and decide next steps

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
- status should be "blocked" (or can show current task if in-progress)

---

## Load Blocked Task Info

Read `progress.md` for the blocked/current task:
- Task name and description
- All iteration history
- Executor notes from each iteration
- Reviewer feedback from each iteration
- Test results
- Last error/issue

---

## Display Detailed Review

```
📋 Task Review: [Task Name] (Task [N]/[total])

Status: 🔴 BLOCKED after [X] iterations

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Task Description

[From tasks.md]

**Complexity**: [Low/Medium/High]
**Max Iterations**: [N]
**Files to Modify**: [list]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Iteration History

### Iteration 1
**Executor**:
[Summary of what was implemented]

**Test Results**:
✅ [X] passed, ❌ [Y] failed
Failed: [test names]

**Reviewer Feedback**:
⚠️ CHANGES REQUESTED
- [Issue 1]
- [Issue 2]

---

### Iteration 2
**Executor**:
[What was changed to address feedback]

**Test Results**:
✅ [X] passed, ❌ [Y] failed
Failed: [test names]

**Reviewer Feedback**:
⚠️ CHANGES REQUESTED
- [Issue 1]
- [Issue 2]

---

### Iteration 3
**Executor**:
[Final attempt]

**Test Results**:
✅ [X] passed, ❌ [Y] failed
Failed: [test names]

**Reviewer Feedback**:
⚠️ STILL NOT APPROVED
- [Remaining issues]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Analysis

**Pattern Detected**:
[If same issue repeated across iterations]
⚠️ Same issue across all iterations: "[issue]"
This suggests: [possible root cause]

[If different issues each time]
ℹ️ Different issues each iteration - making progress but not complete.

**Last Blocker**:
[Most recent issue from reviewer]

**Reviewer's Suggestion**:
[Last guidance provided]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Current Code State

**Files Modified**:
[List with last modified timestamps]

**Test Status**:
✅ [X] tests passing
❌ [Y] tests failing
  - [test name]: [error message]
  - [test name]: [error message]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Recommended Actions

[Based on analysis, suggest best path forward]

1. **Most Likely Solution**: [Specific action based on pattern]
   Command: [command to execute]

2. **Alternative**: [Another approach]
   Command: [command to execute]

3. **Investigation Needed**: [If unclear]
   Suggested steps: [manual investigation steps]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Your Options

1. **Give more attempts**:
   /asaf-impl-retry 2
   → Gives 2 more attempts (5 max total)

2. **Fix manually**:
   → Edit the code yourself
   → Run tests: [test command]
   → When ready: /asaf-impl-resume

3. **Skip this task**:
   /asaf-impl-skip task[N]
   → Mark as TODO, continue with other tasks

4. **Get more context**:
   /asaf-impl-view
   → View full progress.md

5. **Redesign approach**:
   → Reconsider technical approach
   → Update grooming docs if needed
   → Cancel and restart: /asaf-cancel

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What would you like to do?
```

---

## Pattern Analysis

### Detect Common Patterns

**Same Error Repeated**:
```
⚠️ Pattern: Same error in all [X] iterations

"[Error message]" appeared in iterations 1, 2, and 3.

This suggests:
- The executor may not understand the error
- The fix being attempted doesn't address root cause
- Missing dependency or configuration issue

Recommendation: Manual investigation needed.
```

**Progressive Improvement**:
```
ℹ️ Pattern: Making progress each iteration

Iteration 1: [Y] tests failing
Iteration 2: [Y-2] tests failing (improved)
Iteration 3: [Y-4] tests failing (improved)

This suggests: One or two more iterations might succeed.

Recommendation: /asaf-impl-retry 2
```

**Different Issues Each Time**:
```
⚠️ Pattern: New issues each iteration

Each iteration uncovered different problems.

This suggests:
- Complex task with multiple challenges
- May need fundamental redesign
- Or task is too large (should be split)

Recommendation: Consider manual implementation or task splitting.
```

---

## Specific Recommendations

Based on test failures:

**If "Module not found"**:
```
💡 Detected: Missing dependency

The error "[module] not found" suggests:
- Library not installed
- Import path incorrect

Action:
1. Install missing dependency: npm install [module]
2. Or fix import path in code
3. Then: /asaf-impl-resume
```

**If "Timeout"**:
```
💡 Detected: Test timeout

Tests timing out after [X] seconds.

Possible causes:
- Async operation not completing
- Infinite loop
- Missing mock/stub

Action:
1. Increase timeout in test config
2. Or fix async handling in code
3. Then: /asaf-impl-resume
```

**If "Type error"**:
```
💡 Detected: Type mismatch

TypeScript/type errors detected.

Action:
1. Review type definitions in [file]
2. Or add type assertions
3. Then: /asaf-impl-resume
```

---

## Display File Diffs

Show what changed in last iteration:

```
## Code Changes (Iteration [X])

**[filename]**:
```diff
- old code
+ new code
```

[Show key changes, not entire files]
```

---

## Error Handling

### No Blocked Task

```
ℹ️ No blocked task to review

Current implementation status: [status]

[If in-progress]
Implementation is running. Current task: Task [N]

[If complete]
All tasks completed successfully.

[If not started]
Implementation hasn't started yet.

Use /asaf-status to see overall progress.
```

---

## Context to Include

- Full task description
- All iteration history
- Test results
- Code changes
- Reviewer feedback
- Pattern analysis

---

_Review command helps understand blocking issues and choose best path forward._
