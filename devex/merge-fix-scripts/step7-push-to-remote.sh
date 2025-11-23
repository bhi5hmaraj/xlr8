#!/bin/bash

echo "=== STEP 7: Pushing to Remote ==="
echo ""

BACKUP_BRANCH=$(cat /tmp/backup_branch.txt)

echo "⚠️  FINAL WARNING - This will rewrite main on remote"
echo ""
echo "Current state:"
git log main --oneline | head -5

echo ""
echo "Backup branch (for recovery): $BACKUP_BRANCH"
echo ""

read -p "Type 'yes' to force push main to origin (THIS IS FINAL): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Push cancelled"
    exit 1
fi

echo ""
echo "Pushing to remote..."
git push origin main --force-with-lease

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to remote!"
    echo ""
    echo "Verification - Remote main:"
    git log origin/main --oneline | head -10

    echo ""
    echo "✅ MERGE FIX COMPLETE!"
    echo ""
    echo "Summary:"
    echo "  - Old state backed up to: $BACKUP_BRANCH"
    echo "  - All individual commits preserved on main"
    echo "  - Changes pushed to remote"
else
    echo "❌ Push failed"
    exit 1
fi

# Cleanup
rm /tmp/merge_target.txt /tmp/backup_branch.txt /tmp/merge_status.txt 2>/dev/null
