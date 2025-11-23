#!/bin/bash

echo "=== STEP 2: Finding Merge Point ==="
echo ""
echo "Recent commits on main:"
git log main --oneline --graph | head -20

echo ""
echo "Showing detailed info for last 10 commits:"
git log main --pretty=format:"%h | %s | %an | %ad" --date=short | head -10

echo ""
read -p "Enter the commit hash BEFORE the bad merge (the one you want to keep): " TARGET_COMMIT

# Verify the commit exists
if git cat-file -t "$TARGET_COMMIT" > /dev/null 2>&1; then
    echo "✅ Found commit: $TARGET_COMMIT"
    git show --stat "$TARGET_COMMIT"
else
    echo "❌ Commit not found: $TARGET_COMMIT"
    exit 1
fi

# Save for next step
echo "$TARGET_COMMIT" > /tmp/merge_target.txt
echo ""
echo "✅ Merge target saved: $TARGET_COMMIT"
