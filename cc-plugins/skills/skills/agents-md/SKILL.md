---
name: agents-md
description: Guide for creating and editing CLAUDE.md or AGENTS.md files - AI agent instruction documents. Use when the user wants to create a new CLAUDE.md/AGENTS.md, edit existing agent documentation, set up AI instructions for a repository, or asks about best practices for agent docs structure.
---

# Agents MD

## Overview

This skill provides knowledge and templates for creating and editing CLAUDE.md and AGENTS.md files - structured documentation that guides AI coding agents working with a codebase.

## Output Format Selection

Let the user choose the output format:

| Format | Use Case |
|--------|----------|
| **CLAUDE.md** | Claude Code specific (supports `@` imports, hierarchical memory) |
| **AGENTS.md** | Cross-tool compatible (Codex, Cursor, Copilot, etc.) |

For format-specific features, see:
- `references/claude-md-features.md` - Claude Code specific features
- `references/agents-md-spec.md` - AGENTS.md specification

## Document Structure

Use this 7-section structure. See `assets/template.md` for the full template.

### 1. Project Overview
Brief description of the project's purpose and goals. Answer "WHY does this project exist?"

### 2. Architecture
Factual description of the repository structure and package responsibilities. Answer "WHAT is in this codebase?"

### 3. Core Principles
Coding principles to follow. **Use these defaults as-is; append project-specific items rather than replacing:**

```markdown
## Core Principles
- Correspond to the current codebase, data, and terminology over theory or general practices; always review thoroughly
- Choose simple over easy; prefer clarity over cleverness
- Avoid adding new dependencies unless necessary; remove when possible
- Write comments that explain Why, not What
- Use descriptive variable and function names
- Remove unused code and arguments immediately
- Follow Conventional Commits for commit messages unless otherwise instructed
```

### 4. Development Commands
Build, run, lint, and test commands. Example:

```markdown
## Development Commands
- `npm install` - Install dependencies
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm test` - Run all tests
- `npm run lint` - Run linter
```

### 5. Testing Instructions
Testing strategy and policies (not commands). **Use these defaults as-is; append project-specific items rather than replacing:**

```markdown
## Testing Instructions
- Prefer integration tests over unit tests; write unit tests to cover edge cases
- Do not use mocks by default; use them only for external communication or resource fetching
- Test names should follow the user's language
- New features require corresponding tests
```

### 6. Language Policy
Programming and natural language rules. **Use these defaults as-is; append project-specific items rather than replacing:**

```markdown
## Language Policy
- Follow the user's language by default
- The following files must always be written in English:
  - CLAUDE.md, AGENTS.md
  - Files under .claude/
  - Files under docs/agents/
```

### 7. Additional Resources
References to detailed documentation. Format:

```markdown
## Additional Resources
- `docs/agents/DATABASE.md`: Database schema and relationships
- `docs/agents/API.md`: API endpoints and usage
- `docs/agents/ARCHITECTURE.md`: Detailed architecture decisions
```

## Best Practices

For detailed guidelines on writing effective agent documentation, see `references/best-practices.md`.

Key points:
- Keep under 300 lines (ideally under 100)
- Be specific, not generic
- Use Progressive Disclosure - link to detailed docs instead of including everything
- Let linters handle code style, not agent docs
