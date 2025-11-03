# Template: Product Team Presentation

## Metadata

```yaml
audience: product-team
technical_depth: moderate
business_focus: moderate
code_examples: minimal
diagrams: user-flows-required
target_role: Product Managers, Product Owners, UX Designers
presentation_style: User-focused, balanced business and technical context
```

## Slide Sequence (15 min baseline)

**Total Slides**: 11-12 slides
**Pace**: ~1-1.5 minutes per slide
**Focus**: User problems, user flows, UX decisions, acceptance criteria, user metrics

### Slide Order (15 min)

1. **Title** (common/title.md)
2. **User Problem** (custom)
3. **User Flows & Journey** (with diagram)
4. **Solution Overview** (custom - user-facing features)
5. **UX Decisions & Rationale** (custom)
6. **Feature Comparison** (custom - before/after)
7. **Acceptance Criteria** (custom)
8. **Demo** (custom - user perspective)
9. **User Metrics & Success** (custom)
10. **Success Criteria** (custom)
11. **Next Features & Roadmap** (custom)
12. **Q&A** (common/qa.md)

---

## Length Adjustments

### 5 Minutes (Quick Product Brief)
**Slides**: 5-6 total
**Include**: [1, 2, 4, 8, 12]
- Title
- User Problem (pain points)
- Solution Overview (key features)
- Demo (user journey)
- Q&A

**Omit**: UX rationale, detailed flows, metrics, roadmap

---

### 30 Minutes (Product Review Meeting)
**Slides**: 18-20 total
**Add to 15min baseline**:
- Detailed User Personas (slide 2b) - Target user segments
- User Research Findings (slide 2c) - Research backing the solution
- Detailed Feature Breakdown (slide 4b) - Feature prioritization
- A/B Test Results (slide 9b) - Data-driven decisions
- User Feedback Summary (slide 9c) - Direct user quotes

---

### 45 Minutes (Product Planning Session)
**Slides**: 26-28 total
**Add to 30min**:
- Competitive Feature Analysis (slide 6b) - Market positioning
- User Story Workshop (slide 11b) - Interactive user story creation
- Product Metrics Dashboard (slide 9d) - Comprehensive analytics
- Long-term Product Vision (slide 11c) - Strategic roadmap discussion

---

## Content Mappings

These mappings define where to extract user-focused content from ASAF sprint documentation.

### Slide 2: User Problem
**Source**: `grooming/design.md`, `initial.md`
**Sections**:
- Problem Statement (from user perspective)
- User pain points
- Current user experience issues

**Format**:
```markdown
# The User Problem

## What Users Face Today
{extract: problem from design.md - reframe from user perspective}

## User Pain Points
- **Pain Point 1**: {user frustration from design.md}
- **Pain Point 2**: {user need from initial.md}
- **Pain Point 3**: {current limitation}

## User Impact
- **Productivity**: {how users are slowed down}
- **Experience**: {how users feel frustrated}
- **Outcomes**: {how user goals are blocked}

## User Quote
> "{hypothetical user quote capturing the pain}"
```

**Reframing Guide**:
- "System is slow" → "Users wait 30+ seconds for results, losing focus"
- "No validation" → "Users submit forms and lose data, requiring rework"
- "Complex workflow" → "Users need 10 clicks to complete a 2-step task"

---

### Slide 3: User Flows & Journey
**Source**: `grooming/design.md`, `grooming/acceptance-criteria.md`
**Sections**: User flows, interaction patterns

**Generate Flow Diagram**:
```markdown
# User Journey

```mermaid
flowchart TD
    Start[User starts task] --> Action1[{step 1 from design.md}]
    Action1 --> Decision{Decision point?}
    Decision -->|Path A| Success[✅ Task complete]
    Decision -->|Path B| Action2[{step 2}]
    Action2 --> Success

    style Start fill:#e1f5ff
    style Success fill:#d4edda
```

## Key User Actions
1. **{Action 1}**: {user goal from design.md}
2. **{Action 2}**: {interaction}
3. **{Action 3}**: {outcome}

## User Experience Goals
- {UX goal 1 from acceptance-criteria.md}
- {UX goal 2}
```

---

### Slide 4: Solution Overview
**Source**: `grooming/design.md`
**Sections**: Features, capabilities (user-facing only)

**Format**:
```markdown
# Our Solution

## User-Facing Features
### Feature 1: {Feature Name}
**What it does**: {user benefit from design.md}
**Why it matters**: {problem it solves}

### Feature 2: {Feature Name}
**What it does**: {user benefit}
**Why it matters**: {problem it solves}

### Feature 3: {Feature Name}
**What it does**: {user benefit}
**Why it matters**: {problem it solves}

## How Users Will Benefit
- {benefit 1 from acceptance-criteria.md}
- {benefit 2}
- {benefit 3}
```

---

### Slide 5: UX Decisions & Rationale
**Source**: `grooming/decisions.md`, `grooming/design.md`
**Sections**: Design decisions, UX considerations

**Format**:
```markdown
# UX Decisions

## Key Design Choices

### Decision 1: {UX Decision}
**What we chose**: {decision from decisions.md}
**Why**: {user-centered rationale}
**Alternative considered**: {other option}
**User benefit**: {how this helps users}

### Decision 2: {UX Decision}
**What we chose**: {decision}
**Why**: {rationale}
**Alternative considered**: {other option}
**User benefit**: {user impact}

## Design Principles Applied
- {principle 1 from design.md or standard: "Minimize clicks"}
- {principle 2 or standard: "Clear feedback"}
- {principle 3 or standard: "Error prevention"}
```

---

### Slide 6: Feature Comparison (Before/After)
**Source**: `grooming/design.md`, `initial.md`
**Sections**: Current state vs future state

**Format**:
```markdown
# Before & After

## User Experience Comparison

| Aspect | Before (Current) | After (With Solution) |
|--------|------------------|----------------------|
| **Time to complete task** | {current time} | {improved time} |
| **Steps required** | {current steps} | {reduced steps} |
| **Error rate** | {current errors} | {reduced errors} |
| **User satisfaction** | {current score} | {target score} |

## Feature-by-Feature

### {Feature 1}
- **Before**: {limitation from design.md}
- **After**: {capability}
- **Impact**: {user benefit}

### {Feature 2}
- **Before**: {limitation}
- **After**: {capability}
- **Impact**: {benefit}
```

---

### Slide 7: Acceptance Criteria
**Source**: `grooming/acceptance-criteria.md`
**Sections**: All acceptance criteria

**Format**:
```markdown
# Acceptance Criteria

## User Story Format

**As a** {user type}
**I want** {capability}
**So that** {benefit}

## Acceptance Criteria
{extract: all criteria from acceptance-criteria.md in Given/When/Then format}

### AC1: {Criterion Title}
- **Given** {precondition}
- **When** {user action}
- **Then** {expected outcome}
- **Status**: {✅ if implemented, ⏳ if pending}

{repeat for all acceptance criteria}

## Verification Method
{how each AC will be tested/verified}
```

---

### Slide 8: Demo (User Perspective)
**Source**: Sprint context, acceptance criteria
**Style**: Show from user's point of view

**Format**:
```markdown
# Demo: User Experience

## User Scenario
**User**: {persona name} - {role}
**Goal**: {what user wants to accomplish}
**Context**: {situation}

## Demo Flow (User POV)

### Step 1: {User Action}
**User does**: {interaction}
**System responds**: {feedback}
**User sees**: {outcome}

### Step 2: {User Action}
**User does**: {interaction}
**System responds**: {feedback}
**User sees**: {outcome}

{continue for key interactions}

## User Outcome
✅ {goal achieved}
⏱️ {time saved}
😊 {user satisfaction}
```

---

### Slide 9: User Metrics & Success
**Source**: `grooming/acceptance-criteria.md`, `implementation/progress.md`
**Sections**: User-focused metrics

**Format**:
```markdown
# Measuring User Success

## User Metrics

### Efficiency Metrics
- **Task Completion Time**: {target from AC or baseline}
- **Success Rate**: {target percentage}
- **Error Rate**: {target - should decrease}

### Satisfaction Metrics
- **User Satisfaction Score**: {target - e.g., 4.5/5}
- **Net Promoter Score**: {target if applicable}
- **Feature Adoption**: {target usage rate}

### Behavioral Metrics
- **Daily Active Users**: {target}
- **Feature Usage**: {target engagement}
- **Return Rate**: {target retention}

## How We'll Measure
{measurement methods from acceptance-criteria.md or standard: surveys, analytics, A/B tests}
```

---

### Slide 10: Success Criteria
**Source**: `grooming/acceptance-criteria.md`
**Sections**: Success definition

**Format**:
```markdown
# Definition of Success

## Must-Have (Launch Blockers)
- {critical AC 1 from acceptance-criteria.md}
- {critical AC 2}
- {critical AC 3}

## Should-Have (Post-Launch)
- {important AC 1}
- {important AC 2}

## Nice-to-Have (Future)
- {optional enhancement 1}
- {optional enhancement 2}

## Success Indicators
✅ All must-have criteria met
✅ User testing completed with positive feedback
✅ No critical bugs
✅ Performance meets targets
```

---

### Slide 11: Next Features & Roadmap
**Source**: `implementation/tasks.md`, `grooming/decisions.md`
**Sections**: Future enhancements, deferred features

**Format**:
```markdown
# Product Roadmap

## Immediate (This Sprint)
- ✅ {completed tasks from tasks.md}
- 🔄 {in-progress tasks}
- ⏳ {remaining tasks}

## Next Sprint
{extract: future tasks from tasks.md or future decisions from decisions.md}

## Future Enhancements
{extract: deferred features from decisions.md future section}

## User-Requested Features
{if user feedback available, else: "Collecting user feedback"}

## Vision
{long-term product vision - 1-2 sentences}
```

---

## Enhancement Insertion Points

When enhancements are selected:

- **Metrics**: Expand slide 9 with detailed analytics dashboard
- **Timeline**: Insert after slide 1 - product development timeline
- **Next Steps**: Already included by default (slide 11)

**Code Examples**: Only minimal, user-facing (e.g., API response format for integrations)

---

## Diagram Insertion Points

Product presentations benefit from user-centric diagrams:

- **Slide 3**: User flow diagram (required) - flowchart format
- **After Slide 3**: User journey map (if detailed user research available)
- **Slide 6**: Before/After comparison diagram (optional visual)

**NO**: Architecture diagrams, database schemas, technical flows

---

## Variable Placeholders

All slides can use these variables:
- `{sprint}` - Sprint name
- `{date}` - Generation date
- `{tagline}` - User-focused tagline
- `{user_persona}` - Primary user type (detected from design.md or generic)
- `{total_acs}` - Count from acceptance-criteria.md
- `{completed_acs}` - From progress.md or .state.json
- `{feature_count}` - Number of features (from design.md)
- `{user_benefit}` - Primary user benefit (extracted from problem statement)

---

## Notes for Content Generator

**Product Language Guidelines**:
- Focus on user problems and solutions
- Use "users" not "customers" or "clients" (internal product focus)
- Emphasize user experience and usability
- Balance business value with technical feasibility
- Include moderate technical detail when relevant to UX

**Tone**: User-centered, balanced, outcome-focused

**User Flow Guidelines**:
- Show user journey, not system architecture
- Focus on user actions and decisions
- Include happy path and key alternative flows
- Show error handling from user perspective

**Metrics Focus**:
- User-centric metrics (task completion, satisfaction)
- Behavioral analytics (engagement, adoption)
- Efficiency gains (time saved, fewer errors)
- Avoid technical metrics (latency, throughput)

**Fallbacks**:
- If user research missing: Create reasonable user persona
- If flows not documented: Extract from acceptance criteria
- If metrics missing: Use industry standard targets
- If UX decisions not explicit: Infer from acceptance criteria

**Balance**:
- 60% user experience and benefits
- 30% feature functionality
- 10% technical considerations (only where relevant to UX)
