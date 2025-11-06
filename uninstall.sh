#!/bin/bash

# ASAF Global Uninstallation Script
# Removes ASAF commands from ~/.claude/commands/

set -e  # Exit on error

echo "🗑️  Uninstalling ASAF (Agile Scrum Agentic Flow)"
echo ""

# Check if ASAF is installed
if [ ! -f ~/.claude/commands/asaf-init.md ]; then
    echo "ℹ️  ASAF is not installed globally."
    echo ""
    echo "Note: This only removes global installation."
    echo "Sprint data in project folders (asaf/) is preserved."
    exit 0
fi

# Confirm uninstallation
echo "⚠️  This will remove ASAF commands from ~/.claude/commands/"
echo ""
echo "Your sprint data in project folders will NOT be deleted."
echo ""
read -p "Continue with uninstallation? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Count files before removal
COMMAND_COUNT=$(ls ~/.claude/commands/asaf-*.md 2>/dev/null | wc -l)
SHARED_COUNT=$(ls ~/.claude/commands/shared/{asaf-core,grooming-agent,executor-agent,reviewer-agent}.md 2>/dev/null | wc -l)
TEMPLATE_COUNT=$(find ~/.claude/commands/templates/demo -name "*.md" 2>/dev/null | wc -l)
AGENT_COUNT=$(ls ~/.claude/agents/asaf-*.md 2>/dev/null | wc -l)

# Remove command files
echo "🗑️  Removing ASAF commands..."
rm -f ~/.claude/commands/asaf-*.md
echo "   ✓ Command files removed"

# Remove shared files
echo "🗑️  Removing shared agent personas..."
rm -f ~/.claude/commands/shared/asaf-core.md
rm -f ~/.claude/commands/shared/grooming-agent.md
rm -f ~/.claude/commands/shared/executor-agent.md
rm -f ~/.claude/commands/shared/reviewer-agent.md
echo "   ✓ Shared files removed"

# Remove templates
echo "🗑️  Removing demo templates..."
rm -rf ~/.claude/commands/templates/demo
echo "   ✓ Demo templates removed"

# Remove sub-agents
echo "🗑️  Removing ASAF sub-agents..."
rm -f ~/.claude/agents/asaf-*.md
echo "   ✓ Sub-agents removed"

echo ""
echo "✅ ASAF uninstalled successfully!"
echo ""
echo "📊 Removed:"
echo "   Commands:   $COMMAND_COUNT files"
echo "   Shared:     $SHARED_COUNT files"
echo "   Templates:  $TEMPLATE_COUNT files"
echo "   Sub-Agents: $AGENT_COUNT files"
echo ""
echo "📁 Preserved:"
echo "   - All sprint data in project asaf/ folders"
echo "   - Personal goals (~/.claude/personal-goals.md)"
echo ""
echo "💡 To remove personal goals (optional):"
echo "   rm ~/.claude/personal-goals.md"
echo ""
echo "💡 To remove sprint data from a project:"
echo "   cd your-project && rm -rf asaf/"
echo ""
