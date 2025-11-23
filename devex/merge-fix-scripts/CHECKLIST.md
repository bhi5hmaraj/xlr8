# Merge Fix - Quick Reference Checklist

## Pre-Execution Checklist

- [ ] Understand what `--no-ff` merge does (preserves individual commits)
- [ ] Have backup plan (recovery procedure noted)
- [ ] Team aware (if main already pushed)
- [ ] No active work on main (no one else working)
- [ ] Working directory is clean (no uncommitted changes)
- [ ] Latest version of main fetched locally

## Step 1: Current State

- [ ] No uncommitted changes
- [ ] Understand current main state
- [ ] Know which branch we're on
- [ ] Can see remote main status

## Step 2: Find Merge Point

- [ ] Reviewed recent commits carefully
- [ ] Correct commit identified (the one BEFORE the bad merge)
- [ ] Commit hash verified to exist
- [ ] Understood what this commit represents
- [ ] Target commit saved to `/tmp/merge_target.txt`

## Step 3: Backup

- [ ] Backup branch created
- [ ] Recovery command noted: `git reset --hard <backup-branch-name>`
- [ ] Backup branch name saved to `/tmp/backup_branch.txt`
- [ ] Can see backup branch in git: `git branch | grep backup-main`

## Step 4: Reset

- [ ] Confirmed reset action (typed 'yes')
- [ ] Reset completed successfully
- [ ] main is now at the correct commit
- [ ] Backup branch still exists for recovery (verify: `git branch | grep backup`)
- [ ] Current state matches what we expect

## Step 5: Merge

- [ ] Correct branch selected for merge
- [ ] Reviewed commits that will be merged
- [ ] Merge completed without conflicts
- [ ] Merge commit created
- [ ] No file conflicts to resolve
- [ ] Merge status saved to `/tmp/merge_status.txt`

## Step 6: Verify

- [ ] All individual commits visible in history
- [ ] Graph view shows proper merge structure
- [ ] No commits lost in the process
- [ ] Commit count matches expectations
- [ ] Can see all authors' contributions
- [ ] Merge commit is at the tip of main

## Step 7: Push

- [ ] Reviewed final warning
- [ ] Backup branch noted for emergency recovery
- [ ] Remote updated successfully (no auth errors)
- [ ] Commits visible on `origin/main`
- [ ] Force-with-lease flag used (safe against races)

## Post-Execution Checklist

- [ ] Verify on GitHub/GitLab/etc (web UI shows all commits)
- [ ] All contributions display correctly (not collapsed to 1)
- [ ] Team notified of change
- [ ] Backup branch kept for at least 24 hours (for safety)
- [ ] Can delete backup branch after confirmation: `git branch -d <backup-branch-name>`
- [ ] Anyone with downstream branches updated their work

## Emergency Recovery Procedure

If anything goes wrong:

```bash
# 1. Check backup branch exists
git branch | grep backup-main

# 2. Restore from backup
BACKUP_BRANCH=backup-main-<timestamp>
git reset --hard $BACKUP_BRANCH

# 3. Push to remote
git push origin main --force-with-lease

# 4. Verify remote is restored
git log origin/main --oneline | head -5
```

## Quick Commands Reference

```bash
# Check status
git status
git log main --oneline | head -10

# View history graphically
git log main --graph --oneline -15

# Create backup
git branch backup-main-$(date +%s) main

# Reset to commit
git reset --hard <commit-hash>

# Merge with --no-ff
git merge --no-ff <branch-name>

# View merge history
git log main --oneline --all --graph | head -20

# Push with safety
git push origin main --force-with-lease

# Restore from backup
git reset --hard <backup-branch-name>
git push origin main --force-with-lease
```

## Troubleshooting Quick Reference

| Problem | Solution |
|---------|----------|
| Step hangs | Press `Ctrl+C`, check git status, restart step |
| Merge conflicts | Read error carefully, resolve manually, `git merge --abort` if needed |
| Can't find commit | Run `git log --all --oneline`, look before bad merge |
| Push fails | `git fetch origin`, check permissions, ensure `--force-with-lease` used |
| Backup missing | Try to find backup with `git branch -a \| grep backup` |
| Remote out of sync | Run `git fetch origin` to update local tracking |
| Wrong commit reset | Restore: `git reset --hard <backup-branch-name>` |

## Key Concepts to Remember

- **--no-ff**: Creates a merge commit, preserves all original commits
- **--force-with-lease**: Safe force push, protects against concurrent pushes
- **backup branch**: Emergency recovery option - keep for 24+ hours
- **Individual commits**: Each commit keeps its original hash and author
- **Merge commit**: Shows when feature was integrated, but all commits visible

## When to Abort and Restore

Abort and restore if:
- You selected the wrong commit in Step 2
- Merge conflicts occur in Step 5 that you can't resolve
- Something feels wrong or unexpected happens
- Remote push fails and you can't understand why

**Recovery is always an option** - that's why we create the backup!

---

**Remember**: Take your time at each step, read all prompts carefully, and don't hesitate to abort and restore from backup if anything feels wrong.
