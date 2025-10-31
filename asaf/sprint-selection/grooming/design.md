# Design Document: Sprint Selection State Management

## Overview

This feature introduces explicit sprint selection to prevent commands from accidentally operating on the wrong sprint when multiple sprints exist in a repository. A global state file (`/asaf/.current-sprint.json`) tracks which sprint is currently active, with auto-selection of the most recently modified sprint for backward compatibility.

**Problem Solved**: Solo developers working on multiple features in parallel can run commands that accidentally operate on the wrong sprint, causing confusion and potential mistakes.

**Success Criteria**:
- Developers always know which sprint is active before running commands
- Zero incidents of commands operating on wrong sprint
- Clear state file for visualization tools and external integrations

## Scope

**In Scope**:
- New `/asaf-select` command for explicit sprint selection
- Auto-selection algorithm for missing state file
- Update all 14 existing ASAF commands to validate sprint selection
- Documentation updates

**Out of Scope** (future enhancements):
- Multi-sprint operations (comparing, merging)
- Sprint history/audit log
- Sprint workspaces or grouping
- Undo functionality for sprint selection

**Constraints**:
- Must maintain backward compatibility (existing repos work without migration)
- Only applies to full sprints (express mode excluded)
- File location must be in `/asaf/` directory
- Must follow existing ASAF conventions (JSON format, dot-prefix, ISO-8601 timestamps)

---

## State File Design

### Location
`/asaf/.current-sprint.json`

### Format
```json
{
  "sprint": "sprint-name",
  "selected_at": "2025-10-31T11:30:00Z",
  "type": "full"
}
```

### Fields
- **sprint** (string): Name of the currently selected sprint (matches folder name in `/asaf/`)
- **selected_at** (ISO-8601 timestamp): When this sprint was selected
- **type** (string): Always "full" (express sprints are not tracked in selection)

### Git Considerations
- Developers can choose to commit or gitignore this file
- Documentation will explain trade-offs:
  - **Commit**: Preserves selection across machines, team coordination
  - **Gitignore**: Each developer has independent selection per machine
- Suggested default: gitignore (solo developer workflow)

---

## Components

### 1. `/asaf-select` Command

**Location**: `.claude/commands/asaf-select.md`

**Behavior**:

**Without arguments** (interactive mode):
- Read current selection from `/asaf/.current-sprint.json`
- Scan `/asaf/` for all valid full sprints (have `.state.json`)
- If only 1 sprint exists: Display it as current selection
- If multiple sprints exist: Show numbered list with current sprint highlighted, prompt user to keep or choose different
- If 0 sprints exist: Error with suggestion to run `/asaf-init`

**With sprint name argument**: `/asaf-select <sprint-name>`
- Validate sprint exists and is valid (has `.state.json`)
- Update `/asaf/.current-sprint.json` immediately
- Show confirmation message
- No blocking if sprint is in-progress (selection takes effect on next command)

**Error cases**:
- Sprint doesn't exist → List available sprints
- No valid sprints → Error, suggest `/asaf-init`
- Invalid sprint structure (missing `.state.json`) → Lenient warning, but don't allow selection

---

### 2. Auto-Selection Algorithm

**Trigger**: When any command needs sprint context but `/asaf/.current-sprint.json` is missing or points to deleted sprint

**Algorithm**:
1. Scan `/asaf/` for all subdirectories (exclude `/asaf/express/`)
2. Filter to valid sprints: must have `.state.json` file
3. If 0 valid sprints found:
   - Show error: "No valid sprints found. Run `/asaf-init <name>` to create one."
   - Do NOT create empty selection file
   - STOP execution
4. If 1+ valid sprints found:
   - Sort by `.state.json` modification time (most recent first)
   - Select most recent
   - Create `/asaf/.current-sprint.json` with selected sprint
   - Log: "Auto-selected sprint '<name>' (most recently modified)"
   - Continue command execution

**Rationale for `.state.json` modification time**:
- Reflects actual sprint work (only updated by ASAF commands)
- Ignores noise from file viewing, IDE indexing
- Already required for validation (every valid sprint has it)

---

### 3. Command Integration

**Commands requiring sprint selection validation**:
- `/asaf-groom`, `/asaf-groom-approve`
- `/asaf-impl`, `/asaf-impl-pause`, `/asaf-impl-resume`, `/asaf-impl-review`, `/asaf-impl-approve`
- `/asaf-demo`, `/asaf-retro`
- `/asaf-status`, `/asaf-summary`

**Commands NOT requiring validation** (work independently):
- `/asaf-list` (lists all sprints)
- `/asaf-help` (shows help)

**Special case - `/asaf-init`**:
- After creating new sprint, PROMPT user:
  - "New sprint '<name>' created. Set as current sprint? [Y/n]"
  - If YES: Update `.current-sprint.json`
  - If NO: Keep existing selection (or no selection if first sprint)

**Validation flow for commands**:
```
1. Check if /asaf/.current-sprint.json exists
   - If NO: Run auto-selection algorithm
   - If YES: Read sprint name

2. Validate sprint exists at /asaf/<sprint-name>/
   - If NO: Delete stale .current-sprint.json, run auto-selection

3. Validate sprint has .state.json
   - If NO but sprint folder exists: LENIENT - warn but allow (developer may be fixing)
   - If sprint folder missing: Run auto-selection

4. Set context: All subsequent operations use /asaf/<sprint-name>/
```

---

## Data Flow

### Scenario 1: First command in fresh repo
```
User runs: /asaf-groom

1. Command checks: /asaf/.current-sprint.json → NOT FOUND
2. Auto-selection runs:
   - Scans /asaf/ → finds "my-feature" (only sprint)
   - Creates /asaf/.current-sprint.json → {"sprint": "my-feature", ...}
   - Logs: "Auto-selected sprint 'my-feature'"
3. Command continues with my-feature context
```

### Scenario 2: User switches sprint explicitly
```
User runs: /asaf-select other-sprint

1. Command validates "other-sprint" exists and has .state.json
2. Updates /asaf/.current-sprint.json → {"sprint": "other-sprint", ...}
3. Shows: "✓ Switched to sprint 'other-sprint'"
```

### Scenario 3: User creates new sprint
```
User runs: /asaf-init new-feature

1. Command creates /asaf/new-feature/ with .state.json
2. Prompts: "Set 'new-feature' as current sprint? [Y/n]"
3. User enters Y
4. Updates /asaf/.current-sprint.json → {"sprint": "new-feature", ...}
```

### Scenario 4: Stale selection (deleted sprint)
```
User deletes /asaf/old-sprint/ folder
User runs: /asaf-status

1. Command checks: /asaf/.current-sprint.json → points to "old-sprint"
2. Validates: /asaf/old-sprint/ → NOT FOUND
3. Deletes stale /asaf/.current-sprint.json
4. Runs auto-selection → selects most recent valid sprint
5. Command continues with new selection
```

---

## Files Modified

### New Files
1. `.claude/commands/asaf-select.md` - New command implementation

### Modified Files
1. `.claude/commands/shared/asaf-core.md` - Add auto-selection algorithm as reusable pattern
2. `.claude/commands/asaf-init.md` - Add post-creation selection prompt
3. `.claude/commands/asaf-groom.md` - Add Step 0: Verify Active Sprint
4. `.claude/commands/asaf-groom-approve.md` - Add Step 0: Verify Active Sprint
5. `.claude/commands/asaf-impl.md` - Add Step 0: Verify Active Sprint
6. `.claude/commands/asaf-impl-pause.md` - Add Step 0: Verify Active Sprint
7. `.claude/commands/asaf-impl-resume.md` - Add Step 0: Verify Active Sprint
8. `.claude/commands/asaf-impl-review.md` - Add Step 0: Verify Active Sprint
9. `.claude/commands/asaf-impl-approve.md` - Add Step 0: Verify Active Sprint
10. `.claude/commands/asaf-demo.md` - Add Step 0: Verify Active Sprint
11. `.claude/commands/asaf-retro.md` - Add Step 0: Verify Active Sprint
12. `.claude/commands/asaf-status.md` - Add Step 0: Verify Active Sprint + display current sprint
13. `.claude/commands/asaf-summary.md` - Add Step 0: Verify Active Sprint
14. `README.md` - Document sprint selection feature
15. `CLAUDE.md` - Document `.current-sprint.json` format and behavior
16. `.gitignore` - Add `/asaf/.current-sprint.json` (suggested)

**Total**: 1 new file, 15 modified files

---

## Technology Decisions

### File Format: JSON
**Alternatives considered**: YAML, TOML, plain text
**Rationale**: Consistency with existing `.state.json`, simple parsing, widely supported
**Trade-offs**: Slightly less human-readable than YAML, but more consistent

### Location: `/asaf/.current-sprint.json`
**Alternatives considered**: `~/.claude/current-sprint.json` (global), `/asaf/CURRENT` (plain text)
**Rationale**: Project-local (supports multiple repos), follows dot-prefix convention for hidden state
**Trade-offs**: Not shared across projects (but that's desired - each repo has independent selection)

### Validation Strategy: Lenient
**Alternatives considered**: Strict (always fail on invalid state)
**Rationale**: Allows developers to manually fix broken sprints without losing selection
**Trade-offs**: Could mask underlying issues, but better DX for edge cases

### Auto-selection Criteria: `.state.json` modification time
**Alternatives considered**: Folder mtime, most recent file in sprint, manual timestamp in .state.json
**Rationale**: Reflects actual work (commands update this), ignores filesystem noise
**Trade-offs**: Requires valid .state.json (but we already validate that)

---

_(Phase 2 complete - Technical design finalized)_
