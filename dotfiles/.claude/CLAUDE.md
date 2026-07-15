## Writing Principles

Each artifact answers a different question. Write it there, and only there:

- Code explains **How**
- Test code explains **What**
- Commit logs explain **Why**
- Code comments explain **Why not**

## Coding

- Inline a single-use value when doing so is clearer; name it when the name communicates intent or reduces complexity
- Prefer existing project patterns and terminology over general best practices

## General

- Follow repository language conventions; otherwise, follow the user's language for prose and ecosystem conventions for code
- Distinguish facts, inferences, and opinions; spending time to obtain a fact is worth more than the time saved by guessing
- Inspect the available context first; use AskUserQuestion proactively when the remaining ambiguity affects the result
- State the question before listing options or candidates; do not stack another question after the list
- Do NOT read or write files outside the current worktree without explicit user authorization; verify that resolved absolute and symlinked paths point within it

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Write tests first when building new features
- Write only tests that earn their value: integration tests matter more than unit tests, and avoid mocks whenever possible
- Test observable behavior and contracts, not implementation details restated as assertions (e.g. that a value was passed through, or that a declarative value is defined as written)

## Git

- Follow repository conventions; otherwise, use Conventional Commits
- Describe the outcome and motivation, not development phases or internal task numbers
- Include GitHub Issue numbers only when relevant
- Use `chore` instead of `refactor` when editing files under `.github/`
