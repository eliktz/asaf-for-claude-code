# ASAF Select Command

**Command**: `/asaf-select` or `/asaf-select <sprint-name>`

**Purpose**: Explicitly select which sprint is currently active

---

## Prerequisites

None - this command works with any state (even no sprints).

---

## Execution Steps

### Step 1: Parse Arguments

**If command includes sprint name**: `/asaf-select <sprint-name>`
- Proceed to Step 2: Direct Selection

**If command has no arguments**: `/asaf-select`
- Proceed to Step 3: Interactive Mode

**If sprint name is empty or only whitespace**:
- Trim input
- If empty after trim: Fall back to Step 3: Interactive Mode

**If sprint name looks like a path** (`/asaf/sprint-name`, `./asaf/sprint-name`, `asaf/sprint-name`):
- Strip common prefixes: `/asaf/`, `./asaf/`, `asaf/`
- Extract sprint name
- Show helpful message: "Using sprint name '<extracted-name>'"
- Continue with extracted name

---

### Step 2: Direct Selection (with sprint name argument)

**Scan for valid sprints**:
```
List all subdirectories in /asaf/ (exclude /asaf/express/)
Filter to valid sprints: must have .state.json file
```

**Check if requested sprint exists**:

If sprint folder exists at `/asaf/<sprint-name>/`:
- Check if `.state.json` exists
- If YES: Valid sprint, proceed
- If NO: **Lenient warning**

```
🟡 WARNING: Sprint '<sprint-name>' has no .state.json

This sprint may be incomplete or corrupted.

Cannot select incomplete sprint.

Available sprints:
  [List all valid sprints with status]

Try: /asaf-select <valid-sprint-name>
```
**STOP execution.**

If sprint folder does NOT exist:
- Check for typos using fuzzy matching (simple approach: check if any sprint name is within edit distance of 2-3 characters)

**If close match found**:
```
🔴 ERROR: Sprint not found

Sprint '<sprint-name>' doesn't exist.

Did you mean '<close-match>'?

Available sprints:
  [List all valid sprints]

Try: /asaf-select <sprint-name>
```
**STOP execution.**

**If no close match**:
```
🔴 ERROR: Sprint not found

Sprint '<sprint-name>' doesn't exist.

Available sprints:
  [List all valid sprints]

Try: /asaf-select <sprint-name>
```
**STOP execution.**

**If sprint is valid, update selection**:

Read existing `.state.json` from `/asaf/<sprint-name>/` to get sprint type:
```json
{
  "sprint": "sprint-name",
  "type": "full" or "express"
}
```

Create or update `/asaf/.current-sprint.json`:
```json
{
  "sprint": "<sprint-name>",
  "selected_at": "<current-timestamp-ISO-8601>",
  "type": "full"
}
```

**Success message**:
```
✅ Switched to sprint '<sprint-name>'

Type: full
Phase: <phase from .state.json>
Status: <status from .state.json>

This selection will apply to all subsequent ASAF commands.
```

**STOP HERE - Done.**

---

### Step 3: Interactive Mode (no arguments)

**Scan for valid sprints**:
```
List all subdirectories in /asaf/ (exclude /asaf/express/)
Filter to valid sprints: must have .state.json file
```

**If 0 valid sprints found**:
```
🔴 ERROR: No sprints found

No valid full sprints exist in this repository.

To create a new sprint:
  /asaf-init <sprint-name>

To see what exists:
  ls -la asaf/
```
**STOP execution.**

---

**If exactly 1 sprint exists**:

Read current selection from `/asaf/.current-sprint.json` (if it exists).

Show:
```
📋 Current Sprint

Sprint: <sprint-name>
Type: full
Phase: <phase>
Status: <status>

[If this matches .current-sprint.json]
Already selected.

[If .current-sprint.json doesn't exist or points to different sprint]
This is the only sprint available.
```

Create/update `/asaf/.current-sprint.json` if needed.

**STOP HERE - Done.**

---

**If multiple sprints exist**:

Read current selection from `/asaf/.current-sprint.json` (if it exists).

Show numbered list:
```
📋 Available Sprints

[For each sprint, with current marked with *]

  1. sprint-one (full) - grooming phase *          ← currently selected
  2. sprint-two (full) - implementation complete
  3. sprint-three (full) - ready

[If no current selection]
  1. sprint-one (full) - grooming phase
  2. sprint-two (full) - implementation complete
  3. sprint-three (full) - ready

  No sprint currently selected.

Select sprint (1-[N]), or press Enter to keep current selection:
```

**Wait for user input.**

**Handle user response**:

**If user presses Enter (empty input)**:
- Keep current selection unchanged
- Show:
```
Selection unchanged.

[If there was a current selection]
Current sprint: <sprint-name>

[If no current selection]
No sprint selected. Run /asaf-select again to choose.
```
**STOP execution.**

**If user enters a number (1-N)**:
- Validate it's within range
- If out of range:
```
Invalid choice. Please enter a number between 1 and [N].
```
- Ask again (loop back)

- If valid: Select that sprint
- Update `/asaf/.current-sprint.json`
- Show:
```
✅ Switched to sprint '<sprint-name>'

Type: full
Phase: <phase>
Status: <status>
```
**STOP execution.**

**If user enters anything else**:
- Treat as direct sprint name
- Go back to Step 2 with that name

---

## Edge Case Handling

### Empty /asaf/ Directory
- Covered by "If 0 valid sprints found" above

### Corrupted .current-sprint.json
- Read attempt may fail (invalid JSON)
- If read fails: Treat as if file doesn't exist
- No current selection shown in interactive mode
- New selection will overwrite corrupted file

### Sprint Deleted While Selected
- Not handled in this command
- Other commands will detect stale selection
- This command just sets new selection

### User Cancels (Ctrl+C)
- Standard terminal behavior - command stops
- Selection remains unchanged

---

## State File Format

`/asaf/.current-sprint.json`:
```json
{
  "sprint": "sprint-name",
  "selected_at": "2025-10-31T12:00:00Z",
  "type": "full"
}
```

**Fields**:
- `sprint` (string): Name of selected sprint (matches folder in /asaf/)
- `selected_at` (string): ISO-8601 timestamp
- `type` (string): Always "full" (express sprints not tracked)

---

## Examples

### Example 1: Direct Selection
```
User: /asaf-select my-feature

✅ Switched to sprint 'my-feature'

Type: full
Phase: grooming
Status: ready
```

### Example 2: Interactive Selection (Multiple Sprints)
```
User: /asaf-select

📋 Available Sprints

  1. feature-one (full) - grooming phase *
  2. feature-two (full) - implementation in progress
  3. bugfix-three (full) - complete

Select sprint (1-3), or press Enter to keep current selection: 2

✅ Switched to sprint 'feature-two'

Type: full
Phase: implementation
Status: in-progress
```

### Example 3: Typo with Suggestion
```
User: /asaf-select my-feture

🔴 ERROR: Sprint not found

Sprint 'my-feture' doesn't exist.

Did you mean 'my-feature'?

Available sprints:
  - my-feature (full) - grooming phase
  - other-sprint (full) - complete

Try: /asaf-select <sprint-name>
```

### Example 4: Path Input
```
User: /asaf-select /asaf/my-feature

Using sprint name 'my-feature'

✅ Switched to sprint 'my-feature'
```

### Example 5: Single Sprint
```
User: /asaf-select

📋 Current Sprint

Sprint: my-feature
Type: full
Phase: grooming
Status: ready

This is the only sprint available.
```

---

## Design Notes

### Why Interactive Mode?
- User-friendly when they don't remember exact names
- Shows context (all sprints, their status)
- Allows confirmation without typing

### Why Allow Selection During Active Work?
- User may be queueing up next sprint
- Selection applies to *next* command, not current
- No need to block - keep workflow smooth

### Why Fuzzy Matching?
- Typos are common
- Better UX than forcing exact match
- Simple algorithm (edit distance) is sufficient

### Why Lenient Validation?
- Sprint may be in process of repair
- Better to warn than block entirely
- Matches overall ASAF philosophy

---

_This command is the primary way users explicitly control sprint context._
