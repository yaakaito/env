## Writing Principles

Each artifact answers a different question. Write it there, and only there:

- Code explains **How**
- Test code explains **What**
- Commit logs explain **Why**
- Code comments explain **Why not**
- Remove mannered prose; choose words that do not exaggerate or obscure the point.
- Avoid the Japanese word `効く` wherever possible. It often hides the actual mechanism or outcome. Use it only when it is the precise, idiomatic term for a specific effect, as in `キャッシュが効き、レスポンスが速くなった`. Never write `A には XX が効く`; state what XX changes and why.

## Coding

- Inline a single-use value when doing so is clearer; name it when the name communicates intent or reduces complexity

## General

- Follow repository language conventions; otherwise, follow the user's language for prose and ecosystem conventions for code
- Distinguish facts, inferences, and opinions; verify uncertain facts before relying on them
- Read supporting documents and skill references when they inform the current task; do not load unrelated workflows

## Completion

- Carry authorized work through the requested outcome, including relevant verification and fixes; do not stop at the first implementation
- Ask when a missing decision or authorization blocks the next step; continue independent work within the agreed scope
- Report the result, verification performed, and any remaining blockers or unverified behavior

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Prefer integration tests over unit tests; avoid mocks; test observable behavior and contracts, not implementation details

## Git

- Follow repository conventions; otherwise, use Conventional Commits
- No development phases or internal task numbers in commit messages; include GitHub Issue numbers only when relevant
- Use `chore` instead of `refactor` when editing files under `.github/`
- When a review comment from a bot (e.g. Copilot) is valid and you have applied the fix, resolve the thread silently; do not write a reply
