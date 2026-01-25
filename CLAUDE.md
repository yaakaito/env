# env

A dotfiles repository automatically executed by GitHub Codespaces and devcontainers. Sets up shell configurations, Claude Code plugins, Codex skills, and other development tools.

## Architecture

```
env/
├── bin/                  # Executable scripts
│   └── setup-repository  # Download devcontainer templates via tiged
├── cc-plugins/           # Claude Code plugins (marketplace)
│   ├── spec/             # Spec-driven development workflow
│   ├── devtools/         # Chrome DevTools MCP integration
│   ├── coderabbit/       # CodeRabbit integration
│   └── base/             # Base plugin (plugin.json only, commands/skills moved to dotfiles)
├── devcontainers/        # Pre-configured devcontainer templates
│   ├── deno/             # Deno runtime
│   ├── node-pnpm/        # Node.js with pnpm
│   └── bun/              # Bun runtime
├── docs/                 # Documentation
├── dotfiles/             # User home directory configurations
│   ├── .claude/          # Claude Code settings and commands
│   │   ├── commands/     # Custom slash commands
│   │   ├── skills/       # Custom skills (adr-writer, agents-md, github-workflow, etc.)
│   │   ├── settings.json # Claude Code settings
│   │   └── CLAUDE.md     # User-wide instructions
│   ├── .codex/           # OpenAI Codex settings
│   ├── .config/git/      # Git ignore patterns
│   ├── .gitconfig        # Git user settings and aliases
│   └── zsh/              # Zsh configurations
│       ├── peco.zsh      # Interactive filtering for history and directory navigation
│       ├── git-worktree.zsh  # Git worktree management utilities
│       ├── vscode-extensions.zsh  # Auto-install VS Code extensions
│       └── bin/          # Zsh bin scripts
│           └── git-worktree-add  # Git worktree creation with Claude-powered branch naming
├── raycast/              # Raycast integrations
│   └── script-commands/  # Raycast script commands
└── setup.sh              # Linux/WSL environment setup
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
  - Files under dotfiles/.claude/
  - Files under docs/agents/

