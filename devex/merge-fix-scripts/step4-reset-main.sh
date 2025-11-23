#!/bin/bash

echo "=== STEP 4: Resetting Main to Merge Point ==="
echo ""

# Read target commit from previous step
TARGET_COMMIT=$(cat /tmp/merge_target.txt)
BACKUP_BRANCH=$(cat /tmp/backup_branch.txt)

echo "Target commit: $TARGET_COMMIT"
echo "Backup branch: $BACKUP_BRANCH"
echo ""

echo "⚠️  WARNING: This will reset main to commit $TARGET_COMMIT"
echo "    All commits after this point will be lost from main"
echo "    (but saved in backup branch: $BACKUP_BRANCH)"
echo ""

read -p "Type 'yes' to confirm reset: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Reset cancelled"
    exit 1
fi

echo ""
echo "Resetting main..."
git reset --hard "$TARGET_COMMIT"

if [ $? -eq 0 ]; then
    echo "✅ Reset successful"
    echo ""
    echo "Current main state:"
    git log main --oneline | head -5
else
    echo "❌ Reset failed"
    exit 1
fi
