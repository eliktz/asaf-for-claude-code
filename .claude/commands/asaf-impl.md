# ASAF Implementation Command

**Command**: `/asaf-impl`

**Purpose**: Execute all tasks using executor and reviewer agents

**Duration**: 3-6 hours (mostly autonomous)

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
- grooming_approved must be true
- planning_complete must be true
- phase must be "implementation"

If not:
```
🔴 ERROR: Cannot start implementation

Current state: [phase] - [status]

Requirements:
- Grooming must be approved
- Task planning must be complete

[If grooming not approved]
Run: /asaf-groom-approve

[If wrong phase]
This sprint is in [phase] phase.
Current status: [status]
```
**STOP execution.**

---

## Load Context

Read:
1. **Tasks**: `implementation/tasks.md` (what to implement)
2. **Progress**: `implementation/progress.md` (current state)
3. **Grooming docs**: All files from `grooming/` (design reference)
4. **Decisions**: `grooming/decisions.md` - Extract:
   - **Executor Sub-Agent**: Exact agent name to invoke
   - **Reviewer Sub-Agent**: Exact agent name to invoke
   - **Reviewer Mode**: Mode to use during review
   - **Max Iterations**: Per-task limit
   - **Validation Config**: Build command, test command, type check command

---

## Pre-Flight Validation (REQUIRED)

**Before starting any task, verify the codebase baseline is healthy:**

1. **Read validation commands** from `grooming/decisions.md`

2. **Run pre-flight checks**:
   ```
   🔍 Running pre-flight validation...

   Build:  [build_command]
   Tests:  [test_command]
   ```

3. **Evaluate results**:

   **If all pass** ✅:
   ```
   ✅ Pre-flight validation passed

   Baseline is green:
   - Build: ✅ Success
   - Tests: ✅ [N] tests passing

   Starting implementation...
   ```
   Proceed to Update State.

   **If any fail** ❌:
   ```
   🔴 Pre-flight validation FAILED

   Baseline is NOT green:
   - Build: [✅/❌] [status]
   - Tests: [✅/❌] [N] passing, [M] failing

   [Error output if failed]
   ```

   **USE AskUserQuestion:**
   ```yaml
   AskUserQuestion:
     questions:
       - question: "Pre-flight validation failed. How should we proceed?"
         header: "Action"
         multiSelect: false
         options:
           - label: "Fix baseline first"
             description: "I'll fix these issues before we start"
           - label: "Proceed anyway"
             description: "These failures are known/expected"
           - label: "Skip validation"
             description: "Don't run validation for this sprint"
   ```

   - **If "Fix baseline first"**: STOP and wait for user to fix
   - **If "Proceed anyway"**: Document known failures and continue
   - **If "Skip validation"**: Set `skip_validation: true` in state and continue

---

## Update State

```json
{
  "phase": "implementation",
  "status": "in-progress",
  "implementation_started_at": "[timestamp]",
  "current_task": 1
}
```

---

## Opening Message

```
🚀 Starting implementation: [sprint-name]

📋 Tasks: [N] total
⏱️  Estimated time: [hours]

Configuration:
  - Executor: [profile-name]
  - Reviewer: [mode]
  - Max iterations: [N] per task

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Implementation will run autonomously. You can:
  - Monitor progress in real-time (updates shown below)
  - Check status anytime: /asaf-status
  - Pause if needed: /asaf-impl-pause

Starting Task 1/[N]...
```

---

## Implementation Loop

**CRITICAL: Use Task tool to delegate to sub-agents. DO NOT implement code yourself.**

For each task in `tasks.md`:

### Check if Task Already Complete

Read `progress.md`:
- If task status is "Complete", skip to next task
- If task status is "Blocked", show error and stop
- Otherwise, proceed with implementation

---

### Task Header

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task [N]/[total]: [Task Name]
├─ Complexity: [Low/Medium/High]
├─ Max iterations: [N]
└─ Pattern: executor → test → reviewer → executor

```

---

### Iteration Loop

Set `iteration = 0`
Set `max_iterations` from task definition

While `iteration < max_iterations`:

#### Step 1: Launch Executor Sub-Agent

Use Task tool with subagent_type="[executor-agent-name from grooming/decisions.md - e.g., asaf-typescript-executor, asaf-python-executor, or custom agent]"
- description: "Implementing Task [N]: [Task Name]"
- prompt: "You are the [executor-agent-name] implementing this ASAF task. Read your complete persona and workflow from your agent file (which references `.claude/commands/shared/executor-agent.md` for core behavior). Implement this task: [full task description from tasks.md]. Design context in grooming/design.md, grooming/edge-cases.md, grooming/decisions.md. [If iteration > 1: Previous reviewer feedback from progress.md: {feedback}]. Implement code following design.md, handle edge cases, write comprehensive tests (happy path + edge cases + errors, >80% coverage), run tests, update progress.md with implementation summary, files modified, edge cases addressed, test results, and notes for reviewer. Return: files changed, test summary, implementation notes."

Wait for executor sub-agent to complete. The Task tool will run autonomously.

After completion, show summary:
- Files changed
- Edge cases handled
- Test results

Then proceed to reviewer.

---

#### Step 2: Launch Reviewer Sub-Agent

Use Task tool with subagent_type="[reviewer-agent-name from grooming/decisions.md - e.g., asaf-code-reviewer or custom agent]"
- description: "Reviewing Task [N]: [Task Name]"
- prompt: "You are the [reviewer-agent-name] in [reviewer-mode from grooming/decisions.md] mode. Read your complete persona and review methodology from your agent file (which references `.claude/commands/shared/reviewer-agent.md` for core behavior).

TASK TO REVIEW: [full task description from tasks.md]

READ THESE FILES:
- grooming/design.md (what should be implemented)
- grooming/edge-cases.md (edge cases that MUST be handled)
- grooming/acceptance-criteria.md (success criteria)
- grooming/decisions.md (code standards)
- implementation/progress.md (executor's implementation, files modified, test results)
- [All modified files to review actual code]

REVIEW CHECKLIST:
1. Design compliance - does implementation match design.md?
2. Edge case coverage - are ALL relevant edge cases from edge-cases.md handled?
3. Code quality - clean, readable, maintainable? Follows standards from decisions.md?
4. Test coverage - comprehensive tests? All passing?
5. TypeScript quality - no excessive 'any' types (max 2), proper typing?

DECISION CRITERIA:
REQUEST CHANGES if ANY of these:
- Tests failing
- Security vulnerabilities
- Violates design.md architecture
- Missing required edge cases from edge-cases.md
- Excessive TypeScript 'any' types (>2 occurrences)
- Poor error handling or code quality issues
- Not following code standards from decisions.md

APPROVE if ALL of these:
- All tests passing
- Design compliance verified
- All edge cases handled
- Code quality acceptable
- Minor issues only (document as suggestions)

UPDATE progress.md with this EXACT format:

### Reviewer Notes
**Decision**: [APPROVED or CHANGES REQUESTED]
**Reviewed**: [timestamp]
**Reviewer**: ASAF ([mode] Mode)

[IF APPROVED:]
**What Went Well**:
- [Specific positive points - at least 2]

**Code Quality**:
- Design compliance: ✅ or ⚠️
- Edge cases: ✅ or ⚠️
- TypeScript quality: ✅ or ⚠️
- Tests: ✅ or ⚠️

**Minor Suggestions** (non-blocking):
- [Improvements for future - if any]

**Verdict**: Task complete, ready for next task.

[IF CHANGES REQUESTED:]
**Blocking Issues**:
1. **[Category]**: [Specific issue]
   - Problem: [What's wrong]
   - Fix: [Specific action needed]
   - Reference: [Edge case #N or design section]

**What's Working**:
- [Acknowledge good parts]

**Next Steps**:
- [Clear guidance for executor]

RETURN to main context: Your decision (APPROVED or CHANGES_REQUESTED) and brief summary."

Wait for reviewer sub-agent to complete. The Task tool will run autonomously.

After completion, check decision from progress.md:

**If APPROVED**:
- Show: `✅ Reviewer: APPROVED - Task [N] complete!`
- Mark task complete
- Move to next task

**If CHANGES REQUESTED and iteration < max**:
- Show: `⚠️ Reviewer: Changes requested - Starting iteration [iteration+1]`
- Increment iteration
- Loop back to Step 1 with feedback

**If CHANGES REQUESTED and iteration == max**:
- Show: `🔴 Task blocked after [max] iterations`
- Update .state.json: status = "blocked"
- Update progress.md: task status = "BLOCKED"
- Show options: /asaf-impl-review, /asaf-impl-retry, manual fix, skip
- STOP execution, wait for user

---

### After Task Complete

Update state:
```json
{
  "current_task": [N+1],
  "completed_tasks": [list of completed task numbers]
}
```

Update SUMMARY.md with progress.

Move to next task.

---

## Final Validation Gate (REQUIRED)

**Before marking implementation complete, run final validation:**

```
🔍 Running final validation...

Build:      [build_command]     [running...]
Tests:      [test_command]      [running...]
Type Check: [type_check]        [running...]
```

**Results:**
```
✅ Final Validation Results

- Build:      ✅ Passed
- Tests:      ✅ [N] passing, 0 failing
- Type Check: ✅ No errors

All Technical Acceptance Criteria met:
- ✅ TAC1: Build Passes
- ✅ TAC2: All Tests Pass
- ✅ TAC3: New Tests Added ([N] new tests)
- ✅ TAC4: No Type Errors
- ✅ TAC5: No Regressions
```

**If any validation fails:**
```
🔴 Final Validation FAILED

- Build:      [✅/❌]
- Tests:      [✅/❌] [N] passing, [M] failing
- Type Check: [✅/❌] [N] errors

Failing checks:
- [details]

Cannot mark implementation complete until all validations pass.
```

Return to executor to fix the issues before completing.

---

## Completion

When all tasks complete AND final validation passes:

### Update State

```json
{
  "phase": "implementation",
  "status": "complete",
  "implementation_complete": true,
  "implementation_completed_at": "[timestamp]",
  "total_iterations": [count],
  "total_tasks": [N],
  "completed_tasks": [N]
}
```

---

### Calculate Metrics

From `progress.md`:
- Total tasks: [N]
- Completed: [N]
- Total iterations: [sum across all tasks]
- Average iterations per task: [total / tasks]
- Tests written: [count]
- Tests passing: [count]
- Time elapsed: [start to finish]

---

### Update SUMMARY.md

Add implementation results:

```markdown
## 📊 Implementation Results

**Completed**: [date/time]
**Duration**: [hours/minutes]

### Tasks
- **Total**: [N]
- **Completed**: [N] (100%)
- **Iterations**: [X] total (avg [Y] per task)

### Task Breakdown
1. Task 1: [Name] ✅ (1 iteration)
2. Task 2: [Name] ✅ (2 iterations)
...

### Quality Metrics
- **Tests Written**: [X]
- **Tests Passing**: [X] (100%)
- **Code Coverage**: [%]% (if available)

### Files Changed
**Created** ([N] files):
- path/to/file - [purpose]

**Modified** ([N] files):
- path/to/file - [changes]

[See implementation/progress.md for full details]

---

## 📊 Sprint Progress

- [x] Initialization
- [x] Grooming
- [x] Planning
- [x] Implementation ← _Just completed_
- [ ] Demo
- [ ] Retrospective

---

_Updated after implementation on [date]_
```

---

### Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Implementation complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Final Results:

**Duration**: [hours minutes]

**Tasks**: [N]/[N] completed (100%)
**Iterations**: [X] total (avg [Y] per task)
  - [N] tasks completed in 1 iteration
  - [N] tasks required 2 iterations
  - [N] tasks required 3 iterations

**Tests**: [X] written, [X] passing (100%)

**Files Changed**: [N] created, [N] modified

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Details:
   Full implementation log: asaf/[sprint]/implementation/progress.md
   Summary: asaf/[sprint]/SUMMARY.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:
  /asaf-impl-approve   - Approve and move to demo
  /asaf-impl-view      - Review implementation details
  /asaf-summary        - View full sprint summary

Great work! The implementation is ready for demo and retrospective.
```

---

## Error Handling

### Task Blocked After Max Iterations

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Task [N] blocked after [max] iterations

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task: [Task Name]
Status: 🔴 BLOCKED

Iteration History:
  1. ❌ [Brief issue description]
  2. ❌ [Brief issue description]
  3. ❌ [Brief issue description]

Last Error:
  [Most recent issue from reviewer]

Reviewer's Final Suggestion:
  [Last reviewer feedback]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏸️  Implementation paused automatically.

This task needs human intervention.

Action needed:
  /asaf-impl-review     - See full details and decide

Options:
  1. /asaf-impl-retry 2    - Give 2 more attempts (5 max total)
  2. Fix manually, then:
     /asaf-impl-resume     - Continue with remaining tasks
  3. /asaf-impl-skip task[N] - Skip and mark as TODO

What would you like to do?
```

**Wait for user command. Do not proceed to next task automatically.**

---

### Test Framework Crash

```
🔴 CRITICAL: Test execution failed

Task: [Task Name]
Phase: Running tests

Error: [System error - e.g., "Jest process crashed"]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Progress saved to: implementation/progress.md

What happened:
  - Executor completed implementation
  - Tests were written
  - Test framework crashed during execution

This prevents verification of the implementation.

Options:
  1. Check test framework setup
  2. Run tests manually: [test command]
  3. /asaf-impl-skip-tests [task] - Continue without tests (not recommended)
  4. /asaf-impl-pause - Pause and investigate

Cannot proceed without working tests.
```

**STOP execution. Wait for user to fix.**

---

### File Write Error

```
🔴 CRITICAL: Cannot write file

Task: [Task Name]
File: [path]

Error: [System error - e.g., "EACCES: permission denied"]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Code was generated but couldn't be saved.

Temporary location: asaf/[sprint]/.temp/[filename]
(You can manually move this file)

Troubleshooting:
  1. Check file permissions: ls -la [directory]
  2. Check if file is open in editor
  3. Check disk space: df -h

Fix the issue, then:
  /asaf-impl-resume

Cannot proceed without write access.
```

**STOP execution. Wait for user to fix.**

---

### Infinite Loop Detection

```
🟡 WARNING: Possible infinite loop detected

Task: [Task Name]
Pattern: Last 3 iterations all attempted the same fix

Iterations [X-2] to [X]:
  All tried: "[same approach]"

This suggests the executor is stuck.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏸️  Auto-pausing to prevent wasted iterations.

The agent may be:
  - Misunderstanding the error
  - Missing context about the codebase
  - Hitting a tool/library limitation

Manual intervention recommended:
  /asaf-impl-review  - See full iteration history
```

**STOP execution. Escalate to user.**

---

### Context Window Warning

If context approaching limits during implementation:

```
🟡 WARNING: Context window filling up

Current: [X]K tokens (75% of limit)

To preserve progress:
  - Summarizing old iterations
  - Archiving detailed logs
  - Continuing with compressed context

All details preserved in progress.md
```

**Continue but with summarized context.**

---

## Progress Updates

During execution, show periodic updates:

```
[After each task completes]

✅ Task [N]/[total] complete

Progress: [N]/[total] tasks ([%]%)
Time elapsed: [duration]
Estimated remaining: [estimate based on avg]

[Every 30 minutes if no task completion]

⏳ Still working on Task [N]...
   Current: [Executor implementing / Reviewer analyzing / etc.]
   Time on this task: [duration]
```

---

## State Management

### Save State Frequently

After each significant event:
- Task starts: Update current_task
- Task completes: Update completed_tasks
- Iteration completes: Update progress.md
- Block occurs: Update status to "blocked"

This allows `/asaf-impl-pause` and `/asaf-impl-resume` to work cleanly.

---

### Checkpoint Format

In `.state.json`:
```json
{
  "sprint": "sprint-name",
  "phase": "implementation",
  "status": "in-progress",
  "current_task": 3,
  "total_tasks": 5,
  "completed_tasks": [1, 2],
  "current_iteration": 2,
  "implementation_started_at": "2025-10-05T14:00:00Z",
  "last_updated": "2025-10-05T16:30:00Z"
}
```

---

## Context to Include

Throughout implementation:
- Current task from tasks.md
- Grooming documents (design, edge cases, criteria)
- Previous iterations from progress.md
- Code being modified
- Test output
- Executor profile and reviewer mode

---

## Design Notes

### Why Autonomous?

- Developer can step away (hours of work)
- Consistent execution (no forgetting steps)
- Automatic documentation (progress.md updated)
- Quality gates built-in (review cycles)

### Why Max 3 Iterations?

- Prevents infinite loops
- Forces escalation to human for complex issues
- 3 attempts usually sufficient for most issues
- Can be increased per-task or via retry command

### Why Show Progress?

- Developer confidence (seeing it work)
- Allows monitoring (check status anytime)
- Helps with estimation (track velocity)
- Identifies patterns (which tasks harder?)

### Why Auto-Pause on Block?

- Prevents wasting iterations
- Gets human help when needed
- Preserves all progress
- Clear escalation path

---

_Implementation command is the engine of ASAF - autonomous execution with quality gates._
