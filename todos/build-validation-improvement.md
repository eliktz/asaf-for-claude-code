# Build Validation Improvement Analysis

## Problem Statement

After completing a full ASAF groom → impl cycle, users frequently discover that:
- Code doesn't compile
- Build is failing
- Tests are broken
- Type errors exist

This wastes significant time and effort, as the entire implementation may need rework.

---

## Root Cause Analysis

### Why Does This Happen?

1. **No explicit validation checkpoints** - ASAF doesn't mandate build/test verification
2. **Acceptance criteria focus on functional requirements** - "User can login" not "Code compiles"
3. **Executor operates in isolation** - Writes code without verifying it integrates
4. **Late discovery** - Issues found only when user manually runs build
5. **Unknown build commands** - Claude may not know project-specific build/test commands
6. **Baseline assumption** - Assumes codebase was healthy before starting

### Failure Modes

| Failure Type | When Discovered | Cost |
|--------------|-----------------|------|
| Syntax error | After impl complete | Low (easy fix) |
| Type mismatch | After impl complete | Medium |
| Missing import | After impl complete | Low |
| Breaking existing tests | After impl complete | High |
| Build config issue | After impl complete | High |
| Integration failure | After impl complete | Very High |

**Key Insight**: All failures are discovered AFTER implementation is "complete" - too late.

---

## Constraints

User requirements:
- ❌ No new ASAF stages
- ✅ Enrich grooming phase (think about testing with user)
- ✅ Enrich implementation phase (verify during execution)
- ✅ Maintain current workflow feel

---

## Proposed Solution: Build Validation Integration

### Overview

Integrate build validation into existing phases:

```
GROOMING                          IMPLEMENTATION
   │                                    │
   ├─► Discover validation commands     ├─► Pre-flight check (baseline green?)
   │                                    │
   ├─► Add technical acceptance         ├─► Post-task validation (still green?)
   │   criteria                         │
   │                                    ├─► Fail-fast on breakage
   └─► Store in decisions.md            │
                                        └─► Final validation gate
```

---

## Part 1: Grooming Phase Enhancements

### 1.1 Validation Discovery (New Section in Phase 2)

Add to `grooming-agent.md` Phase 2 (Technical Design):

```markdown
### Validation Commands Discovery

Before finalizing technical design, establish validation strategy:

**USE AskUserQuestion:**
```yaml
AskUserQuestion:
  questions:
    - question: "What command runs the build for this project?"
      header: "Build"
      multiSelect: false
      options:
        - label: "npm run build"
          description: "Standard npm build"
        - label: "yarn build"
          description: "Yarn build"
        - label: "pnpm build"
          description: "pnpm build"
        - label: "Other/Custom"
          description: "I'll specify the command"
```

Follow up:
```yaml
AskUserQuestion:
  questions:
    - question: "What command runs the tests?"
      header: "Tests"
      multiSelect: false
      options:
        - label: "npm test"
          description: "Standard npm test"
        - label: "npm run test:unit"
          description: "Unit tests only"
        - label: "pytest"
          description: "Python pytest"
        - label: "Other/Custom"
          description: "I'll specify the command"
```

Optional (for TypeScript/typed languages):
```yaml
AskUserQuestion:
  questions:
    - question: "Should we run type checking separately?"
      header: "Types"
      multiSelect: false
      options:
        - label: "Yes, run tsc --noEmit"
          description: "TypeScript type check"
        - label: "Yes, run mypy"
          description: "Python type check"
        - label: "No, build includes it"
          description: "Type checking is part of build"
        - label: "Not applicable"
          description: "No static typing in this project"
```
```

### 1.2 Technical Acceptance Criteria (Mandatory)

Add to `grooming-agent.md` Phase 4 (Acceptance Criteria):

```markdown
### Technical Acceptance Criteria (Required)

In addition to functional acceptance criteria, ALWAYS include these technical criteria:

**Mandatory Technical AC** (add to every sprint):

```markdown
## Technical Acceptance Criteria

- [ ] **Build passes**: `[build_command]` exits with code 0
- [ ] **Tests pass**: `[test_command]` - all existing tests still pass
- [ ] **New tests pass**: Tests for new functionality pass
- [ ] **No type errors**: `[type_check_command]` reports no errors (if applicable)
- [ ] **No linting errors**: Code passes project linting rules (if applicable)
```

These are NON-NEGOTIABLE. Implementation cannot be marked complete without these passing.
```

### 1.3 Store in decisions.md

Add validation config to `decisions.md` template:

```markdown
## Validation Configuration

**Build Command**: `npm run build`
**Test Command**: `npm test`
**Type Check Command**: `tsc --noEmit` (or N/A)
**Lint Command**: `npm run lint` (or N/A)

**Pre-flight Requirement**: Build and tests must pass before implementation starts.
**Post-task Requirement**: Build and tests must pass after each task.
```

---

## Part 2: Implementation Phase Enhancements

### 2.1 Pre-Flight Check (Before First Task)

Add to `asaf-impl.md` after prerequisites:

```markdown
## Pre-Flight Validation

Before starting any implementation:

1. **Read validation commands** from `grooming/decisions.md`

2. **Run baseline check**:
   ```
   Running pre-flight validation...

   Build: [build_command]
   Tests: [test_command]
   ```

3. **Evaluate results**:

   **If all pass**:
   ```
   ✅ Pre-flight passed

   Baseline is green:
   - Build: ✅ Success
   - Tests: ✅ X tests passing

   Starting implementation...
   ```

   **If any fail**:
   ```
   🔴 Pre-flight FAILED

   Baseline is NOT green:
   - Build: ❌ Failed (see errors below)
   - Tests: ⚠️ 3 tests failing

   [Error output]
   ```

   **USE AskUserQuestion:**
   ```yaml
   AskUserQuestion:
     questions:
       - question: "Baseline validation failed. How should we proceed?"
         header: "Action"
         multiSelect: false
         options:
           - label: "Fix baseline first"
             description: "I'll fix these issues before we start"
           - label: "Proceed anyway"
             description: "These failures are known/expected"
           - label: "Skip validation"
             description: "Don't run validation for this sprint"
   ```
```

### 2.2 Post-Task Validation (After Each Task)

Add to `executor-agent.md` task completion:

```markdown
## Post-Task Validation (Required)

After completing each task, BEFORE marking it complete:

1. **Run build**:
   ```bash
   [build_command from decisions.md]
   ```

2. **Run tests**:
   ```bash
   [test_command from decisions.md]
   ```

3. **Evaluate**:

   **If all pass** → Mark task complete, proceed to reviewer

   **If build fails**:
   ```
   🔴 BUILD FAILED after Task [N]

   [Error output]

   Attempting to fix...
   ```
   - Analyze error
   - Fix the issue
   - Re-run validation
   - Max 3 fix attempts before escalating

   **If tests fail**:
   ```
   🟡 TESTS FAILING after Task [N]

   Failing tests:
   - test_name_1: [reason]
   - test_name_2: [reason]

   Analyzing if these are:
   1. Tests broken by our changes (must fix)
   2. Tests that need updating for new behavior (update test)
   3. Unrelated flaky tests (document and proceed)
   ```

4. **Document in progress.md**:
   ```markdown
   ### Task [N] Validation

   - Build: ✅ Passed
   - Tests: ✅ 42/42 passing
   - Type check: ✅ No errors
   ```
```

### 2.3 Fail-Fast Protocol

Add to `executor-agent.md`:

```markdown
## Fail-Fast Protocol

**If build/tests fail and cannot be fixed after 3 attempts:**

1. **Stop implementation immediately**
2. **Document the failure** in progress.md:
   ```markdown
   ### 🔴 VALIDATION FAILURE - Task [N]

   **Failed Check**: Build / Tests / Types
   **Error**: [error message]
   **Attempts**: 3/3
   **Root Cause Analysis**: [analysis]
   **Suggested Fix**: [what would fix it]
   ```

3. **Notify user**:
   ```
   🔴 Implementation Paused - Validation Failure

   Task [N] is causing [build/test] failures that I cannot resolve.

   Error: [summary]

   I've documented my analysis in progress.md.

   Options:
   1. Review my analysis and provide guidance
   2. Fix the issue manually and run /asaf-impl-resume
   3. Skip this validation and continue (/asaf-impl-resume --skip-validation)
   ```

4. **Update .state.json**:
   ```json
   {
     "status": "blocked",
     "blocked_reason": "validation_failure",
     "blocked_at_task": 3
   }
   ```
```

### 2.4 Final Validation Gate

Add to `asaf-impl.md` completion section:

```markdown
## Final Validation Gate

Before marking implementation complete:

1. **Full validation suite**:
   ```
   Running final validation...

   Build:      [running...]  ✅
   Tests:      [running...]  ✅ (47 passing)
   Type check: [running...]  ✅ (0 errors)
   Lint:       [running...]  ✅ (0 warnings)
   ```

2. **Technical AC verification**:
   ```
   Verifying Technical Acceptance Criteria:

   ✅ Build passes: npm run build exits with code 0
   ✅ Tests pass: All 47 tests passing
   ✅ New tests pass: 12 new tests added
   ✅ No type errors: tsc --noEmit clean
   ✅ No linting errors: eslint passed
   ```

3. **Only if ALL pass** → Mark implementation complete

4. **If any fail** → Return to executor to fix before completing
```

---

## Part 3: Changes Required

### Files to Modify

| File | Change |
|------|--------|
| `grooming-agent.md` | Add validation discovery to Phase 2 |
| `grooming-agent.md` | Add mandatory technical AC to Phase 4 |
| `asaf-groom-approve.md` | Validate technical AC exists |
| `executor-agent.md` | Add post-task validation requirement |
| `executor-agent.md` | Add fail-fast protocol |
| `asaf-impl.md` | Add pre-flight check |
| `asaf-impl.md` | Add final validation gate |
| Template: `decisions.md` | Add validation config section |
| Template: `acceptance-criteria.md` | Add technical AC section |

### New Content (No New Files)

All changes integrate into existing files - no new stages or commands.

---

## Part 4: User Experience Flow

### During Grooming

```
Claude: "Before we finalize the design, let's establish our validation strategy."

[AskUserQuestion: Build command?]
User: [clicks "npm run build"]

[AskUserQuestion: Test command?]
User: [clicks "npm test"]

Claude: "I've added these to decisions.md. I'll also add mandatory
technical acceptance criteria:
- Build passes
- Tests pass
- No type errors

These will be verified during implementation."
```

### During Implementation

```
Claude: "Running pre-flight validation..."

Build: ✅ Success
Tests: ✅ 42 tests passing

"Baseline is green. Starting Task 1..."

[Implements task 1]

"Running post-task validation..."

Build: ✅ Success
Tests: ✅ 43 tests passing (1 new)

"Task 1 complete. Proceeding to reviewer..."
```

### On Failure

```
Claude: "Running post-task validation..."

Build: ❌ FAILED

Error: Cannot find module './NewComponent'

"Build failed. Analyzing..."

"Found issue: Missing export in index.ts. Fixing..."

[Makes fix]

"Re-running validation..."

Build: ✅ Success

"Fixed. Proceeding to reviewer..."
```

---

## Part 5: Edge Cases

### EC1: No Build Command

Some projects don't have a build step (interpreted languages, simple scripts).

**Solution**: Make build command optional in discovery:
```yaml
options:
  - label: "No build step"
    description: "This project doesn't require building"
```

If selected, skip build validation but still run tests.

### EC2: No Tests

Some projects have no test suite.

**Solution**: Warn but don't block:
```
⚠️ No test command configured.

Implementation will proceed without test validation.
Consider adding tests for new functionality.
```

### EC3: Very Long Build Times

Some projects take 5+ minutes to build.

**Solution**: Ask during grooming:
```yaml
AskUserQuestion:
  questions:
    - question: "How long does the build typically take?"
      header: "Duration"
      multiSelect: false
      options:
        - label: "Fast (< 30 seconds)"
          description: "Run after every task"
        - label: "Medium (30s - 2 min)"
          description: "Run after every 2-3 tasks"
        - label: "Slow (> 2 minutes)"
          description: "Run only at milestones"
```

Adjust validation frequency based on answer.

### EC4: Flaky Tests

Tests that sometimes pass, sometimes fail.

**Solution**:
- Retry once on failure
- If passes on retry, document as flaky
- If fails twice, treat as real failure

### EC5: CI-Only Checks

Some validations only run in CI (e.g., E2E tests).

**Solution**: Ask during grooming:
```yaml
AskUserQuestion:
  questions:
    - question: "Are there checks that only run in CI?"
      header: "CI"
      multiSelect: false
      options:
        - label: "No, all checks run locally"
          description: "Full validation possible"
        - label: "Yes, some are CI-only"
          description: "I'll list what we can skip locally"
```

### EC6: Monorepo

Project has multiple packages with separate builds.

**Solution**: During grooming, ask which package(s) are affected:
```
Build commands for affected packages:
- packages/core: npm run build -w @myapp/core
- packages/api: npm run build -w @myapp/api
```

---

## Part 6: Benefits

### Immediate Benefits

1. **Early failure detection** - Catch issues after each task, not at the end
2. **Reduced rework** - Fix small issues before they compound
3. **Confidence** - Know implementation actually works
4. **Documentation** - Validation results logged in progress.md

### Long-term Benefits

1. **Better habits** - Developers learn to think about validation upfront
2. **Cleaner codebase** - No more "it worked for Claude" situations
3. **Faster cycles** - Less time debugging at the end
4. **Trust** - Users trust ASAF implementations more

### Metrics (Expected)

| Metric | Before | After |
|--------|--------|-------|
| Build failures at end | ~40% | <5% |
| Test failures at end | ~30% | <5% |
| Implementation rework | ~25% | <10% |
| User confidence | Medium | High |

---

## Part 7: Implementation Plan

### Phase 1: Grooming Enhancements

1. Update `grooming-agent.md` Phase 2:
   - Add validation discovery section
   - Add AskUserQuestion prompts for build/test/type commands

2. Update `grooming-agent.md` Phase 4:
   - Add mandatory technical AC section
   - Ensure these are always generated

3. Update `asaf-groom-approve.md`:
   - Validate that technical AC exists
   - Warn if missing

4. Update `decisions.md` template:
   - Add validation configuration section

### Phase 2: Implementation Enhancements

1. Update `asaf-impl.md`:
   - Add pre-flight validation section
   - Add final validation gate

2. Update `executor-agent.md`:
   - Add post-task validation requirement
   - Add fail-fast protocol
   - Add validation documentation in progress.md

3. Update `.state.json` schema:
   - Add `validation_config` field
   - Add `validation_status` tracking

### Phase 3: Testing

1. Test with TypeScript project (npm/yarn)
2. Test with Python project (pytest)
3. Test with project without tests
4. Test with slow build
5. Test failure scenarios

---

## Summary

This solution integrates build validation into ASAF without adding new stages:

| Phase | Enhancement |
|-------|-------------|
| **Grooming** | Discover validation commands, add technical AC |
| **Implementation** | Pre-flight check, post-task validation, fail-fast, final gate |

**Key Principles**:
- Validation is discovered during grooming (user input)
- Validation is enforced during implementation (automated)
- Failures are caught early and fixed immediately
- No surprises at the end

**Expected Outcome**: Build/test failures at end of implementation reduced from ~40% to <5%.

---

**Status**: Ready for implementation
**Priority**: HIGH - Addresses major pain point
**Complexity**: Medium - Changes to existing files only
**Dependencies**: None

---

_Document created: 2025-11-30_
_Author: Claude (via ASAF analysis)_
_Related: User feedback on build failures after implementation_
