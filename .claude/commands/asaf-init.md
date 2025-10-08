# ASAF Init Command

**Command**: `/asaf-init <sprint-name>` or `/asaf-init @file.md`

**Purpose**: Initialize a new ASAF sprint

---

## Prerequisites

None - this is the starting command.

---

## Execution Steps

### Step 1: Validate Sprint Name

**Check if sprint already exists**:
```
Look for folder: asaf/<sprint-name>/
```

If exists:
```
🔴 ERROR: Sprint already exists

A sprint named "<sprint-name>" already exists at:
  asaf/<sprint-name>/

Status: [Read from .state.json]

Options:
  1. /asaf-resume <sprint-name>     - Continue existing sprint
  2. /asaf-cancel                   - Cancel and start over
  3. /asaf-init <different-name>    - Use different name

What would you like to do?
```
**STOP execution.**

---

**Validate sprint name format**:
- Only letters, numbers, hyphens, underscores allowed
- No spaces or special characters

If invalid:
```
🔴 ERROR: Invalid sprint name

Sprint name "<sprint-name>" contains invalid characters.

Rules:
  ✅ Letters (a-z, A-Z)
  ✅ Numbers (0-9)
  ✅ Hyphens (-)
  ✅ Underscores (_)
  ❌ Spaces
  ❌ Special characters (!, @, #, $, %, etc.)

Examples of valid names:
  ✅ add-authentication
  ✅ fix_login_bug
  ✅ refactor-api-v2
  ✅ user-profile-2024

Suggested name for your feature:
  [Generate valid version of their input]

Try again: /asaf-init <valid-name>
```
**STOP execution.**

---

### Step 2: Gather Requirements

**If command includes @file.md**:
```bash
# User ran: /asaf-init @specs/feature.md

Read the referenced file and use its content as feature description.
```

**If command is just sprint name**:
```bash
# User ran: /asaf-init add-authentication

Ask the user:

"📝 Describe the feature you want to build:

(Provide a clear description of what you want to implement. Include:
 - What problem it solves
 - Who will use it
 - Any specific requirements or constraints)"

```

Wait for user's response.

If user provides insufficient detail (< 20 words):
```
"Could you provide a bit more detail? A good feature description helps with design later. For example:
 
 - What specific functionality do you need?
 - Are there any technical requirements?
 - Any constraints or dependencies?"
```

---

### Step 3: Create Folder Structure

Create:
```
asaf/<sprint-name>/
├── SUMMARY.md
├── .state.json
└── initial.md
```

**If folder creation fails**:
```
🔴 CRITICAL: Cannot create sprint folder

Failed to create: asaf/<sprint-name>/

Possible reasons:
  - No write permissions in asaf/ folder
  - Disk space full
  - Path too long
  - File system error

Troubleshooting:
  1. Check permissions: ls -la asaf/
  2. Check disk space: df -h
  3. Try creating manually: mkdir -p asaf/<sprint-name>

Error details: [System error message]

Cannot proceed without write access.
```
**STOP execution.**

---

### Step 4: Generate Initial Files

#### initial.md

```markdown
# Feature: <sprint-name>

## Description

<user's full description>

## Context

<any additional context gathered from conversation>

---

Created: <timestamp>
Type: Full ASAF Sprint
```

---

#### .state.json

```json
{
  "sprint": "<sprint-name>",
  "type": "full",
  "phase": "grooming",
  "status": "ready",
  "created": "<ISO-8601 timestamp>",
  "updated": "<ISO-8601 timestamp>",
  "grooming_approved": false,
  "planning_complete": false,
  "implementation_complete": false
}
```

---

#### SUMMARY.md (Initial Version)

```markdown
# Sprint Summary: <sprint-name>

> **Status**: 🔄 Ready for Grooming  
> **Created**: <human-readable date/time>  
> **Type**: Full ASAF Sprint

---

## 📋 Feature Description

<user's description>

---

## 🎯 Current Phase: Initialization Complete

Sprint initialized successfully. Ready to begin design conversation.

**Next step**: Run `/asaf-groom` to start collaborative design session.

---

## 📊 Sprint Progress

- [x] Initialization
- [ ] Grooming
- [ ] Planning
- [ ] Implementation
- [ ] Demo
- [ ] Retrospective

---

_This summary will update automatically as the sprint progresses._
```

---

### Step 5: Load Personal Goals (Optional)

Look for `personal-goals.md` in project root.

If found:
- Note it for use in grooming
- Extract developer name if present

If not found:
- No problem, ASAF works without it
- Optionally offer to create one:

```
ℹ️ Personal Goals

I notice you don't have a personal-goals.md file. This is optional but helps ASAF:
  - Connect work to your learning objectives
  - Configure code review style to match your experience
  - Track skill progression over time

Would you like to create one now? (y/n)

[If yes, guide through creation]
[If no, continue without it]
```

---

### Step 6: Success Message

```
✅ Sprint initialized: <sprint-name>

Created:
  asaf/<sprint-name>/
  ├── initial.md          # Feature description
  ├── SUMMARY.md          # Sprint overview
  └── .state.json         # Sprint state

Status: 🔄 Ready for Grooming

Next step: Run `/asaf-groom` to begin design conversation

This will take 30-45 minutes of collaborative discussion to:
  - Clarify requirements
  - Design technical approach
  - Identify edge cases
  - Define acceptance criteria
  - Configure execution

[If personal goals found]
Loaded personal goals for: <developer-name>
```

---

## Error Handling

### Cannot Create Folder
- Show specific system error
- Provide troubleshooting steps
- Check permissions, disk space, path length
- Cannot proceed without fixing

### Invalid File Reference
```bash
/asaf-init @missing-file.md
```

```
🔴 ERROR: File not found

Cannot find: missing-file.md

Please check:
  - File exists in project
  - Path is correct
  - You have read permissions

Try again with correct path or provide description directly:
  /asaf-init <sprint-name>
```

### Insufficient Requirements
If user provides very minimal description:
- Ask for more detail
- Give examples of good descriptions
- Don't proceed with insufficient info

---

## Context to Include

When executing this command, include:
- Current working directory
- Contents of asaf/ folder (to check for duplicates)
- Personal-goals.md (if exists)
- Current timestamp

---

## Post-Execution State

After successful completion:
- asaf/<sprint-name>/ folder exists
- .state.json shows: phase=grooming, status=ready
- SUMMARY.md initialized
- initial.md contains feature description
- Ready for /asaf-groom

---

## Usage Examples

### Example 1: Simple Init
```bash
User: /asaf-init add-authentication

Claude: 📝 Describe the feature you want to build:

User: Add user authentication with email and password. Users should be able to register, login, and logout. Need JWT tokens for session management.

Claude: ✅ Sprint initialized: add-authentication
[success message]
```

### Example 2: Init with File
```bash
User: /asaf-init @docs/auth-spec.md

Claude: ✅ Sprint initialized: auth-spec
[success message with content from file]
```

### Example 3: Duplicate Name
```bash
User: /asaf-init add-authentication

Claude: 🔴 ERROR: Sprint already exists
[error with options]
```

### Example 4: Invalid Name
```bash
User: /asaf-init "add auth & OAuth"

Claude: 🔴 ERROR: Invalid sprint name
[error with suggestions: add-auth-oauth]
```

---

## Design Notes

### Why Validate Early?
- Prevents wasted work
- Clear error messages before investing time
- Better UX than failing mid-process

### Why Ask for Description?
- Forces clarity upfront
- Becomes basis for grooming
- Documented for future reference

### Why .state.json AND SUMMARY.md?
- .state.json: Machine-readable, quick checks
- SUMMARY.md: Human-readable, comprehensive view
- Both serve different purposes

---

_Remember: This is the entry point to ASAF. Make it smooth and welcoming._
