# ASAF Retrospective Command

**Command**: `/asaf-retro`

**Purpose**: Reflect on learnings and process improvements

**Duration**: 10-15 minutes (interactive)

---

## Prerequisites

Check `.state.json`:
- demo must be complete (or skipped)
- phase should be "retro" or "demo"

If not ready:
```
ℹ️ Retrospective not ready yet

Current phase: [phase]

[If demo not done]
Demo should be completed first (or skipped).

Options:
  /asaf-demo          - Generate demo
  /asaf-demo-skip     - Skip demo, go to retro
```

---

## Load Context

Read entire sprint history:
1. **Initial**: initial.md (what was requested)
2. **Grooming**: All grooming docs (design decisions)
3. **Implementation**: progress.md (what happened)
4. **Demo**: presentation.md (what was delivered)
5. **Personal Goals**: personal-goals.md (learning objectives)
6. **Metrics**: Calculate from all sources

---

## Retrospective Conversation

**Adopt Retrospective Agent persona** - reflective, growth-oriented, honest.

### Opening Message

```
🎓 Sprint Retrospective: [sprint-name]

Let's reflect on what we learned and how to improve.

Sprint summary:
  - Duration: [total time]
  - Tasks: [X]/[N] completed
  - Tests: [X] written, [X] passing
  - Iterations: [X] total

[If personal goals exist]
Your learning goals for this sprint:
  - [Goal 1]
  - [Goal 2]

This retrospective will take about 10-15 minutes.
We'll discuss what went well, what to improve, and what you learned.

Ready to begin?
```

Wait for confirmation.

---

### Phase 1: Overall Experience (2-3 min)

**Questions to explore**:

1. "How did this sprint feel overall? On a scale of 1-10, how would you rate the experience?"

2. "What stands out to you most about this sprint?"

3. [If rating is low] "What made it challenging?"
   [If rating is high] "What made it work well?"

---

### Phase 2: What Went Well (3-4 min)

**Questions to explore**:

1. "What are you most proud of from this sprint?"

2. "Which part of the process was most valuable?"
   - Grooming conversation?
   - Implementation automation?
   - Code review cycles?
   - Something else?

3. "Were there any 'aha moments' or breakthroughs?"

4. [If tasks completed quickly] "Task [X] went perfectly on first try. What made that work well?"

5. [If high test coverage] "You achieved [X]% test coverage. How did that feel?"

**Document positives** for what-went-well.md

---

### Phase 3: What Could Be Improved (3-4 min)

**Questions to explore**:

1. "What was harder than expected?"

2. [If tasks required multiple iterations] "Task [X] needed [Y] iterations. What made it challenging?"

3. "Was there anything frustrating about the process?"

4. "If you could change one thing about this sprint, what would it be?"

5. [If grooming took long] "Grooming took [X] minutes. Was that time well spent, or could it be shorter?"

6. "Did the code review feedback help you, or was it confusing?"

**Document improvements** for improvements.md

---

### Phase 4: Learning & Growth (3-4 min)

**Connect to personal goals**:

1. [Reference personal goal] "You wanted to learn [goal]. Did this sprint help with that?"

2. "What's the most important thing you learned technically?"
   - New pattern?
   - Library/tool?
   - Best practice?
   - Debugging technique?

3. "What did you learn about the development process?"
   - Planning better?
   - Testing approach?
   - Communication?

4. "Is there something you want to explore deeper based on this sprint?"

**Document learnings** for learnings.md

---

### Phase 5: Personal Goals Update (2-3 min)

**Review progress on goals**:

1. [For each goal] "Your goal was '[goal]'. How much progress did you make?"
   - Achieved (ready to move on)
   - In Progress (made progress, need more)
   - No Progress (didn't focus on this)

2. "Do you want to add any new learning goals based on this experience?"

3. "Should we update your reviewer preferences?"
   - If learned a lot: Maybe want more challenge (Harsh Critic)
   - If struggled: Maybe want more support (Educational)

**Prepare personal goal updates**

---

## Generate Retrospective Documents

### 1. learnings.md

```markdown
# Sprint Learnings: [Sprint Name]

**Date**: [Timestamp]
**Duration**: [Total time]

---

## Technical Learnings

### [Topic/Skill]
**What I learned**: [Description]
**How it helps**: [Benefit]
**Pattern to remember**: [Key takeaway]

**Example**:
```[language]
[Code snippet showing the learning]
```

[Repeat for each technical learning]

---

## Process Learnings

### [Process Insight]
**Discovery**: [What was learned about the process]
**Impact**: [How this affects future sprints]
**Action**: [What to do differently]

[Repeat for each process insight]

---

## Personal Goal Progress

### Goal: "[Goal from personal-goals.md]"
**Status**: ✅ Achieved / 🔄 In Progress / ⬜ No Progress

**Progress Made**:
- [Specific achievement]
- [Skill gained]
- [Understanding deepened]

**Evidence**:
- [Reference to implementation]
- [Tests written]
- [Problem solved]

**Next Level**: [What's the next step for this goal]

[Repeat for each goal]

---

## Reusable Patterns Discovered

1. **[Pattern Name]**
   - **Context**: [When to use]
   - **Implementation**: [How it works]
   - **Reference**: [Where implemented in this sprint]

[Repeat for patterns worth remembering]

---

## Questions for Next Sprint

- [Question raised by this sprint]
- [Area to explore]
- [Technique to try]

---

_Retrospective completed [date]_
```

---

### 2. what-went-well.md

```markdown
# What Went Well: [Sprint Name]

These are successes to repeat in future sprints.

---

## Process Successes

### [Success 1]
**What happened**: [Description]
**Why it worked**: [Reason]
**Repeat by**: [How to do this again]

[Repeat for each process success]

---

## Technical Successes

### [Success 1]
**What happened**: [Achievement]
**Impact**: [Result]
**Why it worked**: [Reason]

[Repeat for technical successes]

---

## Efficiency Wins

[If tasks completed in 1 iteration]
- **[X] tasks completed perfectly on first try**
  - Task [N]: [Name]
  - Reason: [Why it went smoothly]

[If high test coverage]
- **Excellent test coverage: [X]%**
  - Comprehensive edge case testing
  - Prevented bugs before they happened

[If good time estimates]
- **Accurate time estimates**
  - Estimated: [X] hours
  - Actual: [Y] hours
  - Delta: [Small difference]

---

## Collaboration Wins

[If code reviews helpful]
- **Effective code reviews**
  - [Specific helpful feedback]
  - Improved implementation quality

[If grooming valuable]
- **Thorough grooming**
  - Edge cases identified upfront
  - Prevented [X] bugs

---

## Learning Wins

- Achieved learning goal: "[goal]"
- New skill acquired: [skill]
- Deeper understanding of: [topic]

---

_Document successes to build on them._
```

---

### 3. improvements.md

```markdown
# Areas for Improvement: [Sprint Name]

These are opportunities to improve future sprints.

---

## Process Improvements

### [Improvement Area 1]
**What happened**: [Issue]
**Impact**: [How it affected sprint]
**Root cause**: [Why it happened]
**Suggested fix**: [How to improve]
**Priority**: High / Medium / Low

[Repeat for each process improvement]

---

## Technical Improvements

### [Improvement Area 1]
**What happened**: [Issue]
**Learning**: [What this taught]
**Next time**: [How to handle better]

[Repeat for technical improvements]

---

## Iteration Analysis

[If tasks needed multiple iterations]
**Tasks requiring rework**:
- Task [N]: [Name] ([X] iterations)
  - Why: [Reason for iterations]
  - Lesson: [What to do differently]

**Pattern**: [If there's a common pattern]
**Action**: [How to reduce iterations next time]

---

## Time Management

[If took longer than expected]
**Estimated**: [X] hours
**Actual**: [Y] hours
**Difference**: [Z] hours

**Reasons**:
- [Reason 1]
- [Reason 2]

**Adjustments for next sprint**:
- [Adjustment 1]
- [Adjustment 2]

---

## Tool/Process Suggestions

**ASAF Process**:
- [Suggestion for improving ASAF workflow]
- [Command that could be better]
- [Feature that would help]

**Development Tools**:
- [Tool that would have helped]
- [Library to consider]

---

## Next Sprint Prep

Based on this retrospective:
- [ ] [Action item 1]
- [ ] [Action item 2]
- [ ] [Action item 3]

---

_Improvements drive continuous growth._
```

---

### 4. Suggested Personal Goals Updates

Create a proposed update to `personal-goals.md`:

```markdown
# Suggested Updates to Personal Goals

Based on retrospective of: [sprint-name]

---

## Current Goals - Progress Update

### "[Goal 1]"
**Current status**: In Progress
**Suggested update**: ✅ Achieved

**Reason**: 
- [Evidence from sprint]
- [Achievement]

**New goal to replace it**: "[Suggested next level goal]"

---

### "[Goal 2]"
**Current status**: In Progress
**Suggested update**: Keep as is (continue working on it)

**Reason**:
- Made progress but not complete
- [Specific area to focus on next]

---

## New Goals to Add

Based on discoveries in this sprint:

### "[New Goal 1]"
**Why**: [Reason based on sprint experience]
**Next steps**: [How to work on this]

### "[New Goal 2]"
**Why**: [Reason]
**Next steps**: [How to work on this]

---

## Reviewer Preferences Update

**Current**: [Current mode]
**Suggested**: [New mode if change recommended]

**Reason**: [Why the change, based on sprint experience]

---

**Apply these updates?** (y/n)

[If yes, update personal-goals.md]
[If no, keep suggestions for manual review]
```

---

## Update State

```json
{
  "phase": "complete",
  "status": "complete",
  "retro_completed_at": "[timestamp]",
  "sprint_complete": true
}
```

---

## Update SUMMARY.md

Add final section:

```markdown
## 🎓 Retrospective

**Completed**: [date/time]

### What Went Well
- [Key success 1]
- [Key success 2]
- [Key success 3]

[Full list: retro/what-went-well.md]

### Areas for Improvement
- [Improvement area 1]
- [Improvement area 2]

[Full details: retro/improvements.md]

### Key Learnings

**Technical**:
- [Learning 1]
- [Learning 2]

**Process**:
- [Learning 1]
- [Learning 2]

**Personal Goals**:
- [Goal]: ✅ Achieved
- [Goal]: 🔄 In Progress

[Full retrospective: retro/learnings.md]

---

## 📊 Sprint Progress

- [x] Initialization
- [x] Grooming
- [x] Planning
- [x] Implementation
- [x] Demo
- [x] Retrospective ← _Complete!_

---

## 🎉 Sprint Complete!

**Total Duration**: [time from start to finish]

**Final Results**:
- Tasks: [X]/[N] completed ([%]%)
- Tests: [X] passing
- Coverage: [%]%
- Learning goals: [X] achieved, [Y] in progress

**What's Next**:
- [Suggested follow-up 1]
- [Suggested follow-up 2]

**Reusable Artifacts**:
This sprint's patterns and learnings can inform future work.

---

_Sprint completed on [date]_
```

---

## Completion Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Sprint Complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sprint: [name]
Total Duration: [start to finish]

**Retrospective Generated**:
  ✓ retro/learnings.md
  ✓ retro/what-went-well.md
  ✓ retro/improvements.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Sprint Summary:

**Achievements**:
  - Tasks: [X]/[N] completed ([%]%)
  - Tests: [X] written, [X] passing
  - Learning: [X] goals achieved

**Time**:
  - Grooming: [duration]
  - Implementation: [duration]
  - Total: [duration]

**Quality**:
  - Average iterations: [X] per task
  - Test coverage: [%]%
  - All edge cases handled: ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎓 Key Learnings:

[Top 3 learnings from learnings.md]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📈 Personal Growth:

[If goals achieved]
✅ Achieved: "[goal name]"
   Next level: "[suggested next goal]"

[If goals in progress]
🔄 Progress: "[goal name]"
   Keep working on: [focus area]

[If personal goals updated]
✅ Personal goals updated in: [location]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Complete Sprint Documentation:

  asaf/[sprint]/SUMMARY.md         # Overview
  asaf/[sprint]/grooming/          # Design
  asaf/[sprint]/implementation/    # Execution
  asaf/[sprint]/demo/              # Presentation
  asaf/[sprint]/retro/             # Learnings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 What's Next:

[If follow-up items identified]
Suggested next sprints:
  - [Suggestion 1]
  - [Suggestion 2]

[If patterns discovered]
Reusable patterns from this sprint:
  - [Pattern 1]
  - [Pattern 2]

Start a new sprint:
  /asaf-init <name>
  /asaf-express "<requirements>"

Great work! 🎯
```

---

## Error Handling

### No Sprint Data

```
🔴 ERROR: Cannot run retrospective

Sprint data incomplete:
  - Missing implementation/progress.md
  - Or sprint never completed

Retrospective requires completed sprint.

Options:
  /asaf-status     - Check sprint status
  /asaf-list       - See all sprints
```

---

## Context to Include

- Entire sprint history
- All phase documents
- Metrics from all sources
- Personal goals
- Developer's responses during retro

---

_Retrospective completes the learning cycle and prepares for future growth._
