## General

- Follow the system prompt's language setting for code, documentation, and Git Commit/PR messages
- Do not commit until the user explicitly instructs you to do so
- Use AskUserQuestion tool proactively when something is unclear
- Avoid obvious comments; only add comments to explain the why behind complex logic
- Work on only one feature at a time; complete it before moving to the next

## TypeScript

- Prefer `type` and `satisfies`

## Testing

- Practice TDD as advocated by Kent Beck and t_wada
- Write tests first when building new features

## Planning

- When creating a plan, add running the `/simplify` agent as the final step
- When creating a plan, add running `/codex-review` to get a Codex review before finishing

## Git

- Follow Conventional Commits unless otherwise specified
- Focus commit messages on why the change was made
- Commit messages must not include development phases or task numbers; only GitHub Issue numbers are allowed
- Use `chore` instead of `refactor` when editing files under `.github/`
