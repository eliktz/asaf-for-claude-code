# Edge Cases: Sprint Selection State Management

## File System Operations

### 1. Corrupted `.current-sprint.json` (Invalid JSON)
**Scenario**: File exists but contains malformed JSON (syntax error, truncated file, etc.)
**Handling**:
- Catch JSON parse error
- Log warning: "Selection file corrupted, regenerating..."
- Delete corrupted file
- Run auto-selection algorithm
- Continue command execution
**Test Approach**: Manually create file with invalid JSON, run any command requiring selection
**Priority**: High

### 2. File Permissions Issues
**Scenario**: Cannot read or write `/asaf/.current-sprint.json` due to filesystem permissions
**Handling**:
- Catch permission error
- Show clear error: "Cannot access /asaf/.current-sprint.json - check file permissions"
- Suggest: `chmod 644 /asaf/.current-sprint.json` or delete and regenerate
- STOP execution (cannot proceed without state)
**Test Approach**: Create file with no read permissions, run command
**Priority**: Medium (rare in practice)

### 3. Manually Edited with Invalid Sprint Name
**Scenario**: User edits `.current-sprint.json` to point to non-existent sprint
**Handling**:
- Validation detects sprint doesn't exist
- Log: "Selected sprint '<name>' not found, auto-selecting..."
- Delete stale selection file
- Run auto-selection
- Continue execution
**Test Approach**: Edit file to point to fake sprint name, run command
**Priority**: High

---

## Sprint Validation

### 4. Sprint Folder Exists but `.state.json` Missing
**Scenario**: `/asaf/my-sprint/` exists but no `.state.json` inside
**Handling**:
- LENIENT approach (per design decision)
- Warn: "Sprint 'my-sprint' has no .state.json (may be incomplete)"
- If auto-selecting: Skip this sprint, try next
- If explicitly selected via `/asaf-select`: Block selection, suggest fix
**Test Approach**: Create sprint folder without .state.json, test auto-selection and explicit selection
**Priority**: Medium

### 5. Sprint `.state.json` Corrupted/Invalid JSON
**Scenario**: `.state.json` exists but contains malformed JSON
**Handling**:
- LENIENT approach
- Warn: "Sprint 'my-sprint' has corrupted .state.json"
- If auto-selecting: Skip this sprint, try next
- If explicitly selected: Block selection, show error with fix suggestions
**Test Approach**: Create .state.json with invalid JSON, test both selection modes
**Priority**: Medium

### 6. `.state.json` Wrong Schema
**Scenario**: Valid JSON but missing required fields (no "sprint" field, no "phase", etc.)
**Handling**:
- LENIENT approach
- Warn: "Sprint 'my-sprint' has incomplete .state.json"
- If auto-selecting: Skip this sprint
- If explicitly selected: Allow but show warning (developer may be migrating)
**Test Approach**: Create .state.json with minimal/wrong schema
**Priority**: Low

---

## Auto-Selection Algorithm

### 7. Multiple Sprints with Identical Modification Times
**Scenario**: Two or more sprints have exact same `.state.json` mtime (rare but possible)
**Handling**:
- Use alphabetical order as tiebreaker
- Select first alphabetically
- Log: "Auto-selected sprint '<name>' (most recent, alphabetically first)"
**Test Approach**: Touch multiple .state.json files with same timestamp, run auto-selection
**Priority**: Low (rare)

### 8. All Sprints Have Very Old Modification Times
**Scenario**: All sprints last modified months ago (stale project)
**Handling**:
- Still select most recent (even if old)
- Log normally: "Auto-selected sprint '<name>' (most recently modified)"
- No special handling needed (age doesn't matter, only relative order)
**Test Approach**: Create sprints with old timestamps, verify selection works
**Priority**: Low (cosmetic)

---

## User Input Edge Cases

### 9. User Typo in Sprint Name
**Scenario**: User runs `/asaf-select my-feture` (typo: "feture" instead of "feature")
**Handling**:
- Exact match fails
- Calculate fuzzy match (Levenshtein distance or simple substring)
- If close match found (distance < 3): Suggest "Did you mean 'my-feature'?"
- If no close match: List all available sprints
**Test Approach**: Run /asaf-select with intentional typos
**Priority**: Medium (good UX)

### 10. User Enters Empty/Whitespace Sprint Name
**Scenario**: User runs `/asaf-select ""` or `/asaf-select "   "`
**Handling**:
- Trim input
- If empty after trim: Fall back to interactive mode (show list)
- Treat as if they ran `/asaf-select` without arguments
**Test Approach**: Run command with empty string, whitespace only
**Priority**: Low

### 11. User Enters Path Instead of Name
**Scenario**: User runs `/asaf-select /asaf/my-sprint` or `./asaf/my-sprint`
**Handling**:
- Strip common prefixes: `/asaf/`, `./asaf/`, `asaf/`
- Extract sprint name: `my-sprint`
- Continue with extracted name
- Helpful message: "Using sprint name 'my-sprint'"
**Test Approach**: Run /asaf-select with various path formats
**Priority**: Low (helpful but not critical)

### 12. User Cancels Interactive Selection
**Scenario**: User runs `/asaf-select`, sees list, presses Ctrl+C or just Enter without choosing
**Handling**:
- If Ctrl+C: Exit gracefully, no changes to selection
- If Enter without choice: Keep current selection (no-op)
- Show: "Selection unchanged"
**Test Approach**: Interactive testing (can't automate easily)
**Priority**: Low

---

## Backward Compatibility

### 13. First Command After Upgrade (No Selection File)
**Scenario**: Existing ASAF repo with multiple sprints, user upgrades to version with sprint selection
**Handling**:
- `.current-sprint.json` doesn't exist
- Auto-selection runs automatically on first command
- Most recently modified sprint selected
- Log: "Auto-selected sprint '<name>' (most recently modified)"
- Seamless upgrade, no user action required
**Test Approach**: Create repo with multiple sprints (no selection file), run any command
**Priority**: High (critical for backward compatibility)

### 14. Manually Created Selection File with Wrong Format
**Scenario**: User manually creates `.current-sprint.json` with non-standard format
**Handling**:
- Parse fails (covered by Edge Case #1)
- Or parse succeeds but schema wrong (missing fields)
- Treat as corrupted, delete, regenerate via auto-selection
- Log warning about regeneration
**Test Approach**: Create file with various wrong formats, test recovery
**Priority**: Medium

---

## Out of Scope

The following edge cases are explicitly **out of scope** per design discussion:

- **Concurrent Access**: Two terminal windows running commands simultaneously on different sprints
  - **Rationale**: Commands read selection at start, use throughout execution. Concurrent modification is user responsibility.

- **Non-Sprint Subdirectories**: `/asaf/archive/`, `/asaf/temp/`, etc.
  - **Rationale**: Auto-selection filters by `.state.json` presence. Directories without it are ignored automatically.

- **Sprint Name Validation**: Special characters, Unicode, very long names, shell keywords
  - **Rationale**: `/asaf-init` already validates on creation. Selection works with whatever exists.

---

## Summary

**Total Edge Cases**: 14 identified and documented
**Critical**: 3 (corrupted file, invalid sprint name, backward compatibility)
**Coverage**: File system, validation, auto-selection, user input, migration

All edge cases have defined handling strategies and test approaches.

---

_Generated from grooming session on 2025-10-31_
