# ASAF Architect Proposal

**Version**: 1.0-draft
**Date**: 2025-12-07
**Status**: RFC (Request for Comments)
**Author**: Asaf (ASAF creator) + Community Feedback

---

## Executive Summary

This proposal introduces the **ASAF Architect Agent** - a strategic layer above sprints that addresses three critical pain points identified after 2+ months of real-world ASAF usage:

1. **Pre-sprint friction**: Manual research needed before `/asaf-init` to provide proper context
2. **Post-sprint quality issues**: Sprints complete with non-compiling code, failing tests, or standards violations
3. **No cross-sprint memory**: Each sprint is isolated, with no keeper of "bigger picture" across related work

**Core Concept**: Add an architect persona that handles research, validation, and cross-sprint context management while maintaining ASAF's markdown-based simplicity.

---

## Table of Contents

1. [Problem Statement](#problem-statement)
2. [Industry Research](#industry-research)
3. [Proposed Solution](#proposed-solution)
4. [Architecture](#architecture)
5. [Model Strategy](#model-strategy)
6. [New Commands](#new-commands)
7. [Skills System](#skills-system)
8. [Epic Management](#epic-management)
9. [Quality Gates](#quality-gates)
10. [Configuration](#configuration)
11. [Examples](#examples)
12. [Open Questions](#open-questions)
13. [Migration Path](#migration-path)

---

## Problem Statement

### 1. Pre-Sprint Research Burden

**Current workflow**:
```
Manual research (1-2 hours)
  ↓
Create research notes
  ↓
/asaf-init
  ↓
/asaf-groom (lacks context from research)
```

**Pain points**:
- Research insights lost or poorly documented
- Grooming agent lacks architectural context
- Duplicate work when similar sprints done months apart
- No systematic way to analyze codebase patterns

**Real example**:
> "I often find myself using Claude Code to make a research document BEFORE using asaf to get better results"

### 2. Post-Sprint Quality Issues

**Current reality**:
- Sprints complete with code that doesn't compile
- Tests failing at end of implementation
- Code violates repository standards (custom patterns like special Record implementations)
- Manual refinement needed after "completion"

**Pain points**:
- Executor doesn't validate build before marking complete
- No enforcement of repo-specific patterns
- Reviewer checks design compliance but not execution quality
- Wasted iterations on broken code

**Real example**:
> "Sometimes at the end of asaf sprint the results are not good enough and I find myself refining manually or with Claude"

### 3. Isolated Sprints

**Current structure**:
```
asaf/
├── sprint-1/  (no connection)
├── sprint-2/  (no connection)
└── sprint-3/  (no connection)
```

**Pain points**:
- No cross-sprint architectural memory
- Related sprints don't share context
- Architectural decisions not preserved
- Same mistakes repeated across sprints
- Multi-phase features require manual planning

**Real example**:
> "I often manually research about a larger task/epic and produce several phases MD files which I turn into sprints"

---

## Industry Research

### Spec-Driven Development (GitHub Spec Kit, Sept 2024)

GitHub released [Spec Kit](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) with workflow:

```
Constitution → Specify → Plan → Tasks → Implementation
```

**Key concepts**:
- **Constitution**: Non-negotiable project principles
- **Specify**: Agent creates refined specs from high-level intent
- **Analyze**: Validation that spec/plan/tasks align

> "Specs are refined context that provides just enough information to LLMs to be effective without being overwhelmed"

**Relevance**: This is essentially an "architect" concept under different names.

### Multi-Agent Orchestration (2024-2025)

Microsoft's [AI Agent Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns) defines **Supervisor-Based Orchestration**:

> "A central orchestrator breaks down complex tasks, assigns them to the most relevant agents, reconciles results, and delivers unified outputs"

**Key findings**:
- Planning agents serve as central orchestrators
- Handle high-level reasoning and task decomposition
- Maintain context across agent interactions

**Relevance**: Validates the "orchestration" role we're proposing for the architect.

### Continuous Adaptive Requirements (Academic Research)

[CARE Framework](https://ieeexplore.ieee.org/document/5628553/) for runtime requirements refinement:

> "Self-adaptive systems monitor changes, evaluate, and enact suitable behavior ensuring acceptable quality"

**Key principle**: Requirements refinement is **continuous**, not one-time.

**Relevance**: Supports our "adapt specs along the way" concept.

### Architecture Decision Records (Industry Standard)

[ADR best practices](https://github.com/joelparkerhenderson/architecture-decision-record):

> "Many architectural decisions recur across projects; experiences with past decisions can be valuable reusable assets when employing an explicit knowledge management strategy"

> "Well-structured ADRs become valuable assets beyond individual projects... creating institutional memory that outlives individual team members" - [AWS](https://aws.amazon.com/blogs/architecture/master-architecture-decision-records-adrs-best-practices-for-effective-decision-making/)

**Relevance**: Validates cross-sprint knowledge management approach.

### Performance Data

- Teams using AI-assisted planning saw [**55% reduction in story point variance and 30% drop in cycle time**](https://www.ideas2it.com/blogs/agentic-ai-agile-software-delivery) across sprints (GitHub Next, 2024)
- [**Nearly 50% of AI vendors identified orchestration as their primary differentiator**](https://medium.com/@akankshasinha247/building-multi-agent-architectures-orchestrating-intelligent-agent-systems-46700e50250b) (Gartner 2025)

**Conclusion**: The industry is converging on these patterns independently. ASAF can adapt proven concepts to its markdown-based philosophy.

---

## Proposed Solution

### Core Principle

**Add strategic layer WITHOUT compromising ASAF's simplicity**:
- ✅ Still markdown-based (no databases, no backend)
- ✅ Still file-based state (version controllable)
- ✅ Still conversational (not prescriptive)
- ✅ Still optional (backward compatible)
- ✅ Still ASAF philosophy (conventions + prompts + structure)

### Three New Capabilities

#### 1. Architect Agent (New Persona)

**Role**: Senior technical architect who:
- Conducts pre-sprint research (codebase + web)
- Validates post-sprint implementation quality
- Maintains cross-sprint architectural context
- Enforces repository standards
- Learns from past mistakes

**NOT**: Micro-manager, blocker, ivory tower designer

#### 2. Epic Management (New Layer)

**Structure**:
```
asaf/
├── ARCHITECTURE.md       # Project-wide principles (constitution)
├── DECISIONS.md          # ADR log
├── PATTERNS.md           # Reusable solutions
├── epics/
│   └── user-auth/
│       ├── EPIC.md       # Vision, scope, sprint breakdown
│       ├── research/     # Pre-epic research
│       ├── architecture.md  # Epic-specific architecture
│       └── sprints/
│           ├── basic-login/
│           ├── oauth-integration/
│           └── 2fa/
└── standalone-sprints/   # One-off sprints
```

**Purpose**: Handle multi-phase features with shared context

#### 3. Quality Gates (Skills-Based)

**Automated validation** before marking tasks complete:
- ✅ Code compiles/builds successfully
- ✅ Tests pass
- ✅ Linting passes
- ✅ Repository standards met
- ✅ Architecture compliance verified

**Purpose**: Prevent "sprint done but code broken" scenarios

---

## Architecture

### File Structure

```
~/.claude/
├── commands/
│   ├── asaf-*.md              # Existing commands
│   ├── asaf-epic-*.md         # NEW: Epic commands (3)
│   ├── asaf-architect-*.md    # NEW: Architect commands (1)
│   ├── asaf-config.md         # NEW: Configuration wizard (1)
│   └── shared/
│       ├── grooming-agent.md
│       ├── executor-agent.md
│       ├── reviewer-agent.md
│       └── architect-agent.md  # NEW: Architect persona
│
├── skills/                     # NEW: Skills system
│   ├── asaf-quality-gate/
│   │   └── skill.md
│   ├── asaf-repo-standards/
│   │   └── skill.md
│   └── asaf-anti-regression/
│       └── skill.md
│
└── asaf-config.json           # NEW: Global defaults

user-project/
├── asaf/
│   ├── .config.json           # NEW: Project config overrides
│   ├── ARCHITECTURE.md        # NEW: Project architecture
│   ├── DECISIONS.md           # NEW: ADR log
│   ├── PATTERNS.md            # NEW: Reusable patterns
│   ├── REPO-STANDARDS.md      # NEW: Coding standards
│   ├── MISTAKES-LOG.md        # NEW: Learning database
│   │
│   ├── epics/                 # NEW: Epic structure
│   │   └── <epic-name>/
│   │       ├── EPIC.md
│   │       ├── research/
│   │       ├── architecture.md
│   │       └── sprints/
│   │
│   └── <sprint-name>/         # Existing sprint structure (unchanged)
```

### State Management

**Epic state** (`asaf/epics/<epic>/.state.json`):
```json
{
  "epic": "user-authentication",
  "status": "in-progress",
  "sprints": [
    {
      "name": "basic-login",
      "status": "complete",
      "completed_at": "2025-12-05"
    },
    {
      "name": "oauth-integration",
      "status": "in-progress",
      "phase": "implementation"
    }
  ],
  "architecture_locked": true,
  "cross_sprint_decisions": ["ADR-015", "ADR-018"]
}
```

**Backward compatible**: Existing sprint `.state.json` unchanged

---

## Model Strategy

### Research Findings: Opus vs Sonnet for Agents

**Key benchmarks** ([source](https://www.anthropic.com/news/claude-opus-4-5)):

- **Multi-agent orchestration**: Opus 4.5 excels at "managing a team of subagents"
- **Long-horizon tasks**: 15% improvement over Sonnet on Terminal Bench
- **Autonomous coding**: Fewer dead-ends in complex workflows
- **Iteration efficiency**: Opus achieves peak performance in 4 iterations vs 10+ for other models
- **Token efficiency**: Uses 48-76% fewer output tokens while achieving better results
- **Reasoning**: On ARC-AGI-2, Opus scores 37.6% vs Sonnet's 13.6% (3x difference)

### Recommended Model Assignment

Based on [Difficulty-Aware Agentic Orchestration](https://arxiv.org/html/2509.11079v1) research (2025):

> "Heterogeneous model selection exploits model strengths rather than enforcing uniformity, achieving 11.21% better accuracy using only 64% of inference cost"

| Agent | Model | Rationale |
|-------|-------|-----------|
| **Architect** | **Opus** | Complex reasoning, multi-file analysis, research synthesis |
| **Grooming** | **Opus** | Design conversations, trade-off analysis, educational explanations |
| **Executor** | **Opus** | **Autonomous implementation over hours**, complex edge cases, sustained reasoning |
| **Reviewer** | **Sonnet** (default) | Fast pattern-matching for validation, checklist-based |
| **Reviewer (Educational)** | **Opus** | Deep explanations when teaching |
| **Skills** | **Haiku** | Deterministic checks (build, lint, test), speed critical |

### Why Executor Uses Opus

ASAF executor runs **autonomously for 3-6 hours** during `/asaf-impl`:
- Multiple tasks sequentially
- Complex edge case handling
- Test writing + debugging
- Self-correction across iterations
- **Zero human intervention**

This is **long-horizon autonomous coding** - Opus's strength.

**Token economics**:
- Sonnet: 5 tasks × 3 iterations × 10k tokens = 150k tokens
- Opus: 5 tasks × 1.5 iterations × 12k tokens = 90k tokens
- **40% token savings** by reducing wasted iterations

### Version Handling

**Proposal**: Use model families, not versions:

```markdown
**Model**: opus   # Resolves to latest Opus (future-proof)
**Model**: sonnet # Resolves to latest Sonnet
**Model**: haiku  # Resolves to latest Haiku
```

If pinning needed: `**Model**: opus-4-5`

**Fallback**: Configuration-based resolution in `.config.json`

---

## New Commands

### Command Count Analysis

**Existing**: 15 commands
**New**: 5 commands
**Total**: 20 commands

**Breakdown**:

#### Epic Management (3 commands)

##### `/asaf-epic-init "<name>" "<description>"`
**Purpose**: Initialize epic with research and sprint breakdown

**What it does**:
1. Adopts architect-agent.md persona (Opus)
2. Conducts research:
   - Searches codebase for existing patterns
   - Searches web for best practices
   - Analyzes relevant technologies
3. Creates `asaf/epics/<name>/` structure
4. Generates:
   - `EPIC.md` (vision, scope, sprint breakdown)
   - `research/` folder (findings, alternatives)
   - `architecture.md` (epic-level architecture)
5. Updates state

**Example**:
```bash
/asaf-epic-init "user-authentication" "Implement full auth system with OAuth"
```

**Output**:
```
Architect: Conducting research...
  ✓ Analyzed codebase (found existing auth middleware)
  ✓ Searched web (OAuth 2.0 best practices 2025)
  ✓ Identified patterns (session management in /lib/auth)

Created: epics/user-authentication/
  ├── EPIC.md
  ├── research/
  │   ├── codebase-analysis.md
  │   ├── best-practices.md
  │   └── alternatives.md
  └── architecture.md

Proposed sprints:
  1. basic-login (Session-based, 6-8 hrs)
  2. oauth-google (Google OAuth, 6-10 hrs)
  3. 2fa (TOTP-based, 4-6 hrs)

Next: /asaf-epic-sprint "user-authentication" "basic-login"
```

---

##### `/asaf-epic-sprint "<epic-name>" "<sprint-name>"`
**Purpose**: Create sprint within epic (context-aware)

**What it does**:
1. Validates epic exists
2. Creates `epics/<epic>/sprints/<sprint>/`
3. Pre-loads sprint with:
   - Epic EPIC.md context
   - Epic architecture.md constraints
   - Links to related sprints
4. Updates epic state

**Example**:
```bash
/asaf-epic-sprint "user-authentication" "basic-login"
```

**Output**:
```
✓ Created sprint: epics/user-authentication/sprints/basic-login/
✓ Linked to epic architecture
✓ Pre-loaded context from EPIC.md

This sprint inherits:
  - Auth patterns from epic architecture
  - Security constraints from DECISIONS.md
  - Session management approach (defined in epic)

Next: /asaf-groom
```

---

##### `/asaf-epic-status "<epic-name>"`
**Purpose**: View progress across all sprints in epic

**Example**:
```bash
/asaf-epic-status "user-authentication"
```

**Output**:
```
Epic: user-authentication
Status: In Progress (67% complete)

Sprints:
  ✅ basic-login - Complete (Dec 5, 2025)
  ✅ oauth-google - Complete (Dec 6, 2025)
  🔄 2fa - In Progress (implementation phase)

Architecture Decisions: 3 ADRs created
  - ADR-015: Session storage with Redis
  - ADR-018: JWT for OAuth tokens
  - ADR-021: TOTP library selection

Next: Complete 2FA implementation
Blockers: None
```

---

#### Architect Validation (1 command)

##### `/asaf-architect-review`
**Purpose**: Post-implementation validation and refinement

**What it does**:
1. Adopts architect-agent.md persona (Opus)
2. Validates implementation:
   - Build successful?
   - Tests passing?
   - Repo standards met?
   - Architecture alignment?
   - Edge cases properly handled?
3. If issues found:
   - Lists specific violations
   - Proposes fixes (based on auto-fix config)
   - Optionally auto-refines
4. Creates `validation/review.md`
5. Updates `PATTERNS.md` and `MISTAKES-LOG.md`

**Example**:
```bash
/asaf-architect-review
```

**Output (with issues)**:
```
Architect: Reviewing sprint implementation...

Build & Tests:
  ✅ Build successful
  ✅ Tests passing (42/42)

Repository Standards:
  ⚠️ Found 3 violations:

  1. src/auth/login.ts:15
     Issue: Using plain Error (should use Result<T,E>)
     Standard: REPO-STANDARDS.md section 2.3
     Fix: return Result.err(new AuthError(...))

  2. src/auth/session.ts:8
     Issue: File organization violation
     Expected: src/lib/auth/session.ts
     Current: src/auth/session.ts

  3. Missing edge case: concurrent login attempts
     Reference: grooming/edge-cases.md #7
     Needs: Rate limiting implementation

Auto-fix: propose (from config)

[Shows diffs for fixes 1-2]

Apply fixes? (y/n):
```

**Output (all good)**:
```
Architect: Reviewing sprint implementation...

✅ Build successful
✅ Tests passing (42/42)
✅ Repository standards compliant
✅ Architecture alignment verified
✅ All edge cases handled

Excellent work! Sprint approved.

Updated:
  - PATTERNS.md (added auth session pattern)
  - DECISIONS.md (documented session storage choice)
```

---

#### Configuration (1 command)

##### `/asaf-config`
**Purpose**: Interactive configuration wizard

**What it configures**:
1. Validation strictness
2. Auto-fix behavior
3. Model assignments
4. Quality gate thresholds

**Example flow**:
```bash
/asaf-config
```

```
ASAF Configuration Wizard

1. Validation Strictness

   When should implementation be blocked?

   Build errors:
     1. Strict - Block until fixed (recommended)
     2. Advisory - Warn but allow
     3. Off
   Choice: [1]

   Test failures:
     1. Strict - Block until fixed (recommended)
     2. Advisory - Warn but allow
     3. Off
   Choice: [1]

   Repository standards:
     1. Strict - Block until fixed
     2. Advisory - Warn but allow (recommended)
     3. Off
   Choice: [2]

2. Auto-Fix Behavior

   When code violates standards, how should I respond?

   1. Automatic - Fix without asking (fast, autonomous)
   2. Propose - Show diff, ask permission (recommended)
   3. List only - Report, you fix manually
   Choice: [2]

3. Model Strategy (Advanced)

   Use recommended model assignments?
   - Architect: Opus (research, reasoning)
   - Grooming: Opus (design conversations)
   - Executor: Opus (autonomous coding)
   - Reviewer: Sonnet (validation)
   - Skills: Haiku (deterministic checks)

   1. Yes, use recommended (recommended)
   2. Customize
   Choice: [1]

4. Quality Gates

   Minimum test coverage for new code: [80]%
   Max acceptable linting errors: [0]

Saved to: asaf/.config.json

Configuration complete! Run /asaf-status to verify.
```

---

### Command Summary Table

| Command | Purpose | Frequency |
|---------|---------|-----------|
| `/asaf-epic-init` | Start epic with research | Per epic (1-2/month) |
| `/asaf-epic-sprint` | Create sprint in epic | Per sprint in epic |
| `/asaf-epic-status` | View epic progress | As needed |
| `/asaf-architect-review` | Validate implementation | After `/asaf-impl` |
| `/asaf-config` | Configure ASAF | Once per project |

**Total new commands: 5**
**Total ASAF commands: 20** (15 existing + 5 new)

---

## Skills System

### What Are Skills?

Skills are **reusable validation/execution modules** invoked by agents during workflows. They're markdown-based prompt modules with specific expertise.

**Philosophy**: Skills absorb complexity, keeping commands simple.

### Three Core Skills

#### 1. `asaf-quality-gate`

**Purpose**: Validate build, tests, and linting

**Auto-detection logic**:
- Scans for `package.json`, `Cargo.toml`, `pom.xml`, etc.
- Detects build commands from scripts
- Identifies test framework
- Finds linter configuration

**Execution**:
```
1. Build
   - Detected: package.json → npm run build
   - Run: npm run build
   - Result: ✅ Success (23 files)

2. Tests
   - Detected: Jest
   - Run: npm test
   - Result: ✅ 42 passed, 0 failed

3. Linting
   - Detected: ESLint
   - Run: eslint src/
   - Result: ✅ 0 errors, 2 warnings
```

**Invoked**: Automatically during `/asaf-impl` after each task

**Model**: Haiku (fast, cheap, deterministic)

---

#### 2. `asaf-repo-standards`

**Purpose**: Enforce project-specific patterns

**Uses**: `asaf/REPO-STANDARDS.md`

**Checks**:
- Code patterns (custom Record implementations, error handling)
- File organization (module structure, naming conventions)
- Prohibited patterns (identified anti-patterns)
- Consistency (similar problems solved similarly)

**Example validation**:
```
Checking against REPO-STANDARDS.md...

Pattern Compliance:
  ✅ Error handling uses Result<T,E> pattern
  ❌ Data model doesn't extend BaseRecord
     File: src/models/user.ts:5
     Expected: class User extends BaseRecord<UserData>
     Current: interface User { ... }

File Organization:
  ❌ API route in wrong location
     File: src/api/login.ts
     Expected: src/app/api/auth/login/route.ts
     Reason: Next.js 13+ app router convention

Fix suggestions:
  1. Refactor User to class extending BaseRecord
  2. Move login.ts to correct app router location
```

**Created via**: `/asaf-standards-init` (guided wizard)

**Invoked**: During `/asaf-architect-review`

**Model**: Sonnet (pattern matching, structured checks)

---

#### 3. `asaf-anti-regression`

**Purpose**: Learn from past mistakes

**Uses**: `asaf/MISTAKES-LOG.md` (generated from retros)

**Example log**:
```markdown
# Common Mistakes Log

## Authentication Patterns
- **Mistake**: Using `any` type for user objects (occurred: 3 sprints)
  - Impact: Runtime type errors
  - Prevention: Use User interface from /types/user
  - Test: Add TypeScript strict checks

## Error Handling
- **Mistake**: Forgot to handle null case from DB queries (occurred: 4 sprints)
  - Impact: Null pointer exceptions
  - Prevention: Always check query results before use
  - Pattern: if (!result) return Result.err(...)
```

**Proactive warnings** (before task starts):
```
⚠️ Anti-Regression Alert

Based on past sprints, watch out for:

1. Auth task detected - We've had 3 sprints with 'any' type issues
   → Use strict typing: User interface from /types/user

2. Database queries in this task - 4 sprints had null handling bugs
   → Always check: if (!result) return Result.err(...)
```

**Invoked**:
- Before task (proactive warnings)
- After task (check if repeated)

**Model**: Sonnet (pattern recognition, learning)

---

### Skills vs Commands

**Commands**: User-facing, high-level workflows
**Skills**: Internal, reusable validation/execution logic

**Example**: `/asaf-impl` command invokes 3 skills automatically:
1. `asaf-anti-regression` (get warnings)
2. `asaf-quality-gate` (validate build/test)
3. `asaf-repo-standards` (check patterns)

This keeps `/asaf-impl` simple while adding sophisticated validation.

---

## Epic Management

### When to Use Epics vs Standalone Sprints

**Use Epic when**:
- Multi-phase feature (3+ related sprints)
- Shared architecture across sprints
- Research needed upfront
- Cross-sprint dependencies

**Examples**:
- "User authentication system" (login + OAuth + 2FA)
- "Payment processing" (Stripe integration + refunds + webhooks)
- "Admin dashboard" (user management + analytics + settings)

**Use Standalone Sprint when**:
- Bug fix
- One-off feature
- Independent task
- Quick enhancement

**Examples**:
- "Fix pagination bug"
- "Add email notifications"
- "Optimize image loading"

### Epic Workflow

```
1. Initialize Epic
   /asaf-epic-init "name" "description"
   → Research phase (architect)
   → Sprint breakdown
   → Epic architecture

2. Execute Sprints Sequentially
   /asaf-epic-sprint "epic" "sprint-1"
   /asaf-groom
   /asaf-groom-approve
   /asaf-impl
   /asaf-architect-review

   /asaf-epic-sprint "epic" "sprint-2"
   [repeat]

3. Track Progress
   /asaf-epic-status "epic"
   → See completed/in-progress/upcoming sprints
   → View architectural decisions
   → Check blockers
```

### Epic Structure Example

```
asaf/epics/user-authentication/
├── EPIC.md                      # Vision, scope, success criteria
├── .state.json                  # Epic state
├── research/                    # Pre-epic research
│   ├── codebase-analysis.md
│   ├── oauth-investigation.md
│   ├── security-review.md
│   └── alternatives.md
├── architecture.md              # Epic-level architecture
└── sprints/
    ├── 01-basic-login/
    │   ├── SUMMARY.md
    │   ├── grooming/
    │   └── implementation/
    ├── 02-oauth-google/
    │   └── ...
    └── 03-2fa/
        └── ...
```

### Cross-Sprint Context

**Problem solved**: Sprint 2 automatically knows about Sprint 1's decisions.

**How**:
- Sprint 2 reads `epic/architecture.md`
- Links to ADRs created in Sprint 1
- Understands constraints from earlier work

**Example**:
```markdown
# Sprint 2: OAuth Google

## Context from Epic
- Sprint 1 established session storage with Redis (ADR-015)
- User model defined in sprint 1 (/models/user.ts)
- Security constraints: HTTPS only, secure cookies

## This Sprint's Focus
- Integrate Google OAuth
- Reuse existing session infrastructure
- Follow established auth patterns
```

---

## Quality Gates

### Validation Layers

Implementation goes through **4 validation layers**:

```
┌─ 1. BUILD & TEST GATE (asaf-quality-gate skill)
│   ├─ Code compiles?
│   ├─ Tests pass?
│   └─ Linting clean?
│
├─ 2. REPOSITORY STANDARDS (asaf-repo-standards skill)
│   ├─ Follows code patterns?
│   ├─ File organization correct?
│   └─ No anti-patterns?
│
├─ 3. ARCHITECTURE ALIGNMENT (architect agent)
│   ├─ Matches ARCHITECTURE.md?
│   ├─ Follows ADRs?
│   └─ Epic constraints met?
│
└─ 4. DESIGN COMPLIANCE (reviewer agent)
    ├─ Implements design.md?
    ├─ Handles edge cases?
    └─ Tests adequate?
```

**Only when all 4 pass**: Task marked complete

### Enhanced `/asaf-impl` Loop

```
For each task:

  ┌─ EXECUTOR PHASE
  │   ├─ Read task + design + edge cases
  │   ├─ Invoke asaf-anti-regression (get warnings)
  │   ├─ Implement code
  │   └─ Write tests
  │
  ├─ GATE 1: Quality Gate (Automatic)
  │   ├─ Invoke asaf-quality-gate skill
  │   ├─ If FAIL: Executor auto-fixes, retry (max 3x)
  │   └─ If still fail: Mark BLOCKED, escalate
  │
  ├─ GATE 2: Repo Standards (Automatic)
  │   ├─ Invoke asaf-repo-standards skill
  │   ├─ If violations: List for executor
  │   ├─ Executor fixes
  │   └─ Re-check until pass
  │
  ├─ GATE 3: Architect Validation
  │   ├─ Check ARCHITECTURE.md compliance
  │   ├─ Verify epic constraints (if applicable)
  │   └─ APPROVE or REQUEST CHANGES
  │
  ├─ GATE 4: Reviewer Phase
  │   ├─ Check design compliance
  │   ├─ Verify edge case coverage
  │   └─ APPROVE or REQUEST CHANGES
  │
  └─ All gates pass → Task complete ✅
```

### Configuration

**Strictness levels** (set via `/asaf-config`):

- **Strict**: Block progress until fixed (recommended for build/tests)
- **Advisory**: Warn but allow override (recommended for style)
- **Off**: Skip this gate

**Example config**:
```json
{
  "validation": {
    "build_errors": "strict",      // Never proceed with broken code
    "test_failures": "strict",     // Never proceed with failing tests
    "repo_standards": "advisory",  // Warn about violations
    "linting": "advisory",         // Warn about style issues
    "architecture": "strict"       // Must align with architecture
  }
}
```

---

## Configuration

### Configuration Hierarchy

```
Global Default
  ↓ (overrides)
Project Config
  ↓ (overrides)
Command-line flags
```

**Files**:
1. `~/.claude/asaf-config.json` - Global defaults
2. `project/asaf/.config.json` - Project-specific overrides
3. CLI: `/asaf-impl --strict-mode` (one-time override)

### Configuration Schema

```json
{
  "version": "1.0",

  "validation": {
    "build_errors": "strict",
    "test_failures": "strict",
    "repo_standards": "advisory",
    "linting": "advisory",
    "architecture": "strict"
  },

  "auto_fix": "propose",  // automatic | propose | list

  "models": {
    "architect": "opus",
    "grooming": "opus",
    "executor": "opus",
    "reviewer": "sonnet",
    "reviewer_educational": "opus",
    "skills": "haiku"
  },

  "quality_gates": {
    "min_test_coverage": 80,
    "max_linting_errors": 0,
    "max_linting_warnings": 10
  },

  "build": {
    "commands": {
      "compile": "npm run build",      // Auto-detected if null
      "test": "npm test",
      "lint": "npm run lint"
    }
  }
}
```

### Creating Configuration

**Method 1**: Wizard (recommended)
```bash
/asaf-config
```

**Method 2**: Manual
```bash
# Copy template
cp ~/.claude/asaf-config.template.json asaf/.config.json

# Edit
vim asaf/.config.json
```

**Method 3**: Inherit + Override
```json
// asaf/.config.json
{
  "extends": "~/.claude/asaf-config.json",
  "validation": {
    "repo_standards": "strict"  // Override just this
  }
}
```

---

## Examples

### Example 1: Epic Workflow (User Authentication)

```bash
# Initialize epic
/asaf-epic-init "user-authentication" "Full auth system with OAuth and 2FA"
```

**Architect output**:
```
Conducting research on user authentication...

Codebase Analysis:
  ✓ Found existing middleware: /middleware/auth.ts
  ✓ Session storage: Currently in-memory (not production-ready)
  ✓ User model: /models/user.ts (basic, needs expansion)

Web Research:
  ✓ OAuth 2.0 best practices (2025)
  ✓ TOTP 2FA implementation patterns
  ✓ Session security recommendations

Architectural Decisions Needed:
  1. Session storage: Redis vs PostgreSQL vs JWT
  2. OAuth provider: Google, GitHub, or both?
  3. 2FA method: TOTP (app) vs SMS vs email

Recommended Sprints:
  1. basic-login (6-8h)
     - Email/password authentication
     - Session management with Redis
     - Password hashing with bcrypt

  2. oauth-google (8-10h)
     - Google OAuth integration
     - Account linking
     - Profile sync

  3. 2fa (4-6h)
     - TOTP implementation
     - Backup codes
     - Recovery flow

Created: epics/user-authentication/
  ├── EPIC.md
  ├── research/
  │   ├── codebase-analysis.md
  │   ├── oauth-comparison.md
  │   └── session-storage-decision.md
  └── architecture.md

Next: Review epics/user-authentication/EPIC.md
Then: /asaf-epic-sprint "user-authentication" "basic-login"
```

---

```bash
# Start first sprint
/asaf-epic-sprint "user-authentication" "basic-login"
```

**Output**:
```
Created sprint: epics/user-authentication/sprints/basic-login/

Inherited from epic:
  - Architecture: Redis session storage (ADR-015)
  - Security: HTTPS only, secure cookies, CSRF protection
  - User model: Extend existing /models/user.ts

This sprint will establish:
  - Foundation for future OAuth integration
  - Session patterns for entire epic
  - Security baseline

Next: /asaf-groom
```

---

```bash
# Normal grooming
/asaf-groom
```

**Grooming conversation** (abbreviated):
```
Grooming Agent: I see you're building basic login as part of the
user-authentication epic. I've read the epic architecture - you've
decided on Redis for sessions and bcrypt for passwords. Let's design
the login flow.

First, let's clarify: What user flows do we need?
1. Registration (new user)
2. Login (existing user)
3. Logout
4. Password reset?

User: 1-3 for this sprint, password reset later

Grooming Agent: Got it. For registration, the epic architecture specifies
extending the existing User model. Looking at /models/user.ts, I see it
has email and id. We'll need to add passwordHash.

Should we also add email verification in this sprint, or defer that?

[... conversation continues ...]

✓ Generated grooming/design.md
✓ Generated grooming/edge-cases.md (12 cases)
✓ Generated grooming/acceptance-criteria.md (6 criteria)
✓ Generated grooming/decisions.md

Next: /asaf-groom-approve
```

---

```bash
# Approve grooming
/asaf-groom-approve
```

**Output**:
```
Grooming locked ✓
Generated tasks.md (5 tasks)

Tasks:
  1. Update User model with passwordHash
  2. Implement registration endpoint
  3. Implement login endpoint with session creation
  4. Implement logout endpoint
  5. Add comprehensive tests

Next: /asaf-impl
```

---

```bash
# Implementation with quality gates
/asaf-impl
```

**Enhanced output with gates**:
```
Starting implementation (5 tasks)...

[Task 1: Update User model]

  Executor: Implementing...
    ✓ Added passwordHash field to User model
    ✓ Updated Prisma schema
    ✓ Generated migration

  Quality Gate 1: Build & Test
    ✓ Running: npm run build
    ✓ Build successful
    ✓ Running: npm test
    ✓ Tests pass (38/38)

  Quality Gate 2: Repo Standards
    ⚠️ Checking against REPO-STANDARDS.md...
    ✓ No violations

  Architect Validation:
    ✓ Aligns with epic architecture
    ✓ Follows ADR-015 (data model patterns)

  Reviewer:
    ✓ Design compliance verified
    ✓ Edge cases handled
    ✓ APPROVED

  Task 1 complete ✅

[Task 2: Registration endpoint]

  Executor: Implementing...
    ✓ Created /api/auth/register route
    ✓ Added email validation
    ✓ Added password hashing (bcrypt, 10 rounds)
    ✓ Wrote 8 tests

  Quality Gate 1: Build & Test
    ✓ Build successful
    ❌ Tests failing (2/8)
       - "should reject weak password" - FAIL
       - "should reject duplicate email" - FAIL

  Executor: Fixing test failures...
    Fixed: Weak password validation (min 8 chars + number)
    Fixed: Duplicate email check (unique constraint)
    ✓ Re-running tests: 8/8 pass

  Quality Gate 2: Repo Standards
    ⚠️ Found 1 violation:
       - /api/auth/register.ts:23 uses throw Error
       - Should use: Result<T, E> pattern

  Executor: Fixing standards violation...
    ✓ Refactored to Result<User, AuthError>
    ✓ Re-check: No violations

  Architect Validation:
    ✓ Architecture compliant
    ✓ Security requirements met

  Reviewer:
    ✓ All edge cases handled (email format, duplicate, weak password)
    ✓ APPROVED

  Task 2 complete ✅

[Tasks 3-5 continue similarly...]

Implementation complete! All 5 tasks done.

Next: /asaf-architect-review (final validation)
```

---

```bash
# Final architect review
/asaf-architect-review
```

**Output**:
```
Architect: Performing final validation...

Build & Tests:
  ✅ Build successful
  ✅ All tests passing (58/58)
  ✅ Coverage: 94% (exceeds 80% threshold)

Repository Standards:
  ✅ All files follow conventions
  ✅ No anti-patterns detected
  ✅ Consistent with codebase style

Architecture Alignment:
  ✅ Follows epic architecture.md
  ✅ Complies with ADR-015 (session storage)
  ✅ Security requirements met:
      - Passwords hashed (bcrypt, 10 rounds)
      - Sessions in Redis (secure, httpOnly cookies)
      - CSRF protection implemented

Edge Case Coverage:
  ✅ All 12 edge cases from grooming handled
  ✅ Tests cover happy path + error cases

Code Quality:
  ✅ Clear, readable code
  ✅ Appropriate error messages
  ✅ Good test names

Sprint approved! ✅

Updated:
  - DECISIONS.md (added ADR-021: bcrypt configuration)
  - PATTERNS.md (added auth session pattern)
  - Epic state (basic-login → complete)

Next sprint: /asaf-epic-sprint "user-authentication" "oauth-google"
```

---

### Example 2: Standalone Sprint (Bug Fix)

```bash
# Traditional standalone sprint (no epic needed)
/asaf-init "fix-pagination-bug"
/asaf-groom
/asaf-groom-approve
/asaf-impl

# Still benefits from quality gates
# Still gets architect validation if /asaf-architect-review run
# But no epic structure needed
```

---

### Example 3: First-Time Setup

```bash
# Install ASAF globally
cd ~/asaf-for-claude-code
./install.sh

# In your project
cd ~/my-project

# One-time project setup
/asaf-config
```

**Config wizard**:
```
Welcome to ASAF! Let's configure your project.

Detecting your codebase...
  ✓ TypeScript detected (package.json)
  ✓ React detected
  ✓ Jest detected (test framework)
  ✓ ESLint detected

[Validation questions...]
[Auto-fix questions...]
[Model strategy questions...]

Created: asaf/.config.json

Would you like to create repository standards? (y/n): y
```

**Standards wizard**:
```
/asaf-standards-init
```

```
Analyzing codebase patterns...

Found 3 error handling patterns:
  1. try/catch with throw (15 files) ← Most common
  2. Result<T, E> (3 files)
  3. Callbacks with err param (legacy, 2 files)

Which should be standard for NEW code?
  1. try/catch with throw
  2. Result<T, E>
  3. Callbacks
Choice: 2

Found 2 data model patterns:
  1. Plain interfaces (20 files)
  2. Classes with validation (5 files) ← Best practice

Which should be standard?
  1. Plain interfaces
  2. Classes with validation
Choice: 2

[... more questions ...]

Generated: asaf/REPO-STANDARDS.md

Sample:
  ## Error Handling
  **Standard**: Use Result<T, E> pattern
  **Anti-pattern**: throw Error (except for unexpected errors)

  ## Data Models
  **Standard**: Classes with validation methods
  **Example**: class User { validate() { ... } }

Review asaf/REPO-STANDARDS.md and edit as needed.

Setup complete! You're ready to use ASAF.

Try: /asaf-init "your-first-sprint"
```

---

## Open Questions

These questions need community feedback before implementation:

### 1. Epic Management

**Q1.1**: Should `/asaf-status` auto-detect context (epic vs sprint) or require explicit mode?

**Option A**: Auto-detect
```bash
/asaf-status  # Inside epic sprint → shows epic status
/asaf-status  # Inside standalone → shows sprint status
```

**Option B**: Explicit
```bash
/asaf-status        # Always current sprint
/asaf-epic-status "epic-name"  # Explicit epic status
```

**Q1.2**: Should epic architecture be locked after first sprint starts, or editable throughout?

**Option A**: Locked (immutable after first sprint)
**Option B**: Editable (can evolve, but tracked in ADRs)

**Q1.3**: Can standalone sprints be "upgraded" to epic sprints later?

**Example**: Start as bug fix, realize it's part of larger feature
```bash
/asaf-sprint-to-epic "fix-pagination" "pagination-overhaul"
```

---

### 2. Quality Gates

**Q2.1**: If quality gate fails after max retries (3x), should we:

**Option A**: Block completely (require manual intervention)
**Option B**: Allow override with explicit `/asaf-impl --force`
**Option C**: Escalate to architect for review
**Option D**: Configurable per gate

**Q2.2**: Should quality gates run on EVERY task or only at sprint completion?

**Option A**: Every task (safer, slower)
**Option B**: Sprint completion only (faster, riskier)
**Option C**: Configurable (user chooses)

**Q2.3**: What happens if repo standards change mid-sprint?

**Example**: REPO-STANDARDS.md updated during implementation

**Option A**: New standards apply immediately to remaining tasks
**Option B**: Sprint locked to standards from /asaf-groom-approve
**Option C**: Warning shown, user decides

---

### 3. Architect Agent Behavior

**Q3.1**: Should `/asaf-architect-review` be:

**Option A**: Automatic (always runs after `/asaf-impl`)
**Option B**: Manual (user explicitly invokes)
**Option C**: Configurable (auto for epics, manual for standalone)

**Q3.2**: When architect finds issues, should refinement be:

**Option A**: Automatic (if auto_fix: automatic)
**Option B**: Always ask user permission
**Option C**: Configurable threshold (auto-fix if <5 issues, else ask)

**Q3.3**: Should architect validation block demo/retro?

**Option A**: Yes (can't run /asaf-demo until architect approves)
**Option B**: No (architect review is optional)
**Option C**: Configurable

---

### 4. Repository Standards

**Q4.1**: Should REPO-STANDARDS.md support multiple profiles?

**Example**: Different standards for frontend vs backend in monorepo

**Option A**: Single standards file (simpler)
**Option B**: Multiple profiles (REPO-STANDARDS-frontend.md, REPO-STANDARDS-backend.md)
**Option C**: Sections within one file, auto-detect based on path

**Q4.2**: How should we handle evolving standards?

**Option A**: Manual updates to REPO-STANDARDS.md
**Option B**: `/asaf-standards-review` command (analyzes recent code, suggests updates)
**Option C**: Automatic learning (track patterns from approved code)

**Q4.3**: Should standards violations be:

**Option A**: All equal priority
**Option B**: Categorized (critical, warning, info)
**Option C**: User-assigned priority in REPO-STANDARDS.md

---

### 5. Skills System

**Q5.1**: Should users be able to create custom skills easily?

**Option A**: Yes, via `/asaf-skill-create` wizard
**Option B**: Yes, but manual (create .md file)
**Option C**: No, use built-in skills only

**Q5.2**: Should skills have dependency management?

**Example**: `asaf-repo-standards` depends on `asaf-quality-gate` passing first

**Option A**: Yes, explicit dependencies in skill.md
**Option B**: No, execution order determined by command
**Option C**: Smart ordering (skills declare when they should run)

**Q5.3**: Should skills be sharable across projects?

**Option A**: Global only (~/.claude/skills/)
**Option B**: Global + project-specific (.claude/skills/)
**Option C**: Global + project + team-shared (team-skills repo)

---

### 6. Model Strategy

**Q6.1**: Should model selection be:

**Option A**: Fixed (Opus for architect/grooming/executor, Sonnet for reviewer)
**Option B**: Configurable (user can override in config)
**Option C**: Dynamic (select based on task complexity)

**Q6.2**: If user's plan doesn't include Opus, should we:

**Option A**: Degrade gracefully to Sonnet for all
**Option B**: Warn that quality may be reduced
**Option C**: Require Opus for architect at minimum

**Q6.3**: Should Educational reviewer mode ALWAYS use Opus, or respect user config?

**Option A**: Always Opus (quality teaching)
**Option B**: User configurable
**Option C**: Opus by default, overridable with warning

---

### 7. Migration & Backward Compatibility

**Q7.1**: For existing ASAF users, should we:

**Option A**: Require explicit opt-in to architect features
**Option B**: Auto-enable with defaults, allow opt-out
**Option C**: Gradual migration path (Phase 1: quality gates, Phase 2: epics, Phase 3: architect)

**Q7.2**: Should old sprints (pre-architect) be:

**Option A**: Left as-is (frozen in old structure)
**Option B**: Auto-migrated to new structure
**Option C**: Manual migration via `/asaf-migrate-sprint`

**Q7.3**: Should we maintain `/asaf-init` for simple sprints, or merge into epic system?

**Option A**: Keep both (standalone sprints via /asaf-init, epics via /asaf-epic-init)
**Option B**: Merge (all sprints must be in epics, even if epic has 1 sprint)
**Option C**: Soft merge (/asaf-init creates implicit "standalone" epic)

---

### 8. Documentation & Onboarding

**Q8.1**: How should new users learn about architect features?

**Option A**: Separate tutorial sprint (`/asaf-tutorial-architect`)
**Option B**: Inline guidance during first epic
**Option C**: Documentation only (README, CLAUDE.md)

**Q8.2**: Should `/asaf-help` show:

**Option A**: All 20 commands (overwhelming?)
**Option B**: Grouped by feature (core, epic, architect, config)
**Option C**: Contextual (show epic commands only when in epic)

---

### 9. Error Handling & Recovery

**Q9.1**: If architect review fails catastrophically (e.g., infinite loop), should we:

**Option A**: Auto-pause and notify user
**Option B**: Fallback to reviewer-only validation
**Option C**: Save state and allow `/asaf-architect-retry`

**Q9.2**: If skills fail to load (missing dependencies, etc.), should we:

**Option A**: Block sprint (strict)
**Option B**: Warn and continue without skill (permissive)
**Option C**: Fallback to manual validation

---

### 10. Performance & Cost

**Q10.1**: With all agents using Opus, token costs increase. Should we:

**Option A**: Accept higher cost for quality (recommended models)
**Option B**: Provide "economy mode" (all Sonnet)
**Option C**: Smart routing (Opus for complex tasks only, auto-detect complexity)

**Q10.2**: Should we cache architect research across similar sprints?

**Example**: Research on "OAuth 2.0" reused for multiple auth sprints

**Option A**: Yes, cache in epics/research/
**Option B**: Yes, cache globally in ~/.claude/asaf-cache/
**Option C**: No, always fresh research

**Q10.3**: Should quality gate results be cached?

**Example**: If code unchanged, skip build/test re-run

**Option A**: Yes, cache based on file hashes
**Option B**: No, always run (ensure freshness)
**Option C**: User configurable

---

## Migration Path

### For Existing ASAF Users

#### Phase 1: Install (Backward Compatible)

```bash
cd ~/asaf-for-claude-code
git pull
./install.sh
```

**What changes**:
- New commands available: `/asaf-epic-*`, `/asaf-config`, `/asaf-architect-review`
- New skills installed: `~/.claude/skills/asaf-*`
- New agent persona: `architect-agent.md`

**What doesn't change**:
- Existing `/asaf-*` commands work identically
- Old sprints remain untouched
- No forced migration

#### Phase 2: Opt-In Configuration

**Optional**: Configure new features
```bash
cd ~/my-project
/asaf-config
```

**Creates**:
- `asaf/.config.json` (validation rules, models)

**If skipped**: Uses sensible defaults, architect features available but not enforced

#### Phase 3: Gradual Adoption

**Try architect review on existing sprint**:
```bash
cd asaf/my-existing-sprint
/asaf-architect-review
```

Works with old sprint structure, provides validation feedback.

**Try epic for new work**:
```bash
/asaf-epic-init "my-first-epic" "Description"
```

**Keep using standalone sprints**:
```bash
/asaf-init "bug-fix"  # Still works, no epic needed
```

#### Phase 4: Full Adoption

Once comfortable:
1. Create `ARCHITECTURE.md` for project
2. Run `/asaf-standards-init` to document conventions
3. Use epics for multi-phase features
4. Use architect review on all sprints

**Timeline**: User-driven, no forced migration

---

### For New ASAF Users

#### Recommended Onboarding

**Day 1**: Install + Simple Sprint
```bash
./install.sh
cd ~/my-project
/asaf-init "first-sprint"
/asaf-groom
/asaf-impl
```

**Day 2**: Configure
```bash
/asaf-config
/asaf-standards-init
```

**Week 2**: Try Epic
```bash
/asaf-epic-init "feature-name" "description"
/asaf-epic-sprint "feature-name" "sprint-1"
```

**Week 3**: Use Architect Review
```bash
/asaf-architect-review
```

---

## Alternatives Considered

### Alternative 1: External Tool Integration

**Idea**: Instead of architect agent, integrate with external tools (GitHub Copilot Workspace, Cursor, etc.)

**Pros**:
- Leverage existing tools
- Potentially more features

**Cons**:
- Breaks ASAF's self-contained philosophy
- Adds dependencies
- Requires internet
- Less customizable

**Verdict**: ❌ Doesn't align with ASAF's markdown-based, portable approach

---

### Alternative 2: AI-Powered Code Generation Only

**Idea**: Focus on better code generation, skip validation/architecture layers

**Pros**:
- Simpler
- Faster iteration

**Cons**:
- Doesn't solve the "code doesn't compile" problem
- No cross-sprint memory
- Repeats mistakes

**Verdict**: ❌ Addresses symptoms, not root causes

---

### Alternative 3: Human-Only Architecture

**Idea**: Keep architecture/standards as human responsibility, ASAF only codes

**Pros**:
- Clear separation of concerns
- Humans make strategic decisions

**Cons**:
- Doesn't solve "manual research before sprint" problem
- Doesn't help with validation
- Misses opportunity for AI assistance in architecture

**Verdict**: ❌ Underutilizes AI capabilities

---

### Alternative 4: Single "Super-Agent"

**Idea**: One agent handles grooming + implementation + review + architecture

**Pros**:
- Simpler mental model
- One persona to understand

**Cons**:
- Context overload (single agent juggling too much)
- Loses specialization benefits
- Harder to configure behavior per role
- Research shows multi-agent outperforms single-agent

**Verdict**: ❌ Multi-agent orchestration proven more effective

---

### Alternative 5: Plugin Architecture

**Idea**: Make architect a "plugin" to ASAF core, fully optional install

**Pros**:
- True opt-in
- Keeps core ASAF minimal
- Users choose features à la carte

**Cons**:
- Fragmentation (some users have architect, some don't)
- Harder to maintain
- More complex installation

**Verdict**: 🤔 Possible future direction, but start integrated for v1

---

## Success Metrics

How will we know if Architect Agent is successful?

### Quantitative Metrics

**Pre-Sprint Efficiency**:
- Target: **60-70% reduction** in manual pre-sprint research time
- Measure: Time from "I have an idea" to `/asaf-impl` starting

**Post-Sprint Quality**:
- Target: **40-50% reduction** in manual post-sprint fixes
- Measure: % of sprints requiring manual refinement after "completion"

**Cross-Sprint Consistency**:
- Target: **55% improvement** in architectural consistency (based on [GitHub Next data](https://www.ideas2it.com/blogs/agentic-ai-agile-software-delivery))
- Measure: ADR compliance across related sprints

**Iteration Efficiency**:
- Target: **30% fewer iterations** per task (Opus impact)
- Measure: Average iterations before task approval

**Token Efficiency**:
- Target: **20-40% overall token reduction** (fewer wasted iterations)
- Measure: Total tokens per completed sprint

### Qualitative Metrics

**User Satisfaction**:
- "I feel confident starting complex features"
- "Sprint results meet my expectations"
- "I understand the 'why' behind architectural decisions"

**Code Quality**:
- "Code compiles first time after sprint"
- "Tests pass without manual intervention"
- "Consistent with existing codebase patterns"

**Learning**:
- "I learned new patterns during sprints"
- "Architect explanations improved my understanding"
- "Past mistakes aren't repeated"

### Failure Indicators

**Red flags** that would indicate architect isn't working:

- ❌ Architect review takes longer than manual review would
- ❌ Users bypass architect features (too cumbersome)
- ❌ Quality gates create more friction than value
- ❌ Epic management feels like bureaucracy
- ❌ Token costs increase without quality improvement

---

## Timeline & Phases

### Phase 1: Foundation (Weeks 1-2)

**Deliverables**:
- `architect-agent.md` persona
- `/asaf-config` command
- `.config.json` schema
- Update existing agents with model specs

**Testing**:
- Config wizard usability
- Model selection works correctly

**Goal**: Configuration infrastructure ready

---

### Phase 2: Quality Gates (Weeks 3-4)

**Deliverables**:
- `asaf-quality-gate` skill
- `asaf-repo-standards` skill
- `/asaf-standards-init` wizard
- Enhanced `/asaf-impl` with gates

**Testing**:
- Gates detect build/test failures correctly
- Auto-fix works in propose mode
- Standards detection accurate across codebases

**Goal**: "Code compiles after sprint" problem solved

---

### Phase 3: Epic Management (Weeks 5-6)

**Deliverables**:
- `/asaf-epic-init` command
- `/asaf-epic-sprint` command
- `/asaf-epic-status` command
- Epic folder structure
- EPIC.md, ARCHITECTURE.md templates

**Testing**:
- Research phase produces useful insights
- Cross-sprint context flows correctly
- Epic state tracking accurate

**Goal**: Multi-phase features manageable

---

### Phase 4: Architect Validation (Weeks 7-8)

**Deliverables**:
- `/asaf-architect-review` command
- `asaf-anti-regression` skill
- DECISIONS.md, PATTERNS.md, MISTAKES-LOG.md
- Refinement loop

**Testing**:
- Architect catches violations grooming/reviewer miss
- Refinement loop converges
- Learning from mistakes works

**Goal**: Post-sprint quality issues eliminated

---

### Phase 5: Polish & Documentation (Weeks 9-10)

**Deliverables**:
- Updated README.md
- Updated CLAUDE.md
- Tutorial sprint
- Video walkthrough
- Migration guide

**Testing**:
- New users can onboard successfully
- Existing users can migrate smoothly
- Documentation covers all features

**Goal**: Production-ready release

---

## Community Feedback Requested

### Critical Decisions Needed

Please provide feedback on:

1. **Open Questions (Section 10)**: Which options do you prefer? Any we missed?

2. **Command Count**: Do 20 total commands feel manageable, or still too many?

3. **Model Strategy**: Comfortable with Opus for architect/grooming/executor? Any cost concerns?

4. **Epic vs Standalone**: Is the distinction clear? Would you use epics?

5. **Quality Gates**: Strictness levels make sense? Default recommendations appropriate?

6. **Skills Approach**: Does skill system make sense for validation? Want custom skill creation?

7. **Migration Path**: Gradual adoption plan work for your existing projects?

8. **Missing Features**: What else would make architect agent valuable?

### How to Provide Feedback

**Option 1**: GitHub Discussions (preferred)
- Create thread in asaf-for-claude-code discussions
- Reference this proposal
- Answer open questions

**Option 2**: Direct Feedback
- Email/DM with your thoughts
- Structured or free-form

**Option 3**: Community Call
- If enough interest, schedule video call to discuss

### Timeline for Feedback

**Feedback window**: 2 weeks from proposal publication
**Decision point**: Dec 21, 2025
**Start implementation**: Jan 2026 (if approved)

---

## Conclusion

The **ASAF Architect Agent** addresses real pain points identified through months of production usage:

1. **Pre-sprint research** → Automated via `/asaf-epic-init`
2. **Post-sprint quality issues** → Solved via quality gates + `/asaf-architect-review`
3. **Cross-sprint isolation** → Solved via epic management + ARCHITECTURE.md

**Key principles maintained**:
- ✅ Markdown-based (no databases)
- ✅ File-based state (version controllable)
- ✅ Conversational agents (not prescriptive)
- ✅ Optional (backward compatible)
- ✅ ASAF philosophy (conventions + prompts)

**Industry validation**:
- GitHub Spec Kit (constitution + specify)
- Multi-agent orchestration patterns (supervisor agents)
- ADR best practices (architectural memory)
- Quality gates (industry standard)

**Expected impact**:
- 60-70% reduction in pre-sprint research time
- 40-50% reduction in post-sprint refinement
- 55% improvement in cross-sprint consistency
- 30% fewer iterations per task

**Your feedback is critical** to ensure this enhances ASAF without adding unwanted complexity.

Thank you for being part of the ASAF community! 🚀

---

**Document Version**: 1.0-draft
**Last Updated**: 2025-12-07
**Next Review**: After community feedback (Dec 21, 2025)
