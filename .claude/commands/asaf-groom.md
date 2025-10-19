# ASAF Groom Command

**Command**: `/asaf-groom`

**Purpose**: Conduct collaborative design conversation and generate grooming documents

**Duration**: 30-45 minutes (interactive)

---

## Prerequisites

### Check Sprint State

Read `.state.json` from current active sprint.

**Required**:
- phase must be "grooming"
- status must be "ready" or "in-progress"

**If no active sprint**:
```
🔴 ERROR: No active sprint

You must initialize a sprint before grooming.

Start with:
  /asaf-init <sprint-name>

Or resume existing:
  /asaf-list                  - See all sprints
  /asaf-resume <sprint-name>  - Resume specific sprint
```
**STOP execution.**

**If wrong phase**:
```
🔴 ERROR: Sprint is in <current-phase> phase

Grooming can only happen in the grooming phase.

Current sprint: <sprint-name>
Phase: <current-phase>

[If already groomed]
Grooming was completed on <date>.
To proceed: /asaf-groom-approve

[If past grooming]
This sprint is past the grooming phase.
To start over: /asaf-init <new-sprint-name>
```
**STOP execution.**

---

## Load Context

Before starting conversation, load:

1. **Feature description**: Read `asaf/<sprint>/initial.md`

2. **Personal goals**: Look for `personal-goals.md` in order:
   - Project root: `./personal-goals.md` (project-specific)
   - Home directory: `~/.claude/personal-goals.md` (global)
   - If neither exists: continue without personal goals (optional feature)

3. **Codebase context**:
   - Scan project structure (top-level directories)
   - Read package.json / requirements.txt / Cargo.toml (detect stack)
   - Identify existing patterns (middleware/, models/, services/, etc.)

4. **Existing sprint context**: Check if grooming/ folder exists (resuming?)

---

## Launch Grooming Agent (Task Tool)

**STOP:** Do NOT conduct the grooming conversation yourself in this context.

**REQUIRED ACTION:** You MUST use the Task tool to launch a sub-agent.

**Step 1:** Show the user:
```
🚀 Launching dedicated grooming agent with fresh context...
```

**Step 2:** Use the Task tool - invoke it with these exact parameters:

**Task Tool Invocation:**
- **subagent_type**: general-purpose
- **description**: ASAF grooming conversation
- **prompt**: [The full agent prompt below]

**Agent Prompt to pass:**

```
You are the ASAF Grooming Agent conducting a design conversation.

CRITICAL: Read the complete grooming agent persona from:
`.claude/commands/shared/grooming-agent.md`

This file contains your full behavior, conversation style, and all phase instructions.

CONTEXT PROVIDED:

Sprint name: [insert sprint name from .state.json]

Feature description (from initial.md):
[insert full content of initial.md]

Personal goals (if found):
[insert content of personal-goals.md or "No personal goals file found"]

Codebase context:
- Detected stack: [e.g., TypeScript + Express + Prisma from package.json]
- Project structure: [brief directory overview]

YOUR TASK:

Follow the complete conversation flow defined in grooming-agent.md:

1. Phase 1 - Understanding (5-10min): Problem, users, success
   → WRITE: initial grooming/design.md

2. Phase 2 - Technical Design (10-15min): Architecture, data, flows
   → UPDATE: grooming/design.md
   → CREATE: grooming/decisions.md

3. Phase 3 - Edge Cases (5-10min): Failure scenarios
   → WRITE: grooming/edge-cases.md

4. Phase 4 - Acceptance Criteria (5min): Success tests
   → WRITE: grooming/acceptance-criteria.md

5. Phase 5 - Execution Planning (3min): Executor & reviewer config
   → UPDATE: grooming/decisions.md

CRITICAL REMINDERS:
- Write files INCREMENTALLY (after each phase, not at end)
- ONE question at a time
- After each phase, say: "Let me document this..." then write the file
- Use Read tool to check if files exist (resuming grooming)
- Search codebase for existing patterns
- Search web for best practices
- Target minimums: 10 edge cases, 5 acceptance criteria

At end:
- Write grooming/conversation-log.md
- Update SUMMARY.md
- Update .state.json (phase: "grooming", status: "complete")
- Show completion message from grooming-agent.md

Begin now.
```

---

## After Agent Completes

When the grooming agent returns, verify files were created:

**Check for:**
- ✅ `grooming/design.md`
- ✅ `grooming/edge-cases.md`
- ✅ `grooming/acceptance-criteria.md`
- ✅ `grooming/decisions.md`
- ✅ `grooming/conversation-log.md`
- ✅ `SUMMARY.md` updated
- ✅ `.state.json` updated

**If any missing:**
```
⚠️ Grooming incomplete - some files missing

Expected files not found:
- [list missing files]

This may indicate the conversation was interrupted.

Options:
  /asaf-groom          - Resume grooming
  /asaf-status         - Check current state
```

**If all present:**

Show user the completion summary (agent already showed it, just confirm):

```
✅ Grooming completed successfully!

All documents created. Review them in grooming/ folder.

When ready to proceed:
  /asaf-groom-approve
```

---

## Why Use Task Tool?

**Benefits:**
- ✅ Fresh context for grooming (not accumulated from /asaf-init)
- ✅ True separation between command orchestration and grooming conversation
- ✅ Agent can re-read files if it forgets (files written incrementally)
- ✅ Clearer state boundaries
- ✅ User sees "Grooming agent running..." (clear what's happening)

**Trade-offs:**
- Agent start/stop messages visible to user
- Need to explicitly pass context (but this is good - forces clarity)

---

## Original Conversation Flow (For Reference)

### Phase 1: Understanding (5-10 min)

Walk through these questions, **one at a time**:

1. **Problem & Users**
   - "Let me make sure I understand what we're building. [Paraphrase initial.md]. Is that accurate?"
   - "Who are the primary users? End customers? Internal team? API consumers?"
   - "What problem does this solve for them? What's painful about the current situation?"

2. **Success Criteria**
   - "What does success look like? How will we know this works well?"
   - "Are there any metrics or user feedback that would indicate success?"

3. **Scope Boundaries**
   - "What's explicitly IN scope for this sprint?"
   - "What's out of scope or deferred to future work?"
   - "Are there any constraints? (Timeline, dependencies, technical limits)"

4. **Related Work**
   - **Search codebase** for similar features
   - "I found [existing pattern/feature]. Should we follow that approach?"
   - "Are there any existing features this depends on or integrates with?"

---

### Phase 2: Technical Design (10-15 min)

Walk through architecture and technical choices:

1. **Approach Options**
   - Present 2-3 approaches with trade-offs
   - "For [problem], I see these approaches: [Option A: pros/cons], [Option B: pros/cons]. Which feels right?"
   - Let developer choose, explain rationale

2. **Data & State**
   - "What data needs to be stored?"
   - "Where should it live? (Database, cache, state management)"
   - "What's the data model? What fields, relationships?"

3. **Component Breakdown**
   - "What are the main components/modules needed?"
   - "How do they interact?"
   - **Search codebase** for existing patterns to follow

4. **User/Data Flows**
   - Walk through step-by-step: "User does X → System does Y → Result is Z"
   - Identify each decision point and branch

5. **Technology Choices**
   - "For [need], should we use [library A] or [library B]?"
   - **Search web** for best practices if unfamiliar
   - Present pros/cons, let developer decide

6. **Security & Performance**
   - "Any security considerations? (Auth, validation, injection risks)"
   - "Performance concerns? (Expected load, optimization needs)"

**Document key decisions with rationale as you go.**

---

### Phase 3: Edge Cases (5-10 min)

Systematically identify what could go wrong:

1. **Input Validation**
   - "What if user enters invalid format?"
   - "What if required field is missing?"
   - "What about malicious input?"

2. **State & Concurrency**
   - "What if two requests happen simultaneously?"
   - "What if data becomes stale?"
   - "Race conditions?"

3. **External Dependencies**
   - "What if the database is unavailable?"
   - "What if API call times out?"
   - "What if third-party service is down?"

4. **Security**
   - "How could someone try to bypass security?"
   - "Token theft scenarios?"
   - "Privilege escalation?"

5. **Performance & Scale**
   - "What if 1000 users hit this endpoint simultaneously?"
   - "What if data grows to millions of records?"
   - "Need rate limiting?"

6. **User Experience**
   - "How do we show errors clearly?"
   - "What if operation takes a long time?"
   - "How can user recover from errors?"

**For each edge case**:
- Confirm: "What should happen in this scenario?"
- Document: Trigger → Handling → Test approach

**Target**: Minimum 10 edge cases across categories.

**If falling short**:
```
"We've identified [N] edge cases so far. Let's think through a few more to ensure we're covered. What about [suggest category]?"
```

---

### Phase 4: Acceptance Criteria (5 min)

Define testable success conditions:

1. **For each major capability**:
   - "What must work for this to be considered complete?"
   - Convert to: "As a [user], I want [capability], so that [benefit]"
   - Add test: "Given [context], when [action], then [outcome]"

2. **Link to edge cases**:
   - "This criterion covers edge cases #1, #3, #5"

3. **Definition of Done**:
   - Code implemented
   - Tests passing
   - Documentation updated
   - Edge cases handled

**Target**: Minimum 5 acceptance criteria.

**Example dialogue**:
```
"Let's define acceptance criteria. For user registration, what must be true?"

Developer: "User can create account with email and password"

"Good. Let me frame that:

**AC1: User Registration**
- Story: As a new user, I want to create an account, so I can access features
- Test: Given valid email/password, when I submit registration, then account is created and I'm logged in
- This covers edge cases #1 (invalid email), #2 (duplicate), #3 (weak password)
- DoD: Endpoint works, tests pass, validation clear

Does that capture it?"
```

---

### Phase 5: Execution Planning (3 min)

Configure how implementation will run:

1. **Detect Stack**
   - From package.json / requirements.txt: "I see you're using [language/framework]"
   - Choose executor profile: "I'll use [typescript-fullstack-executor / python-backend-executor / etc.]"

2. **Choose Reviewer Mode**
   - **If personal goals exist**:
     - Read experience level
     - Read learning goals
     - Propose mode: "You're [senior/mid/junior] in [area] and learning [goal]. I'd suggest [Supportive Mentor / Educational / Harsh Critic] mode. Thoughts?"
   - **If no personal goals**:
     - Default to Supportive Mentor
     - Explain: "I'll use Supportive Mentor mode - balanced feedback with guidance. You can change this in personal-goals.md if you prefer."

3. **Task Patterns**
   - "Standard pattern: executor → test → reviewer → iterate"
   - "Max 3 iterations per task (we can adjust for specific tasks)"
   - "If blocked after 3 attempts, I'll escalate to you"

4. **Estimate**
   - Based on complexity: "I estimate [4-6 hours] for [N] tasks"
   - "Does that match your expectation?"

---

## Generate Documents

After conversation complete, create files in `grooming/`:

### 1. design.md

```markdown
# Design Document: [Sprint Name]

## Overview

[2-3 paragraph summary of what we're building and why]

## Architecture

### Components

1. **[Component Name]**
   - **Responsibility**: [What it does]
   - **Location**: `path/to/component`
   - **Key Functions**: [List main functions/methods]
   - **Dependencies**: [What it depends on]

[Repeat for each component]

### Data Models

**[Model Name]** (`path/to/model`)
```language
[Schema definition with comments]
```

[Repeat for each model]

### User Flows

**[Flow Name]** (e.g., Registration Flow)
1. [Step 1]
2. [Step 2]
3. [Step 3]
...

[Repeat for each major flow]

### Technology Decisions

**[Technology/Library]**: [Chosen option]
- **Alternatives considered**: [Other options]
- **Rationale**: [Why this choice]

### Security Considerations

- [Security measure 1]
- [Security measure 2]
...

### Performance Considerations

- [Performance consideration 1]
- [Performance consideration 2]
...

### Dependencies

**New Dependencies**:
- `library-name` - [Purpose]

**Existing Code to Leverage**:
- `existing/module` - [How we'll use it]

---

_Generated from grooming session on [date]_
```

---

### 2. edge-cases.md

```markdown
# Edge Cases: [Sprint Name]

## Input Validation

### 1. [Edge Case Name]
**Scenario**: [What triggers this]
**Handling**: [How we'll handle it]
**Test Approach**: [How we'll test it]
**Priority**: High / Medium / Low

[Repeat for each edge case in category]

## Authentication & Authorization

[Edge cases in this category]

## State & Concurrency

[Edge cases in this category]

## External Dependencies

[Edge cases in this category]

## Security

[Edge cases in this category]

## Performance & Scale

[Edge cases in this category]

## User Experience

[Edge cases in this category]

---

## Summary

**Total Edge Cases**: [Count]
**Critical**: [Count requiring special attention]
**Coverage**: All categories addressed

---

_Generated from grooming session on [date]_
```

---

### 3. acceptance-criteria.md

```markdown
# Acceptance Criteria: [Sprint Name]

## AC1: [Capability Name]

**User Story**: As a [user type], I want [capability], so that [benefit]

**Acceptance Test**:
```gherkin
Given [preconditions]
When [action]
Then [expected outcome]
And [additional outcomes]
```

**Edge Cases Covered**:
- ✅ Edge case #[N]: [Name]
- ✅ Edge case #[N]: [Name]

**Definition of Done**:
- [ ] [Implementation requirement]
- [ ] [Test requirement]
- [ ] [Documentation requirement]

---

[Repeat for each acceptance criterion]

---

## Summary

**Total Acceptance Criteria**: [Count]
**Estimated Tests**: ~[Count] (unit + integration)

All criteria must be met before sprint is considered complete.

---

_Generated from grooming session on [date]_
```

---

### 4. decisions.md

```markdown
# Technical Decisions: [Sprint Name]

## Stack & Tooling

**Language**: [Language]
**Framework**: [Framework]
**Database**: [Database + ORM]
**Testing**: [Test framework]
**Additional Libraries**: [List]

**Rationale**: [Why this stack]

---

## Execution Configuration

### Executor Profile
**Profile**: `[executor-profile-name]`

**Capabilities**:
- [Language] syntax and idioms
- [Framework] patterns
- [Testing framework] conventions
- [Other relevant skills]

**Rationale**: [Why this profile for this sprint]

---

### Reviewer Configuration

**Mode**: [Harsh Critic / Supportive Mentor / Educational / Quick Review]

**Rationale**: [Based on personal goals and experience level]

**Reviewer Behavior**:
- [Expected behavior 1]
- [Expected behavior 2]

**Focus Areas**:
- [What reviewer should emphasize]
- [Based on learning goals]

---

### Task Execution

**Default Pattern**: executor → test → reviewer → executor
**Max Iterations**: 3 per task
**Special Cases**: [Any tasks needing different treatment]

---

## Key Technical Decisions

### [Decision Category]

**Decision**: [What was decided]
**Alternatives Considered**: [Other options]
**Rationale**: [Why this choice]
**Trade-offs**: [What we're giving up / gaining]

[Repeat for each major decision]

---

## Out of Scope

The following are explicitly out of scope for this sprint:

1. **[Feature]**: [Why deferred]
2. **[Feature]**: [Why deferred]

These may become future sprints.

---

## Decision Log

| Date | Decision | Rationale | Decided By |
|------|----------|-----------|------------|
| [Date] | [Decision] | [Why] | Developer + Grooming Agent |

---

_Generated from grooming session on [date]_
```

---

### 5. conversation-log.md

```markdown
# Grooming Conversation: [Sprint Name]

**Date**: [Timestamp]
**Duration**: [Approximate duration]
**Developer**: [Name from personal-goals.md or "Developer"]

---

[Full transcript of the grooming Q&A session]

[Preserve the entire conversation for future reference]

---

_This log captures the full context of design decisions for future reference._
```

---

## Update State and Summary

### Update .state.json

```json
{
  "sprint": "[sprint-name]",
  "type": "full",
  "phase": "grooming",
  "status": "complete",
  "grooming_approved": false,
  "planning_complete": false,
  "created": "[original timestamp]",
  "updated": "[current timestamp]",
  "grooming_completed_at": "[current timestamp]"
}
```

---

### Update SUMMARY.md

Add these sections:

```markdown
## 🎯 Key Decisions

**Technical Stack**:
- [Stack details]

**Approach**:
- [High-level approach]

**Execution**:
- Executor: [Profile]
- Reviewer: [Mode]

[See grooming/decisions.md for full details]

---

## ⚠️ Edge Cases Identified

Total: [Count] edge cases across [N] categories

**Critical**:
- [High-priority edge case]
- [High-priority edge case]

[See grooming/edge-cases.md for complete list]

---

## ✅ Acceptance Criteria

Total: [Count] criteria defined

1. [Criterion 1 summary]
2. [Criterion 2 summary]
...

[See grooming/acceptance-criteria.md for full details]

---

## 📊 Sprint Progress

- [x] Initialization
- [x] Grooming
- [ ] Planning
- [ ] Implementation
- [ ] Demo
- [ ] Retrospective

---

_Updated after grooming session on [date]_
```

---

## Completion Message

```
✅ Grooming complete!

Documents created (written incrementally during our conversation):
  ✓ grooming/design.md (architecture, components, flows)
  ✓ grooming/edge-cases.md ([count] scenarios identified)
  ✓ grooming/acceptance-criteria.md ([count] criteria defined)
  ✓ grooming/decisions.md (technical choices + rationale)
  ✓ grooming/conversation-log.md (full Q&A preserved)

Updated SUMMARY.md with key information.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Quick Summary:

**What We're Building**:
[1-2 sentence summary]

**Key Decisions**:
- [Decision 1]
- [Decision 2]
- [Decision 3]

**Edge Cases**: [Count] identified and documented
**Acceptance Criteria**: [Count] defined with tests
**Estimated Complexity**: [Low/Medium/High]
**Estimated Time**: [Hours]

[If personal goals involved]
**Learning Focus**: This sprint aligns with your goal of "[goal]"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Next Step**: Please review the documents in grooming/ folder.

When ready to proceed with implementation planning, run:

  /asaf-groom-approve

This will lock grooming and generate the task breakdown.
```

---

## Error Handling

### Context Window Approaching Limit

If conversation exceeds ~40,000 tokens:

```
🟡 WARNING: Conversation getting lengthy

To preserve context, I'll now:
1. Summarize our discussion
2. Generate all documents
3. Offer to continue if needed

[Generate summary]

Documents generated with current progress.

To complete remaining items:
  /asaf-groom-continue

Or if satisfied:
  /asaf-groom-approve
```

### Grooming Session Interrupted

If user needs to stop mid-session:

```
Session paused.

Progress saved:
- Partial documents created
- Conversation logged
- State preserved

Resume anytime with:
  /asaf-groom
```

The command should resume where it left off.

### Insufficient Detail

If reaching end of session without minimum requirements:

```
⚠️ Grooming incomplete

Missing:
- [ ] Edge cases (found [N], need minimum 10)
- [ ] Acceptance criteria (found [N], need minimum 5)

Cannot proceed to implementation without these.

Options:
  /asaf-groom-continue  - Continue this session
  /asaf-groom-force     - Proceed anyway (not recommended)
```

---

## Context Management

**What to keep in context**:
- Current conversation
- Feature description
- Personal goals
- Key decisions made so far

**What to archive**:
- Old Q&A once decisions documented
- Excessive detail (keep summaries)
- Full conversation → conversation-log.md

**When to summarize**:
- Every 10,000 tokens
- At phase transitions
- Before generating documents

---

## Quality Checklist

Before marking grooming complete, verify:

- [ ] Requirements are clear and specific
- [ ] Technical approach is justified with trade-offs
- [ ] Minimum 10 edge cases identified
- [ ] Edge cases span multiple categories
- [ ] Minimum 5 acceptance criteria defined
- [ ] All decisions have rationale
- [ ] Executor profile selected
- [ ] Reviewer mode chosen with reasoning
- [ ] Personal goals referenced (if applicable)
- [ ] All documents generated successfully

If any missing, continue conversation to complete.

---

_Remember: Grooming is an investment. Thorough design now prevents bugs and rework later._
