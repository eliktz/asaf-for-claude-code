# ASAF List Command

**Command**: `/asaf-list`

**Purpose**: List all ASAF sprints in current project

---

## Scan Project

Look for:
1. **Full sprints**: `asaf/*/`
2. **Express sprints**: `asaf/express/*/`

For each sprint, read `.state.json` to get:
- Sprint name
- Type (full/express)
- Phase
- Status
- Created date
- Last updated
- Completion date (if complete)

---

## Display Sprint List

```
📋 ASAF Sprints

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Active Sprint

[If one in progress]
🔵 add-authentication (Implementation, Task 3/5)
   Type: Full ASAF
   Started: 2 hours ago
   Last active: 5 minutes ago
   
   Quick actions:
     /asaf-status              - Check progress
     /asaf-impl-pause          - Pause
     /asaf-summary             - View summary

[If none active]
ℹ️ No active sprint

   Start one:
     /asaf-init <name>         - Full workflow
     /asaf-express "<req>"     - Quick task

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Recent Full Sprints

✅ add-user-profiles (Complete)
   Completed: Oct 1, 2025
   Duration: 4h 15m
   Tasks: 5/5 (100%)
   Tests: 42 passing
   
   View: /asaf-summary add-user-profiles

✅ refactor-api (Complete)
   Completed: Sep 28, 2025
   Duration: 6h 30m
   Tasks: 8/8 (100%)
   Tests: 67 passing

⚠️ add-payment (Incomplete - Grooming)
   Last active: 12 days ago
   Status: Grooming incomplete (60%)
   
   Resume: /asaf-resume add-payment

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Recent Express Sprints (last 7 days)

✅ add-email-field (Complete)
   Completed: Today, 2 hours ago
   Duration: 47 min
   Tasks: 3/3
   
✅ fix-submit-typo (Complete)
   Completed: Today, 4 hours ago
   Duration: 4 min (auto mode)

✅ update-validation (Complete)
   Completed: Yesterday
   Duration: 1.2 hrs
   Tasks: 4/4

✅ fix-login-bug (Complete)
   Completed: Oct 4
   Duration: 1.2 hrs
   Tasks: 5/5

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Statistics

**Full Sprints**: 3 total (2 complete, 1 incomplete)
**Express Sprints**: 4 total (4 complete)

**Average Duration**:
  - Full sprints: 5.2 hours
  - Express sprints: 48 minutes

**Success Rate**:
  - Full sprints: 67% complete
  - Express sprints: 100% complete

**Total Tests Written**: 156 tests (149 passing)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commands:
  /asaf-status            - Check active sprint
  /asaf-resume <name>     - Resume sprint
  /asaf-summary <name>    - View sprint summary
  /asaf-init <name>       - Start new sprint
```

---

## Filtering Options

### By Status

```bash
/asaf-list --status=complete
/asaf-list --status=in-progress
/asaf-list --status=blocked
```

### By Type

```bash
/asaf-list --type=full
/asaf-list --type=express
```

### By Time

```bash
/asaf-list --recent=7        # Last 7 days
/asaf-list --since=2025-10-01
```

---

## Detailed View

```bash
/asaf-list --detailed
```

Shows more info per sprint:
```
✅ add-user-profiles (Complete)
   Type: Full ASAF
   Created: Sep 28, 2025
   Completed: Oct 1, 2025
   Duration: 4h 15m
   
   Grooming: 45 min
   Implementation: 2h 45m (5 tasks, 7 iterations)
   Demo: 15 min
   Retro: 15 min
   
   Results:
     - Tasks: 5/5 (100%)
     - Tests: 42 written, 42 passing
     - Coverage: 94%
   
   Learning:
     - Advanced "Learn React hooks" goal
     - Identified 3 reusable patterns
   
   View: /asaf-summary add-user-profiles
```

---

## Empty State

If no sprints found:

```
📋 ASAF Sprints

No sprints found in this project.

Get started:
  /asaf-init <name>         - Start full sprint
  /asaf-express "<req>"     - Quick task

Learn more:
  /asaf-help
```

---

## Sorting

Default: Most recent first

Options:
```bash
/asaf-list --sort=name          # Alphabetical
/asaf-list --sort=duration      # Longest first
/asaf-list --sort=date          # Newest first (default)
```

---

## Export

```bash
/asaf-list --export=json
```

Generates `asaf-sprint-list.json`:
```json
{
  "generated": "2025-10-05T16:30:00Z",
  "project": "your-project",
  "sprints": [
    {
      "name": "add-authentication",
      "type": "full",
      "status": "in-progress",
      "phase": "implementation",
      "created": "2025-10-05T14:00:00Z",
      "duration_seconds": 9000,
      "tasks": {"total": 5, "completed": 3},
      "tests": {"written": 30, "passing": 30}
    }
  ],
  "statistics": {
    "total_sprints": 7,
    "complete": 6,
    "avg_duration_hours": 2.1
  }
}
```

---

## Error Handling

### No asaf/ Folder

```
ℹ️ No ASAF sprints found

The asaf/ folder doesn't exist in this project.

ASAF hasn't been used here yet.

Get started:
  /asaf-init <name>         - Start first sprint
  /asaf-express "<req>"     - Quick task

The asaf/ folder will be created automatically.
```

### Corrupted Sprint Data

```
⚠️ Warning: Some sprint data is incomplete

The following sprints have issues:
  - old-sprint: Missing .state.json
  - broken-sprint: Cannot parse state file

These sprints are excluded from the list.

To clean up:
  mv asaf/old-sprint asaf/.corrupted/
  mv asaf/broken-sprint asaf/.corrupted/
```

---

## Context to Include

- Scan asaf/ and asaf/express/ folders
- Read .state.json from each sprint
- Read SUMMARY.md for additional details
- Calculate statistics from all sprints

---

_List command provides overview of all sprint activity in the project._
