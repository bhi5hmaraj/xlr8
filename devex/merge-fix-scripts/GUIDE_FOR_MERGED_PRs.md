# Guide: Fixing Already-Merged PRs

This guide explains how to use the merge-fix process for PRs that are **already merged to main** but only show as 1 contribution instead of N individual commits.

## Scenario: Already-Merged PR

You merged a PR using squash or rebase, and now:
- Main has the merged code ✅
- But all commits collapsed into 1 contribution ❌
- You want to preserve individual commits as contributions ✅

## Key Difference for Already-Merged PRs

In **Step 5**, instead of merging from a branch, you'll merge from the **commit that contains all your individual commits**.

### Where to Find This Commit

Your individual commits are typically found in one of these places:

#### Option 1: On the Original Branch (if still exists)
```bash
# List all branches
git branch -a

# If your feature branch still exists
git log origin/feature-branch --oneline
```

#### Option 2: In Your Local Git History
```bash
# View all commits across all branches/remotes
git log --all --oneline --graph | head -50

# Look for commits with your name/message
git log --all --oneline --author="your-name" | head -20
```

#### Option 3: From GitHub/GitLab Web UI
1. Go to the PR page (might be closed)
2. Click "Commits" tab
3. Copy any commit hash from the PR
4. The entire PR's commits are connected

#### Option 4: If You Have the PR Branch Locally
```bash
# Check what branches you have
git branch -a

# See commits on that branch
git log origin/my-pr-branch --oneline
```

## Step-by-Step for Already-Merged PRs

### Before You Start

Make sure you have the original branch available:

```bash
# Fetch to get all remote references
git fetch origin

# Check if your PR branch still exists
git branch -a | grep your-branch-name

# If it's gone, but commits exist locally
git log --all --oneline | grep "your commit message"
```

### Running the Process

1. **Step 1**: Verify current state
   ```bash
   ./step1-check-current-state.sh
   ```

2. **Step 2**: Find merge point
   - Look for the commit **BEFORE** the merge happened
   - This is typically the parent of the merged commit
   - Example: if bad merge was commit `abc1234`, use its parent
   ```bash
   ./step2-find-merge-point.sh
   ```

3. **Step 3**: Create backup
   ```bash
   ./step3-create-backup.sh
   ```

4. **Step 4**: Reset main
   ```bash
   ./step4-reset-main.sh
   ```

5. **Step 5**: Merge with --no-ff
   ```bash
   ./step5-merge-with-no-ff.sh
   ```

   When prompted for branch/commit to merge:
   - If you have the PR branch: use `origin/your-branch-name`
   - If you have a commit hash: use that hash (e.g., `abc1234567890`)
   - The commits from that point will be merged with `--no-ff`

6. **Step 6**: Verify commits are visible
   ```bash
   ./step6-verify-commits.sh
   ```

7. **Step 7**: Push to remote
   ```bash
   ./step7-push-to-remote.sh
   ```

## Common Scenarios for Already-Merged PRs

### Scenario A: PR Branch Still Exists on Remote

Example: You merged `origin/feature/camera-blocking` but the branch wasn't deleted

**In Step 5**, when prompted:
```
Enter the branch/commit to merge: origin/feature/camera-blocking
```

The process will merge all commits from that branch with `--no-ff`.

### Scenario B: PR Branch Was Deleted, but You Know a Commit Hash

You can see from:
- GitHub/GitLab PR page (copy any commit hash)
- `git log --all` history (if commits still referenced)

**In Step 5**, when prompted:
```
Enter the branch/commit to merge: abc1234567890
```

Git will merge from that commit point, preserving all commits back to the merge point.

### Scenario C: You Saved the Branch Before Deleting

```bash
# If you have it locally
git branch my-saved-branch

# Then in Step 5:
Enter the branch/commit to merge: my-saved-branch
```

### Scenario D: Finding Commits from the PR Page

1. Go to your closed/merged PR on GitHub/GitLab
2. Click the "Commits" tab
3. Copy any commit hash shown
4. Use that hash in Step 5

## Verification: How to Know It Worked

After completing all steps, verify on your GitHub/GitLab page:

### ❌ Before (Wrong - All Collapsed):
```
Merge pull request #123 from user/feature
  └─ All commits squashed into 1 contribution
```

### ✅ After (Correct - All Preserved):
```
Merge pull request #123 from user/feature
  ├─ Commit 1: Implement camera blocking
  ├─ Commit 2: Add tests for blocking
  ├─ Commit 3: Fix edge case
  ├─ Commit 4: Update documentation
  └─ Commit 5: Final cleanup
```

Each commit shows as a separate line in the PR's commit history.

## Troubleshooting for Already-Merged PRs

### "Commit not found" in Step 2

The commit you're looking for doesn't exist locally.

**Solution**:
```bash
git fetch origin        # Update all remote refs
git log --all --oneline # View all commits
# Look for the parent of the merged commit
```

### "Already up to date" in Step 5

The commits you're trying to merge are already on main.

**Possible causes**:
- You specified the wrong commit
- The commits were already merged correctly
- The PR branch points to main

**Solution**: Restore from backup and try with the correct commit

```bash
git reset --hard $(cat /tmp/backup_branch.txt)
```

### Still Only Showing 1 Contribution After

The commits might not have been properly referenced.

**Debug**:
```bash
# Check if all commits are on main
git log main --oneline | head -20

# Check if they all have the same author
git log main --pretty=format:"%h | %an" | head -20

# View graphical history
git log main --graph --oneline -20
```

## Recovery for Already-Merged PRs

If something goes wrong and you need to recover the original state:

```bash
# See what backup branch was created
git branch | grep backup-main

# Restore to backup
git reset --hard backup-main-<timestamp>

# Push to remote
git push origin main --force-with-lease
```

## Important Notes for Already-Merged PRs

1. **The original commits are still in history** - Git doesn't delete commits, even if merged. They're in the reflog or referenced by other branches.

2. **Branch deletion doesn't lose commits** - If the PR branch was deleted, the commits are still reachable via commit hashes or PR page.

3. **Commit hashes are permanent** - You can always reference commits by their hash, even if branches are gone.

4. **Time-based recovery** - GitHub/GitLab keep PR commit history visible for a long time, so you can always find commits from old PRs.

## FAQ for Already-Merged PRs

**Q: Will this affect the code on main?**
A: No - we're preserving the same code, just changing how the commits are arranged in history.

**Q: Will this change commit authors?**
A: No - original commit authors are preserved with `--no-ff` merge.

**Q: Do I need the PR branch to still exist?**
A: No - a commit hash works too. If your PR is closed/deleted, you can find the commit hash on the PR page.

**Q: What if I don't remember which commits were in the PR?**
A: Check the PR page on GitHub/GitLab - it lists all commits even if the PR is closed.

**Q: Will this create duplicate commits?**
A: No - Git is smart enough to not duplicate commits that are already on main. The `--no-ff` flag just creates a merge commit pointing to existing commits.

---

**Bottom line**: Yes, this works perfectly for already-merged PRs. The key is finding the commit that has all your individual commits, then merging it with `--no-ff` to preserve the individual contributions.
