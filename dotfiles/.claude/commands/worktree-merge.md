---
allowed-tools: Bash(git *)
description: Merge branch without merge commit (fast-forward only, rebase if needed)
---

Merge the current worktree branch into the target branch without creating a merge commit.

## Arguments

- `$ARGUMENTS`: Target branch to merge into (default: `main`)

## Steps

1. Get the current branch name from this worktree
2. Find the main repository root using `git worktree list` (the first entry is the main worktree)
3. In the main repository root:
   - Checkout the target branch and pull latest changes
   - Attempt `git merge --ff-only <current-branch>`
4. If fast-forward fails:
   - Return to this worktree directory
   - Run `git rebase <target-branch>`
   - Go back to the main repository root
   - Retry `git merge --ff-only <current-branch>`
5. Report the result to the user

## Important

- Use `git worktree list` to find the main repository root (first line)
- If rebase conflicts occur, stop and ask the user for guidance
- Do not force push or use destructive commands
- After successful merge, inform the user but do not delete the worktree automatically
