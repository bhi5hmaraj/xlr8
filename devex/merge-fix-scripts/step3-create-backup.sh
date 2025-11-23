#!/bin/bash

echo "=== STEP 3: Creating Backup Branch ==="
echo ""

BACKUP_BRANCH="backup-main-$(date +%s)"
echo "Creating backup: $BACKUP_BRANCH"

git branch "$BACKUP_BRANCH" main

if git show-ref --quiet refs/heads/"$BACKUP_BRANCH"; then
    echo "✅ Backup created successfully"
    echo "   Branch: $BACKUP_BRANCH"
    echo ""
    echo "   To restore if needed: git reset --hard $BACKUP_BRANCH"
else
    echo "❌ Failed to create backup"
    exit 1
fi

# Save backup branch name
echo "$BACKUP_BRANCH" > /tmp/backup_branch.txt
