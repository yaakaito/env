## Writing Principles

Each artifact has a primary question:

- Code explains **How**
- Tests explain **What behavior is expected**
- Commit messages explain **What changed and Why**
- Code comments explain non-obvious **Why** and **Why not**

Avoid unnecessary duplication.

## Coding

- Inline a single-use value when clearer; name it when the name communicates intent or reduces complexity
- Prefer existing project patterns and terminology

## General

- Follow repository language conventions; otherwise, follow the user's language for prose and ecosystem conventions for code
- Distinguish facts, inferences, and opinions; verify material facts instead of guessing
- Inspect available context first; use AskUserQuestion when remaining ambiguity materially affects the result
- State the question before listing options
- Do not modify files outside the current worktree without explicit user authorization; verify resolved paths before writing

## Testing

- Use red-green-refactor for new behavior and regression fixes, as advocated by Kent Beck and t_wada
- Prefer integration tests at meaningful boundaries; avoid mocks
- Test observable behavior and contracts, not implementation details

## Git

- Follow repository conventions; otherwise, use Conventional Commits
- Describe outcomes and motivation, not development phases or internal task numbers
- Include GitHub Issue numbers only when relevant
- For maintenance-only changes under `.github/`, prefer `chore` over `refactor`
