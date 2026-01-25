# [Project Name]

[Brief description of the project's purpose and goals. 1-3 sentences explaining WHY this project exists.]

- [Key feature 1]
- [Key feature 2]
- [Key feature 3]

## Architecture Overview

- [Key architectural point 1]
- [Key architectural point 2]
- [Key architectural point 3]

## Directory Structure

```
project/
├── src/           # [Description]
├── tests/         # [Description]
├── docs/          # [Description]
└── ...
```

## Core Principles

- Prefer existing patterns and terminology over general best practices
- Avoid adding new dependencies unless necessary; remove when possible
- Follow Conventional Commits for commit messages

## Commands

- `bun install` - Install dependencies
- `bun run dev` - Start development server
- `bun run build` - Production build
- `bun test` - Run all tests
- `bun run lint` - Run linter

## Testing

- Prefer integration tests over unit tests
- Use in-source testing for unit tests covering edge cases
- Avoid mocks; use them only for external communication or resource fetching

## Language Policy

- Follow the user's language for comments, commits, and tests
- Write the following files in English:
  - CLAUDE.md, AGENTS.md
  - Files under `.claude/`
  - Files under `.github/` (except comments)
