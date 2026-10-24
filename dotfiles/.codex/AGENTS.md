## Writing Principles

Each artifact answers a different question. Write it there, and only there:

- Code explains **How**
- Test code explains **What**
- Commit logs explain **Why**
- Code comments explain **Why not**
- Remove mannered prose.
- Choose words that do not exaggerate or obscure the point.
- Avoid the Japanese word `効く` unless it names a specific effect, as in `キャッシュが効き、レスポンスが速くなった`. Never write `A には XX が効く`; state what XX changes and why.

## Coding

- Inline a single-use value when doing so is clearer; name it when the name communicates intent or reduces complexity

## General

- Follow repository language conventions; otherwise, follow the user's language for prose and ecosystem conventions for code
- Distinguish facts, inferences, and opinions; verify claims rather than guessing
- Load supporting documentation and skill references when relevant to the task; do not require a full repository survey for every edit
- Within the authorized scope, carry the requested change through implementation, relevant validation, and fixes without asking again at each step. If completion needs missing access, user input, or an action outside that scope, explain the blocker and continue independent work
- For diagrams and flowcharts in conversation, write a simple, self-contained HTML file under `/tmp` that renders the visualization in a browser and provide its absolute path. Do not publish it as an Artifact or other hosted page. Do not output Mermaid source or code blocks in chat; terminal clients may not render them.

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Prefer integration tests over unit tests; avoid mocks; test observable behavior and contracts, not implementation details

## Git

- Follow repository conventions; otherwise, use Conventional Commits
- No development phases or internal task numbers in commit messages; include GitHub Issue numbers only when relevant
- Use `chore` instead of `refactor` when editing files under `.github/`
- When a review comment from a bot (e.g. Copilot) is valid and you have applied the fix, resolve the thread silently; do not write a reply
