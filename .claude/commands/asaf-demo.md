# ASAF Demo Command (Enhanced)

**Command**: `/asaf-demo`

**Purpose**: Generate customized demo presentation with audience-specific content

---

## Step 0: Verify Active Sprint

1. Check if /asaf/.current-sprint.json exists
   - If NO: Run auto-selection algorithm (see asaf-core.md)
   - If YES: Read sprint name from file

2. Validate selected sprint exists at /asaf/<sprint-name>/
   - If NO: Sprint was deleted
     - Delete stale /asaf/.current-sprint.json
     - Log: "Selected sprint no longer exists, auto-selecting..."
     - Run auto-selection algorithm
   - If YES: Continue

3. Validate sprint has .state.json
   - Check /asaf/<sprint-name>/.state.json exists
   - If NO but sprint folder exists:
     - LENIENT WARNING: Log "Sprint has no .state.json (may be incomplete)"
     - Continue anyway (developer may be fixing)
   - If sprint folder missing: Already handled in step 2

4. Set context: All subsequent operations use /asaf/<sprint-name>/

---

## Prerequisites Check

Read `.state.json`:

**Flexible Prerequisites** (lenient for demo generation):
- If `implementation_complete: true` → Full demo available
- If `implementation_complete: false` BUT `phase: "implementation"` → Mid-implementation demo (WIP)
- If Express sprint → Simplified demo
- If `grooming_approved: false` → Fallback to initial.md only

**Only STOP if**:
```
🔴 ERROR: Cannot generate demo

Sprint has no content:
  - No initial.md
  - No grooming/ directory
  - No .state.json

This sprint appears uninitialized.

Run: /asaf-init <name>
```

Otherwise, proceed with available data and show warnings for missing content.

---

## Phase 1: Interactive Prompts

Show opening message:
```
🎬 Demo Presentation Generator

This will create a customized presentation based on your sprint.

You'll choose:
  • Presentation length (5/15/30/45 min or custom)
  • Target audience (technical/product/executive/customer)
  • Output format (markdown slides, outline, or script)
  • Optional enhancements

Let's customize your demo...
```

---

### Prompt 1: Presentation Length

**USE the AskUserQuestion tool**:

```yaml
AskUserQuestion:
  questions:
    - question: "How long should the presentation be?"
      header: "Length"
      multiSelect: false
      options:
        - label: "Quick (5 min)"
          description: "Brief overview, key highlights only"
        - label: "Standard (15 min)"
          description: "Balanced coverage, recommended"
        - label: "Extended (30 min)"
          description: "Comprehensive deep dive"
        - label: "Workshop (45 min)"
          description: "Full details with discussion time"
```

**Map response**:
- "Quick" → `presentation_length_minutes = 5`
- "Standard" → `presentation_length_minutes = 15`
- "Extended" → `presentation_length_minutes = 30`
- "Workshop" → `presentation_length_minutes = 45`
- If user selects "Other" → Prompt for custom minutes (1-120)

**Edge Case #1**: Out of range custom length
- If < 1 or > 120: Clamp to range and warn
- Store clamped value

---

### Prompt 2: Target Audience

**USE the AskUserQuestion tool**:

```yaml
AskUserQuestion:
  questions:
    - question: "Who is the primary audience?"
      header: "Audience"
      multiSelect: false
      options:
        - label: "Technical Team"
          description: "Engineers, architects (high technical depth)"
        - label: "Product Team"
          description: "PMs, designers (balanced business + tech)"
        - label: "Executive"
          description: "Leadership, stakeholders (business focus)"
        - label: "Customer"
          description: "External users (benefits only, no internals)"
```

**Map response**:
- "Technical Team" → `audience_type = "technical-team"`
- "Product Team" → `audience_type = "product-team"`
- "Executive" → `audience_type = "executive"`
- "Customer" → `audience_type = "customer"`

**Edge Case #2**: Express sprint detection
- If `.state.json` shows `type: "express"`:
  - Skip this prompt
  - Auto-select: technical-team (most likely)
  - Auto-simplify to 5 minutes
  - Show: "🔄 Express sprint detected - auto-selecting 5-min technical demo"

---

### Prompt 3: Output Format

**USE the AskUserQuestion tool**:

```yaml
AskUserQuestion:
  questions:
    - question: "Which output format do you prefer?"
      header: "Format"
      multiSelect: false
      options:
        - label: "Markdown Slides"
          description: "Ready for Marp/Slidev/reveal.js (recommended)"
        - label: "Outline"
          description: "Bulleted presentation outline"
        - label: "Script"
          description: "Full presenter script with notes"
```

**Map response**:
- "Markdown Slides" → `output_format = "markdown-slides"`
- "Outline" → `output_format = "outline"`
- "Script" → `output_format = "script"`

---

### Prompt 4: Include Diagrams

**USE the AskUserQuestion tool**:

```yaml
AskUserQuestion:
  questions:
    - question: "Include Mermaid diagrams (architecture, flows, timeline)?"
      header: "Diagrams"
      multiSelect: false
      options:
        - label: "Yes, include diagrams"
          description: "Architecture, user flows, timeline charts"
        - label: "No, skip diagrams"
          description: "Text-only presentation"
```

**Map response**:
- "Yes" → `include_diagrams = true`
- "No" → `include_diagrams = false`

**Context-aware defaults**:
- If audience is technical/product: Pre-select "Yes"
- If audience is executive/customer: Pre-select "No"

**Edge Case #8**: No diagrams possible
- If design.md has no architecture/flow content:
  - Show: "⚠️ No diagram content available in design docs"
  - Proceed without diagrams even if selected

---

### Prompt 5: Enhancement Selection

**USE the AskUserQuestion tool** with **multiSelect: true**:

```yaml
AskUserQuestion:
  questions:
    - question: "Which optional enhancements should we include?"
      header: "Enhancements"
      multiSelect: true
      options:
        - label: "Code examples"
          description: "Key implementation snippets"
        - label: "Metrics"
          description: "Test coverage, performance data"
        - label: "Timeline"
          description: "Development timeline (Gantt chart)"
        - label: "Risks"
          description: "Edge cases and mitigations"
```

Follow up with:
```yaml
AskUserQuestion:
  questions:
    - question: "Any additional enhancements?"
      header: "More"
      multiSelect: true
      options:
        - label: "Next steps"
          description: "Future work and roadmap"
        - label: "None - enhancements above are sufficient"
          description: "Skip additional enhancements"
```

**Map responses** to: `enhancements = ["code", "metrics", "timeline", "risks", "next-steps"]`

**Context-Aware Defaults** (suggest as pre-selected):
- Technical audience: code, metrics, risks
- Executive audience: timeline, next-steps
- Product audience: metrics, risks, next-steps
- Customer audience: Skip prompt entirely (no internal details)

---

## Phase 2: Load Template & Calculate Slides

### Step 1: Load Audience Template

Read template file:
```
.claude/commands/templates/demo/{audience_type}.md
```

**Templates**:
- `technical-team.md`
- `product-team.md`
- `executive.md`
- `customer.md`

**Edge Case #14**: Missing template
- If template file not found:
  - Fallback to technical-team.md
  - Warn: "⚠️ Template not found, using technical template"

---

### Step 2: Calculate Slide Count

Use formula from template metadata:
```
base_slides = presentation_length_minutes × 0.75

# Audience adjustments
if audience == "technical-team": base_slides += 2
if audience == "executive": base_slides -= 2

# Diagram adjustment
if include_diagrams: base_slides += 1

# Enhancement adjustments
for each enhancement: base_slides += 1

target_slides = round(base_slides)
```

**Edge Case #5**: Slide count mismatch
- If generated slides ≠ target (±2):
  - Adjust content density (summarize or expand)
  - Prioritize key slides from template

---

### Step 3: Select Slides for Length

Based on `presentation_length_minutes`, use template's length adjustment section:
- 5 min: Use template's "5 min" slide list
- 15 min: Use template's baseline sequence
- 30 min: Use baseline + "30 min additions"
- 45 min: Use baseline + "30 min" + "45 min additions"
- Custom: Interpolate between nearest presets

---

## Phase 3: Content Generation

### Load Source Documents

Read available sprint documents:
1. `initial.md` - Feature description
2. `grooming/design.md` - Architecture, design decisions
3. `grooming/edge-cases.md` - Edge case scenarios
4. `grooming/acceptance-criteria.md` - Success criteria
5. `grooming/decisions.md` - Technical decisions
6. `implementation/tasks.md` - Task breakdown
7. `implementation/progress.md` - Implementation notes, test results
8. `.state.json` - Sprint status, metrics

**Edge Case #2**: No grooming data
- If grooming/ directory missing or empty:
  - Use initial.md only
  - Generate simplified demo
  - Warn: "⚠️ No grooming data - generating simplified demo from initial.md"

**Edge Case #6**: Implementation incomplete
- If `implementation_complete: false`:
  - Add WIP badge to title slide
  - Add status slide showing progress: "🔄 In Progress: {current_task}/{total_tasks} tasks ({%}% complete)"
  - Show completed tasks, remaining tasks

---

### Generate Slides

For each slide in selected sequence:

1. **Read slide definition** from template (e.g., "Slide 2: Technical Context")

2. **Find content mapping** in template
   - Example: "Technical Context → grooming/design.md: Problem Statement"

3. **Extract content** from source file
   - Read specified section from source document
   - Apply audience-specific translation (from template's translation guide)

4. **Apply template format**
   - Use slide format from template
   - Replace {variables} with actual values
   - Insert extracted content

5. **Format as markdown slide**
   ```markdown
   # Slide Title

   Content here...

   ---
   ```

**Edge Case #7**: Missing enhancement data
- If enhancement selected but data missing:
  - Insert placeholder slide: "⚠️ [Enhancement] data pending implementation"
  - Note in DEMO-CONFIG.json

---

### Content Extraction Examples

**From design.md to Technical Context slide**:
```
1. Read grooming/design.md
2. Find "Problem Statement" or similar section
3. Extract 2-3 paragraphs
4. If audience == "executive": Translate to business terms
5. If audience == "customer": Translate to benefits
6. Format into slide template
```

**From progress.md to Code Examples slide** (if enhancement selected):
```
1. Read implementation/progress.md
2. Search for code blocks (```language ... ```)
3. Select 2-3 most relevant snippets (10-20 lines each)
4. Extract surrounding context/explanation
5. Format into code example slides
```

---

## Phase 4: Diagram Generation

If `include_diagrams: true`:

### Architecture Diagram

**Source**: `grooming/design.md` - Architecture section

**Generate**:
```markdown
```mermaid
graph TB
    {extract components from design.md}
    A[Component 1] --> B[Component 2]
    B --> C[Component 3]
```
```

**Fallback**: If no architecture content:
- Skip diagram
- Use text description instead

---

### User Flow Diagram

**Source**: `grooming/design.md` - User flows section

**Generate**:
```markdown
```mermaid
flowchart TD
    Start[User starts] --> Action1[{action}]
    Action1 --> Decision{decision?}
    Decision -->|Yes| Success[Complete]
    Decision -->|No| Action2[{alternative}]
    Action2 --> Success
```
```

**Applicable**: Product and technical audiences only

---

### Timeline Diagram (Gantt Chart)

**Source**: `implementation/tasks.md` + `.state.json`

**Generate**:
```markdown
```mermaid
gantt
    title Implementation Timeline
    dateFormat YYYY-MM-DD

    section Planning
    Grooming: done, {start_date}, {duration}

    section Development
    {task 1}: {status}, {start}, {end}
    {task 2}: {status}, {start}, {end}

    section Complete
    Demo: milestone, {demo_date}
```
```

**Applicable**: Executive and product audiences

---

## Phase 5: Preview & Enhancement Confirmation

### Show Preview

Display:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Demo Preview

Generated: {target_slides} slides for {audience} ({length} min)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{First slide content}

---

{Second slide content}

---

... {target_slides - 2} more slides ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Slide titles:
3. {Slide 3 title}
4. {Slide 4 title}
...
{target_slides}. {Last slide title}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Enhancement Confirmation

If enhancements were selected:
```
✨ Confirm enhancements?

Selected enhancements will add {N} slides:
  • Code examples (2 slides)
  • Metrics (1 slide)
  • Timeline (1 slide)

Total slides: {base_slides} + {enhancement_slides} = {total_slides}

Proceed? [Y/n]:
```

**Edge Case #11**: User cancels
- If user answers "n":
  - Ask: "Remove enhancements or cancel demo generation? [remove/cancel]"
  - If "remove": Continue without enhancements
  - If "cancel": Exit cleanly, no files created

---

## Phase 6: Enhancement Insertion

For each selected enhancement:

### Code Examples Enhancement

**Insert after**: Implementation details slide

**Content**:
```markdown
# Code Highlights

## {Component 1}

```{language}
{extract: code snippet from progress.md}
```

**Purpose**: {explanation}
**Pattern**: {design pattern used}

---

## {Component 2}

```{language}
{extract: code snippet}
```

**Purpose**: {explanation}

---
```

**Source**: Extract from implementation/progress.md

---

### Metrics Enhancement

**Insert after**: Demo slide

**Content**:
```markdown
# Metrics & Quality

## Test Coverage
- **Total Tests**: {count from progress.md}
- **Passing**: {passing} (100%)
- **Coverage**: {%}% {if available}

## Implementation Efficiency
- **Tasks**: {completed}/{total}
- **Iterations**: {avg per task}
- **Duration**: {hours/days}

## Quality Gates
- ✅ All edge cases handled
- ✅ Code reviewed
- ✅ Tests passing

---
```

**Source**: implementation/progress.md, .state.json

---

### Timeline Enhancement

**Insert after**: Context/intro slide

**Content**: Gantt chart (see diagram generation section above)

---

### Risks Enhancement

**Insert before**: Q&A slide

**Content**:
```markdown
# Risk Mitigation

## Edge Cases Handled

### {Edge Case 1}
**Scenario**: {description from edge-cases.md}
**Mitigation**: {handling strategy}
**Status**: ✅ Addressed

{repeat for top 5 edge cases}

---
```

**Source**: grooming/edge-cases.md

---

### Next Steps Enhancement

**Insert before**: Q&A slide

**Content**:
```markdown
# Next Steps

## Immediate
- {remaining tasks from tasks.md or "All tasks complete ✅"}

## Future Enhancements
{extract: future decisions from decisions.md or deferred features}

## Reusable Patterns
- {pattern 1 that can be applied elsewhere}
- {pattern 2}

---
```

**Source**: implementation/tasks.md, grooming/decisions.md

---

## Phase 7: Write Output Files

### Write DEMO-PRESENTATION.md

Create file: `/asaf/{sprint}/DEMO-PRESENTATION.md`

**Format** (if output_format == "markdown-slides"):
```markdown
# {Sprint Name}

> {Tagline from problem statement}

**Presented by**: ASAF
**Generated**: {date}
**Audience**: {audience_type}
**Duration**: {length} minutes

---

{Slide 2 content}

---

{Slide 3 content}

---

{Continue for all slides}

---

# Questions?

**Thank you!**

---

_Generated by ASAF Demo Generator • {date}_
_Sprint: {sprint} • Audience: {audience} • {slide_count} slides_
```

**Format** (if output_format == "outline"):
```markdown
# Demo Outline: {Sprint Name}

## 1. {Slide 1 Title}
   - {Key point 1}
   - {Key point 2}

## 2. {Slide 2 Title}
   - {Key point 1}
   - {Key point 2}

{Continue...}
```

**Format** (if output_format == "script"):
```markdown
# Presenter Script: {Sprint Name}

## Slide 1: {Title}

**What to show**: {Visual description}

**What to say**:
"{Full presenter notes with timing}"

**Duration**: ~{minutes} minutes

---

{Continue for each slide}
```

---

### Write DEMO-CONFIG.json

Create file: `/asaf/{sprint}/DEMO-CONFIG.json`

```json
{
  "generated_at": "2025-10-31T14:00:00Z",
  "sprint": "sprint-name",
  "presentation_length_minutes": 15,
  "audience_type": "technical-team",
  "output_format": "markdown-slides",
  "include_diagrams": true,
  "enhancements": ["code", "metrics"],
  "slide_count": 14,
  "template_used": "technical-team.md",
  "source_files": [
    "initial.md",
    "grooming/design.md",
    "grooming/edge-cases.md",
    "grooming/acceptance-criteria.md",
    "implementation/progress.md"
  ],
  "warnings": [],
  "version": "1.0"
}
```

**Purpose**: Enables regeneration with parameter overrides

---

### Update .state.json

Add demo metadata:
```json
{
  ...existing state...,
  "demo_generated_at": "2025-10-31T14:00:00Z",
  "demo_config": {
    "audience": "technical-team",
    "length_minutes": 15,
    "slide_count": 14
  }
}
```

---

## Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 Demo presentation generated!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 **DEMO-PRESENTATION.md**
   {slide_count} slides • {length} minutes • {audience} audience

✨ **Enhancements included**:
   {list enhancements if any, else "None"}

📊 **Diagrams**: {count} diagrams included

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Files created**:
  • asaf/{sprint}/DEMO-PRESENTATION.md
  • asaf/{sprint}/DEMO-CONFIG.json

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Next steps**:

  View presentation:
    Open: asaf/{sprint}/DEMO-PRESENTATION.md

  Convert to slides:
    marp DEMO-PRESENTATION.md --pdf
    (or use Slidev, reveal.js, etc.)

  Regenerate with changes:
    /asaf-demo-regenerate --audience executive --length 30

  Continue sprint:
    /asaf-retro    - Sprint retrospective

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

### Edge Case #1: Custom Length Out of Range
```
⚠️ Length adjusted: {entered_value} → {clamped_value} minutes
   (Valid range: 1-120 minutes)

Continuing with {clamped_value} minutes...
```

### Edge Case #2: No Grooming Data
```
⚠️ No grooming data found

Creating simplified demo from:
  • initial.md (feature description)
  • .state.json (sprint status)

Demo will have reduced technical detail.

Continue? [Y/n]:
```

### Edge Case #3: Express Sprint Auto-Simplification
```
🔄 Express sprint detected

Auto-configuring:
  • Length: 5 minutes (quick overview)
  • Audience: Technical team
  • Format: Markdown slides
  • Enhancements: None

Generating lightweight demo...
```

### Edge Case #4: User Cancels Mid-Prompts
```
🛑 Demo generation cancelled

No files created.

Tip: Run /asaf-demo anytime to generate a presentation.
```

### Edge Case #6: Implementation Incomplete (WIP Demo)
```
🔄 Implementation in progress: {current_task}/{total_tasks} ({%}%)

Generating Work-In-Progress demo with:
  • Completed work highlighted
  • Remaining tasks noted
  • Current status shown

This demo reflects current sprint state.

Continue? [Y/n]:
```

### Edge Case #7: Missing Enhancement Data
```
⚠️ Enhancement data missing: {enhancement_name}

Reason: {reason - e.g., "No code snippets in progress.md"}

Options:
  1. Skip this enhancement
  2. Add placeholder slide
  3. Cancel demo generation

Choose [1-3]:
```

### Edge Case #10: Invalid Inputs (Re-prompt)
```
❌ Invalid input: "{entered_value}"

Expected: {expected_format}

Please try again (attempt {N}/3):
```

After 3 failed attempts:
```
⚠️ Using default value: {default_value}

Continuing...
```

---

## Tips & Best Practices

**Markdown Slides Format**:
- Compatible with: Marp, Slidev, reveal.js, Deckset
- Slide separator: `---` on its own line
- Use `#` for slide titles, `##` for sections

**Mermaid Diagrams**:
- Preview: https://mermaid.live/
- Edit diagrams in preview tool, copy back to presentation

**Converting to Other Formats**:
```bash
# PDF with Marp
marp DEMO-PRESENTATION.md --pdf

# PowerPoint with Marp
marp DEMO-PRESENTATION.md --pptx

# HTML with reveal.js
pandoc DEMO-PRESENTATION.md -t revealjs -o presentation.html
```

**Regeneration**:
- Use `/asaf-demo-regenerate` to change audience or length
- Config is saved in DEMO-CONFIG.json
- Preserves settings, overrides specified parameters

---

## Variables Used in Templates

All templates can reference these variables (replaced during generation):

- `{sprint}` - Sprint name
- `{date}` - Generation date
- `{tagline}` - Auto-generated from problem statement
- `{language}` - Primary language (detected)
- `{total_tasks}` - From tasks.md
- `{completed_tasks}` - From .state.json
- `{test_count}` - From progress.md
- `{edge_case_count}` - From edge-cases.md
- `{ac_count}` - From acceptance-criteria.md
- `{completion_percentage}` - Calculated
- `{current_phase}` - From .state.json

---

_Enhanced demo command with audience customization, interactive prompts, and template system._
