# Template: Customer Presentation

## Metadata

```yaml
audience: customer
technical_depth: none
business_focus: benefits-only
code_examples: never
diagrams: simple-visuals-only
target_role: External customers, potential clients, end users
presentation_style: Benefits and value, no internal details
```

## Slide Sequence (15 min baseline)

**Total Slides**: 10-11 slides
**Pace**: ~1-1.5 minutes per slide
**Focus**: Customer challenges, benefits, use cases, getting started

### Slide Order (15 min)

1. **Title** (common/title.md)
2. **Your Challenge** (custom)
3. **Benefits Overview** (custom)
4. **Use Case 1** (custom - relatable scenario)
5. **Use Case 2** (custom - different scenario)
6. **Before & After** (custom - transformation story)
7. **Demo** (custom - outcome-focused)
8. **Getting Started** (custom - onboarding)
9. **Success Stories** (custom - testimonials/case studies)
10. **Support & Resources** (custom)
11. **Q&A** (common/qa.md)

---

## Length Adjustments

### 5 Minutes (Quick Customer Pitch)
**Slides**: 5-6 total
**Include**: [1, 2, 3, 7, 11]
- Title
- Your Challenge (problem we solve)
- Benefits Overview (key value props)
- Demo (quick outcome)
- Q&A

**Omit**: Use cases, before/after, getting started, support details

---

### 30 Minutes (Customer Onboarding Session)
**Slides**: 16-18 total
**Add to 15min baseline**:
- Use Case 3 (slide 5b) - Additional scenario
- Detailed Pricing & Plans (slide 8b) - If applicable
- Integration Options (slide 8c) - How it works with their tools
- Training & Support Details (slide 10b) - Comprehensive support info
- Customer Portal Tour (slide 8d) - Where to find help

---

### 45 Minutes (Customer Workshop)
**Slides**: 22-24 total
**Add to 30min**:
- Interactive Problem-Solving (slide 2b) - Address specific customer pain points
- ROI Calculator Workshop (slide 3b) - Help customer calculate their value
- Live Q&A Throughout (integrated) - Pause for questions frequently
- Custom Use Case (slide 5c) - Address customer's specific scenario
- Next Steps Planning (slide 11b) - Action plan for customer

---

## Content Mappings

These mappings define where to extract customer-focused content from ASAF sprint documentation.

### Slide 2: Your Challenge
**Source**: `grooming/design.md`, `initial.md`
**Sections**: Problem Statement (from customer perspective)

**Format**:
```markdown
# The Challenge You Face

## Common Pain Points
{extract: problem from design.md - translate to customer language}

### Challenge 1: {Customer-Friendly Problem Name}
{describe pain point customers experience}

### Challenge 2: {Problem Name}
{describe frustration or limitation}

### Challenge 3: {Problem Name}
{describe cost or inefficiency}

## The Impact
- ⏱️ **Time Lost**: {how much time customers waste}
- 💰 **Cost**: {financial impact or opportunity cost}
- 😤 **Frustration**: {emotional/productivity impact}
```

**Translation Examples**:
- "No API" → "Manual work that takes hours instead of minutes"
- "Poor performance" → "Waiting and delays that slow you down"
- "Complex workflow" → "Too many steps to get simple things done"

---

### Slide 3: Benefits Overview
**Source**: `grooming/acceptance-criteria.md`, `initial.md`
**Sections**: Benefits from customer perspective

**Format**:
```markdown
# How We Help

## Key Benefits

### 🚀 {Benefit 1 - Action Oriented}
{what customer can now do easily}
**Result**: {outcome customer achieves}

### ⚡ {Benefit 2 - Action Oriented}
{capability customer gains}
**Result**: {tangible improvement}

### ✅ {Benefit 3 - Action Oriented}
{problem customer solves}
**Result**: {positive outcome}

## What This Means for You
- {benefit 1 in customer's daily work}
- {benefit 2 in customer's outcomes}
- {benefit 3 in customer's success}
```

**Benefit Language**:
- Focus on outcomes, not features
- Use active, positive language
- Emphasize "you" and "your"
- NO internal details or technical terms

---

### Slide 4: Use Case 1
**Source**: `grooming/design.md`, `grooming/acceptance-criteria.md`
**Sections**: Relatable scenario for customer

**Format**:
```markdown
# Use Case: {Relatable Scenario Title}

## The Scenario
**Customer**: {persona type - e.g., "Small business owner"}
**Challenge**: {specific problem they faced}
**Goal**: {what they wanted to achieve}

## How They Used [Solution]

### Step 1: {Simple Action}
{what customer did - simple, clear}

### Step 2: {Simple Action}
{next action - easy to understand}

### Step 3: {Outcome}
{result achieved}

## Results
- ✅ {Achievement 1}
- ✅ {Achievement 2}
- ✅ {Time/cost saved}

> "{Customer quote if available, else hypothetical}"
```

---

### Slide 5: Use Case 2
**Source**: `grooming/acceptance-criteria.md`
**Sections**: Different scenario showing versatility

**Format**:
```markdown
# Use Case: {Different Scenario}

## The Scenario
**Customer**: {different persona type}
**Challenge**: {different problem}
**Goal**: {different objective}

## Their Experience

{narrative format - storytelling approach}

1. **Started with**: {initial state}
2. **Discovered**: {how solution helped}
3. **Achieved**: {outcome}

## Impact
- {Quantified result 1}
- {Quantified result 2}
- {Unexpected benefit}
```

---

### Slide 6: Before & After
**Source**: `grooming/design.md`
**Sections**: Transformation story

**Format**:
```markdown
# The Transformation

## Before

### {Pain Point 1}
❌ {specific problem customers experienced}

### {Pain Point 2}
❌ {limitation or frustration}

### {Pain Point 3}
❌ {inefficiency or cost}

---

## After

### {Improvement 1}
✅ {how this problem is solved}

### {Improvement 2}
✅ {how limitation is removed}

### {Improvement 3}
✅ {how efficiency is gained}

## The Difference
{summarize transformation in one compelling sentence}
```

---

### Slide 7: Demo
**Source**: Sprint context
**Style**: Outcome-focused, benefits-driven

**Format**:
```markdown
# See It in Action

## What We'll Show You
{brief description of what demo will cover}

## Key Things to Notice

### 1. {Benefit Visible in Demo}
**Watch for**: {what to observe}
**Result**: {outcome you'll see}

### 2. {Benefit Visible in Demo}
**Watch for**: {what to observe}
**Result**: {outcome you'll see}

### 3. {Benefit Visible in Demo}
**Watch for**: {what to observe}
**Result**: {outcome you'll see}

## [Live Demo]

{after demo}

## What This Means for You
{connect demo to customer's challenge}
```

---

### Slide 8: Getting Started
**Source**: `implementation/tasks.md`, generic onboarding
**Sections**: How customers can begin

**Format**:
```markdown
# Getting Started is Easy

## Simple 3-Step Process

### Step 1: {Sign Up / Setup}
⏱️ **Time**: {X minutes}
**What You'll Do**: {simple description}

### Step 2: {Configuration / Onboarding}
⏱️ **Time**: {X minutes}
**What You'll Do**: {simple description}
**Support Available**: {how we help}

### Step 3: {Start Using}
⏱️ **Time**: Immediate
**What You'll Do**: {first action}

## Total Time to Value
🚀 **{X minutes/hours}** from sign-up to first results

## What You'll Need
- {Requirement 1 - keep minimal}
- {Requirement 2}
- {That's it!}
```

---

### Slide 9: Success Stories
**Source**: Hypothetical (unless real customer data available)
**Sections**: Social proof

**Format**:
```markdown
# Customers Love the Results

## Success Metrics

{if real data available:}
- **{N}%** average time saved
- **{N}** customers using daily
- **{N}/5** average satisfaction rating

{else generic:}
- Proven results for {customer segment}
- Trusted by {team size/industry}

## What Customers Say

> "{Hypothetical positive quote about ease of use}"
>
> — {Role}, {Industry}

> "{Hypothetical quote about results}"
>
> — {Role}, {Industry}

> "{Hypothetical quote about support}"
>
> — {Role}, {Industry}

## Common Results
- {Benefit 1 customers typically see}
- {Benefit 2 customers achieve}
- {Benefit 3 customers experience}
```

---

### Slide 10: Support & Resources
**Source**: Generic support information
**Sections**: How customers get help

**Format**:
```markdown
# We're Here to Help

## Support Options

### 📚 Knowledge Base
- Step-by-step guides
- Video tutorials
- FAQs and troubleshooting

### 💬 Customer Support
- **Email**: {if available, else generic}
- **Hours**: {if known, else "Available to assist"}
- **Response Time**: {if known, else "Quick response"}

### 🎓 Training Resources
- Getting started guide
- Best practices
- Tips and tricks

### 👥 Community
{if applicable}
- User community
- Share experiences
- Learn from others

## Contact Us
{provide contact method or note to add contact info}
```

---

## Enhancement Insertion Points

Customer presentations typically don't use technical enhancements:

- **Timeline**: Only if showing "what's coming next" in customer-friendly terms
- **Metrics**: Customer success metrics (not technical metrics)
- **Next Steps**: Already included by default (slide 8)

**Code Examples**: **NEVER**
**Technical Diagrams**: **NEVER**
**Implementation Details**: **NEVER**

---

## Diagram Insertion Points

Customers prefer simple visual comparisons, not technical diagrams:

- **Slide 6**: Before/After visual comparison (simple icons/graphics if available)
- **Slide 3**: Benefits icons or visual list

**DO NOT include**:
- Architecture diagrams
- Flowcharts
- Technical schemas
- Data models

---

## Variable Placeholders

All slides can use these variables:
- `{sprint}` - Sprint name (translated to customer-friendly product name)
- `{date}` - Generation date
- `{tagline}` - Customer-focused value proposition
- `{key_benefit}` - Primary benefit (extracted from problem statement)
- `{customer_segment}` - Target customer type
- `{time_to_value}` - How quickly customers see results

---

## Notes for Content Generator

**Customer Language Guidelines**:
- **Zero technical jargon** - avoid ALL technical terms
- **Benefits, not features** - focus on what customers achieve, not what system does
- **Outcome-oriented** - emphasize results and success
- **Emotional connection** - address frustrations and aspirations
- **Simple language** - 8th-grade reading level maximum
- **Action-oriented** - use active verbs (save, achieve, eliminate, gain)

**Translation Rules**:
- "Fast response time" → "Get answers instantly"
- "Scalable architecture" → "Grows with your needs"
- "Automated workflow" → "Save hours every week"
- "Error handling" → "Reliable and worry-free"
- "REST API" → "Works with your existing tools"

**Tone**: Friendly, helpful, customer-focused, benefit-driven

**Storytelling**:
- Use concrete examples and scenarios
- Make customers the hero of the story
- Show relatable challenges
- Demonstrate clear before/after transformation
- Include emotional elements (frustration → relief, complexity → simplicity)

**Social Proof**:
- If no real customer data: Use hypothetical but realistic scenarios
- If real data available: Use specific numbers and quotes
- Always protect customer privacy (no proprietary information)

**Pricing/Business Terms**:
- If not your sprint's scope: Mention "flexible plans available"
- Focus on value, not cost
- Emphasize ROI and time saved

**Fallbacks**:
- If insufficient detail: Create realistic hypothetical scenarios
- If too technical: Completely reframe in customer language
- If missing use cases: Generate plausible scenarios based on problem statement
- **Never** include internal details, technical specs, or implementation information

**Red Flags to Avoid**:
- Technical terminology
- Internal process details
- Code or technical diagrams
- Feature lists without benefits
- Jargon of any kind
- Uncertain language ("we hope", "should", "might")
- Focus on "us" instead of "you"

## Success Criteria

Customer presentation is successful if:
- ✅ Customer can understand all content without technical background
- ✅ Customer sees themselves in the use cases
- ✅ Customer understands the benefits they'll receive
- ✅ Customer knows how to get started
- ✅ Customer feels supported and confident
- ✅ **NO internal/technical details revealed**
