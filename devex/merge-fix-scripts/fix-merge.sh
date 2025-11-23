#!/bin/bash

set -e  # Exit on any error

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════╗"
echo "║   Git Merge Fix - Preserve Commits     ║"
echo "╚════════════════════════════════════════╝"
echo ""

steps=(
    "step1-check-current-state.sh"
    "step2-find-merge-point.sh"
    "step3-create-backup.sh"
    "step4-reset-main.sh"
    "step5-merge-with-no-ff.sh"
    "step6-verify-commits.sh"
    "step7-push-to-remote.sh"
)

for i in "${!steps[@]}"; do
    step=$((i + 1))
    script="${steps[$i]}"

    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║ Step $step of ${#steps[@]}: $(basename "$script" .sh)     ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    if [ ! -f "$SCRIPTS_DIR/$script" ]; then
        echo "❌ Script not found: $script"
        exit 1
    fi

    bash "$SCRIPTS_DIR/$script"

    if [ $? -ne 0 ]; then
        echo ""
        echo "❌ Step $step failed. Aborting."
        exit 1
    fi

    echo ""
    read -p "Press Enter to continue to next step (or Ctrl+C to abort): " _
done

echo ""
echo "╔════════════════════════════════════════╗"
echo "║         ✅ ALL STEPS COMPLETE!         ║"
echo "╚════════════════════════════════════════╝"
