# Template: Technical Team Presentation

## Metadata

```yaml
audience: technical-team
technical_depth: high
business_focus: low
code_examples: yes
diagrams: required
target_role: Engineers, Architects, Technical Leads
presentation_style: Deep technical dive with implementation details
```

## Slide Sequence (15 min baseline)

**Total Slides**: 12-14 slides
**Pace**: ~1-1.5 minutes per slide
**Focus**: Architecture, implementation, edge cases, testing

### Slide Order (15 min)

1. **Title** (common/title.md)
2. **Technical Context** (custom)
3. **Architecture Overview** (with diagram)
4. **Implementation Details** (with code examples)
5. **Edge Cases & Handling** (custom)
6. **Testing Strategy** (custom)
7. **Demo Walkthrough** (custom)
8. **Performance Considerations** (custom)
9. **Security Analysis** (custom)
10. **Deployment Approach** (custom)
11. **Monitoring & Observability** (custom)
12. **Next Steps & Roadmap** (custom)
13. **Q&A** (common/qa.md)

---

## Length Adjustments

### 5 Minutes (Quick Technical Overview)
**Slides**: 5-6 total
**Include**: [1, 2, 3, 7, 13]
- Title
- Technical Context (problem + constraints)
- Architecture (high-level diagram)
- Demo (key functionality)
- Q&A

**Omit**: Implementation details, edge cases, testing, performance, security, deployment, monitoring

---

### 30 Minutes (Comprehensive Technical Deep Dive)
**Slides**: 22-25 total
**Add to 15min baseline**:
- Detailed Implementation (slide 4b) - Code walkthrough with patterns
- Deep Dive Edge Cases (slide 5b) - All edge cases with code examples
- Load Testing Results (slide 8b) - Performance benchmarks and analysis
- API Documentation (slide 10b) - Endpoint specs and examples
- CI/CD Pipeline (slide 10c) - Deployment automation details

---

### 45 Minutes (Workshop-Style Technical Session)
**Slides**: 32-35 total
**Add to 30min**:
- Interactive Workshop Exercise (slide 7b) - Hands-on coding challenge
- Troubleshooting Common Issues (slide 11b) - Debug scenarios
- Future Enhancements Discussion (slide 12b) - Technical roadmap brainstorming
- Extended Q&A (slide 13b) - Deep dive Q&A session

---

## Content Mappings

These mappings define where to extract content for each slide from the ASAF sprint documentation.

### Slide 2: Technical Context
**Source**: `grooming/design.md`
**Sections**:
- Problem Statement (lines ~10-30)
- Technical Constraints (if present)
- Current System Issues (if present)

**Format**:
```markdown
# Technical Context

## The Problem
{extract: problem statement from design.md}

## Technical Constraints
- {constraint 1 from design.md}
- {constraint 2}
- {constraint 3}

## Why This Solution?
{extract: rationale from design.md or decisions.md}
```

---

### Slide 3: Architecture Overview
**Source**: `grooming/design.md`
**Sections**:
- Architecture section
- Component diagrams (if present)
- System design

**Diagram**: Generate mermaid architecture diagram if diagrams=yes

**Format**:
```markdown
# Architecture Overview

{extract: architecture description from design.md}

```mermaid
{generate: architecture diagram from design.md components}
```

## Key Components
- **{Component 1}**: {description from design.md}
- **{Component 2}**: {description}
- **{Component 3}**: {description}
```

---

### Slide 4: Implementation Details
**Source**: `implementation/progress.md` OR `grooming/design.md`
**Sections**:
- Code snippets from progress.md
- Implementation notes
- Technical decisions from decisions.md

**Format**:
```markdown
# Implementation Highlights

## Core Logic
```{language}
{extract: key code snippet from progress.md or design.md}
```

## Technical Decisions
- **{Decision 1}**: {rationale from decisions.md}
- **{Decision 2}**: {rationale}

## Patterns Used
- {pattern 1 from design.md or decisions.md}
- {pattern 2}
```

---

### Slide 5: Edge Cases & Handling
**Source**: `grooming/edge-cases.md`
**Sections**: Extract top 5 most critical edge cases

**Format**:
```markdown
# Edge Cases Handled

## Critical Scenarios

### 1. {Edge Case Title from edge-cases.md}
- **Scenario**: {description}
- **Handling**: {mitigation strategy}
- **Test Coverage**: ✅

### 2. {Edge Case Title}
- **Scenario**: {description}
- **Handling**: {mitigation}
- **Test Coverage**: ✅

{repeat for top 5 edge cases}

**Total Edge Cases**: {count from edge-cases.md}
```

---

### Slide 6: Testing Strategy
**Source**: `implementation/progress.md`, `grooming/acceptance-criteria.md`
**Sections**:
- Test results from progress.md
- Test coverage metrics
- Acceptance criteria coverage

**Format**:
```markdown
# Testing & Validation

## Test Coverage
- **Unit Tests**: {count} tests, {%}% coverage
- **Integration Tests**: {count} tests
- **Edge Case Tests**: {count} scenarios covered

## Test Results
```
{extract: test output summary from progress.md}
```

## Acceptance Criteria
- ✅ {AC 1 from acceptance-criteria.md}
- ✅ {AC 2}
- ✅ {AC 3}

**All {N} acceptance criteria verified**
```

---

### Slide 7: Demo Walkthrough
**Source**: Sprint context + generated flow
**Format**: Live demo slide with key interaction points

**Format**:
```markdown
# Live Demo

## Demo Flow
1. **Setup**: {initial state}
2. **Action**: {user interaction 1}
3. **Result**: {expected outcome}
4. **Edge Case**: {demonstrate error handling}
5. **Recovery**: {show resilience}

## What to Watch For
- {key feature 1}
- {key feature 2}
- {error handling in action}
```

---

### Slide 8: Performance Considerations
**Source**: `implementation/progress.md`, `grooming/design.md`
**Sections**: Performance notes, if present

**Format**:
```markdown
# Performance Analysis

## Metrics
- **Response Time**: {metric from progress.md or estimated}
- **Throughput**: {metric}
- **Resource Usage**: {metric}

## Optimizations
- {optimization 1 from design.md or progress.md}
- {optimization 2}

## Scalability
{extract: scalability notes from design.md if present, else: "Designed for {estimated scale}"}
```

---

### Slide 9: Security Analysis
**Source**: `grooming/edge-cases.md` (security category), `grooming/design.md`
**Sections**: Security edge cases, auth/authz patterns

**Format**:
```markdown
# Security Considerations

## Security Measures
- **Authentication**: {from design.md or "Standard auth flow"}
- **Authorization**: {from design.md or "Role-based access"}
- **Input Validation**: {from edge-cases.md security section}

## Threats Mitigated
- {security edge case 1 from edge-cases.md}
- {security edge case 2}

## Compliance
{if present in design.md, else: "Standard security practices applied"}
```

---

### Slide 10: Deployment Approach
**Source**: `implementation/tasks.md`, `grooming/design.md`
**Sections**: Deployment tasks, infrastructure notes

**Format**:
```markdown
# Deployment Strategy

## Deployment Steps
{extract: deployment-related tasks from tasks.md, or generate generic steps}

## Infrastructure
{extract: infrastructure notes from design.md if present}

## Rollback Plan
{extract: from design.md or decisions.md if present, else: "Standard rollback procedures"}
```

---

### Slide 11: Monitoring & Observability
**Source**: `grooming/design.md`, `implementation/progress.md`
**Sections**: Monitoring requirements, logging strategy

**Format**:
```markdown
# Monitoring & Observability

## Metrics to Track
- {metric 1 from design.md or generic: "Error rates"}
- {metric 2 or generic: "Response times"}
- {metric 3 or generic: "Resource utilization"}

## Logging Strategy
{extract: from design.md if present, else: "Structured logging with {estimated log level}"}

## Alerts
{extract: from design.md if present, else: "Standard alerting on critical errors"}
```

---

### Slide 12: Next Steps & Roadmap
**Source**: `implementation/tasks.md`, `grooming/design.md`
**Sections**: Future tasks, enhancements

**Format**:
```markdown
# Next Steps

## Immediate (Sprint Complete)
- ✅ {list completed tasks from tasks.md}

## Short-term
{extract: remaining tasks from tasks.md or future enhancements from design.md}

## Future Enhancements
{extract: future decisions section from decisions.md if present}
```

---

## Code Example Insertion Points

When "code" enhancement is selected, insert code example slides after:
- **After Slide 4** (Implementation Details): Deep dive code example
- **After Slide 5** (Edge Cases): Error handling code example

---

## Diagram Insertion Points

When diagrams are enabled, generate and insert:
- **Slide 3**: Architecture diagram (required)
- **After Slide 3**: Data flow diagram (if design.md has data flow section)
- **Slide 10**: Deployment diagram (if infrastructure details present)

---

## Variable Placeholders

All slides can use these variables (will be replaced during generation):
- `{sprint}` - Sprint name
- `{date}` - Generation date
- `{tagline}` - Auto-generated from problem statement
- `{language}` - Primary programming language (detected from codebase)
- `{total_tasks}` - From tasks.md
- `{completed_tasks}` - From progress.md or .state.json
- `{test_count}` - From progress.md
- `{edge_case_count}` - From edge-cases.md
- `{ac_count}` - From acceptance-criteria.md

---

## Notes for Content Generator

**Technical Depth Guidelines**:
- Use technical terminology freely (audience is technical)
- Include code snippets (5-15 lines max per slide)
- Show actual implementation details, not abstractions
- Emphasize edge cases and error handling
- Include performance numbers when available
- Reference specific design patterns used

**Tone**: Professional, technically precise, detail-oriented

**Fallbacks**:
- If source content missing, generate placeholder with note: "⚠️ Details pending implementation"
- If no code available, show pseudocode or architectural patterns
- If no metrics available, show "Benchmarking in progress"
