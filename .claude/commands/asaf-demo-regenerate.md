# ASAF Demo Regenerate Command

**Command**: `/asaf-demo-regenerate [options]`

**Purpose**: Regenerate demo presentation with parameter overrides

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

## Prerequisites

Check for existing demo configuration:

1. **DEMO-CONFIG.json must exist**
   ```
   Read: /asaf/{sprint}/DEMO-CONFIG.json
   ```

2. **If NOT found**:
   ```
   🔴 ERROR: No demo configuration found

   Cannot regenerate without existing demo.

   Options:
     /asaf-demo          - Generate initial demo presentation
     /asaf-status        - Check sprint status

   Tip: Run /asaf-demo first to create the initial presentation.
   ```
   **STOP execution.**

---

## Parse Command-Line Arguments

Accept optional parameters to override config values:

### Available Arguments

```bash
/asaf-demo-regenerate [OPTIONS]

OPTIONS:
  --audience <type>     Override audience type
                        Values: technical, product, executive, customer

  --length <minutes>    Override presentation length
                        Values: 5, 15, 30, 45, or 1-120

  --format <format>     Override output format
                        Values: markdown-slides, outline, script

  --diagrams <yes|no>   Override diagram inclusion
                        Values: yes, no

  --enhancements <list> Override enhancements (comma-separated)
                        Values: code, metrics, timeline, risks, next-steps
                        Example: --enhancements code,metrics

EXAMPLES:
  # Change audience to executive
  /asaf-demo-regenerate --audience executive

  # Change length to 30 minutes
  /asaf-demo-regenerate --length 30

  # Change multiple parameters
  /asaf-demo-regenerate --audience product --length 45 --diagrams yes

  # Remove all enhancements
  /asaf-demo-regenerate --enhancements none
```

---

## Step 1: Load Existing Configuration

Read `/asaf/{sprint}/DEMO-CONFIG.json`:

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
  "source_files": [...],
  "warnings": [],
  "version": "1.0"
}
```

**Edge Case #15**: Corrupt config file
```
🔴 ERROR: Configuration file is corrupted

File: DEMO-CONFIG.json
Issue: {parse error details}

Options:
  1. Delete DEMO-CONFIG.json and run /asaf-demo (fresh start)
  2. Manually fix the JSON file
  3. Cancel regeneration

The config file contains invalid JSON or missing required fields.
```

If corrupted, show options and **STOP**.

---

## Step 2: Parse CLI Arguments

Extract provided arguments from command line.

### Argument Parsing

```
For each argument:
  --audience <value>:
    Validate: technical | product | executive | customer
    If invalid: Error + stop

  --length <value>:
    Validate: Integer 1-120
    If invalid: Error + stop

  --format <value>:
    Validate: markdown-slides | outline | script
    If invalid: Error + stop

  --diagrams <value>:
    Validate: yes | no | y | n
    Convert to boolean: true/false
    If invalid: Error + stop

  --enhancements <value>:
    If "none": Set to []
    Else: Split by comma
    Validate each: code | metrics | timeline | risks | next-steps
    If invalid enhancement: Error + stop
```

**Edge Case #10**: Invalid argument values

```
❌ Invalid argument value

Argument: --{argument_name}
Value: "{entered_value}"
Expected: {valid_values}

Valid examples:
  {example_1}
  {example_2}

Run /asaf-demo-regenerate --help for all options.
```

**STOP** if any argument is invalid.

---

## Step 3: Merge Parameters

Create new configuration by merging:
- **Base**: Existing DEMO-CONFIG.json values
- **Overrides**: CLI arguments (take precedence)
- **Preserved**: Non-overridden values from config

### Merge Logic

```
merged_config = {
  presentation_length_minutes: CLI.length ?? config.presentation_length_minutes,
  audience_type: CLI.audience ?? config.audience_type,
  output_format: CLI.format ?? config.output_format,
  include_diagrams: CLI.diagrams ?? config.include_diagrams,
  enhancements: CLI.enhancements ?? config.enhancements
}
```

**Precedence**: CLI arguments > Config file > Defaults

---

## Step 4: Show Regeneration Summary

Display what will change:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 Demo Regeneration Summary

Sprint: {sprint_name}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHANGES:

  Audience:      {old_value} → {new_value}
  Length:        {old_minutes} min → {new_minutes} min
  Format:        {old_format} → {new_format}
  Diagrams:      {old_bool} → {new_bool}
  Enhancements:  {old_list} → {new_list}

PRESERVED:

  {List any settings that are not changing}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This will OVERWRITE:
  • DEMO-PRESENTATION.md
  • DEMO-CONFIG.json

Previous demo will be lost (unless backed up).

Continue? [Y/n]:
```

**Edge Case #13**: Multiple regenerations

Show regeneration count:
```
ℹ️ This is regeneration #{count}

Previous regenerations: {count - 1}
Original generated: {first_generation_timestamp}
Last regenerated: {last_regeneration_timestamp}
```

---

## Step 5: Invoke Demo Generation

Call the demo generation logic from `/asaf-demo`:

### Reuse Demo Generation Logic

**Option A**: Call `/asaf-demo` with parameters (simpler)
```
Run /asaf-demo internally with merged_config as inputs:
  - Skip interactive prompts
  - Use merged_config values directly
  - Follow same generation phases (2-7)
```

**Option B**: Reference generation phases (documentation approach)
```markdown
Follow the same generation process as `/asaf-demo`:

## Phase 2: Load Template & Calculate Slides
{Reference: /asaf-demo Phase 2, lines 206-262}
- Load template for merged_config.audience_type
- Calculate slide count with merged_config values

## Phase 3: Content Generation
{Reference: /asaf-demo Phase 3, lines 265-346}
- Extract content from source documents
- Apply audience translations
- Format as slides

## Phase 4: Diagram Generation
{Reference: /asaf-demo Phase 4, lines 350-418}
- Generate diagrams if merged_config.include_diagrams == true

## Phase 5: Preview & Confirmation
{Reference: /asaf-demo Phase 5, lines 421-477}
- SKIP preview for regeneration (user already confirmed)

## Phase 6: Enhancement Insertion
{Reference: /asaf-demo Phase 6, lines 480-602}
- Insert enhancements from merged_config.enhancements

## Phase 7: Write Output Files
{Reference: /asaf-demo Phase 7, lines 605-726}
- OVERWRITE DEMO-PRESENTATION.md
- UPDATE DEMO-CONFIG.json with regeneration metadata
```

**Recommended**: Use Option B (reference approach) to avoid code duplication in markdown commands.

---

## Step 6: Update Configuration

Update DEMO-CONFIG.json with regeneration metadata:

```json
{
  "generated_at": "2025-10-31T14:00:00Z",
  "regenerated_at": "2025-10-31T15:30:00Z",
  "regeneration_count": 2,
  "sprint": "sprint-name",
  "presentation_length_minutes": 30,
  "audience_type": "executive",
  "output_format": "markdown-slides",
  "include_diagrams": false,
  "enhancements": ["timeline", "next-steps"],
  "slide_count": 18,
  "template_used": "executive.md",
  "source_files": [...],
  "warnings": [],
  "version": "1.0",
  "regeneration_history": [
    {
      "regenerated_at": "2025-10-31T14:30:00Z",
      "changes": ["audience: technical-team → product-team"]
    },
    {
      "regenerated_at": "2025-10-31T15:30:00Z",
      "changes": ["audience: product-team → executive", "length: 15 → 30"]
    }
  ]
}
```

**New fields**:
- `regenerated_at`: Timestamp of last regeneration
- `regeneration_count`: Number of times regenerated
- `regeneration_history`: Array of past regenerations with changes

---

## Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Demo regenerated successfully!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 **DEMO-PRESENTATION.md** (updated)
   {slide_count} slides • {length} minutes • {audience} audience

✨ **Changes applied**:
   {list of changes}

📊 **Regeneration**: #{count}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Files updated**:
  • asaf/{sprint}/DEMO-PRESENTATION.md
  • asaf/{sprint}/DEMO-CONFIG.json

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Next steps**:

  View updated presentation:
    Open: asaf/{sprint}/DEMO-PRESENTATION.md

  Regenerate again:
    /asaf-demo-regenerate --audience customer --length 15

  Convert to slides:
    marp DEMO-PRESENTATION.md --pdf

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

### Edge Case #13: Multiple Regenerations

Show history:
```
ℹ️ Regeneration History

Original:      {timestamp} - {original_config}
Regeneration 1: {timestamp} - {changes}
Regeneration 2: {timestamp} - {changes}

About to create regeneration #{count + 1}
```

No limit on regenerations (allow unlimited).

---

### Edge Case #14: Missing Source Files

If source documents have changed/deleted since original generation:

```
⚠️ Source files changed since original demo

Missing files:
  • {file_1} (was used in original)
  • {file_2}

New files:
  • {file_3} (now available)

This may affect content quality.

Options:
  1. Continue anyway (may have missing content)
  2. Cancel regeneration

Continue? [y/N]:
```

If user chooses continue, add warning to config:
```json
{
  "warnings": [
    "Source file missing: grooming/design.md",
    "Regenerated with incomplete source data"
  ]
}
```

---

### Edge Case #15: Corrupt Config

Already handled in prerequisites section.

If config is corrupt, cannot proceed with regeneration.

---

### No Arguments Provided

If user runs `/asaf-demo-regenerate` with no arguments:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ️ Current Demo Configuration

Sprint: {sprint_name}
Generated: {timestamp}
{if regenerated: Regenerated: {timestamp} (#{count})}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Configuration:
  • Audience:      {audience_type}
  • Length:        {minutes} minutes
  • Format:        {format}
  • Diagrams:      {yes/no}
  • Enhancements:  {list or "None"}
  • Slides:        {count}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

No parameters specified - nothing to change.

To regenerate with changes, use:
  /asaf-demo-regenerate --audience <type>
  /asaf-demo-regenerate --length <minutes>
  /asaf-demo-regenerate --enhancements <list>

Run: /asaf-demo-regenerate --help
```

**Do not regenerate** if no parameters provided.

---

### Invalid Audience Type

```
❌ Invalid audience type: "{value}"

Valid audience types:
  • technical   - Engineers, architects (high technical depth)
  • product     - PMs, designers (balanced business + tech)
  • executive   - Leadership, stakeholders (business focus)
  • customer    - External users (benefits only)

Example:
  /asaf-demo-regenerate --audience executive
```

---

### Invalid Length

```
❌ Invalid length: "{value}"

Valid lengths:
  • Preset: 5, 15, 30, 45 (minutes)
  • Custom: Any number from 1 to 120

Examples:
  /asaf-demo-regenerate --length 30
  /asaf-demo-regenerate --length 20
```

---

### Invalid Enhancement

```
❌ Invalid enhancement: "{value}"

Valid enhancements:
  • code        - Code examples from implementation
  • metrics     - Test coverage and quality metrics
  • timeline    - Development timeline (Gantt chart)
  • risks       - Edge cases and mitigations
  • next-steps  - Future work and roadmap

To remove all enhancements:
  /asaf-demo-regenerate --enhancements none

Examples:
  /asaf-demo-regenerate --enhancements code,metrics
  /asaf-demo-regenerate --enhancements timeline
```

---

## Help Text

If user runs: `/asaf-demo-regenerate --help` or `/asaf-demo-regenerate -h`

```
ASAF Demo Regenerate

Regenerate demo presentation with parameter overrides.

USAGE:
  /asaf-demo-regenerate [OPTIONS]

OPTIONS:
  --audience <type>
      Change target audience
      Values: technical, product, executive, customer

  --length <minutes>
      Change presentation length
      Values: 5, 15, 30, 45, or custom (1-120)

  --format <format>
      Change output format
      Values: markdown-slides, outline, script

  --diagrams <yes|no>
      Enable or disable diagrams
      Values: yes, no, y, n

  --enhancements <list>
      Change enhancements (comma-separated)
      Values: code, metrics, timeline, risks, next-steps
      Special: none (removes all)

  --help, -h
      Show this help message

EXAMPLES:
  # Change to executive audience
  /asaf-demo-regenerate --audience executive

  # Change length to 30 minutes with no diagrams
  /asaf-demo-regenerate --length 30 --diagrams no

  # Add code and metrics enhancements
  /asaf-demo-regenerate --enhancements code,metrics

  # Full customization
  /asaf-demo-regenerate --audience product --length 45 --format outline

PRECEDENCE:
  CLI arguments > DEMO-CONFIG.json > Defaults

The existing DEMO-PRESENTATION.md will be overwritten.
DEMO-CONFIG.json will be updated with regeneration metadata.

For initial demo generation, use:
  /asaf-demo
```

---

## Configuration Precedence

**Merge Priority** (highest to lowest):
1. **CLI arguments** (this regeneration)
2. **DEMO-CONFIG.json** (previous settings)
3. **Defaults** (if not in config or CLI)

### Precedence Examples

**Example 1**: Change only audience
```bash
Config: audience=technical, length=15, diagrams=yes
CLI: --audience executive
Result: audience=executive, length=15, diagrams=yes
```

**Example 2**: Change multiple parameters
```bash
Config: audience=technical, length=15, enhancements=[code,metrics]
CLI: --audience product --length 30
Result: audience=product, length=30, enhancements=[code,metrics]
```

**Example 3**: Remove enhancements
```bash
Config: enhancements=[code,metrics,timeline]
CLI: --enhancements none
Result: enhancements=[]
```

---

## Tips & Best Practices

**Quick Changes**:
- Change audience for different stakeholders
- Adjust length for time constraints
- Add/remove enhancements based on feedback

**Common Use Cases**:
```bash
# Executive version of technical demo
/asaf-demo-regenerate --audience executive --diagrams no

# Shorter version for standup
/asaf-demo-regenerate --length 5

# Add timeline for project review
/asaf-demo-regenerate --enhancements timeline,risks,next-steps
```

**Preservation**:
- Original DEMO-PRESENTATION.md is overwritten
- Consider backing up manually if needed
- Config history tracks all regenerations

**Source Data**:
- Uses same source documents as original
- If source docs updated, regeneration includes new content
- Grooming/implementation changes reflected automatically

---

## Comparison: /asaf-demo vs /asaf-demo-regenerate

| Feature | /asaf-demo | /asaf-demo-regenerate |
|---------|------------|----------------------|
| **When to use** | First time | Modify existing |
| **Prompts** | 5 interactive prompts | No prompts (CLI args) |
| **Config** | Creates new | Updates existing |
| **Preview** | Shows preview | Skips preview |
| **Speed** | Slower (interactive) | Faster (direct) |
| **Flexibility** | All options | Override specific |

---

_Regenerate command provides quick parameter updates without re-answering prompts._
