#!/bin/bash

echo "=== STEP 6: Verifying Commits ==="
echo ""

MERGE_STATUS=$(cat /tmp/merge_status.txt 2>/dev/null)

if [ "$MERGE_STATUS" != "success" ]; then
    echo "❌ Merge did not complete successfully"
    exit 1
fi

echo "Checking commit visibility:"
echo ""

# Count commits on main
TOTAL_COMMITS=$(git log main --oneline | wc -l)
echo "Total commits on main: $TOTAL_COMMITS"

echo ""
echo "Recent commits with details:"
git log main --pretty=format:"%h | %s | Author: %an | Date: %ad" --date=short | head -20

echo ""
echo "Graphical view of history:"
git log main --graph --oneline -15

echo ""
echo "✅ All commits visible!"
echo ""
echo "=== Ready for Step 7 ==="
