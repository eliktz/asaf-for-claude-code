# ASAF PR Review Command

**Command**: `/asaf-impl-pr-review`

**Purpose**: Systematically handle PR review comments - answer, convert to tasks, or ignore

**When to use**: After pushing code and creating a PR, when reviewers leave comments

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

### Check Sprint State

Read `.state.json`:
- phase should be "implementation" or later (demo, retro)
- Implementation should have started (at least one task attempted)

**If implementation not started**:
```
🔴 ERROR: No implementation to review

Current phase: [phase]

You must run /asaf-impl before handling PR reviews.

Current sprint: [sprint-name]
Phase: [phase]

Options:
  /asaf-impl          - Start implementation
  /asaf-status        - Check sprint status
```
**STOP execution.**

---

## Opening Message

```
🔍 PR Review Handler

Sprint: [sprint-name]

I'll help you systematically handle PR review comments:
1. Fetch all comments from your PR
2. Triage each comment (Answer / Task / Ignore)
3. Post answers to the PR
4. Convert selected comments to tasks
5. Execute tasks with quality gates

Let's start by detecting your PR platform.
```

---

## Step 1: Platform Detection

### Check for PR Configuration

Read `grooming/decisions.md` and look for PR configuration section:

```markdown
## PR Configuration

**Platform**: github | bitbucket-api | bitbucket-mcp
**PR URL**: https://github.com/org/repo/pull/123
**Token Env Var**: BITBUCKET_TOKEN (only for bitbucket-api)
```

**If PR configuration exists**:
- Extract platform, PR URL, and token env var (if applicable)
- Proceed to validation

**If PR configuration NOT found**:

Show:
```
No PR configuration found in grooming/decisions.md.

Let me help you set it up.
```

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "Which platform hosts your PR?"
      header: "Platform"
      multiSelect: false
      options:
        - label: "GitHub"
          description: "Using GitHub CLI (gh) - must be authenticated"
        - label: "Bitbucket API"
          description: "Using Bitbucket REST API 1.0 with token"
        - label: "Bitbucket MCP"
          description: "Using Bitbucket MCP server"
```

**After platform selection, ask for PR URL**:
```
Please provide the PR URL:

Examples:
- GitHub: https://github.com/org/repo/pull/123
- Bitbucket: https://bitbucket.org/workspace/repo/pull-requests/123
```

**If Bitbucket API selected, ask for token env var**:
```
What environment variable contains your Bitbucket token?

NOTE: I will NOT store the token itself, only the variable name.

Example: BITBUCKET_TOKEN
```

**Save configuration** to `grooming/decisions.md`:

Append to the file:
```markdown

## PR Configuration

**Platform**: [github|bitbucket-api|bitbucket-mcp]
**PR URL**: [user-provided-url]
**Token Env Var**: [env-var-name] (only for bitbucket-api)
```

---

### Validate Platform Access

**For GitHub**:
```bash
gh auth status
```

If not authenticated:
```
🔴 ERROR: GitHub CLI not authenticated

Please run: gh auth login

Then try again: /asaf-impl-pr-review
```
**STOP execution.**

**For Bitbucket API**:
Check if environment variable is set:
```bash
echo $[TOKEN_ENV_VAR]
```

If empty or not set:
```
🔴 ERROR: Bitbucket token not found

Environment variable '[TOKEN_ENV_VAR]' is not set.

Please set it:
  export [TOKEN_ENV_VAR]=your_token

Then try again: /asaf-impl-pr-review
```
**STOP execution.**

**For Bitbucket MCP**:
Verify MCP server is available (check if bitbucket tools are accessible).

If not available:
```
🔴 ERROR: Bitbucket MCP not available

The Bitbucket MCP server is not configured or not running.

Please check your MCP configuration.
```
**STOP execution.**

---

## Step 2: Fetch & Display Comments

### Fetch Comments

**For GitHub**:
```bash
gh pr view [PR_URL] --json comments,reviews
```

Parse JSON response to extract:
- Comment ID
- Author
- Body (content)
- Created at
- File path (if inline comment)
- Line number (if inline comment)

**For Bitbucket API**:
Extract workspace, repo, and PR number from URL.
```bash
curl -s -H "Authorization: Bearer $[TOKEN_ENV_VAR]" \
  "https://api.bitbucket.org/2.0/repositories/[workspace]/[repo]/pullrequests/[pr_number]/comments"
```

Parse JSON response similarly.

**For Bitbucket MCP**:
Use the appropriate MCP tool to fetch PR comments.

---

### Check for Previously Handled Comments

Read `implementation/progress.md` and look for "PR Review Round" sections.

Extract list of comment IDs that have been handled (from previous rounds).

---

### Display Comments

**If no comments found**:
```
✅ No comments on this PR

The PR has no review comments yet.

Options:
  - Wait for reviewers to comment
  - /asaf-status - Check sprint status
```
**STOP execution.**

**If comments found**:

```
📋 PR Comments ([N] total, [M] new)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[For each comment, numbered]

Comment #1 [NEW]
├─ ID: [platform-comment-id]
├─ Author: @username
├─ File: src/auth/login.ts:42 (if inline)
├─ Date: 2025-01-15
└─ Content:
   "[Comment text, truncated if long]"

---

Comment #2 ✓ HANDLED (Round 1 - Answered)
├─ ID: [platform-comment-id]
├─ Author: @reviewer
├─ File: General comment
├─ Date: 2025-01-15
└─ Content:
   "[Comment text]"

---

Comment #3 ✓ HANDLED (Round 1 - Task created)
├─ ID: [platform-comment-id]
├─ Author: @reviewer
├─ File: src/api/client.ts:88
├─ Date: 2025-01-16
└─ Content:
   "[Comment text]"

---

[Continue for all comments...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Summary:
- Total comments: [N]
- Already handled: [M]
- New to triage: [K]
```

**If all comments already handled**:
```
✅ All comments already handled

All [N] comments have been addressed in previous rounds.

Options:
  - Re-run later if new comments are added
  - /asaf-status - Check sprint status
```
**STOP execution.**

---

## Step 3: Triage Comments

For each NEW (unhandled) comment, present triage options:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Triaging Comment #[N] of [Total New]

Author: @[username]
File: [file:line or "General"]
Content:
  "[Full comment text]"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "How should we handle this comment?"
      header: "Action"
      multiSelect: false
      options:
        - label: "Answer"
          description: "Respond to this comment on the PR"
        - label: "Task"
          description: "Create a task to address this (code change needed)"
        - label: "Ignore"
          description: "Skip this comment (resolved, outdated, or not actionable)"
```

**Collect all triage decisions** before proceeding.

After triaging all comments:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Triage Summary:

📝 To Answer: [N] comments
   [List comment numbers]

🔧 To Create Tasks: [M] comments
   [List comment numbers]

⏭️  Ignored: [K] comments
   [List comment numbers]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Proceeding with:
1. Answer [N] comments (discuss each, post immediately)
2. Define [M] tasks (I propose, you confirm)
3. Execute all tasks (executor → reviewer loop)
```

**If ALL comments were ignored** (N = 0 and M = 0):
```
✅ All comments triaged as ignore

No actions required - all [K] comments marked as ignored.

Updating documentation...
```
Skip to Step 7 (Documentation) to record the ignored comments.
**Do NOT proceed to Steps 4-6.**

**Otherwise, confirm with user**:

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "Ready to proceed with [N] answers and [M] tasks?"
      header: "Confirm"
      multiSelect: false
      options:
        - label: "Proceed"
          description: "Start answering and creating tasks"
        - label: "Re-triage"
          description: "Go back and change my selections"
        - label: "Exit"
          description: "Cancel and exit without changes"
```

**If "Re-triage"**: Go back to Step 3.
**If "Exit"**: Show "Cancelled. No changes made." and STOP execution.

---

## Step 4: Answer Loop

For each comment marked "Answer":

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Answering Comment #[N]

Author: @[username]
Content:
  "[Comment text]"

---

Let me draft a response...

[Analyze the comment]
[Consider context from design.md, progress.md, code]

Proposed Response:
┌─────────────────────────────────────────────
│ [Draft response text]
│
│ [Explain any technical decisions]
│ [Reference relevant code if needed]
└─────────────────────────────────────────────

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "How should we proceed with this response?"
      header: "Response"
      multiSelect: false
      options:
        - label: "Post as-is"
          description: "Post this response to the PR"
        - label: "Modify"
          description: "I want to change the response"
        - label: "Skip"
          description: "Don't answer this comment after all"
```

**If "Modify"**:
```
Please provide your modified response (or describe what to change):
```
[User provides modified text or guidance]
[Update draft and show again]

**If "Post as-is" or after modification approved**:

**For GitHub**:
```bash
gh pr comment [PR_URL] --body "[response text]"
```

**For Bitbucket API**:
```bash
curl -X POST \
  -H "Authorization: Bearer $[TOKEN_ENV_VAR]" \
  -H "Content-Type: application/json" \
  -d '{"content": {"raw": "[response text]"}}' \
  "https://api.bitbucket.org/2.0/repositories/[workspace]/[repo]/pullrequests/[pr_number]/comments"
```

**For Bitbucket MCP**:
Use the appropriate MCP tool to post comment.

**After posting**:
```
✅ Response posted to PR

Comment #[N] answered successfully.

[Continue to next comment...]
```

**Track answered comment ID** for documentation.

---

## Step 5: Task Definition

For each comment marked "Task":

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Defining Task from Comment #[N]

Author: @[username]
File: [file:line if applicable]
Comment:
  "[Comment text]"

---

Analyzing comment and codebase context...

[Read relevant files mentioned]
[Check design.md for related requirements]
[Check edge-cases.md for related scenarios]

Proposed Task:
┌─────────────────────────────────────────────
│ **Task**: [Descriptive task name]
│
│ **Description**:
│ [What needs to be done]
│
│ **Files to Modify**:
│ - [file1.ts] - [change description]
│ - [file2.ts] - [change description]
│
│ **Acceptance Criteria**:
│ - [ ] [Criterion 1]
│ - [ ] [Criterion 2]
│
│ **Complexity**: [1/2/4] story points
│ **Max Iterations**: [2/3/4]
└─────────────────────────────────────────────

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "Does this task definition look correct?"
      header: "Task"
      multiSelect: false
      options:
        - label: "Approve"
          description: "Task is well-defined, proceed"
        - label: "Modify"
          description: "I want to adjust the task"
        - label: "Skip"
          description: "Don't create a task for this"
```

**If "Modify"**:
```
What would you like to change?
(Describe modifications or provide full revised task)
```
[User provides changes]
[Update task definition and show again]

**If "Skip"**:
```
Skipping task creation for Comment #[N].

This comment will be marked as "Ignored" in documentation.
```
[Remove this comment from task list]
[Update triage decision from "Task" to "Ignored"]
[Continue to next comment...]

**After all tasks defined**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task Summary: [N] tasks defined

1. [Task 1 name] ([X] story points)
2. [Task 2 name] ([Y] story points)
3. [Task 3 name] ([Z] story points)

Total: [Sum] story points

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If 0 tasks defined** (all were skipped):
```
No tasks to execute - all were skipped during definition.

Proceeding to documentation...
```
Skip to Step 7 (Documentation).

**Otherwise, confirm execution**:

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "Ready to execute [N] tasks ([Sum] story points)?"
      header: "Execute"
      multiSelect: false
      options:
        - label: "Execute all"
          description: "Run all tasks with quality gates"
        - label: "Review tasks"
          description: "Let me review task definitions again"
        - label: "Skip execution"
          description: "Skip to documentation without executing"
```

**If "Review tasks"**: Go back to show task definitions.
**If "Skip execution"**: Skip to Step 7 (Documentation).

---

## Step 6: Batch Execution

**CRITICAL: Use Task tool to delegate to sub-agents. DO NOT implement code yourself.**

Read executor and reviewer configuration from `grooming/decisions.md`.

For each defined task:

### Task Header

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PR Review Task [N]/[total]: [Task Name]
├─ From Comment: #[comment_number] by @[author]
├─ Complexity: [X] story points
├─ Max iterations: [Y]
└─ Pattern: executor → test → reviewer

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Iteration Loop

Set `iteration = 0`
Set `max_iterations` from task definition

While `iteration < max_iterations`:

#### Launch Executor Sub-Agent

Use Task tool with subagent_type="[executor-agent-name from grooming/decisions.md]"
- description: "PR Review Task [N]: [Task Name]"
- prompt: Include full task description, relevant context from design.md, edge-cases.md, the original PR comment, and reviewer feedback if iteration > 1.

Wait for executor sub-agent to complete.

Show summary:
- Files changed
- Tests added/modified
- Implementation notes

#### Launch Reviewer Sub-Agent

Use Task tool with subagent_type="[reviewer-agent-name from grooming/decisions.md]"
- description: "Reviewing PR Task [N]: [Task Name]"
- prompt: Include task requirements, design context, original PR comment, code quality standards, and request approval or changes.

Wait for reviewer sub-agent to complete.

**If APPROVED**:
- Show: `✅ Reviewer: APPROVED - Task [N] complete!`
- Mark task complete
- Move to next task

**If CHANGES REQUESTED and iteration < max**:
- Show: `⚠️ Reviewer: Changes requested - Starting iteration [iteration+1]`
- Increment iteration
- Loop back to executor with feedback

**If CHANGES REQUESTED and iteration == max**:
- Show: `🔴 Task blocked after [max] iterations`
- Mark as BLOCKED
- Continue to next task (don't stop entire flow)
- User can address blocked tasks later

### After Each Task

Show progress:
```
Progress: [N]/[total] PR review tasks
- ✅ Completed: [X]
- 🔴 Blocked: [Y]
- ⏳ Remaining: [Z]
```

---

## Step 7: Documentation

### Get Current Commit Hash

Before posting comments, get the current commit hash:
```bash
git rev-parse --short HEAD
```
Store result as `[commit_hash]`.

---

### Post Task Comment to PR

For each **COMPLETED** task:

**For GitHub**:
```bash
gh pr comment [PR_URL] --body "✅ Addressed in commit [commit_hash]: [task description]

[Brief summary of changes made]

Files modified:
- [file list]"
```

**For Bitbucket API**:
```bash
curl -X POST \
  -H "Authorization: Bearer $[TOKEN_ENV_VAR]" \
  -H "Content-Type: application/json" \
  -d '{"content": {"raw": "✅ Addressed in commit [commit_hash]: [task description]\n\n[Brief summary]"}}' \
  "https://api.bitbucket.org/2.0/repositories/[workspace]/[repo]/pullrequests/[pr_number]/comments"
```

**For Bitbucket MCP**: Use the appropriate MCP tool to post comment.

---

For each **BLOCKED** task:

**For GitHub**:
```bash
gh pr comment [PR_URL] --body "⚠️ Working on: [task description]

Status: Blocked after [N] iterations - needs manual attention.

Issue: [brief description of why it's blocked]

Will address in next review round."
```

**For Bitbucket API**:
```bash
curl -X POST \
  -H "Authorization: Bearer $[TOKEN_ENV_VAR]" \
  -H "Content-Type: application/json" \
  -d '{"content": {"raw": "⚠️ Working on: [task description]\n\nStatus: Blocked - needs manual attention."}}' \
  "https://api.bitbucket.org/2.0/repositories/[workspace]/[repo]/pullrequests/[pr_number]/comments"
```

**For Bitbucket MCP**: Use the appropriate MCP tool to post comment.

---

### Update progress.md

Append new section:

```markdown

---

### PR Review Round [N]

**Started**: [timestamp]
**PR URL**: [url]
**Platform**: [github|bitbucket-api|bitbucket-mcp]

#### Comments Processed

| # | Platform ID | Author | Action | Status |
|---|-------------|--------|--------|--------|
| 1 | gh-123456 | @user1 | Answer | ✅ Posted |
| 2 | gh-234567 | @user2 | Task | ✅ Completed |
| 3 | gh-345678 | @user3 | Task | 🔴 Blocked |
| 4 | gh-456789 | @user4 | Ignore | ⏭️ Skipped |

**Note**: Platform ID is used to track handled comments across rounds.

#### Answers Posted

**Comment #1** (@user1):
> Original: "[comment text]"

Response:
> "[our response]"

#### Tasks Executed

**Task from Comment #2**: [Task Name]
- **Status**: ✅ Complete (iteration 1)
- **Files Modified**: [list]
- **Tests**: [count] added
- **Reviewer**: APPROVED

**Task from Comment #3**: [Task Name]
- **Status**: 🔴 Blocked (iteration 3/3)
- **Issue**: [brief description]
- **Action Needed**: [what user should do]

---

**Round Summary**:
- Comments processed: [N]
- Answers posted: [X]
- Tasks completed: [Y]
- Tasks blocked: [Z]
- Ignored: [W]
```

---

### Update SUMMARY.md

Add PR review section (or update if exists):

```markdown
## 🔍 PR Reviews

**Round 1** (Completed [date]):
- Comments processed: [N]
- Answers posted: [X]
- Tasks completed: [Y]

[See implementation/progress.md for details]
```

---

## Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ PR Review Round [N] Complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Summary:

**Comments**:
- Total processed: [N]
- Answers posted: [X] ✅
- Tasks executed: [Y]
- Ignored: [Z]

**Tasks**:
- Completed: [A] ✅
- Blocked: [B] 🔴

**Quality**:
✅ All completed tasks passed reviewer quality gates
[If any blocked]: ⚠️ [B] tasks need manual attention

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Documentation Updated:
- implementation/progress.md (PR Review Round [N] added)
- SUMMARY.md (PR Reviews section updated)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Next Steps**:

[If blocked tasks exist]
⚠️ Blocked tasks need attention:
  - [Task name]: [brief issue]

Fix manually and run /asaf-impl-pr-review again.

[If all complete]
✅ All PR comments addressed!

Have more comments?
  /asaf-impl-pr-review    - Run another round

Ready to merge?
  Push changes and request re-review

Sprint complete?
  /asaf-demo              - Generate presentation
  /asaf-retro             - Run retrospective
```

---

## Error Handling

### Network Failure During Fetch

```
🔴 ERROR: Failed to fetch PR comments

Platform: [platform]
PR URL: [url]
Error: [error message]

Troubleshooting:
1. Check internet connection
2. Verify PR URL is correct
3. [Platform-specific]: Check authentication

Try again: /asaf-impl-pr-review
```
**STOP execution.**

---

### Failed to Post Answer

```
🟡 WARNING: Failed to post answer

Comment #[N]: [comment preview]
Error: [error message]

The answer was not posted to the PR.
```

**USE AskUserQuestion**:
```yaml
AskUserQuestion:
  questions:
    - question: "Answer failed to post. What should we do?"
      header: "Action"
      multiSelect: false
      options:
        - label: "Retry"
          description: "Try posting again"
        - label: "Skip"
          description: "Skip this answer, continue with others"
        - label: "Copy to clipboard"
          description: "I'll post it manually"
```

---

### All Tasks Blocked

```
🟡 WARNING: All PR review tasks blocked

None of the [N] tasks could be completed.

This may indicate:
- Complex issues requiring manual investigation
- Missing context in design docs
- External dependencies

Recommendations:
1. Review blocked tasks in progress.md
2. Fix issues manually
3. Run /asaf-impl-pr-review again

Answers were still posted successfully.
```

---

### PR Not Found

```
🔴 ERROR: PR not found

The PR at [url] was not found or is not accessible.

Possible reasons:
- PR was closed or merged
- URL is incorrect
- Permissions issue

Update PR URL:
  Edit grooming/decisions.md → PR Configuration section

Then try again: /asaf-impl-pr-review
```
**STOP execution.**

---

## Design Notes

### Why This Command Exists

**Problem**: After creating a PR, review comments come in. Developers handle them ad-hoc:
- Some comments get answered, some forgotten
- Code changes made without proper testing
- No documentation of what was addressed
- Quality varies based on developer attention

**Solution**: Structured PR review handling with:
- Systematic triage of all comments
- Quality gates for code changes (same as /asaf-impl)
- Documentation of all actions
- Repeatable process for multiple review rounds

### Key Principles

1. **Systematic**: Every comment is triaged, nothing falls through cracks
2. **Quality**: Code changes go through executor → reviewer loop
3. **Documented**: All actions tracked in progress.md
4. **Flexible**: Supports GitHub, Bitbucket API, and Bitbucket MCP
5. **Iterative**: Can run multiple times as new comments arrive

### Platform Support

| Platform | Auth | Fetch | Post |
|----------|------|-------|------|
| GitHub | `gh auth` | `gh pr view --json` | `gh pr comment` |
| Bitbucket API | Token in env var | REST API 2.0 | REST API 2.0 |
| Bitbucket MCP | MCP config | MCP tool | MCP tool |

### Comparison to /asaf-impl-feedback

| Aspect | /asaf-impl-feedback | /asaf-impl-pr-review |
|--------|---------------------|----------------------|
| **Source** | User feedback | PR comments |
| **Triage** | Bug/Improvement/Enhancement | Answer/Task/Ignore |
| **Answers** | N/A | Posted to PR |
| **Tasks** | User-defined | Derived from comments |
| **Quality** | Executor → Reviewer | Same |
| **Docs** | Feedback sections | PR Review rounds |

Both maintain ASAF quality standards.

---

## Future Enhancements (Not in v1)

- Auto-suggest answers based on code context
- Link PR comments to edge cases from grooming
- Generate PR description from SUMMARY.md
- Auto-resolve comments after task completion (if platform supports)
- Support for GitLab, Azure DevOps

---

_This command ensures PR reviews are handled systematically with the same quality standards as implementation._
