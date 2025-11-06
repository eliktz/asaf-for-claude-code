# ASAF Summary Command

**Command**: `/asaf-summary`

**Purpose**: Generate executive summary of workspace tasks and overall progress

**Category**: Reporting & Analysis

---

## When to Use

Run `/asaf-summary` to get:
- Overview of all tasks in workspace
- Progress metrics and completion rates
- Active work highlights
- Blockers and risks
- Key insights and recommendations

**Best for**: Weekly standups, sprint reviews, executive updates, identifying patterns

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

**Required**:
- At least one task exists in workspace (check with `/asaf-list`)

**Files Read**:
- `asaf-state.json` - All task states
- `tasks/*/.task-state.json` - Individual task details
- `tasks/*/.retro.md` - Retrospective insights
- `tasks/*/.demo-notes.md` - Demo outcomes

---

## Command Behavior

### 1. Gather All Task Data

Read workspace state:
```json
{
  "workspaceId": "my-project",
  "tasks": {
    "feature-auth": { "state": "IMPLEMENTING", ...},
    "bug-fix-login": { "state": "COMPLETED", ...},
    "api-integration": { "state": "BLOCKED", ...}
  }
}
```

### 2. Calculate Metrics

Analyze tasks to determine:
- Total tasks: Count all tasks
- Active: GROOMING, IMPLEMENTING, REVIEWING states
- Completed: COMPLETED state
- Blocked: Tasks with blockers
- Completion rate: Completed / Total
- Average cycle time: From INIT to COMPLETED
- Velocity trend: Compare recent vs older completions

### 3. Identify Patterns

Detect:
- Common blocker types
- Tasks blocked by same issue
- Velocity changes
- Success/failure patterns

### 4. Generate Summary Report

Create comprehensive markdown summary

---

## Output Format

```markdown
# ASAF Workspace Summary
Generated: [timestamp]

## 📊 Overview
- **Total Tasks**: X
- **Active**: X | **Completed**: X | **Blocked**: X
- **Overall Health**: [Excellent/Good/Needs Attention/Critical]

## 📈 Key Metrics
- **Completion Rate**: X% (X of X tasks)
- **Average Cycle Time**: X days
- **Blocker Impact**: X tasks affected
- **Velocity Trend**: [Increasing/Stable/Decreasing]

## 🚀 Active Work Highlights

### High Priority
- **feature-user-authentication** - IMPLEMENTING (60% complete)
  - Phase: Implementation
  - Next: Complete JWT token generation

### In Progress
- **api-payment-integration** - GROOMING (Plan in review)
  - Waiting for: Grooming approval

## ✅ Recent Completions (Last 7 Days)
- **bug-fix-login-timeout** - Completed Oct 7
  - Outcome: Reduced timeout errors by 95%
  - Demo: Successful
  
- **refactor-database-queries** - Completed Oct 5
  - Outcome: 40% performance improvement
  - Demo: Approved by team

## ⚠️ Blockers & Risks

### Active Blockers
1. **API_SECRET Environment Variable**
   - Affects: feature-user-authentication
   - Status: Waiting for DevOps team
   - Impact: Implementation paused
   - Action Needed: Follow up with DevOps

2. **Third-party API Downtime**
   - Affects: api-payment-integration
   - Status: Monitoring vendor status
   - Impact: Cannot test integration
   - Action Needed: Escalate to vendor

### Risk Analysis
- ⚠️ 2 tasks blocked by external dependencies
- ⚠️ Velocity decreased 20% this week
- ✅ No critical technical debt accumulating

## 💡 Insights & Recommendations

### What's Going Well
- High completion rate (85%) shows good task scoping
- No implementation failures in last 10 tasks
- Demo success rate: 100% (last 5 demos)

### Areas for Improvement
- Average blocker resolution time: 2.5 days (target: <1 day)
- 3 tasks waiting for grooming approval (suggest dedicated review time)
- External dependency blockers recurring (consider fallback strategies)

### Leadership Actions Needed
1. **Urgent**: Expedite API_SECRET setup (blocking critical feature)
2. **Important**: Schedule grooming review session (3 tasks waiting)
3. **Nice to Have**: Explore backup payment provider (reduce risk)

## 📚 Retrospective Highlights

**Key Learnings** (from completed tasks):
- JWT implementation was more complex than estimated (factor 1.5x for auth)
- Database migration went smoothly with proper rollback plan
- Early reviewer involvement prevented rework

**Process Improvements**:
- Add "external dependency" flag during grooming
- Create blocker escalation SLA
- Schedule daily 10-min blocker review

---

**Workspace Health**: Good ✅  
(Minor blockers present but manageable, strong completion rate)

**Next Actions**:
1. Resolve 2 active blockers
2. Approve 3 pending grooming plans
3. Continue implementation on active tasks

---
Generated by ASAF v1.0
Use `/asaf-status <task>` for detailed task info
Use `/asaf-help` for command reference
```

---

## Display to User

Show the complete summary above, then:

```
📊 Summary complete!

Quick Actions:
  /asaf-status feature-user-authentication  - Check blocked task details
  /asaf-list --active                       - See all active tasks
  /asaf-help                                - View all commands

Want to export this summary?
The report has been saved to: reports/summary-[timestamp].md
```

---

## Advanced Usage

### Filter by State
```
/asaf-summary --active
/asaf-summary --completed
/asaf-summary --blocked
```
Show only tasks in specific states

### Time-Based Filtering
```
/asaf-summary --since 2024-10-01
/asaf-summary --last-week
```
Analyze tasks within time windows

### Detailed Level
```
/asaf-summary --detail minimal
/asaf-summary --detail comprehensive
```
Adjust depth of analysis

---

## State Updates

**Reads Only** (no state modifications):
- `asaf-state.json`
- `tasks/*/.task-state.json`
- `tasks/*/.retro.md`
- `tasks/*/.demo-notes.md`

**Writes To**:
- `reports/summary-[timestamp].md` - Saved copy of summary

---

## Error Handling

### No Tasks Found
```
ℹ️ No tasks in workspace

No tasks have been created yet.

To create your first task:
  /asaf-init <task-name>

Example:
  /asaf-init feature-user-authentication
```

### Corrupted State
```
⚠️ Warning: State file issues detected

X tasks have invalid or corrupted state.

Summary generated from Y valid tasks.

To investigate issues:
  /asaf-status --all

To repair state:
  Review tasks/<task-name>/.task-state.json files manually
```

---

## Health Scoring Algorithm

**Excellent** ✅✅✅
- 0 blockers
- Completion rate > 80%
- Velocity stable or increasing
- No stalled tasks (>7 days inactive)

**Good** ✅✅
- 1-2 minor blockers
- Completion rate > 60%
- Velocity stable
- Few stalled tasks

**Needs Attention** ⚠️
- 3+ blockers or 1 critical blocker
- Completion rate < 60%
- Velocity decreasing
- Multiple stalled tasks

**Critical** 🔴
- Critical blocker affecting multiple tasks
- Completion rate < 40%
- Velocity dropped significantly
- Many stalled or abandoned tasks

---

## Integration with Other Commands

**Complements**:
- `/asaf-status <task>` - Detailed single task status
- `/asaf-list` - Raw task listing
- `/asaf-retro` - Individual task learnings

**Difference from `/asaf-status`**:
- **Status**: Single task, detailed, technical, current state
- **Summary**: All tasks, high-level, strategic, trends & patterns

---

## Use Cases

### 1. Daily Standup
```
/asaf-summary --active
```
Quick overview of work in progress

### 2. Weekly Team Meeting
```
/asaf-summary
```
Full picture for team sync

### 3. Sprint Review
```
/asaf-summary --completed --since <sprint-start-date>
```
Show sprint accomplishments

### 4. Executive Update
```
/asaf-summary --detail minimal
```
High-level status for leadership

### 5. Retrospective Prep
```
/asaf-summary --completed --last-month
```
Gather data for retro discussion

---

## Best Practices

✅ **Run regularly**: Daily or weekly to catch issues early

✅ **Share with team**: Use summary in standups and reviews

✅ **Track trends**: Compare summaries over time to measure improvement

✅ **Act on insights**: Don't just read—address recommendations

✅ **Celebrate wins**: Highlight team achievements from summary

❌ **Don't ignore warnings**: Health scores and risks require action

❌ **Don't skip blockers**: Address blockers promptly

---

## Pro Tips

💡 **Automate it**: Schedule weekly summaries via CI/CD or cron

💡 **Version control**: Commit summary reports for historical tracking

💡 **Compare months**: Use saved reports to see long-term trends

💡 **Share insights**: Post key findings in team chat

💡 **Action blockers**: Create tasks to resolve recurring blockers

💡 **Refine process**: Use patterns to improve grooming and estimation

---

_Summary command provides the strategic view needed for effective team leadership and continuous improvement._
