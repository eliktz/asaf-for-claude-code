# Acceptance Criteria: Sprint Selection State Management

## AC1: Auto-selection on First Use

**User Story**: As a developer with existing sprints, I want automatic selection of the most recent sprint when no selection exists, so I don't have to manually configure on first use.

**Acceptance Test**:
```gherkin
Given no /asaf/.current-sprint.json exists
  And one or more valid sprints exist in /asaf/
When any command requiring sprint context runs (e.g., /asaf-groom, /asaf-status)
Then the most recently modified sprint is auto-selected
  And /asaf/.current-sprint.json is created with correct format
  And log message shows "Auto-selected sprint '<name>' (most recently modified)"
  And command continues execution normally
```

**Edge Cases Covered**:
- ✅ Edge case #13: First command after upgrade (backward compatibility)
- ✅ Edge case #7: Multiple sprints with identical modification times (alphabetical tiebreaker)

**Definition of Done**:
- [ ] Auto-selection algorithm implemented in asaf-core.md
- [ ] All sprint-context commands call auto-selection when needed
- [ ] Selection file created with correct JSON format and timestamp
- [ ] Manual verification: Delete selection file, run any command, verify auto-selection

---

## AC2: Explicit Selection

**User Story**: As a developer, I want to explicitly select which sprint I'm working on, so that ASAF commands always operate on the correct sprint context.

**Acceptance Test**:
```gherkin
Given multiple valid sprints exist
When user runs /asaf-select <sprint-name>
Then that sprint becomes active
  And /asaf/.current-sprint.json is updated with sprint name and timestamp
  And confirmation message displayed: "✓ Switched to sprint '<name>'"
  And selection persists (next command uses selected sprint)
```

**Edge Cases Covered**:
- ✅ Edge case #3: Manually edited with invalid sprint name (validation catches it)
- ✅ Edge case #9: User typo in sprint name (fuzzy matching suggests corrections)
- ✅ Edge case #11: User enters path instead of name (strips path, uses name)

**Definition of Done**:
- [ ] /asaf-select command created
- [ ] Sprint name validation implemented
- [ ] Selection file updated atomically
- [ ] Manual verification: Select sprint A, run command, verify operates on A; select sprint B, verify switch

---

## AC3: Interactive Selection

**User Story**: As a developer, I want to see available sprints and choose interactively, so I can easily switch context when I don't remember exact sprint names.

**Acceptance Test**:
```gherkin
Given multiple valid sprints exist
When user runs /asaf-select (no arguments)
Then list of sprints shown with:
  - Current sprint highlighted/marked
  - Sprint type (full/express) displayed
  - Sprint phase/status shown
  And user can choose from numbered list
  And selection updates based on choice
  Or if only 1 sprint exists, display it as current (no choice needed)
```

**Edge Cases Covered**:
- ✅ Edge case #12: User cancels interactive selection (selection unchanged)
- ✅ Edge case #10: User enters empty/whitespace (falls back to interactive mode)

**Definition of Done**:
- [ ] Interactive mode implemented in /asaf-select
- [ ] Sprint list formatted clearly with highlighting
- [ ] Single-sprint case handled (just display, no prompt)
- [ ] Manual verification: Run /asaf-select, see list, choose different sprint, verify update

---

## AC4: Stale State Recovery

**User Story**: As a developer, I want automatic recovery when my selected sprint is deleted, so I don't get stuck with errors.

**Acceptance Test**:
```gherkin
Given /asaf/.current-sprint.json points to sprint "old-sprint"
  And /asaf/old-sprint/ folder has been deleted
When any command requiring sprint context runs
Then stale state is detected
  And selection file is deleted
  And auto-selection runs (selects different valid sprint)
  And log message shows: "Selected sprint not found, auto-selecting..."
  And command continues with new selection
```

**Edge Cases Covered**:
- ✅ Edge case #3: Invalid sprint name in selection file
- ✅ Edge case #1: Corrupted selection file (triggers same recovery)

**Definition of Done**:
- [ ] Validation detects missing sprint folder
- [ ] Stale selection file deleted automatically
- [ ] Auto-selection runs as fallback
- [ ] Manual verification: Select sprint, delete its folder, run command, verify recovery

---

## AC5: Status Visibility

**User Story**: As a developer, I want clear feedback about which sprint is currently active, so I can verify I'm in the right context before executing commands.

**Acceptance Test**:
```gherkin
Given a sprint is selected
When user runs /asaf-status
Then current sprint information displayed prominently at top:
  - Sprint name
  - Sprint type (full/express)
  - Selection timestamp (human-readable)
  And rest of status output follows (phase, progress, etc.)
```

**Edge Cases Covered**:
- ✅ All validation edge cases (status shows current state accurately)

**Definition of Done**:
- [ ] /asaf-status updated with "Current Sprint" section at top
- [ ] Selection timestamp formatted as human-readable (e.g., "2 hours ago")
- [ ] Manual verification: Run /asaf-status, verify current sprint displayed clearly

---

## AC6: All Commands Respect Selection

**User Story**: As a developer, I want every ASAF command to operate on the selected sprint, so there's no confusion about context.

**Acceptance Test**:
```gherkin
Given sprint "sprint-foo" is selected
When any command requiring sprint context runs:
  - /asaf-groom, /asaf-groom-approve
  - /asaf-impl, /asaf-impl-pause, /asaf-impl-resume, /asaf-impl-review, /asaf-impl-approve
  - /asaf-demo, /asaf-retro
  - /asaf-summary
Then command operates on /asaf/sprint-foo/ directory only
  And no other sprint is accessed or modified
  And command output references "sprint-foo" in messages
```

**Edge Cases Covered**:
- ✅ All command integration (each command validated independently)

**Definition of Done**:
- [ ] All 11 sprint-context commands updated with Step 0: Verify Active Sprint
- [ ] Each command loads context from selected sprint only
- [ ] Manual verification: Create 2 sprints, select one, run each command, verify operates on correct sprint

---

## AC7: Backward Compatibility

**User Story**: As an existing ASAF user, I want the upgrade to sprint selection to work seamlessly without manual migration or configuration.

**Acceptance Test**:
```gherkin
Given existing ASAF repository with multiple sprints
  And no /asaf/.current-sprint.json exists (pre-upgrade state)
When first command runs after upgrade (any command requiring sprint context)
Then auto-selection runs automatically
  And most recently modified sprint selected
  And selection file created
  And command continues normally without errors
  And no manual intervention required
```

**Edge Cases Covered**:
- ✅ Edge case #13: First command after upgrade
- ✅ All validation edge cases (robust to various sprint states)

**Definition of Done**:
- [ ] Auto-selection works on first run
- [ ] No breaking changes to existing sprint structure
- [ ] No manual migration steps required
- [ ] Manual verification: Clone existing ASAF repo (pre-selection), run command, verify seamless

---

## AC8: Init Prompt Behavior

**User Story**: As a developer creating a new sprint, I want control over whether it becomes my current sprint, so I can queue up work without disrupting my current context.

**Acceptance Test**:
```gherkin
Given user runs /asaf-init new-sprint
When sprint creation completes successfully
Then user is prompted: "Set 'new-sprint' as current sprint? [Y/n]"
  And if user answers Y (or Enter):
    - /asaf/.current-sprint.json updated to new-sprint
    - Confirmation shown
  And if user answers n:
    - Existing selection preserved (or no selection if first sprint)
    - Message: "Current sprint unchanged"
```

**Edge Cases Covered**:
- ✅ First sprint created (no existing selection)
- ✅ Subsequent sprints (existing selection preserved if user chooses)

**Definition of Done**:
- [ ] /asaf-init updated with post-creation prompt
- [ ] Prompt respects user choice (Y/n)
- [ ] Default behavior (Enter) sets new sprint as current
- [ ] Manual verification: Create sprint with Y, verify selection; create another with n, verify unchanged

---

## Summary

**Total Acceptance Criteria**: 8 criteria defined
**Estimated Manual Verification Tests**: ~15 scenarios across all ACs

All criteria must be met before sprint is considered complete.

---

## Test Coverage Matrix

| AC | Edge Cases Covered | Commands Affected | Verification Method |
|----|-------------------|-------------------|---------------------|
| AC1 | #13, #7 | All sprint-context commands | Manual: delete file, run command |
| AC2 | #3, #9, #11 | /asaf-select | Manual: explicit selection tests |
| AC3 | #12, #10 | /asaf-select | Manual: interactive mode testing |
| AC4 | #3, #1 | All sprint-context commands | Manual: delete sprint, run command |
| AC5 | All validation | /asaf-status | Manual: status output verification |
| AC6 | All integration | 11 commands | Manual: multi-sprint context test |
| AC7 | #13, all validation | All commands | Manual: fresh upgrade simulation |
| AC8 | First sprint, subsequent | /asaf-init | Manual: init with Y/n responses |

---

_Generated from grooming session on 2025-10-31_
