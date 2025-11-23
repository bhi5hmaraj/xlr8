# Git Merge Fix - Preserve Individual Commits as Contributions

> Fix a merged PR that used squash/rebase to show all individual commits as separate contributions

## Problem

When merging a PR with multiple commits using **squash** or **rebase**, all commits get collapsed into a single contribution. This loses individual commit history.

**Result**: Only 1 contribution shows up instead of N commits ❌

## Solution

Use a **regular merge with `--no-ff`** flag to preserve all individual commits.

**Result**: All N commits show as separate contributions ✅

## Quick Start

### For Already-Merged PRs

**If your PR is already merged to main**, read this first:

```bash
cat GUIDE_FOR_MERGED_PRs.md
```

This explains how to find the commit that has all your individual commits, which you'll need in Step 5.

### Prerequisites

```bash
# Verify you're in a git repository with uncommitted changes clean
git status

# Make sure no one else is working on main
git log main --oneline | head -10
```

### Run the Fix

```bash
# Make the scripts executable
chmod +x step*.sh fix-merge.sh

# Run the complete process (includes human-in-the-loop checks)
./fix-merge.sh

# Or run individual steps manually (with full control)
./step1-check-current-state.sh
./step2-find-merge-point.sh
./step3-create-backup.sh
./step4-reset-main.sh
./step5-merge-with-no-ff.sh
./step6-verify-commits.sh
./step7-push-to-remote.sh
```

## What This Does

| Step | Purpose | Human Check |
|------|---------|-------------|
| 1 | Verify current state, no uncommitted changes | Review git status |
| 2 | Find the commit to reset to (before bad merge) | Verify correct commit selected |
| 3 | Create backup branch for recovery | Note backup branch name |
| 4 | Reset main to that commit | Confirm reset was successful |
| 5 | Merge the branch with `--no-ff` | Verify merge succeeded without conflicts |
| 6 | Verify all commits are visible in history | Check graphical view of commits |
| 7 | Push to remote with safety flag | Confirm final push to origin |

## How It Works

### ❌ Wrong Way (Squash/Rebase)
All commits become 1 merged commit - only 1 contribution counted

### ✅ Right Way (Merge with --no-ff)
Creates a merge commit but preserves all original commits with original hashes:
```
main
│
└─ [Merge Commit] ─────────────────┐
   │                                │
   ├─ Individual Commit 1          │
   ├─ Individual Commit 2    ← All visible!
   ├─ Individual Commit 3          │
   └─ Individual Commit N ────────┘
```

All N commits show as separate contributions ✅

## Emergency Recovery

If anything goes wrong:

```bash
# Restore from backup
BACKUP_BRANCH=$(cat /tmp/backup_branch.txt)
git reset --hard $BACKUP_BRANCH
git push origin main --force-with-lease
```

Or restore manually if you noted the backup branch name:
```bash
git reset --hard backup-main-<timestamp>
git push origin main --force-with-lease
```

## Key Commands Reference

```bash
# Check current state
git log main --oneline | head -10

# View commit graph
git log main --graph --oneline -15

# Create backup
git branch backup-main-$(date +%s) main

# Reset to a commit
git reset --hard <commit-hash>

# Merge with --no-ff (preserves commits)
git merge --no-ff origin/feature-branch

# Force push with safety
git push origin main --force-with-lease

# Restore from backup if needed
git reset --hard <backup-branch-name>
```

## Why --no-ff Preserves Commits

| Strategy | Effect | Contributions |
|----------|--------|---|
| Squash | All commits → 1 commit | 1 ❌ |
| Rebase | Rewrites hashes | May not count ❌ |
| Merge (ff) | Fast-forward, no merge commit | May look messy ⚠️ |
| **Merge --no-ff** | **Creates merge commit, preserves all** | **All N commits** ✅ |

The `--no-ff` flag ensures:
1. A merge commit is created
2. All original commits are preserved with original hashes
3. History shows when feature was integrated
4. All commits count as separate contributions

## Troubleshooting

### Step hangs/freezes
- Press `Ctrl+C` to abort
- Run step again or use manual commands
- Check git status for uncommitted changes

### Merge conflicts
- Read error message carefully
- Manually resolve conflicts if needed
- Run `git merge --abort` to cancel
- Check which files are conflicting

### Remote push fails
- Ensure you have permission to push to main
- Check that no one pushed to main while you were working
- Use `git fetch origin` to update remote tracking
- The `--force-with-lease` flag prevents accidental overwrites

### Can't find the right commit
- Review the full commit history: `git log main --pretty=format:"%h | %s | %an" --all`
- Look for the commit before the bad merge was done
- Take your time - getting this right is critical

## Files in This Directory

- `README.md` - This file (overview and quick start)
- `GUIDE_FOR_MERGED_PRs.md` - **Start here if your PR is already merged**
- `CHECKLIST.md` - Quick reference checklist for each step
- `step1-check-current-state.sh` - Verify git state before starting
- `step2-find-merge-point.sh` - Identify commit to reset to
- `step3-create-backup.sh` - Create emergency backup branch
- `step4-reset-main.sh` - Reset main to merge point
- `step5-merge-with-no-ff.sh` - Perform correct merge
- `step6-verify-commits.sh` - Verify all commits visible
- `step7-push-to-remote.sh` - Push to remote
- `fix-merge.sh` - Master script (runs all steps sequentially)

## Need Help?

Check the full guide at: `MERGE_FIX_GUIDE.md` (in parent directory)

It includes:
- Detailed explanations of each step
- Pre-verification checklist
- Post-verification checklist
- Emergency recovery procedures
- Design rationale

---

**Remember**: Take your time, read all prompts carefully, and don't hesitate to abort and restore from backup if anything feels wrong.
