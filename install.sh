#!/bin/bash

# ASAF Global Installation Script
# Installs ASAF commands to ~/.claude/commands/

set -e  # Exit on error

echo "🚀 Installing ASAF (Agile Scrum Agentic Flow)"
echo ""

# Check if running from ASAF repo
if [ ! -d ".claude/commands" ]; then
    echo "❌ Error: This script must be run from the ASAF repository root"
    echo ""
    echo "Usage:"
    echo "  git clone https://github.com/your-repo/asaf.git"
    echo "  cd asaf"
    echo "  ./install.sh"
    exit 1
fi

# Create global commands and agents directories if they don't exist
echo "📁 Creating ~/.claude/commands/ directory..."
mkdir -p ~/.claude/commands/shared
echo "📁 Creating ~/.claude/agents/ directory..."
mkdir -p ~/.claude/agents

# Check if commands already exist
if [ -f ~/.claude/commands/asaf-init.md ]; then
    echo ""
    echo "⚠️  ASAF commands already installed."
    read -p "Do you want to overwrite? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
fi

# Copy command files
echo "📋 Installing ASAF commands..."
cp .claude/commands/*.md ~/.claude/commands/
echo "   ✓ Command files installed"

echo "📋 Installing shared agent personas..."
cp .claude/commands/shared/*.md ~/.claude/commands/shared/
echo "   ✓ Shared files installed"

echo "📋 Installing demo templates..."
mkdir -p ~/.claude/commands/templates/demo/slides/common
mkdir -p ~/.claude/commands/templates/demo/slides/content
cp -r .claude/commands/templates/demo/*.md ~/.claude/commands/templates/demo/
cp -r .claude/commands/templates/demo/slides/common/*.md ~/.claude/commands/templates/demo/slides/common/
cp -r .claude/commands/templates/demo/slides/content/*.md ~/.claude/commands/templates/demo/slides/content/
echo "   ✓ Demo templates installed"

echo "🤖 Installing ASAF default sub-agents..."
cp agents/*.md ~/.claude/agents/
echo "   ✓ Sub-agents installed"

# Count installed files
COMMAND_COUNT=$(ls ~/.claude/commands/asaf-*.md 2>/dev/null | wc -l)
SHARED_COUNT=$(ls ~/.claude/commands/shared/*.md 2>/dev/null | wc -l)
AGENT_COUNT=$(ls ~/.claude/agents/asaf-*.md 2>/dev/null | wc -l)
TEMPLATE_COUNT=$(find ~/.claude/commands/templates/demo -name "*.md" 2>/dev/null | wc -l)

echo ""
echo "✅ ASAF installed successfully!"
echo ""
echo "📊 Installation Summary:"
echo "   Commands:    $COMMAND_COUNT files"
echo "   Shared:      $SHARED_COUNT files"
echo "   Templates:   $TEMPLATE_COUNT files"
echo "   Sub-Agents:  $AGENT_COUNT files"
echo "   Location:    ~/.claude/commands/"
echo "   Templates:   ~/.claude/commands/templates/demo/"
echo "   Agents:      ~/.claude/agents/"
echo ""
echo "🎯 Next Steps:"
echo ""
echo "1. Navigate to any project:"
echo "   cd your-project/"
echo ""
echo "2. Start using ASAF:"
echo "   /asaf-init my-feature"
echo ""
echo "3. (Optional) Create personal goals:"
echo "   nano ~/.claude/personal-goals.md"
echo ""
echo "📚 Documentation:"
echo "   https://github.com/your-repo/asaf"
echo ""
echo "💡 Tip: ASAF will automatically create an 'asaf/' folder in each"
echo "    project where you use it. Sprint data stays local to each project."
echo ""
