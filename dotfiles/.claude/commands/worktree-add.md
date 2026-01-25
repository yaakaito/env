---
allowed-tools: Bash(git-worktree-add:*)
description: Create a new git worktree (generates branch name from description)
---

Create a new git worktree for: $ARGUMENTS

Run: `git-worktree-add $ARGUMENTS`

The script will automatically generate an appropriate branch name using Claude.
If a branch name is specified directly (e.g., `feature/xxx`), use `-b` option:
`git-worktree-add -b $ARGUMENTS`
