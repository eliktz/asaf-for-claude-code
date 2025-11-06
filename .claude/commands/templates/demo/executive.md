# Template: Executive Presentation

## Metadata

```yaml
audience: executive
technical_depth: minimal
business_focus: high
code_examples: no
diagrams: timeline-only
target_role: C-Suite, VPs, Directors, Senior Management
presentation_style: Business value, ROI, strategic impact
```

## Slide Sequence (15 min baseline)

**Total Slides**: 11-13 slides
**Pace**: ~1-1.5 minutes per slide
**Focus**: Business value, ROI, strategic benefits, risk mitigation

### Slide Order (15 min)

1. **Title** (common/title.md)
2. **Business Problem & Impact** (custom)
3. **Solution Overview** (custom - high-level only)
4. **Business Value & ROI** (custom)
5. **Investment Required** (custom)
6. **Timeline & Milestones** (with Gantt chart)
7. **Risk Mitigation** (custom)
8. **Success Metrics & KPIs** (custom)
9. **Demo** (custom - brief, outcome-focused)
10. **Competitive Advantage** (custom)
11. **ROI Projection** (custom)
12. **Recommendation & Next Steps** (custom)
13. **Q&A** (common/qa.md)

---

## Length Adjustments

### 5 Minutes (Executive Brief)
**Slides**: 5-6 total
**Include**: [1, 2, 4, 11, 13]
- Title
- Business Problem & Impact (cost of inaction)
- Business Value & ROI (key numbers)
- ROI Projection (bottom line)
- Q&A

**Omit**: Technical details, timeline, risk analysis, competitive analysis

**Style**: Ultra-concise, focus on decision-making essentials

---

### 30 Minutes (Board Meeting / Strategic Review)
**Slides**: 18-22 total
**Add to 15min baseline**:
- Market Analysis (slide 2b) - Industry trends, market opportunity
- Detailed Cost Breakdown (slide 5b) - Investment details by category
- Competitive Positioning (slide 10b) - Detailed competitor comparison
- Stakeholder Impact (slide 8b) - Impact on different business units
- Implementation Phases (slide 6b) - Detailed phased rollout plan

---

### 45 Minutes (Strategic Planning Session)
**Slides**: 28-32 total
**Add to 30min**:
- Long-term Strategic Impact (slide 4b) - 3-5 year vision
- Alternative Approaches Considered (slide 3b) - Why this solution vs others
- Financial Modeling Deep Dive (slide 11b) - Detailed financial scenarios
- Change Management Strategy (slide 12b) - Organizational readiness
- Extended Discussion (slide 13b) - Facilitated strategic discussion

---

## Content Mappings

These mappings define where to extract business-focused content from ASAF sprint documentation.

### Slide 2: Business Problem & Impact
**Source**: `grooming/design.md`, `initial.md`
**Sections**:
- Problem Statement (translated to business terms)
- Cost of current state
- Business pain points

**Format**:
```markdown
# The Business Challenge

## Current State
{extract: problem from design.md - translate to business impact}

## Business Impact
- **Cost**: {estimate annual cost if quantifiable, else "Significant operational overhead"}
- **Risk**: {extract: risks from edge-cases.md - business terms}
- **Opportunity Cost**: {lost revenue/efficiency}

## Why Now?
{extract: urgency factors from initial.md or decisions.md}
```

**Translation Guide**:
- "System is slow" → "Productivity losses costing $X/year"
- "No error handling" → "Business-critical failures with $X downtime cost"
- "Technical debt" → "Increasing maintenance costs and slower innovation"

---

### Slide 3: Solution Overview
**Source**: `grooming/design.md`
**Sections**: Architecture section (high-level only, no technical details)

**Format**:
```markdown
# Our Solution

## What We're Building
{extract: solution description from design.md - business terms, no code/architecture}

## Key Capabilities
- {capability 1 - user-facing benefit}
- {capability 2 - user-facing benefit}
- {capability 3 - user-facing benefit}

## How It Works (High-Level)
{1-2 sentence summary of approach - no technical jargon}
```

**Translation Guide**:
- "Microservices architecture" → "Scalable, reliable system"
- "REST API" → "Seamless integration with existing tools"
- "Event-driven" → "Real-time responsiveness"

---

### Slide 4: Business Value & ROI
**Source**: `grooming/acceptance-criteria.md`, `initial.md`, estimated
**Sections**: Benefits, success criteria

**Format**:
```markdown
# Business Value

## Quantifiable Benefits
- **Efficiency Gain**: {estimate: X% time savings or Y hours/week}
- **Cost Reduction**: {estimate: $X saved annually}
- **Revenue Impact**: {estimate: $X new revenue or prevented loss}

## Strategic Benefits
- {benefit 1 from acceptance-criteria.md translated to business value}
- {benefit 2}
- {benefit 3}

## ROI Summary
- **Payback Period**: {estimated: 6-18 months typical}
- **3-Year ROI**: {estimated: 200-400% typical}
```

**Estimation Guidelines** (if not provided):
- Time savings: Assume 10-20% efficiency gain for automation
- Cost reduction: Conservative estimate based on headcount/resource savings
- Revenue: Only include if directly revenue-generating
- Be conservative, round down

---

### Slide 5: Investment Required
**Source**: `implementation/tasks.md`, estimated
**Sections**: Task complexity, time estimates

**Format**:
```markdown
# Investment Required

## Development Costs
- **Engineering Time**: {sum task estimates from tasks.md} hours
- **Estimated Cost**: {hours × blended rate, or "$X-Y range"}

## Additional Costs
- **Infrastructure**: {estimate cloud/hosting costs, or "Minimal"}
- **Training**: {estimate if users need training}
- **Maintenance**: {estimate ongoing costs, typically 15-20% of dev cost annually}

## Total Investment
**One-Time**: ${development + infrastructure + training}
**Annual Recurring**: ${maintenance + hosting}
```

---

### Slide 6: Timeline & Milestones
**Source**: `implementation/tasks.md`, `.state.json`
**Sections**: Task breakdown, current progress

**Generate Gantt Chart**:
```markdown
# Timeline

```mermaid
gantt
    title Implementation Timeline
    dateFormat YYYY-MM-DD

    section Planning
    {if grooming_approved}: done, {start_date}, {completion_date}

    section Development
    {task 1}: {status}, {start}, {estimate}
    {task 2}: {status}, {start}, {estimate}
    {repeat for major tasks}

    section Testing
    {testing tasks}: {status}, {start}, {estimate}

    section Deployment
    {deployment}: {status}, {start}, {estimate}
```

## Key Milestones
- ✅ **Planning Complete**: {date from .state.json}
- {🔄 or ⏳} **Development**: {current_task}/{total_tasks} ({%}% complete)
- ⏳ **Testing & QA**: {estimated start}
- ⏳ **Production Launch**: {estimated date}
```

---

### Slide 7: Risk Mitigation
**Source**: `grooming/edge-cases.md`
**Sections**: Critical edge cases (translated to business risks)

**Format**:
```markdown
# Risk Management

## Identified Risks

### 1. {Risk from edge-cases.md - business terms}
- **Probability**: Low / Medium / High
- **Impact**: {business impact}
- **Mitigation**: {handling strategy from edge-cases.md}
- **Status**: ✅ Addressed in design

### 2. {Risk 2}
- **Probability**: Low / Medium / High
- **Impact**: {business impact}
- **Mitigation**: {strategy}
- **Status**: ✅ Addressed

{Include top 3-4 critical risks}

## Risk Summary
All critical risks have defined mitigation strategies.
```

**Translation Examples**:
- "Invalid input" → "Data quality issues" (mitigated by validation)
- "System overload" → "Performance degradation" (mitigated by load testing)
- "Security vulnerability" → "Data breach risk" (mitigated by security review)

---

### Slide 8: Success Metrics & KPIs
**Source**: `grooming/acceptance-criteria.md`
**Sections**: Acceptance criteria

**Format**:
```markdown
# Measuring Success

## Key Performance Indicators

### Operational Metrics
- {KPI 1 from acceptance-criteria.md or estimated}
  - **Target**: {target value}
  - **Measurement**: {how we'll track}

### Business Metrics
- {KPI 2}
  - **Target**: {target}
  - **Measurement**: {tracking method}

### User Satisfaction
- {KPI 3 - user-focused}
  - **Target**: {target}
  - **Measurement**: {surveys, feedback}

## Success Criteria
{extract: acceptance criteria from acceptance-criteria.md - business language}
```

---

### Slide 9: Demo
**Source**: Sprint context
**Style**: Outcome-focused, not technical process

**Format**:
```markdown
# Solution in Action

## Demo: {Use Case}

**Before**: {current painful process}

**After**: {improved process with solution}

## Key Observations
- {benefit 1 visible in demo}
- {benefit 2 visible in demo}
- {efficiency gain visible in demo}

**Bottom Line**: {quantified improvement if possible}
```

**Note**: Demo should be brief (2-3 min max), focus on business outcomes, not features

---

### Slide 10: Competitive Advantage
**Source**: `grooming/design.md`, `grooming/decisions.md`
**Sections**: Unique aspects, differentiation

**Format**:
```markdown
# Competitive Positioning

## How This Differentiates Us

### Our Approach
{extract: unique aspects from design.md or decisions.md}

### Competitive Landscape
| Factor | Our Solution | Competitors / Status Quo |
|--------|-------------|--------------------------|
| {Factor 1} | {Our advantage} | {Their limitation} |
| {Factor 2} | {Our advantage} | {Their limitation} |
| {Factor 3} | {Our advantage} | {Their limitation} |

## Strategic Value
{long-term competitive benefits}
```

**Note**: If competitive info not available, frame as "Current State vs Future State"

---

### Slide 11: ROI Projection
**Source**: Calculated from slides 4 and 5
**Sections**: Financial modeling

**Format**:
```markdown
# Financial Impact

## ROI Analysis (3-Year)

| Year | Investment | Benefits | Net | Cumulative |
|------|-----------|----------|-----|------------|
| **Y1** | ${investment} | ${year1_benefits} | ${net_y1} | ${net_y1} |
| **Y2** | ${maintenance} | ${year2_benefits} | ${net_y2} | ${cumulative_y2} |
| **Y3** | ${maintenance} | ${year3_benefits} | ${net_y3} | ${cumulative_y3} |

## Key Financial Metrics
- **Payback Period**: {months} months
- **3-Year ROI**: {percentage}%
- **NPV** (at {discount_rate}%): ${npv}

## Assumptions
- {assumption 1 used in calculations}
- {assumption 2}
```

**Conservative Estimates**:
- Year 1: 50% of full benefits (ramp-up period)
- Year 2: 100% of benefits
- Year 3: 100% of benefits + growth
- Discount rate: 10% typical

---

### Slide 12: Recommendation & Next Steps
**Source**: Current sprint state, estimated next steps
**Sections**: Decision request, action items

**Format**:
```markdown
# Recommendation

## Our Recommendation
{if implementation_complete:}
✅ **Approve deployment to production**
{else if in_progress:}
🔄 **Continue implementation** - {%}% complete
{else:}
🚀 **Approve project initiation**

## Business Case Summary
- **Investment**: ${total_investment}
- **Expected ROI**: {%}% over 3 years
- **Payback**: {months} months
- **Risk Level**: Low (all critical risks mitigated)

## Next Steps
1. {next action 1 based on current phase}
2. {next action 2}
3. {next action 3}

## Decision Needed
{what approval/decision is requested}
```

---

## Enhancement Insertion Points

When enhancements are selected (executive presentations typically skip most):

- **Timeline**: Automatically include Gantt chart (slide 6)
- **Metrics**: Expand slide 8 with detailed KPI dashboard
- **Risks**: Already included by default (slide 7)
- **Next Steps**: Already included by default (slide 12)

**Code Examples**: **NEVER include** in executive presentations

---

## Diagram Insertion Points

Executives prefer timeline visualizations over technical diagrams:

- **Slide 6**: Gantt chart (required if timeline selected)
- **Slide 11**: ROI chart (bar/line chart if possible, otherwise table)

**DO NOT include**: Architecture diagrams, flowcharts, technical diagrams

---

## Variable Placeholders

All slides can use these variables:
- `{sprint}` - Sprint name
- `{date}` - Generation date
- `{tagline}` - Business-focused tagline (auto-generated)
- `{total_investment}` - Calculated from tasks
- `{roi_percentage}` - Calculated ROI
- `{payback_months}` - Calculated payback period
- `{current_phase}` - From .state.json
- `{completion_percentage}` - From .state.json
- `{total_tasks}` / `{completed_tasks}` - From .state.json

---

## Notes for Content Generator

**Business Language Guidelines**:
- Avoid ALL technical jargon (API, microservices, database, etc.)
- Translate to business outcomes:
  - "Fast response time" → "Improved productivity"
  - "Scalable architecture" → "Growth-ready solution"
  - "Error handling" → "Business continuity"
- Focus on financial impact and strategic value
- Use conservative estimates (better to under-promise)

**Tone**: Confident, strategic, executive-appropriate

**Financial Modeling**:
- If actual numbers not available, use percentage improvements
- Show 3-year view (standard executive horizon)
- Include payback period (critical decision factor)
- Be transparent about assumptions

**Fallbacks**:
- If cost data missing: Show percentage ROI without dollar amounts
- If timeline uncertain: Show phase approach without specific dates
- If competitive info missing: Frame as transformation opportunity

**Red Flags to Avoid**:
- Technical implementation details
- Code snippets or architecture diagrams
- Lengthy explanations
- Uncertain language ("maybe", "hopefully")
- Over-promising benefits
