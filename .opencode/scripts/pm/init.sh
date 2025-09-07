#!/bin/bash

echo "Initializing..."
echo ""
echo ""

echo " ██████╗ ██████╗██████╗ ███╗   ███╗"
echo "██╔════╝██╔════╝██╔══██╗████╗ ████║"
echo "██║     ██║     ██████╔╝██╔████╔██║"
echo "╚██████╗╚██████╗██║     ██║ ╚═╝ ██║"
echo " ╚═════╝ ╚═════╝╚═╝     ╚═╝     ╚═╝"

echo "┌─────────────────────────────────┐"
echo "│ Claude Code Project Management  │"
echo "│ by https://x.com/aroussi        │"
echo "└─────────────────────────────────┘"
echo "https://gitlab.com/automazeio/ccpm"
echo ""
echo ""

echo "🚀 Initializing Claude Code PM System"
echo "======================================"
echo ""

# Check for required tools
echo "🔍 Checking dependencies..."

# Check glab CLI
if command -v glab &> /dev/null; then
  echo "  ✅ GitLab CLI (glab) installed"
else
  echo "  ❌ GitLab CLI (glab) not found"
  echo ""
  echo "  Please install GitLab CLI (glab): https://gitlab.com/gitlab-org/cli"
  if command -v brew &> /dev/null; then
    brew install glab
  elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install glab
  else
    echo "  Install instructions: https://gitlab.com/gitlab-org/cli/-/tree/main#installation"
    exit 1
  fi
fi

# Check glab auth status
echo ""
echo "🔐 Checking GitLab authentication..."
if glab auth status &> /dev/null; then
  echo "  ✅ GitLab authenticated"
else
  echo "  ⚠️ GitLab not authenticated"
  echo "  Running: glab auth login"
  glab auth login
fi

# Create directory structure
echo ""
echo "📁 Creating directory structure..."
mkdir -p .opencode/prds
mkdir -p .opencode/epics
mkdir -p .opencode/rules
mkdir -p .opencode/agents
mkdir -p .opencode/scripts/pm
echo "  ✅ Directories created"

# Copy scripts if in main repo
if [ -d "scripts/pm" ] && [ ! "$(pwd)" = *"/.opencode"* ]; then
  echo ""
  echo "📝 Copying PM scripts..."
  cp -r scripts/pm/* .opencode/scripts/pm/
  chmod +x .opencode/scripts/pm/*.sh
  echo "  ✅ Scripts copied and made executable"
fi

# Check for git
echo ""
echo "🔗 Checking Git configuration..."
if git rev-parse --git-dir > /dev/null 2>&1; then
  echo "  ✅ Git repository detected"

  # Check remote
  if git remote -v | grep -q origin; then
    remote_url=$(git remote get-url origin)
    echo "  ✅ Remote configured: $remote_url"
    
    # Check if remote is the CCPM template repository
    if [[ "$remote_url" == *"automazeio/ccpm"* ]] || [[ "$remote_url" == *"automazeio/ccpm.git"* ]]; then
      echo ""
      echo "  ⚠️ WARNING: Your remote origin points to the CCPM template repository!"
      echo "  This means any issues you create will go to the template repo, not your project."
      echo ""
      echo "  To fix this:"
      echo "  1. Fork the repository or create your own on GitLab"
      echo "  2. Update your remote:"
      echo "     git remote set-url origin https://gitlab.com/YOUR_USERNAME/YOUR_REPO.git"
      echo ""
    fi
  else
    echo "  ⚠️ No remote configured"
    echo "  Add with: git remote add origin <url>"
  fi
else
  echo "  ⚠️ Not a git repository"
  echo "  Initialize with: git init"
fi

# Create AGENTS.md if it doesn't exist
if [ ! -f "AGENTS.md" ]; then
  echo ""
  echo "📄 Creating AGENTS.md..."
  cat > AGENTS.md << 'EOF'
# AGENTS.md

> Think carefully and implement the most concise solution that changes as little code as possible.

## Project-Specific Instructions

Add your project-specific instructions here.

## Testing

Always run tests before committing:
- `npm test` or equivalent for your stack

## Code Style

Follow existing patterns in the codebase.
EOF
  echo "  ✅ AGENTS.md created"
fi

# Summary
echo ""
echo "✅ Initialization Complete!"
echo "=========================="
echo ""
echo "📊 System Status:"
glab --version | head -1
#echo "  Extensions: $(glab extension list | wc -l) installed"
echo "  Auth: $(glab auth status 2>&1 | grep -o 'Logged in to [^ ]*' || echo 'Not authenticated')"
echo ""
echo "🎯 Next Steps:"
echo "  1. Create your first PRD: /pm:prd-new <feature-name>"
echo "  2. View help: /pm:help"
echo "  3. Check status: /pm:status"
echo ""
echo "📚 Documentation: README.md"

exit 0
