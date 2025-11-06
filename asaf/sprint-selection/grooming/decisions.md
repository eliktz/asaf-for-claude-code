# Technical Decisions: Sprint Selection State Management

## Stack & Tooling

**Project Type**: Markdown-based command system (no compilation)
**Files**: Markdown (.md) command definitions
**Format**: JSON for state files
**Testing**: Manual verification against acceptance criteria

**Rationale**: ASAF is purely markdown instructions - no backend, no code execution. Implementation means creating/editing command files that Claude Code reads.

---

## Execution Configuration

### Executor Profile
**Profile**: `general-purpose`

**Capabilities**:
- File operations (create, read, edit markdown files)
- Understanding ASAF command structure and conventions
- Following existing patterns from asaf-core.md
- JSON file creation with proper formatting
- Clear technical writing (instructions, error messages)

**Rationale**: No specialized programming language needed. This is about writing clear instructions and maintaining consistency across command files.

---

### Reviewer Configuration

**Mode**: Supportive Mentor

**Rationale**: No personal goals found (default mode). Balanced feedback with constructive guidance.

**Reviewer Focus Areas**:
1. **Clarity**: Are instructions clear and unambiguous?
2. **Completeness**: All error cases handled? State transitions documented?
3. **Consistency**: Follows existing ASAF patterns and conventions?
4. **User Experience**: Error messages helpful? Success messages informative?

**Reviewer Behavior**:
- Check each command file against design.md
- Verify edge cases from edge-cases.md are handled
- Ensure error messages follow severity conventions (🔴/🟡/🔵)
- Validate JSON formats match existing .state.json patterns
- Confirm backward compatibility preserved

---

### Task Execution

**Pattern**: executor → test → reviewer → iterate

**Max Iterations**: Variable based on complexity
- **Simple edits** (adding Step 0 to existing commands): 2 iterations
- **Moderate changes** (updating asaf-init with prompt): 3 iterations
- **Complex new features** (creating asaf-select command): 5 iterations
- **Documentation updates**: 2 iterations

**Rationale**: Simple pattern insertions need fewer cycles. New command with interactive mode needs more refinement.

**Special Considerations**:
- Install/uninstall scripts must be updated to include new asaf-select.md
- All 11 command updates should follow identical Step 0 pattern for consistency
- Test with actual ASAF repo during implementation (this repo can be test bed)

---

## Key Technical Decisions

### Decision 1: State File Location and Format

**Decision**: `/asaf/.current-sprint.json` with JSON format

**Alternatives Considered**:
- Global location (`~/.claude/current-sprint.json`)
- Plain text file (`/asaf/CURRENT`)
- YAML format

**Rationale**:
- Project-local supports multiple repos with independent selections
- Dot-prefix follows existing `.state.json` convention
- JSON matches existing state file format for consistency

**Trade-offs**:
- Each repo needs separate selection (benefit: isolation; cost: no cross-repo awareness)
- JSON slightly less readable than plain text (but consistency wins)

---

### Decision 2: Auto-Selection Criteria

**Decision**: Use `.state.json` modification time to determine most recent sprint

**Alternatives Considered**:
- Sprint folder modification time
- Most recently modified file anywhere in sprint
- Explicit timestamp field in .state.json

**Rationale**:
- `.state.json` only updates during real sprint work (commands update it)
- Ignores noise from file viewing, IDE activity
- Already required for validation (no additional dependency)

**Trade-offs**:
- Assumes `.state.json` mtime is reliable (generally true for filesystem ops)
- Won't detect "viewing" as activity (but that's not real work anyway)

---

### Decision 3: Validation Strategy

**Decision**: Lenient validation - warn but allow incomplete sprints

**Alternatives Considered**:
- Strict validation (fail on any missing/corrupt state)
- No validation (trust everything exists)

**Rationale**:
- Developers may be manually fixing broken sprints
- Better UX to warn than block
- Auto-selection skips invalid sprints (only affects explicit selection)

**Trade-offs**:
- Could mask underlying problems (but warnings make them visible)
- More complex error handling (but more robust)

---

### Decision 4: Express Sprint Exclusion

**Decision**: Sprint selection only applies to full sprints (exclude `/asaf/express/`)

**Alternatives Considered**:
- Include express sprints in selection
- Separate selection for express vs full

**Rationale**:
- Express sprints are lightweight, short-lived tasks
- Full sprints are where context confusion happens (long-lived, multiple in parallel)
- Simpler model: selection = full sprint only

**Trade-offs**:
- Can't explicitly "select" an express sprint (but rarely needed)
- Express commands work independently (no selection needed)

---

### Decision 5: Interactive Mode Behavior

**Decision**: `/asaf-select` without args shows list with current highlighted, prompts to keep or change

**Alternatives Considered**:
- Just display current sprint (no interaction)
- Always require sprint name argument

**Rationale**:
- Helpful when user forgets exact sprint names
- Shows context (all available sprints) while allowing confirmation
- Single-sprint case handled differently (just display, no prompt)

**Trade-offs**:
- More complex than argument-only mode
- Requires interactive prompt handling

---

### Decision 6: Init Prompt Behavior

**Decision**: After creating sprint, prompt user "Set as current? [Y/n]"

**Alternatives Considered**:
- Always set new sprint as current (automatic)
- Never set automatically (require explicit /asaf-select)
- Only set if no selection exists

**Rationale**:
- Developers may create sprint to "queue up" work without switching context
- Prompt gives control without assumptions
- Default (Enter = Y) makes common case fast

**Trade-offs**:
- Extra prompt adds friction (but only for /asaf-init, which is infrequent)
- Better than forcing switch or requiring extra command

---

### Decision 7: Command Integration Scope

**Decision**: Only commands that operate on sprint data get validation

**Commands Updated**:
- ✅ groom, groom-approve, impl (variants), demo, retro, status, summary
- ❌ list, help (work independently)

**Alternatives Considered**:
- All commands validate (even list/help)
- No commands validate (check only in asaf-select)

**Rationale**:
- Minimizes changes to commands that don't need sprint context
- Keeps list/help fast and simple
- Clear rule: "operates on sprint data = needs validation"

**Trade-offs**:
- Inconsistent (some commands check, some don't)
- But consistency for its own sake would add unnecessary overhead

---

### Decision 8: Fuzzy Matching for Typos

**Decision**: When sprint name doesn't match, suggest close matches (Levenshtein distance < 3)

**Alternatives Considered**:
- Exact match only (fail with list)
- Substring matching

**Rationale**:
- Helpful UX for common typos
- Low false positive rate (distance < 3 is conservative)
- Falls back to full list if no close match

**Trade-offs**:
- Slightly more complex logic
- Could suggest wrong sprint if names are similar (but user confirms)

---

### Decision 9: Git Handling

**Decision**: Document as optional, suggest gitignore by default

**Alternatives Considered**:
- Always gitignore (force it)
- Always commit (force it)

**Rationale**:
- Solo developer workflow benefits from local selection
- Team workflows might want committed selection (rare for ASAF)
- Let developer choose based on their needs

**Trade-offs**:
- Not opinionated (could lead to confusion)
- But flexibility is better than wrong default for some users

---

## Out of Scope

The following are explicitly deferred for future work:

1. **Sprint History**: Track selection changes over time
2. **Multi-sprint Operations**: Compare, merge, bulk operations
3. **Concurrent Access Protection**: Lock files, conflict detection
4. **Sprint Workspaces**: Grouping related sprints
5. **Undo Functionality**: Revert sprint selection
6. **Non-sprint Subdirectories**: Special handling for /asaf/archive/, etc.
7. **Sprint Name Validation**: Beyond what /asaf-init already does
8. **Automated Tests**: Focus on manual verification via ACs

---

## Estimated Complexity & Time

**Complexity**: Medium
- 1 new command file (complex: interactive mode, fuzzy matching)
- 15 file modifications (11 simple, 4 moderate)
- Clear design, well-defined edge cases
- No external dependencies

**Estimated Time**: 4-6 hours
- 1-2 hours: Create /asaf-select command
- 2-3 hours: Update 15 existing files
- 1 hour: Update install/uninstall scripts, documentation
- Review cycles included in estimate

**Task Breakdown** (to be formalized in tasks.md after grooming approval):
- Task 1: Create asaf-select.md command (5 iter max)
- Task 2: Add auto-selection to asaf-core.md (3 iter max)
- Task 3: Update asaf-init.md with prompt (3 iter max)
- Task 4-14: Update 11 sprint-context commands with Step 0 (2 iter each)
- Task 15: Update install.sh and uninstall.sh (2 iter max)
- Task 16: Update documentation (README, CLAUDE.md, .gitignore) (2 iter max)

---

## Decision Log

| Date | Decision | Rationale | Decided By |
|------|----------|-----------|------------|
| 2025-10-31 | JSON format for state file | Consistency with .state.json | Developer + Grooming Agent |
| 2025-10-31 | Lenient validation strategy | Better UX for fixing issues | Developer + Grooming Agent |
| 2025-10-31 | .state.json mtime for auto-selection | Reflects actual work, no noise | Developer + Grooming Agent |
| 2025-10-31 | Exclude express sprints | Simplify model, full sprints only | Developer + Grooming Agent |
| 2025-10-31 | Init prompt behavior | Give control without assumptions | Developer + Grooming Agent |
| 2025-10-31 | Variable max iterations | Match complexity to iteration budget | Developer + Grooming Agent |

---

_Generated from grooming session on 2025-10-31_
