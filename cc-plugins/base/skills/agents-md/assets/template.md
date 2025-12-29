# [Project Name]

[Brief description of the project's purpose and goals. 1-3 sentences explaining WHY this project exists.]

- [Key feature 1]
- [Key feature 2]
- [Key feature 3]

## Architecture Overview

- [Key architectural point 1]
- [Key architectural point 2]
- [Key architectural point 3]

For detailed architecture, see `docs/ARCHITECTURE.md`.

## Directory Structure

```
project/
├── src/           # [Description]
├── tests/         # [Description]
├── docs/          # [Description]
└── ...
```

## Core Principles

- Correspond to the current codebase, data, and terminology over theory or general practices; always review thoroughly
- Avoid adding new dependencies unless necessary; remove when possible
- Follow clean code principles (simplicity, clarity, descriptive names, remove unused code)
- Follow Conventional Commits for commit messages unless otherwise instructed
- [Add project-specific items as needed]

## Commands

- `[command]` - [Description]
- `[command]` - [Description]
- `[command]` - [Description]

## Testing

- Prefer integration tests over unit tests; write unit tests to cover edge cases
- Do not use mocks by default; use them only for external communication or resource fetching
- Test names should follow the user's language
- New features require corresponding tests
- [Add project-specific items as needed]

## Language Policy

- Follow the user's language by default (comments, commits, tests)
- The following files must always be written in English:
  - CLAUDE.md, AGENTS.md
  - Files under .claude/
  - Files under docs/agents/
  - Files under .github/ (except comments)
- [Add project-specific items as needed]

## Additional Resources

- `docs/ARCHITECTURE.md`: [Description]
- `docs/agents/[FILE].md`: [Description]
- `docs/adr/adr-001-[slug].md`: [ADR title]
