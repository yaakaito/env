# env

## Project Overview

A dotfiles repository automatically executed by GitHub Codespaces and devcontainers. Sets up shell configurations, Claude Code plugins, Codex skills, and other development tools.

## Architecture

```
env/
├── .claude/              # Claude Code settings and commands
│   ├── commands/         # Custom slash commands (commit, reviews-fix, workflow-fix)
│   ├── settings.json     # Claude Code settings
│   └── CLAUDE.md         # Project-specific instructions
├── .codex/               # OpenAI Codex settings
│   ├── config.toml       # Codex configuration
│   └── skills/           # Codex skills directory
├── .config/git/          # Git ignore patterns
├── bin/                  # Executable scripts
│   └── resolve-gh-issue  # GitHub Issue resolver CLI
├── cc-plugins/           # Claude Code plugins
│   ├── dev-plan/         # Spec-driven development workflow (includes adr-writer skill)
│   ├── devtools/         # Chrome DevTools MCP integration
│   ├── coderabbit/       # CodeRabbit integration
│   └── base/             # Basic skills (frontend-design, agents-md)
├── devcontainers/        # Pre-configured devcontainer templates
│   ├── deno/             # Deno runtime
│   ├── node-pnpm/        # Node.js with pnpm
│   └── bun/              # Bun runtime
├── docs/                 # Documentation
├── raycast/              # Raycast integrations
│   └── script-commands/  # Raycast script commands
├── .gitconfig            # Git user settings and aliases
├── git-worktree.zsh      # Git worktree management utilities
├── peco.zsh              # Interactive filtering for history and directory navigation
├── resolve-issue.zsh     # GitHub Issue resolver shell integration
├── setup.sh              # Linux/WSL environment setup
├── setup-mac.sh          # macOS environment setup (with Oh My Zsh)
└── vscode-extensions.zsh # Auto-install VS Code extensions on first run
```

- Setup scripts are idempotent and safe to run multiple times
- Biome is the default formatter for JavaScript/TypeScript
- Devcontainers include GitHub CLI and Asia/Tokyo timezone

## Core Principles

- Correspond to the current codebase, data, and terminology over theory or general practices; always review thoroughly
- Choose simple over easy; prefer clarity over cleverness
- Avoid adding new dependencies unless necessary; remove when possible
- Write comments that explain Why, not What
- Use descriptive variable and function names
- Remove unused code and arguments immediately
- Follow Conventional Commits for commit messages unless otherwise instructed

## Language Policy

- Follow the user's language by default
- The following files must always be written in English:
  - CLAUDE.md, AGENTS.md
  - Files under .claude/
  - Files under docs/agents/
