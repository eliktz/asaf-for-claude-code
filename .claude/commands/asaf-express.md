# ASAF Express Command

**Command**: `/asaf-express "<requirements>"` or `/asaf-express @file.md`

**Purpose**: Lightweight workflow for quick tasks (<2 hours)

---

## Usage

```bash
# Inline requirements
/asaf-express "Add email field to user registration with validation"

# From file
/asaf-express @specs/add-email.md

# Auto mode (no confirmation, trivial tasks only)
/asaf-express --auto "Fix typo in login button text"
```

---

## Step 1: Quick Analysis (2 min)

### Scan Codebase

- Detect tech stack (package.json, requirements.txt, etc.)
- Identify relevant files
- Find similar patterns
- Check for existing utilities

### Analyze Requirements

Break down into 2-5 simple tasks:
- What needs to be done
- Which files to modify
- Edge cases to handle
- Tests needed

### Estimate Complexity

**Indicators**:
- Task count: > 5 = complex
- Files to change: > 8 = complex
- Time estimate: > 3 hours = complex
- Security-sensitive: complex
- Architectural changes: complex
- External APIs: complex

---

## Step 2: Complexity Check

**If too complex**:

```
⚠️ Complexity Assessment

This task seems complex for Express mode.

Detected:
  - [X] tasks identified (threshold: 5)
  - Security-sensitive (OAuth tokens)
  - [X] edge cases (threshold: 8)
  - Estimated: [X] hours (threshold: 3)

Recommendation: Use Full ASAF workflow

Benefits of Full ASAF for this task:
✓ Collaborative security design
✓ Comprehensive edge case analysis
✓ Learning opportunity
✓ Better documentation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Options:
  f → Upgrade to Full ASAF (recommended)
  y → Continue with Express anyway
  n → Cancel

Your choice:
```

**If user chooses 'f'**:
```
✅ Upgrading to Full ASAF workflow...

Created: asaf/[name]/
  - initial.md (from Express requirements)
  - SUMMARY.md (initialized)

This task is now a full sprint.

Next: /asaf-groom
```
**STOP Express, switch to Full.**

**If user chooses 'n'**: Cancel.

**If user chooses 'y'**: Continue with Express (not recommended).

---

## Step 3: Show Plan & Confirm

**If complexity is acceptable (Low/Medium)**:

```
🚀 ASAF Express: Quick Implementation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Understanding:
[Paraphrase requirements in 1-2 sentences]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Implementation Plan

**Tasks** ([N] total, ~[X] hours):

1. **[Task Name]** (Low complexity)
   - Files: `path/to/file1`, `path/to/file2`
   - Edge cases: [count]
   - Tests: [count]
   - DoD: [key requirement]

2. **[Task Name]** (Low complexity)
   - Files: `path/to/file`
   - Edge cases: [count]
   - Tests: [count]
   - DoD: [key requirement]

[Repeat for all tasks]

**Configuration**:
  - Stack: [Detected stack]
  - Executor: [profile-name]
  - Reviewer: Quick Review (functional focus)
  - Max iterations: 2 per task

**Estimated Time**: ~[X] hours

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ This plan looks correct?
▶️ Proceed with implementation?

Options:
  y / Enter  → Proceed with Express
  n          → Cancel
  f          → Upgrade to Full ASAF

Your choice:
```

---

## Step 4: If Approved, Execute

**CRITICAL: Use Task tool to delegate to sub-agents. DO NOT implement code yourself.**

### Step 4.1: Create Sprint Structure

Create these files:

```
asaf/express/[name]/
├── SUMMARY.md          # Lightweight summary
├── .state.json         # Sprint state
├── requirements.md     # What was requested
├── plan.md             # Task breakdown
└── implementation/
    └── progress.md     # Execution log
```

**requirements.md**:
```markdown
# Express Sprint: [Name]

## Requirements
[User's requirements]

## Context
[Detected from analysis]

Type: Express Sprint (lightweight)
Created: [timestamp]
```

**plan.md**:
```markdown
# Implementation Plan: [Name]

## Tasks
[Task breakdown from analysis]

## Configuration
- Executor: [profile]
- Reviewer: Quick Review
- Max iterations: 2

Estimated: [hours]
```

**.state.json**:
```json
{
  "sprint": "[name]",
  "type": "express",
  "phase": "implementation",
  "status": "in-progress",
  "created": "[timestamp]"
}
```

---

### Step 4.2: Execute Implementation with Sub-Agents

Show message to user:
```
🚀 ASAF Express: Executing...
```

**For each task in plan.md:**

Set iteration = 1, max_iterations = 2

While iteration <= max_iterations:

**1. Executor Sub-Agent**

Use Task tool with subagent_type="general-purpose"
- description: "Implementing Express Task [N]: [Task Name]"
- prompt: "You are the ASAF Executor Agent with profile [executor-profile from plan.md]. Read your persona from `.claude/commands/shared/executor-agent.md`. Implement this quick task: [task description from plan.md]. Files to modify: [files list]. Edge cases: [edge cases from plan]. Implement code, write focused tests (key scenarios only), run tests, update progress.md with summary, files modified, test results. Return: files changed, test summary, notes."

Show: `Task [N]/[total]: [Task Name] - ⏳ Executor implementing...`
Wait for executor sub-agent to complete.
Show: `✅ Executor completed - Files: [count], Tests: [passed]/[total]`

**2. Reviewer Sub-Agent (Quick Review Mode)**

Use Task tool with subagent_type="general-purpose"
- description: "Quick Review of Express Task [N]: [Task Name]"
- prompt: "You are the ASAF Reviewer Agent in Quick Review mode. Read your persona from `.claude/commands/shared/reviewer-agent.md`.

TASK TO REVIEW: [task description from plan.md]

READ:
- plan.md (what was expected)
- implementation/progress.md (executor's implementation, files, tests)
- [All modified files to review code]

QUICK REVIEW CHECKLIST:
1. Does it work? (basic functionality)
2. Tests passing? (all tests green)
3. Basic quality OK? (readable, no obvious issues)
4. TypeScript: Reasonable typing (not excessive 'any')

DECISION CRITERIA (Quick Review - functional focus):
REQUEST CHANGES only if ANY of these CRITICAL issues:
- Tests failing
- Doesn't work (basic functionality broken)
- Security vulnerability
- Excessive TypeScript 'any' (>3 occurrences)

APPROVE if:
- Tests passing
- Basic functionality works
- Reasonable code quality
- Minor issues acceptable (document as suggestions)

UPDATE progress.md with this format:

### Reviewer Notes (Quick Review)
**Decision**: [APPROVED or CHANGES REQUESTED]
**Reviewed**: [timestamp]
**Reviewer**: ASAF (Quick Review Mode)

[IF APPROVED:]
**Functional Check**: ✅
**Tests**: ✅ [X] passing
**Code Quality**: ✅ or ⚠️ (with brief note)

**Quick Suggestions** (non-blocking):
- [Any improvements for future - if any]

**Verdict**: Task complete.

[IF CHANGES REQUESTED:]
**Critical Issues**:
1. [Specific blocking issue]
   - Fix: [Action needed]

**Next Steps**: [Clear guidance]

RETURN: Your decision and brief summary."

Show: `⏳ Reviewer checking...`
Wait for reviewer sub-agent to complete.

**3. Handle Review Decision**

If APPROVED:
  Show: `✅ Reviewer: APPROVED - Task [N] complete! ([iteration] iteration[s])`
  Break iteration loop, move to next task

If CHANGES_REQUESTED and iteration < 2:
  Show: `⚠️ Reviewer: Changes requested - Starting iteration [iteration+1]`
  iteration++
  Continue loop with feedback

If CHANGES_REQUESTED and iteration == 2:
  Show: `🔴 Task blocked after 2 iterations - Recommendation: /asaf-express-upgrade`
  Offer upgrade to Full ASAF or manual intervention

---

## Step 5: Completion

### Update SUMMARY.md

```markdown
# Express Sprint: [Name]

**Type**: ASAF Express (Lightweight)
**Status**: ✅ Complete
**Duration**: [minutes/hours]
**Date**: [timestamp]

---

## Requirements

"[Original requirements]"

**Context**: [Brief context]

---

## What Was Built

[Brief description of implementation]

**Changes**:
- [File 1] - [what changed]
- [File 2] - [what changed]

**Tests**: [X] written, [X] passing

---

## Results

**Tasks**: [N]/[N] completed (100%)
**Iterations**: [X] total (avg [Y])
**Time**: [duration]

**Files Changed**: [N] modified

---

## Next Steps

[If any follow-up needed]
- [Suggestion 1]
- [Suggestion 2]

---

_Generated by ASAF Express • Quick mode for daily tasks_
```

---

### Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Express sprint complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏱️  Duration: [minutes/hours]

**Tasks**: [N]/[N] completed
**Iterations**: [X] total (avg [Y])
**Tests**: [X] written, [X] passing

**Files Changed**:
  - [file1]
  - [file2]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Summary: asaf/express/[name]/SUMMARY.md

Quick and efficient! ⚡
```

---

## Auto Mode

If `--auto` flag used:

### Skip Confirmation

Only if complexity is **trivial**:
- 1-2 tasks
- <30 min estimate
- No security concerns
- No architectural changes

If trivial:
```
🚀 ASAF Express Auto Mode

Requirement: "[requirements]"

⏳ Analyzing... (complexity: Trivial)

✅ Auto-approved for immediate execution

[Execute immediately without confirmation]
```

If not trivial:
```
⚠️ Cannot auto-execute: Task is not trivial

Complexity: [Medium/High]
Reasons:
  - [Reason 1]
  - [Reason 2]

Auto mode is designed for trivial tasks only (typos, simple changes).

Recommendation:
  /asaf-express "[requirements]"  (with confirmation)
  /asaf-init [name]               (full workflow)
```
**STOP execution.**

---

## Error Handling

### Task Blocked (2 iterations)

In Express mode, block after just 2 iterations:

```
⚠️ Task [N] blocked after 2 iterations

Express mode uses faster iteration limits.

Last issue: [description]

Options:
  1. /asaf-express-upgrade  - Convert to Full ASAF
  2. Fix manually and retry
  3. Skip task

Recommendation: For complex issues, upgrade to Full ASAF.
```

---

## Upgrade to Full ASAF

If user runs `/asaf-express-upgrade` during Express sprint:

```
📤 Upgrading Express sprint to Full ASAF...

Current Express sprint: [name]

Creating Full ASAF sprint...

✅ Created: asaf/[name]/
   - initial.md (imported from Express)
   - SUMMARY.md (initialized)

Importing completed work:
   ✓ Task [N] results → implementation/progress.md

Original Express sprint archived to:
   asaf/express/.archived/[name]/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is now a full sprint with comprehensive workflow.

Next steps:
  /asaf-groom  - Complete design (for remaining work)
  /asaf-impl   - Continue implementation

Progress preserved from Express sprint.
```

---

## Context to Include

- Requirements
- Codebase scan results
- Complexity analysis
- Task breakdown
- Quick execution mode

---

_Express mode for daily productivity without ceremony._
