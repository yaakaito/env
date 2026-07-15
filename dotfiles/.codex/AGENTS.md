## Writing Principles

Each artifact answers a different question. Write it there, and only there:

- Code explains **How**
- Test code explains **What**
- Commit logs explain **Why**
- Code comments explain **Why not**

## Coding

- Avoid declaring variables or constants that are used only once; inline the expression at its single point of use
- Prefer existing project patterns and terminology over general best practices

## General

- Follow the user's language for code, documentation, and Git commit/PR messages
- Distinguish facts, inferences, and opinions; spending time to obtain a fact is worth more than the time saved by guessing
- Ask the user proactively when something is unclear instead of guessing
- State the question before listing options or candidates; do not stack another question after the list
- Do NOT read or write files outside the current worktree; verify that resolved absolute and symlinked paths point within it

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Write tests first when building new features
- Write only tests that earn their value: integration tests matter more than unit tests, and avoid mocks whenever possible
- Test observable behavior and contracts, not implementation details restated as assertions (e.g. that a value was passed through, or that a declarative value is defined as written)

## Git

- Follow Conventional Commits unless otherwise specified
- Commit messages must not include development phases or task numbers; only GitHub Issue numbers are allowed
- Use `chore` instead of `refactor` when editing files under `.github/`
