# ASAF: Agile Scrum Agentic Flow

**Structured workflow for coding tasks with AI agents**

Version: 1.0.0 (MVP)

---

## What is ASAF?

ASAF is a set of Claude Code slash commands that provide:
1. **Structure** - Organized phases prevent context loss
2. **AI Agents** - Automated implementation with review cycles
3. **Learning Focus** - Personal growth tracked and encouraged
4. **Documentation** - Comprehensive docs generated automatically

**No backend. No database. Just markdown files.**

---

## Quick Start

```bash
# 1. Initialize a sprint
/asaf-init add-authentication

# 2. Design it (30-45 min conversation)
/asaf-groom

# 3. Approve and plan
/asaf-groom-approve

# 4. Implement (3-6 hours, autonomous)
/asaf-impl

# 5. Check status anytime
/asaf-status
```

---

## Installation

### Option 1: Global Installation (Recommended)

**Install once, use in all projects.**

#### Step 1: Install ASAF Commands Globally

```bash
# Clone or download ASAF
git clone https://github.com/your-repo/asaf.git ~/asaf-install

# Copy to global Claude Code commands folder
mkdir -p ~/.claude/commands/shared
cp ~/asaf-install/.claude/commands/*.md ~/.claude/commands/
cp ~/asaf-install/.claude/commands/shared/*.md ~/.claude/commands/shared/

# Clean up
rm -rf ~/asaf-install
```

#### Step 2: Use in Any Project

```bash
# In any project, just start using ASAF
cd your-project/
/asaf-init my-feature

# ASAF will automatically:
# - Create asaf/ folder in your project
# - Store sprint data locally
# - Use global commands
```

#### Step 3: (Optional) Create Personal Goals

```bash
# Create in your home directory (applies to all projects)
nano ~/.claude/personal-goals.md
```

**OR** create per-project:
```bash
# In project root (project-specific goals)
nano personal-goals.md
```

**Example content**:
```markdown
# Personal Goals: Your Name

## Experience Level
- Backend: Senior (5+ years)
- Frontend: Mid-level (2-3 years)

## Current Learning Goals
- Learn secure authentication patterns
- Improve test writing skills

## Reviewer Preferences
- Backend: Harsh Critic (challenge me)
- Frontend: Supportive Mentor (guide me)
```

**Note**: ASAF checks for `personal-goals.md` in this order:
1. Project root (`./personal-goals.md`)
2. Home directory (`~/.claude/personal-goals.md`)

---

### Option 2: Local Installation (Per-Project)

**Install in specific project only.**

#### Step 1: Download ASAF Files

```bash
cd your-project/
git clone https://github.com/your-repo/asaf.git asaf-temp
```

#### Step 2: Copy Command Files to Project

```bash
mkdir -p .claude/commands/shared

# Copy main commands (11 files)
cp asaf-temp/.claude/commands/asaf-*.md .claude/commands/

# Copy shared files (4 files)
cp asaf-temp/.claude/commands/shared/*.md .claude/commands/shared/

# Clean up
rm -rf asaf-temp
```

#### Step 3: Verify Installation

```bash
ls .claude/commands/asaf-*.md
ls .claude/commands/shared/*.md
```

You should see:
- **Main commands**: asaf-init.md, asaf-groom.md, asaf-groom-approve.md, asaf-impl.md, asaf-impl-pause.md, asaf-impl-resume.md, asaf-impl-review.md, asaf-impl-approve.md, asaf-express.md, asaf-demo.md, asaf-retro.md, asaf-status.md, asaf-list.md, asaf-help.md
- **Shared**: asaf-core.md, grooming-agent.md, executor-agent.md, reviewer-agent.md

#### Step 3: Create Sprint Folder

```bash
mkdir asaf
```

#### Step 4: (Optional) Create Personal Goals

```bash
# Create in project root
touch personal-goals.md
```

---

### Global vs Local: Which to Choose?

| Aspect | Global | Local |
|--------|--------|-------|
| **Commands** | One install, all projects | Per-project install |
| **Updates** | Update once, everywhere | Update each project |
| **Customization** | Consistent across projects | Can customize per project |
| **Sprints** | Always local to project | Local to project |
| **Personal Goals** | Can be global or local | Local only |
| **Best For** | Most users | Custom workflows |

**Recommendation**: Use **Global** unless you need project-specific command customizations.

---

### Quick Install Script (Global)

```bash
# One-liner for global installation
curl -fsSL https://raw.githubusercontent.com/your-repo/asaf/main/install.sh | bash
```

**Or manually**:
```bash
# Download and install
cd /tmp
git clone https://github.com/your-repo/asaf.git
cd asaf
./install.sh
```

---

## MVP Commands Available

### Core Workflow
- `/asaf-init <name>` - Initialize new sprint
- `/asaf-groom` - Collaborative design (30-45 min)
- `/asaf-groom-approve` - Lock grooming, create tasks
- `/asaf-status` - Show current status
- `/asaf-select [sprint-name]` - Select active sprint (interactive if no name)

### Coming in Phase 2-6
- `/asaf-impl` - Run implementation (needs completion)
- `/asaf-impl-pause` - Pause implementation
- `/asaf-impl-resume` - Resume paused sprint
- `/asaf-impl-review` - Review blocked tasks
- `/asaf-express` - Quick task mode
- `/asaf-demo` - Generate demo
- `/asaf-retro` - Retrospective
- `/asaf-list` - List all sprints
- `/asaf-summary` - View summary

---

## Folder Structure

### Global Installation (Recommended)

```
# ASAF commands (global)
~/.claude/
└── commands/
    ├── asaf-init.md
    ├── asaf-groom.md
    ├── asaf-groom-approve.md
    ├── asaf-status.md
    └── shared/
        ├── asaf-core.md
        ├── grooming-agent.md
        ├── executor-agent.md
        └── reviewer-agent.md

# Personal goals (optional, global)
~/.claude/
└── personal-goals.md

# Your project (local sprint data)
your-project/
├── asaf/                           # Created automatically
│   └── add-authentication/
│       ├── SUMMARY.md              # ⭐ Your go-to file
│       ├── .state.json
│       ├── initial.md
│       ├── grooming/
│       └── implementation/
├── personal-goals.md               # Optional, overrides global
└── src/                            # Your code
```

### Local Installation

```
your-project/
├── .claude/
│   └── commands/
│       ├── asaf-init.md
│       ├── asaf-groom.md
│       ├── asaf-groom-approve.md
│       ├── asaf-status.md
│       └── shared/
│           ├── asaf-core.md
│           ├── grooming-agent.md
│           ├── executor-agent.md
│           └── reviewer-agent.md
│
├── asaf/
│   └── add-authentication/
│       ├── SUMMARY.md
│       ├── .state.json
│       ├── initial.md
│       ├── grooming/
│       └── implementation/
│
├── personal-goals.md
└── src/
```

### Personal Goals Priority

ASAF looks for `personal-goals.md` in this order:
1. **Project root** (`./personal-goals.md`) - Project-specific
2. **Home directory** (`~/.claude/personal-goals.md`) - Global

Use project-specific goals when:
- Working on different tech stacks per project
- Different learning goals per project
- Different reviewer preferences per project

Use global goals when:
- Consistent learning objectives across projects
- Same experience level and preferences everywhere

---

## How It Works

### 1. Commands are Markdown Files

Each `/asaf-*` command is a markdown file with instructions.

When you run `/asaf-groom`, Claude:
1. Reads `.claude/commands/asaf-groom.md`
2. Follows the instructions in that file
3. Loads context (initial.md, personal-goals.md)
4. Adopts the Grooming Agent persona
5. Conducts the conversation
6. Generates markdown documents

**No code execution. Just:**
- Read markdown instructions
- Follow them
- Write markdown outputs
- Use file system for state

---

### 2. Agents are Personas (Prompts)

An "agent" is Claude with different instructions:

```
Grooming Agent = Claude + grooming-agent.md + feature context
Executor Agent = Claude + executor-agent.md + task context
Reviewer Agent = Claude + reviewer-agent.md + review context
```

**No separate processes.** Just:
1. Load different markdown file
2. Adopt that persona
3. Do the work
4. Write output

---

### 3. State is Markdown + JSON

**Human-readable**: `SUMMARY.md`, all grooming docs, progress logs

**Machine-readable**: `.state.json` for quick checks

```json
{
  "sprint": "add-auth",
  "phase": "implementation",
  "status": "in-progress",
  "current_task": 3
}
```

**No database.** Just files you can read and version control.

---

## Sprint Selection

When working with multiple sprints in a project, ASAF automatically tracks which sprint is currently active using `/asaf/.current-sprint.json`.

### How It Works

**Auto-Selection**:
- First time running a command: ASAF automatically selects the most recently modified sprint
- Selection persists across sessions
- All sprint-context commands operate on the selected sprint

**Manual Selection**:
```bash
# Interactive mode - shows list with current highlighted
/asaf-select

# Direct selection
/asaf-select sprint-name

# Check current sprint
/asaf-status
```

### Current Sprint Display

Every `/asaf-status` shows the active sprint prominently:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 CURRENT SPRINT: add-authentication
   Type: Full Sprint
   Selected: 2 hours ago (auto-selected)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Multi-Sprint Workflow

```bash
# Start first sprint
/asaf-init feature-auth
# ... work on it ...

# Start second sprint (queued, not active yet)
/asaf-init feature-payments
# Choose "n" when asked to set as current

# Continue working on auth
/asaf-groom  # Operates on auth (still active)

# Switch to payments
/asaf-select feature-payments
/asaf-groom  # Now operates on payments

# Switch back
/asaf-select feature-auth
/asaf-impl   # Resumes auth implementation
```

### State File Format

`/asaf/.current-sprint.json`:
```json
{
  "sprint": "add-authentication",
  "selected_at": "2025-10-31T12:00:00Z",
  "type": "full"
}
```

**Git Behavior**: You can choose to:
- **Commit it**: Share active sprint across team/machines
- **Ignore it**: Add to `.gitignore` for local-only selection

Add to `.gitignore` (recommended for solo work):
```gitignore
# ASAF sprint selection (local preference)
/asaf/.current-sprint.json
```

---

## Current Implementation Status

### ✅ Complete - Version 1.0.0 (Production Ready!)

**Core & Agent Personas (4 files)**:
- [x] `asaf-core.md` - Core principles and conventions
- [x] `grooming-agent.md` - Design conversation persona
- [x] `executor-agent.md` - Implementation agent persona
- [x] `reviewer-agent.md` - Code review agent persona

**Full Workflow Commands (11 files)**:
- [x] `asaf-init.md` - Initialize sprint
- [x] `asaf-groom.md` - Grooming conversation
- [x] `asaf-groom-approve.md` - Approve grooming & plan
- [x] `asaf-impl.md` - Implementation with executor/reviewer loop
- [x] `asaf-impl-pause.md` - Pause implementation
- [x] `asaf-impl-resume.md` - Resume paused implementation
- [x] `asaf-impl-review.md` - Review blocked tasks
- [x] `asaf-impl-approve.md` - Approve implementation
- [x] `asaf-demo.md` - Generate demo presentation
- [x] `asaf-retro.md` - Retrospective conversation
- [x] `asaf-status.md` - Show sprint status

**Express & Utilities (5 files)**:
- [x] `asaf-express.md` - Quick task workflow
- [x] `asaf-select.md` - Sprint selection (interactive or direct)
- [x] `asaf-list.md` - List all sprints
- [x] `asaf-help.md` - Complete help system
- [x] `asaf-summary.md` - View sprint summary (uses SUMMARY.md)

**Installation & Docs (3 files)**:
- [x] `README.md` - Complete documentation
- [x] `install.sh` - Global installation script
- [x] `uninstall.sh` - Uninstall script

**Total**: 23 files ready for production use!

### 🎯 Optional Enhancements (Future)
- [ ] `/asaf-resume <sprint>` - Resume old sprint (referenced but not critical)
- [ ] `/asaf-cancel` - Cancel sprint (referenced but not critical)
- [ ] Additional executor profiles (Python, Rust, Go, etc.)
- [ ] Additional reviewer modes variations
- [ ] Sprint templates
- [ ] Analytics dashboard

---

## Testing the Complete System

### Full Workflow Test

```bash
# Should all work now:
/asaf-init test-sprint
# Provide feature description
# ✅ Creates folder and files

/asaf-groom
# Have design conversation (30-45 min)
# ✅ Generates grooming docs

/asaf-groom-approve
# ✅ Creates tasks.md and progress.md

/asaf-impl
# ✅ Executes all tasks with executor/reviewer loop
# ✅ Can pause with /asaf-impl-pause
# ✅ Can resume with /asaf-impl-resume
# ✅ Auto-blocks and reviews if needed

/asaf-impl-approve
# ✅ Validates and moves to demo

/asaf-demo
# ✅ Generates presentation

/asaf-retro
# ✅ Retrospective conversation
# ✅ Generates learnings

/asaf-status
# ✅ Shows complete status at any time

/asaf-summary
# ✅ View SUMMARY.md

/asaf-list
# ✅ Shows all sprints
```

### Express Workflow Test

```bash
/asaf-express "Add email field to registration"
# ✅ Quick analysis
# ✅ Shows plan
# ✅ Executes quickly
# ✅ Generates lightweight summary

/asaf-express --auto "Fix typo in button"
# ✅ Fully autonomous for trivial tasks
```

### Utility Commands Test

```bash
/asaf-help
# ✅ Shows complete help

/asaf-help impl
# ✅ Shows implementation help

/asaf-list
# ✅ Lists all sprints with stats

/asaf-status
# ✅ Shows current sprint state
```

---

## What You Can Do Now

ASAF is **100% complete and production-ready!**

### Get Started Immediately

```bash
# 1. Install globally (recommended)
git clone https://github.com/your-repo/asaf.git
cd asaf
./install.sh

# 2. Use in any project
cd ~/your-project
/asaf-init my-feature

# 3. Follow the complete workflow
/asaf-groom
/asaf-groom-approve
/asaf-impl
/asaf-impl-approve
/asaf-demo
/asaf-retro

# Or use Express for quick tasks
/asaf-express "Add email validation"
```

### Complete Feature Set

✅ **All workflows implemented**:
- Full ASAF (comprehensive, learning-focused)
- Express mode (quick daily tasks)
- Auto mode (trivial tasks)

✅ **All quality gates**:
- Executor/reviewer loops
- Multi-iteration support
- Automatic testing
- Blocked task recovery

✅ **Complete developer experience**:
- Status visibility at any time
- Pause/resume capability
- Comprehensive help system
- Sprint management

✅ **Production ready**:
- Error handling
- State preservation
- Recovery mechanisms
- Complete documentation

---

## Contributing to Development

### To Add a New Command

1. Create `new-command.md` in `.claude/commands/`
2. Follow the structure of existing commands:
   - Prerequisites (state validation)
   - Execution steps (clear, sequential)
   - Error handling (graceful, helpful)
   - Output (clear success message)
3. Test with real sprint
4. Document in this README

### To Add a New Agent Persona

1. Create `new-agent.md` in `.claude/commands/shared/`
2. Define:
   - Role and characteristics
   - Behavior guidelines
   - Input/output format
   - Examples
3. Reference from command files

### To Add a New Executor Profile

1. Edit `executor-agent.md`
2. Add new profile section:
   - Language/framework expertise
   - Testing conventions
   - Code style standards
3. Test with that stack

---

## Philosophy

> **"ASAF is conventions + prompts + file structure, not code."**

### What ASAF Is

✅ Structured markdown-based workflow  
✅ Slash commands that frame conversations  
✅ MD files as state/memory system  
✅ Prompt engineering + file conventions  
✅ Native to Claude Code  

### What ASAF Is Not

❌ A complex backend system  
❌ A database application  
❌ An API service  
❌ Another Cursor.ai  
❌ Something that needs debugging and maintenance  

---

## Design Decisions

### Why Markdown?
- Human-readable (developers can inspect/edit)
- Version controllable (git tracks changes)
- No database needed
- Portable (works anywhere)
- Durable (outlasts any tool)

### Why No Backend?
- Maximum simplicity
- No maintenance burden
- Works offline (except web search)
- No dependencies
- Easy to understand and modify

### Why Personas as Prompts?
- Leverages Claude's strengths
- No orchestration complexity
- Easy to modify (just edit markdown)
- Transparent (developers can read)

---

## Troubleshooting

### Commands Not Working

**Check**:
```bash
# Verify files exist
ls .claude/commands/asaf-*.md

# Verify shared files
ls .claude/commands/shared/

# Restart Claude Code
```

### Sprint Not Creating

**Check**:
```bash
# Permissions
ls -la asaf/

# Disk space
df -h

# Create manually
mkdir -p asaf/test-sprint
```

### State Corrupted

**Fix**:
```bash
# View current state
cat asaf/your-sprint/.state.json

# Manually fix or recreate
nano asaf/your-sprint/.state.json
```

---

## Support

### Documentation
- Commands: `.claude/commands/*.md`
- Personas: `.claude/commands/shared/*.md`
- This README

### Getting Help
- Check `/asaf-help` (when implemented)
- Read `asaf-core.md` for principles
- Review command markdown files
- Check SUMMARY.md of example sprints

---

## Version History

### 1.0.0 (Current - Production Ready!)
- ✅ Complete workflow (init → groom → implement → demo → retro)
- ✅ Implementation with executor/reviewer loop
- ✅ Pause/resume functionality
- ✅ Blocked task review and recovery
- ✅ Express mode for quick tasks
- ✅ Auto mode for trivial tasks
- ✅ Demo generation
- ✅ Retrospective with learning tracking
- ✅ Personal goals integration
- ✅ Complete help system
- ✅ Sprint list management
- ✅ Global and local installation
- ✅ 22 complete command files
- ✅ Full documentation

### Planned: 1.1.0
- Additional executor profiles (Python, Rust, Go)
- More reviewer mode variations
- Sprint templates
- Enhanced analytics

### Planned: 1.2.0
- Team collaboration features
- Sprint sharing
- Advanced metrics
- AI-suggested improvements

---

## License

[Your license here]

---

## Acknowledgments

Built for developers who want:
- Structure without bureaucracy
- AI assistance without black boxes
- Learning without overhead

**ASAF: Making AI-assisted development structured, transparent, and growth-focused.**

---

_For questions, issues, or contributions: [Your contact/repo]_
