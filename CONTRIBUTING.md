# Contributing to ASAF

Thank you for your interest in contributing to ASAF! This guide will help you add new features, fix bugs, and improve the system.

---

## Table of Contents

1. [How ASAF Works](#how-asaf-works)
2. [Adding a New Command](#adding-a-new-command)
3. [Adding an Executor Profile](#adding-an-executor-profile)
4. [Adding a Reviewer Mode](#adding-a-reviewer-mode)
5. [Testing Your Changes](#testing-your-changes)
6. [Submitting Changes](#submitting-changes)

---

## How ASAF Works

ASAF is **not a traditional application**. It's a collection of markdown files that Claude Code reads and follows as instructions.

### Key Concepts

**Commands are Markdown Files**:
- `/asaf-init` → reads `.claude/commands/asaf-init.md`
- Claude follows the instructions in that file
- No code execution, just markdown instructions

**Agents are Personas (Prompts)**:
- Grooming Agent → `shared/grooming-agent.md`
- Executor Agent → `shared/executor-agent.md`
- Claude adopts different personas by reading different files

**State is Files**:
- `.state.json` - Machine-readable state
- `SUMMARY.md` - Human-readable summary
- `progress.md` - Detailed logs
- No database, just files

---

## Adding a New Command

### Step 1: Create Command File

Create `.claude/commands/asaf-yourcommand.md`:

```markdown
# ASAF Your Command

**Command**: `/asaf-yourcommand <params>`

**Purpose**: Brief description of what it does

---

## Prerequisites

Check `.state.json`:
- phase must be "[required-phase]"
- status must be "[required-status]"

If not:
```
🔴 ERROR: Cannot run command

[Clear error message with guidance]
```
**STOP execution.**

---

## Execution Steps

### Step 1: [First Thing]

[Clear, sequential instructions for Claude to follow]

### Step 2: [Second Thing]

[More instructions]

---

## Update State

```json
{
  "your_field": "new_value",
  "updated": "[timestamp]"
}
```

---

## Success Message

```
✅ Command completed!

[Show what was accomplished]

Next: /asaf-next-command
```

---

## Error Handling

### Error Case 1

```
🔴 ERROR: [Description]

[Troubleshooting steps]

Options:
  [Recovery options]
```

---

_Brief note about command purpose_
```

### Step 2: Follow Conventions

**File Structure**:
- Title and command syntax
- Prerequisites (validate state)
- Execution steps (sequential)
- State updates
- Success/error messages
- Context notes

**Tone**:
- Clear and direct
- Helpful error messages
- Show what to do next

**Formatting**:
- Use code blocks for examples
- Use `🔴 🟡 🔵 ✅ ⚠️` for status
- Use `━━━` for visual separators

### Step 3: Test the Command

```bash
# Install your changes
cp .claude/commands/asaf-yourcommand.md ~/.claude/commands/

# Test in a project
cd ~/test-project
/asaf-yourcommand

# Verify it works as expected
```

### Step 4: Document in README

Add to command list in README.md:

```markdown
### Your Category
  /asaf-yourcommand     Description
```

---

## Adding an Executor Profile

Executor profiles define language/framework-specific behavior.

### Step 1: Edit executor-agent.md

Add to the "Available Profiles" section:

```markdown
### go-microservices-executor

**Expertise**:
- Go language syntax and idioms
- Microservices patterns (gRPC, REST)
- Go testing (testing package, testify)
- Docker containerization
- Error handling patterns

**Code Standards**:
- gofmt formatting
- Go naming conventions (CamelCase exports)
- Interface-based design
- Table-driven tests

**Testing**:
- Use testing package
- Table-driven test pattern
- Mock interfaces with testify
- Benchmark critical paths

**Example**:
```go
func TestUserService(t *testing.T) {
    tests := []struct{
        name string
        input User
        want error
    }{
        // test cases
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // test logic
        })
    }
}
```
```

### Step 2: Update decisions.md Template

In grooming-agent.md, add to executor profile examples:

```markdown
**Executor Profile**: `go-microservices-executor`
**Rationale**: Project uses Go with gRPC microservices
```

### Step 3: Test with Real Project

Create a test sprint using your new profile and verify it works correctly.

---

## Adding a Reviewer Mode

Reviewer modes define feedback style and tone.

### Step 1: Edit reviewer-agent.md

Add new mode section:

```markdown
### Your New Mode

**Tone**: [Describe tone]

**Structure**:
1. [How to start]
2. [How to frame issues]
3. [How to encourage]

**Example**:
```markdown
[✅/❌] [Feedback message]

[How this mode phrases things]
```
```

### Step 2: Document When to Use

Add guidance on when this mode is appropriate:

```markdown
**Use this mode when**:
- [Condition 1]
- [Condition 2]

**Example**: Developer is [situation], wants [outcome]
```

### Step 3: Update Grooming Agent

In grooming-agent.md, add to reviewer mode options:

```markdown
**Your New Mode**: [Brief description]
- [Pro 1]
- [Pro 2]
```

---

## Testing Your Changes

### Manual Testing Checklist

- [ ] Command runs without errors
- [ ] State updates correctly
- [ ] Error messages are clear and helpful
- [ ] Success path works
- [ ] Error paths handle gracefully
- [ ] Files created/updated correctly
- [ ] .state.json valid JSON
- [ ] SUMMARY.md updates properly

### Test Scenarios

**Happy Path**:
```bash
# Run through complete workflow
/asaf-init test-feature
/asaf-groom
# ... (complete workflow)
```

**Error Cases**:
```bash
# Test without prerequisites
/asaf-yourcommand  # Should show clear error

# Test with invalid state
# Should handle gracefully
```

**Edge Cases**:
```bash
# Missing files
# Corrupted state
# Interrupted execution
```

---

## Submitting Changes

### Before Submitting

1. **Test Thoroughly**: Run through all scenarios
2. **Update Documentation**: README.md, help text
3. **Follow Conventions**: Match existing file structure
4. **Write Clear Commit Messages**: Explain what and why

### Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test with real sprints
5. Commit: `git commit -m "Add [feature]: [description]"`
6. Push: `git push origin feature/your-feature`
7. Open Pull Request with:
   - Clear description of changes
   - Test results
   - Example usage

### PR Template

```markdown
## What This Adds

[Brief description]

## Why It's Useful

[Use case explanation]

## Changes Made

- Added `/asaf-yourcommand.md`
- Updated README.md
- Updated help system

## Testing Done

- [x] Manual testing with real sprint
- [x] Error scenarios tested
- [x] Documentation updated

## Example Usage

```bash
/asaf-yourcommand <example>
```

Output:
```
[Example output]
```
```

---

## Code of Conduct

### Be Respectful

- Respectful communication
- Constructive feedback
- Inclusive language
- Help others learn

### Quality Standards

- Clear, understandable instructions
- Comprehensive error handling
- Good documentation
- Tested changes

### Collaborative Spirit

- Share knowledge
- Review others' contributions
- Improve existing features
- Report bugs constructively

---

## Questions?

- Open an issue for bugs
- Discuss features in issues before implementing
- Ask questions in discussions
- Check existing issues first

---

## License

By contributing, you agree that your contributions will be licensed under the same license as ASAF.

---

Thank you for helping make ASAF better! 🎉
