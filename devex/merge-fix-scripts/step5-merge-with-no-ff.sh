#!/bin/bash

echo "=== STEP 5: Merging with --no-ff ==="
echo ""

echo "How to provide the branch to merge:"
echo "  For already-merged PRs: Use the commit hash that has all your commits"
echo "                          (Find it in git log or on GitHub/GitLab)"
echo "  For unmerged branches:  Use branch name like 'origin/feature-branch'"
echo ""

read -p "Enter the branch/commit to merge (e.g., origin/feature-branch, commit-hash, or branch-name): " MERGE_BRANCH

echo "Preparing to merge: $MERGE_BRANCH"
echo ""

# Fetch latest from remote
echo "Fetching latest from remote..."
git fetch origin

echo ""
echo "Commits that will be merged:"
# Handle both branch and commit hash
git log main..$MERGE_BRANCH --oneline 2>/dev/null || echo "(Showing commits from $MERGE_BRANCH onwards)"

echo ""
echo "⚠️  WARNING: Merging $MERGE_BRANCH into main with --no-ff flag"
echo "    This will create a merge commit but preserve all individual commits"
echo ""

read -p "Type 'yes' to proceed with merge: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Merge cancelled"
    exit 1
fi

echo ""
echo "Executing merge..."
git merge --no-ff "$MERGE_BRANCH" -m "Merge $MERGE_BRANCH with preserved commits"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Merge successful!"
    echo ""
    echo "New main state:"
    git log main --oneline --graph | head -15
else
    echo "❌ Merge failed"
    echo "   To abort: git merge --abort"
    echo "   To restore: git reset --hard $(cat /tmp/backup_branch.txt)"
    exit 1
fi

# Save merge status
echo "success" > /tmp/merge_status.txt
