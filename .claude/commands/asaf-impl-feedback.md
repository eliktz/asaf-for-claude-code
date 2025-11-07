# ASAF Implementation Feedback Command

**Command**: `/asaf-impl-feedback`

**Purpose**: Handle post-implementation changes with structured quality gates

**When to use**: After `/asaf-impl` completes and you have feedback, fixes, or improvements to apply

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

### Check Sprint State

Read `.state.json`:
- phase must be "implementation"
- OR phase must be "demo" (feedback after demo)
- OR phase must be "retro" (final feedback)

**If implementation not started**:
```
🔴 ERROR: Implementation not started

Current phase: [phase]

You must run /asaf-impl before collecting feedback.

Current sprint: [sprint-name]
Phase: [phase]

Options:
  /asaf-impl          - Start implementation
  /asaf-status        - Check sprint status
```
**STOP execution.**

**If implementation not complete yet**:
```
⚠️ WARNING: Implementation in progress

/asaf-impl is currently running (Task [X]/[N]).

You can still provide feedback, but it's recommended to wait until
implementation completes for a full review.

Continue with feedback now? (y/n)
```

---

## Opening Message

```
📝 Post-Implementation Feedback

Implementation is complete. Let's collect and apply any changes needed.

I'll help you:
1. Review the implementation systematically (optional)
2. Collect all feedback in one place
3. Apply changes with quality checks (executor → reviewer loop)
4. Update documentation

This ensures feedback changes maintain the same quality as /asaf-impl.

How would you like to provide feedback?

1. Interactive Review - I'll walk you through each task
   (Systematic, good for thorough review)

2. Bulk Feedback - You provide all feedback now
   (Fast, good if you've already reviewed)

3. Specific Changes - You have exact changes to make
   (Fastest, for expert users)

Enter choice [1-3]:
```

Wait for user selection.

---

## Mode 1: Interactive Review

### Step 1: Task-by-Task Review

```
Let's review the implementation task by task.

[Read implementation/tasks.md to get task list]
[Read implementation/progress.md to get completion status]

Total tasks: [N]
Completed: [X]
```

**For each completed task**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task [N]: [Task Name]

**Complexity**: [X] story points
**Status**: ✅ Complete
**Iterations**: [Y] (max: [Z])

**Files Modified**:
- [file1] ([lines changed])
- [file2] ([lines changed])

**Edge Cases Handled**:
[List from progress.md]

**Tests**:
✅ [X] tests passing
[If any failures]: ⚠️ [Y] tests failing

**Reviewer Notes** (from last iteration):
[Last reviewer feedback from progress.md]

---

Any feedback on this task?
(Type your comments, or press Enter to skip to next task)

You: [user input]
```

**Collect all feedback** before executing.

After reviewing all tasks:

```
Review complete!

Collected [N] feedback items across [X] tasks.

Ready to proceed with applying feedback? (y/n)
```

---

## Mode 2: Bulk Feedback

```
Please provide all your feedback (one item per line or paragraph):

Format suggestions:
- "Task 1: [feedback]"
- "[file.ts]: [feedback]"
- "[General]: [feedback]"

You can paste from your notes, GitHub comments, etc.

Enter your feedback (type 'done' on a new line when finished):
```

**Collect all input until user types "done".**

---

## Mode 3: Specific Changes

```
Please provide specific changes you want to make:

Format:
- "Fix [issue] in [file]"
- "Add [feature] to [component]"
- "Refactor [code] for [reason]"

You: [user provides list]
```

---

## Categorize Feedback

After collecting feedback (any mode):

```
Analyzing feedback...

[Parse each feedback item]
[Determine severity based on keywords: "bug", "broken", "error" = Bug]
[Determine severity based on keywords: "improve", "better", "refactor" = Improvement]
[Determine severity based on keywords: "add", "would be nice", "consider" = Enhancement]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Feedback Summary:

🔴 BUGS (must fix):
1. [Task X]: [Description]
2. [Task Y]: [Description]
Total: [N] bugs

🟡 IMPROVEMENTS (should fix):
1. [Task X]: [Description]
2. [Task Y]: [Description]
Total: [N] improvements

🟢 ENHANCEMENTS (nice to have):
1. [Task X]: [Description]
Total: [N] enhancements

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total feedback items: [N]

Which items should I address?

1. Fix all (bugs + improvements + enhancements)
2. Fix bugs and improvements only (skip enhancements)
3. Fix bugs only (critical issues)
4. Custom selection (I'll choose specific items)

Enter choice [1-4]:
```

Wait for user selection.

**If choice 4 (Custom)**:
```
Select items to fix (comma-separated numbers):
Example: 1,2,5,7

Available items:
[List all items with numbers]

Enter selection:
```

---

## Execute Feedback with Quality Gates

For each selected feedback item:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Feedback Item [N]/[Total]: [Description]

**Category**: [Bug/Improvement/Enhancement]
**Related Task**: Task [X]
**Files Affected**: [file list]

---

[EXECUTOR PHASE]

Adopting executor persona from implementation/decisions.md...

[Read relevant task from tasks.md]
[Read design from grooming/design.md]
[Read edge cases from grooming/edge-cases.md]

Analyzing feedback: "[feedback description]"

[Implement the change]

Changes made:
- [file1]: [description of change]
- [file2]: [description of change]

---

[TEST PHASE]

Running tests...

[Run test command based on tech stack]

Test results:
✅ [X] tests passing
[If new tests needed]: Added [Y] new tests for this change

---

[REVIEWER PHASE]

Adopting reviewer persona from implementation/decisions.md...

Quality checks:
✅ Aligns with design.md? [Yes/No - explanation]
✅ Edge case coverage maintained? [Yes/No - check against edge-cases.md]
✅ Test coverage sufficient? [Yes/No - percentage]
✅ Code quality standards met? [Yes/No]
✅ No breaking changes? [Yes/No]

[If any checks fail]
❌ ISSUES FOUND:
- [Issue 1]
- [Issue 2]

[Executor addresses issues]

[Re-run quality checks]

✅ All quality checks passed.

---

Feedback item [N] complete and approved.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Continue for all feedback items.**

---

## Update Documentation

After all feedback items processed:

```
All feedback items completed!

Updating documentation...

[Update implementation/progress.md]

Add new section:
```

### Feedback Iteration

**Started**: [timestamp]
**Total Items**: [N]

#### Feedback Item 1: [Description]
**Category**: [Bug/Improvement/Enhancement]
**Related Task**: Task [X]
**Status**: ✅ Complete

**Changes**:
- [file]: [change description]

**Tests**:
- [New test added]: [test name]
- [Tests updated]: [count]

**Reviewer Notes**:
✅ Aligns with design
✅ Edge case coverage maintained
✅ Test coverage: [percentage]

---

[Repeat for each feedback item]

---

**Feedback Summary**:
- Total items: [N]
- Bugs fixed: [X]
- Improvements made: [Y]
- Enhancements added: [Z]
- Files modified: [count]
- Tests added/updated: [count]

All tests passing: ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Update SUMMARY.md

Add feedback section:

```markdown
## 🔄 Feedback Iterations

**Round 1** (Completed [date]):
- Items addressed: [N] ([X] bugs, [Y] improvements, [Z] enhancements)
- Files modified: [count]
- Quality maintained: ✅

[See implementation/progress.md for details]
```

---

### Update .state.json

```json
{
  "sprint": "[sprint-name]",
  "phase": "[current-phase]",
  "status": "[current-status]",
  "feedback_rounds": [
    {
      "round": 1,
      "completed_at": "[timestamp]",
      "items_addressed": [N],
      "bugs": [X],
      "improvements": [Y],
      "enhancements": [Z]
    }
  ],
  "last_feedback_at": "[timestamp]"
}
```

---

## Success Message

```
✅ Feedback iteration complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Summary:

**Feedback Items Processed**: [N]
- 🔴 Bugs fixed: [X]
- 🟡 Improvements made: [Y]
- 🟢 Enhancements added: [Z]

**Changes Made**:
- Files modified: [count]
- Tests added: [count]
- Tests updated: [count]

**Quality**:
✅ All changes passed reviewer quality gates
✅ Edge case coverage maintained
✅ Test coverage: [percentage]
✅ All tests passing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Documentation Updated**:
- implementation/progress.md (feedback section added)
- SUMMARY.md (feedback round logged)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Next Steps**:

Have more feedback?
  /asaf-impl-feedback        - Run another feedback round

Ready for demo?
  /asaf-demo                 - Generate presentation

Sprint complete?
  /asaf-retro                - Run retrospective
```

---

## Multiple Feedback Rounds

Users can run `/asaf-impl-feedback` multiple times:

```
📝 Post-Implementation Feedback (Round 2)

Previous feedback rounds:
- Round 1 ([date]): [N] items addressed

This will be feedback round 2.

[Continue with normal flow]
```

Track in progress.md:

```markdown
### Feedback Iteration - Round 2

[Same structure as Round 1]
```

---

## Error Handling

### No Implementation to Provide Feedback On

```
🔴 ERROR: No implementation to provide feedback on

Current sprint: [sprint-name]
Phase: [phase]

Implementation hasn't been completed yet.

Options:
  /asaf-impl       - Start/continue implementation
  /asaf-status     - Check current status
```

---

### Test Failures During Feedback

If tests fail after applying feedback:

```
⚠️ WARNING: Tests failing after feedback change

Feedback item [N]: [Description]

Test failures:
- [test1]: [error]
- [test2]: [error]

The executor will attempt to fix these issues.

[Executor analyzes failures and fixes]

[Re-run tests]

[If still failing after 3 attempts]

🔴 BLOCKED: Cannot complete feedback item

Feedback item [N] could not be completed due to test failures.

Options:
1. Skip this item and continue with others
2. Stop feedback iteration (manual intervention needed)
3. Mark as incomplete and continue

Enter choice [1-3]:
```

---

### Reviewer Rejects Changes

If reviewer rejects feedback changes:

```
❌ REVIEW FAILED

Feedback item [N]: [Description]

Reviewer found issues:
- [Issue 1]
- [Issue 2]

The executor will address these issues.

[Executor iteration]

[Re-review]

[If fails again]

⚠️ WARNING: Feedback item requires multiple iterations

This feedback change is more complex than expected.

Continue iterating? (max 3 iterations per item) (y/n)
```

---

### No Feedback Provided

If user provides empty feedback:

```
No feedback provided.

It looks like you don't have any changes to make right now.

Implementation is complete and approved!

Options:
  /asaf-demo       - Generate demo presentation
  /asaf-retro      - Run retrospective when ready
```

---

## Design Notes

### Why This Command Exists

**Problem**: After `/asaf-impl`, users provide feedback in ad-hoc conversations. Changes are made without:
- Reviewer oversight
- Edge case validation
- Test updates
- Documentation

Result: Quality degrades.

**Solution**: Structured feedback with same rigor as implementation.

### Key Principles

1. **Quality Gates**: Every feedback change goes through executor → test → reviewer
2. **Documentation**: All feedback tracked in progress.md
3. **Categorization**: Bugs vs improvements vs enhancements (prioritization)
4. **Multiple Rounds**: Can run feedback multiple times
5. **Flexible Input**: Interactive review, bulk feedback, or specific changes

### Comparison to /asaf-impl

| Aspect | /asaf-impl | /asaf-impl-feedback |
|--------|-----------|---------------------|
| **Input** | tasks.md (planned) | User feedback (reactive) |
| **Scope** | All planned tasks | Specific changes |
| **Iterations** | Max per task | Max per feedback item |
| **Quality** | High (executor → reviewer) | High (same loop) |
| **Documentation** | progress.md | progress.md (feedback section) |

Both maintain ASAF quality standards.

---

## Future Enhancements (Not in v1)

- Auto-review: Claude suggests improvements proactively
- Feedback templates: Common feedback patterns (performance, error messages, etc.)
- Diff viewer: Show before/after for each change
- Undo: Rollback specific feedback changes
- Batch export: Export all feedback as GitHub issues

---

_This command ensures post-implementation quality matches implementation quality._
