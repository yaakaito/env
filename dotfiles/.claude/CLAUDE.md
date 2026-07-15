## Writing Principles

Each artifact answers a different question. Write it there, and only there:

- Code explains **How**
- Test code explains **What**
- Commit logs explain **Why**
- Code comments explain **Why not**

## Coding

- Inline a single-use value when doing so is clearer; name it when the name communicates intent or reduces complexity

## General

- Follow repository language conventions; otherwise, follow the user's language for prose and ecosystem conventions for code
- Distinguish facts, inferences, and opinions; spending time to obtain a fact is worth more than the time saved by guessing
- Use AskUserQuestion when the remaining ambiguity affects the result; state the question before listing options

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Prefer integration tests over unit tests; avoid mocks; test observable behavior and contracts, not implementation details

## Git

- Follow repository conventions; otherwise, use Conventional Commits
- No development phases or internal task numbers in commit messages; include GitHub Issue numbers only when relevant
- Use `chore` instead of `refactor` when editing files under `.github/`
