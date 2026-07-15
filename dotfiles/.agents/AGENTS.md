## Writing Principles

Each artifact answers a different question. Write it there, and only there:

- Code explains **How**
- Test code explains **What**
- Commit logs explain **Why**
- Code comments explain **Why not**

## Coding

- Avoid declaring variables or constants that are used only once; inline the expression at its single point of use

## General

- Follow the user's language for code, documentation, and Git commit/PR messages
- Ask the user proactively when something is unclear instead of guessing
- Do NOT read or write files outside the current worktree; when a path is absolute, verify it points within the current worktree

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Write tests first when building new features

## Git

- Follow Conventional Commits unless otherwise specified
- Commit messages must not include development phases or task numbers; only GitHub Issue numbers are allowed
- Use `chore` instead of `refactor` when editing files under `.github/`
