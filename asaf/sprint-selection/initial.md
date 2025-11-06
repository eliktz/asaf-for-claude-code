# Feature: Sprint Selection State Management

## Problem Statement

When multiple sprints exist in the same repository under `/asaf/`, Claude Code can become confused about which sprint context to operate in. Commands may inadvertently read from or write to the wrong sprint, causing workflow disruption and potential data corruption.

## Solution Overview

Introduce a global sprint selection state file (`/asaf/.current-sprint.json`) that explicitly tracks which sprint is currently active. All ASAF commands will check this file first before executing any sprint-specific operations.

## User Stories

1. **As a developer**, I want to explicitly select which sprint I'm working on, so that ASAF commands always operate on the correct sprint context.
2. **As a developer**, I want automatic selection of the most recently modified sprint when no selection exists, so that I don't have to manually configure this on first use.
3. **As a developer**, I want clear feedback about which sprint is currently active, so that I can verify I'm in the right context before executing commands.
4. **As a developer**, I want to easily switch between multiple concurrent sprints, so that I can work on multiple features in parallel.

## Technical Design

### State File Location
`/asaf/.current-sprint.json`

### State File Format
```json
{
  "sprint": "sprint-name",
  "selected_at": "2025-10-31T10:30:00Z",
  "type": "full"
}
```

### New Command: `/asaf-select`

**Purpose**: Explicitly select the active sprint

**Usage**:
```bash
/asaf-select <sprint-name>
/asaf-select                  # Interactive: show list of sprints to choose
```

**Behavior**:
1. Validate sprint exists in `/asaf/`
2. Read existing sprint's `.state.json` to get type
3. Update `/asaf/.current-sprint.json`
4. Display confirmation with sprint details

**Error Cases**:
- Sprint doesn't exist → List available sprints
- No sprints exist → Suggest `/asaf-init` or `/asaf-express`
- Invalid sprint structure (missing `.state.json`) → Warning + ask to fix or select different sprint

### Modified Behavior: All Existing Commands

**New validation step** (add to ALL commands at the beginning):

```markdown
## Step 0: Verify Active Sprint

1. Check if `/asaf/.current-sprint.json` exists
   - If NO: Auto-select most recently modified sprint (see Auto-Selection below)
   - If YES: Read selected sprint name

2. Validate selected sprint exists at `/asaf/<sprint-name>/`
   - If NO: Delete stale `.current-sprint.json`, run auto-selection

3. Validate sprint structure (has `.state.json`)
   - If NO: ERROR with recovery options

4. Set context: All subsequent operations use `/asaf/<sprint-name>/`
```

### Auto-Selection Algorithm

When `/asaf/.current-sprint.json` is missing or stale:

```markdown
1. List all directories in `/asaf/`
2. Filter to valid sprints (have `.state.json`)
3. Sort by modification time (newest first)
4. Select most recent
5. Create `/asaf/.current-sprint.json`
6. Log: "Auto-selected sprint '<name>' (most recently modified)"
```

## Implementation Tasks

### Task 1: Create `/asaf-select` command
- File: `.claude/commands/asaf-select.md`
- Implement selection logic
- Implement interactive mode
- Add validation

### Task 2: Create auto-selection utility
- Add to `.claude/commands/shared/asaf-core.md`
- Define as reusable pattern for all commands
- Include filesystem scanning
- Include modification time sorting

### Task 3: Update all existing commands
- Add Step 0 to: init, groom, groom-approve, impl, impl-pause, impl-resume, impl-review, impl-approve, express, demo, retro, status, list, summary
- Test each command with selection in place

### Task 4: Update `/asaf-status`
- Add "Current Sprint" section at top
- Include selection timestamp

### Task 5: Update `/asaf-list`
- Add indicator for selected sprint
- Show selection age ("selected 2 hours ago")

### Task 6: Update `/asaf-init`
- After creating new sprint, auto-select it
- Update `.current-sprint.json`

### Task 7: Update `/asaf-express`
- After creating express task, auto-select it
- Update `.current-sprint.json`

### Task 8: Update documentation
- README.md: Add section on sprint selection
- CLAUDE.md: Document `.current-sprint.json` format
- Add to troubleshooting guide

### Task 9: Testing
- Test with 0, 1, 2, 5 sprints
- Test auto-selection
- Test explicit selection
- Test stale state recovery
- Test switching during active work

## Edge Cases

1. **Empty /asaf/ directory** - Don't create `.current-sprint.json`, suggest `/asaf-init`
2. **All sprints have invalid structure** - List directories, explain they're invalid
3. **Concurrent modification** - Read state at start, use throughout command execution
4. **Selection during active implementation** - Current command continues on original sprint
5. **Express vs Full sprint selection** - Both types valid, commands check `type` field
6. **Sprint deletion while selected** - Next command detects, runs auto-selection
7. **Case sensitivity** - Sprint names are case-sensitive
8. **Spaces in sprint names** - Valid but discouraged

## Acceptance Criteria

1. **AC1: Auto-selection on first use** - Most recently modified sprint is auto-selected
2. **AC2: Explicit selection** - `/asaf-select <name>` switches active sprint
3. **AC3: Interactive selection** - `/asaf-select` shows list to choose from
4. **AC4: Stale state recovery** - Detects deleted sprint, auto-selects new one
5. **AC5: Status visibility** - `/asaf-status` shows current sprint prominently
6. **AC6: All commands respect selection** - Every command operates on selected sprint
7. **AC7: Backward compatibility** - Works with existing sprints without manual migration

---

Created: 2025-10-31T13:05:00Z
Type: Full ASAF Sprint
