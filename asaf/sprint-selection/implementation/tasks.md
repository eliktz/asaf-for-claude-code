# Task Breakdown: Sprint Selection State Management

Generated: 2025-10-31T11:45:00Z
Total Tasks: 9

---

## Task 1: Create `/asaf-select` Command

**Complexity**: High

**Description**:
Create the new `/asaf-select` command that allows explicit sprint selection. Must support both interactive mode (no arguments) and direct selection (with sprint name argument). Includes fuzzy matching for typos, validation, and helpful error messages.

**Execution Pattern**: executor → reviewer → executor

**Max Iterations**: 5

**Executor Profile**: general-purpose

**Files to Create**:
- `.claude/commands/asaf-select.md` (create) - New command implementation

**Edge Cases to Handle**:
- Edge case #9: User typo in sprint name (fuzzy matching)
- Edge case #10: User enters empty/whitespace sprint name
- Edge case #11: User enters path instead of name
- Edge case #12: User cancels interactive selection
- Edge case #3: Manually edited with invalid sprint name

**Acceptance Criteria Link**:
- Contributes to AC2: Explicit selection
- Contributes to AC3: Interactive selection

**Definition of Done**:
- [ ] Command file created with complete instructions
- [ ] Interactive mode shows list with current highlighted
- [ ] Single-sprint case handled (just display)
- [ ] Direct selection validates and updates file
- [ ] Fuzzy matching suggests corrections for typos
- [ ] Error messages clear and actionable
- [ ] All edge cases documented in command

**Special Considerations**:
- Most complex task - interactive prompts require clear UX design
- Fuzzy matching algorithm should be simple (Levenshtein distance < 3)
- Must handle case where no .current-sprint.json exists yet

---

## Task 2: Add Auto-Selection Algorithm to asaf-core.md

**Complexity**: Medium

**Description**:
Add the auto-selection algorithm as a reusable pattern in asaf-core.md. This will be referenced by all commands that need sprint context. Algorithm scans /asaf/ for valid sprints, sorts by .state.json modification time, selects most recent.

**Execution Pattern**: executor → reviewer → executor

**Max Iterations**: 3

**Executor Profile**: general-purpose

**Files to Modify**:
- `.claude/commands/shared/asaf-core.md` (modify) - Add auto-selection algorithm section

**Edge Cases to Handle**:
- Edge case #7: Multiple sprints with identical modification times
- Edge case #1: Corrupted .current-sprint.json
- Edge case #13: First command after upgrade (backward compatibility)

**Acceptance Criteria Link**:
- Contributes to AC1: Auto-selection on first use
- Contributes to AC4: Stale state recovery
- Contributes to AC7: Backward compatibility

**Definition of Done**:
- [ ] Auto-selection algorithm documented clearly
- [ ] Step-by-step instructions for scanning /asaf/
- [ ] Modification time sorting specified
- [ ] Error handling for 0 valid sprints
- [ ] Tiebreaker logic (alphabetical) documented
- [ ] Pattern can be copy-pasted into commands

**Special Considerations**:
- This is foundational - other tasks depend on this
- Must exclude /asaf/express/ from scanning
- Clear instructions for reading .state.json mtime

---

## Task 3: Update `/asaf-init` with Selection Prompt

**Complexity**: Medium

**Description**:
Modify asaf-init.md to prompt user after creating new sprint: "Set '<name>' as current sprint? [Y/n]". Updates .current-sprint.json based on user choice. Special case: this is the only command that creates selection proactively.

**Execution Pattern**: executor → reviewer → executor

**Max Iterations**: 3

**Executor Profile**: general-purpose

**Files to Modify**:
- `.claude/commands/asaf-init.md` (modify) - Add post-creation prompt

**Edge Cases to Handle**:
- First sprint created (no existing selection)
- Subsequent sprints (existing selection preserved if user chooses N)

**Acceptance Criteria Link**:
- Contributes to AC8: Init prompt behavior

**Definition of Done**:
- [ ] Prompt added after sprint creation
- [ ] Y/n handling clear (Enter defaults to Y)
- [ ] .current-sprint.json created/updated correctly
- [ ] Confirmation messages for both choices
- [ ] Existing selection preserved if user chooses N

**Special Considerations**:
- This is the ONLY command that doesn't use auto-selection
- Prompt should be non-blocking (not error if user skips)
- First sprint should default to auto-selecting without prompt? (Check with design - currently spec says prompt always)

---

## Task 4: Update Sprint-Context Commands (Part 1: asaf-groom group)

**Complexity**: Low

**Description**:
Add "Step 0: Verify Active Sprint" to asaf-groom.md and asaf-groom-approve.md. This step calls the auto-selection algorithm from asaf-core.md before executing command logic. Pattern will be identical across all commands.

**Execution Pattern**: executor → reviewer

**Max Iterations**: 2

**Executor Profile**: general-purpose

**Files to Modify**:
- `.claude/commands/asaf-groom.md` (modify) - Add Step 0
- `.claude/commands/asaf-groom-approve.md` (modify) - Add Step 0

**Edge Cases to Handle**:
- All handled by auto-selection algorithm (no command-specific cases)

**Acceptance Criteria Link**:
- Contributes to AC6: All commands respect selection

**Definition of Done**:
- [ ] Step 0 added before existing Step 1
- [ ] References asaf-core.md auto-selection pattern
- [ ] Clear instructions for reading selected sprint
- [ ] Error handling if no valid sprints exist

**Special Considerations**:
- Simple copy-paste pattern - keep consistent across all commands
- Step 0 should be identical in all 11 commands for maintainability

---

## Task 5: Update Sprint-Context Commands (Part 2: asaf-impl group)

**Complexity**: Low

**Description**:
Add "Step 0: Verify Active Sprint" to asaf-impl.md, asaf-impl-pause.md, asaf-impl-resume.md, asaf-impl-review.md, asaf-impl-approve.md. Same pattern as Task 4.

**Execution Pattern**: executor → reviewer

**Max Iterations**: 2

**Executor Profile**: general-purpose

**Files to Modify**:
- `.claude/commands/asaf-impl.md` (modify) - Add Step 0
- `.claude/commands/asaf-impl-pause.md` (modify) - Add Step 0
- `.claude/commands/asaf-impl-resume.md` (modify) - Add Step 0
- `.claude/commands/asaf-impl-review.md` (modify) - Add Step 0
- `.claude/commands/asaf-impl-approve.md` (modify) - Add Step 0

**Edge Cases to Handle**:
- All handled by auto-selection algorithm

**Acceptance Criteria Link**:
- Contributes to AC6: All commands respect selection

**Definition of Done**:
- [ ] Step 0 added to all 5 impl commands
- [ ] Identical pattern as Task 4
- [ ] No command-specific variations

**Special Considerations**:
- Can be done in parallel with Task 4 (independent)
- Batch editing recommended for consistency

---

## Task 6: Update Sprint-Context Commands (Part 3: asaf-demo, asaf-retro, asaf-summary)

**Complexity**: Low

**Description**:
Add "Step 0: Verify Active Sprint" to asaf-demo.md, asaf-retro.md, asaf-summary.md. Same pattern as Tasks 4-5.

**Execution Pattern**: executor → reviewer

**Max Iterations**: 2

**Executor Profile**: general-purpose

**Files to Modify**:
- `.claude/commands/asaf-demo.md` (modify) - Add Step 0
- `.claude/commands/asaf-retro.md` (modify) - Add Step 0
- `.claude/commands/asaf-summary.md` (modify) - Add Step 0

**Edge Cases to Handle**:
- All handled by auto-selection algorithm

**Acceptance Criteria Link**:
- Contributes to AC6: All commands respect selection

**Definition of Done**:
- [ ] Step 0 added to all 3 commands
- [ ] Identical pattern as previous tasks

**Special Considerations**:
- Can be done in parallel with Tasks 4-5

---

## Task 7: Update `/asaf-status` with Current Sprint Display

**Complexity**: Medium

**Description**:
Add "Step 0: Verify Active Sprint" to asaf-status.md AND add "Current Sprint" section at top of output. This command is special - it displays selection info prominently, not just uses it internally.

**Execution Pattern**: executor → reviewer → executor

**Max Iterations**: 3

**Executor Profile**: general-purpose

**Files to Modify**:
- `.claude/commands/asaf-status.md` (modify) - Add Step 0 + output section

**Edge Cases to Handle**:
- Display when selection exists vs auto-selected
- Human-readable timestamp ("2 hours ago")

**Acceptance Criteria Link**:
- Contributes to AC5: Status visibility
- Contributes to AC6: All commands respect selection

**Definition of Done**:
- [ ] Step 0 added like other commands
- [ ] "Current Sprint" section added to output format
- [ ] Shows sprint name, type, selection timestamp
- [ ] Timestamp formatted as human-readable
- [ ] Positioned prominently at top

**Special Considerations**:
- This is the primary visibility mechanism for users
- Format should be clear and scannable
- Consider adding indicator if auto-selected vs explicitly selected

---

## Task 8: Update Installation Scripts and Documentation

**Complexity**: Low

**Description**:
Update install.sh to copy new asaf-select.md file. Update uninstall.sh to remove it. Update README.md with sprint selection section. Update CLAUDE.md with .current-sprint.json format. Suggest adding to .gitignore.

**Execution Pattern**: executor → reviewer

**Max Iterations**: 2

**Executor Profile**: general-purpose

**Files to Modify**:
- `install.sh` (modify) - Add asaf-select.md to copy list
- `uninstall.sh` (modify) - Add asaf-select.md to remove list
- `README.md` (modify) - Add "Sprint Selection" section
- `CLAUDE.md` (modify) - Document .current-sprint.json format
- `.gitignore` (modify) - Add /asaf/.current-sprint.json (optional, suggested)

**Edge Cases to Handle**:
- None (straightforward documentation/scripts)

**Acceptance Criteria Link**:
- Contributes to AC7: Backward compatibility (installation works)

**Definition of Done**:
- [ ] install.sh includes new command file
- [ ] uninstall.sh removes new command file
- [ ] README.md has clear section on selection
- [ ] CLAUDE.md documents state file format
- [ ] .gitignore suggestion documented (not forced)

**Special Considerations**:
- Installation must work for both global and project-local
- Documentation should explain git decision (commit vs ignore)
- README section should be user-focused (not technical details)

---

## Task 9: Final Integration Testing and Edge Case Verification

**Complexity**: Medium

**Description**:
Manually verify all acceptance criteria are met. Test edge cases systematically. Verify install/uninstall works. Check backward compatibility with existing repo. This is QA task, not implementation.

**Execution Pattern**: executor → reviewer

**Max Iterations**: 3

**Executor Profile**: general-purpose

**Files to Verify**:
- All 16 files from previous tasks
- Test with actual ASAF repository (this repo can be test bed)

**Edge Cases to Verify**:
- All 14 edge cases from edge-cases.md

**Acceptance Criteria Link**:
- Verifies ALL 8 acceptance criteria

**Definition of Done**:
- [ ] All 8 ACs manually verified
- [ ] All 14 edge cases tested
- [ ] Install/uninstall tested (global and project-local)
- [ ] Backward compatibility verified (existing repo without selection file)
- [ ] Documentation reviewed for clarity
- [ ] No broken references between files

**Special Considerations**:
- This is the quality gate before completion
- If issues found, may require iteration on previous tasks
- Should use this repository (asaf-for-claude-code) as test bed
- Document any issues found in progress.md for fixing

---

## Task Dependencies

```
Task 2 (Auto-selection in asaf-core.md) → Task 4, 5, 6, 7 (All commands need it)
                                      ↘
Task 1 (asaf-select command)           → Task 9 (Testing)
Task 3 (asaf-init prompt)             ↗

Task 4, 5, 6 (Command updates - can run in parallel) → Task 9
Task 7 (asaf-status special) → Task 9
Task 8 (Docs & scripts) → Task 9
```

**Critical Path**: Task 2 → Task 4/5/6/7 → Task 9

## Estimated Timeline

- **Total tasks**: 9
- **Estimated time**: 5-6 hours
  - High complexity tasks (1, 9): 2-3 hours combined
  - Medium complexity tasks (2, 3, 7, 8): 2-3 hours combined
  - Low complexity tasks (4, 5, 6): 1 hour combined
- **Expected iterations**: ~25 total (accounting for review cycles)

## Implementation Notes

- **Tasks 4, 5, 6 can be done in parallel** (independent, identical pattern)
- **Task 2 is foundational** - complete before others
- **Task 9 is quality gate** - may uncover issues requiring fixes
- **Use this repository** as test bed during Task 9
- **Lenient validation** throughout - warn but don't block fixes

---

_Task breakdown generated by Task Planner Agent on 2025-10-31_
