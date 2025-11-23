#!/bin/bash

echo "=== STEP 1: Checking Current State ==="
echo ""

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $CURRENT_BRANCH"

# Get main status
echo ""
echo "Main branch status:"
git log main --oneline | head -10

# Check for uncommitted changes
echo ""
echo "Uncommitted changes:"
git status --short
if [ -z "$(git status --short)" ]; then
    echo "✅ No uncommitted changes"
else
    echo "❌ Warning: You have uncommitted changes!"
    exit 1
fi

# Show origin/main
echo ""
echo "Remote main (origin/main):"
git log origin/main --oneline | head -5

echo ""
echo "=== Ready to proceed to Step 2 ==="
