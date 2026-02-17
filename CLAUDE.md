# env

A dotfiles repository automatically executed by GitHub Codespaces and devcontainers. Sets up shell configurations, Claude Code plugins, Codex skills, and other development tools.

## Architecture

```
env/
├── .claude-plugin/       # Plugin marketplace configuration
│   └── marketplace.json  # Defines plugins available via `claude plugin marketplace add`
├── bin/                  # Executable scripts
│   └── setup-repository  # Download devcontainer templates via tiged
├── cc-plugins/           # Claude Code plugins (marketplace)
│   ├── spec/             # Spec-driven development workflow
│   ├── devtools/         # Chrome DevTools MCP integration
│   └── coderabbit/       # CodeRabbit integration
├── devcontainers/        # Pre-configured devcontainer templates
│   ├── deno/             # Deno runtime
│   ├── node-pnpm/        # Node.js with pnpm
│   └── bun/              # Bun runtime
├── docs/                 # Documentation
├── dotfiles/             # User home directory configurations
│   ├── .claude/          # Claude Code settings and commands
│   │   ├── commands/     # Slash commands (reviews-fix, workflow-fix, worktree-add, etc.)
│   │   ├── skills/       # Skills (adr-writer, agents-md, github-workflow, github-workflow-fixer, github-pr-unresolved-review-fetcher)
│   │   ├── settings.json # Claude Code settings
│   │   ├── status-line.sh # Custom status line script
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
├── repository-template/  # Template files for new repositories (used by bin/setup-repository)
└── setup.sh              # Linux/WSL environment setup
```

- Setup scripts are idempotent and safe to run multiple times
- Biome is the default formatter for JavaScript/TypeScript
- Devcontainers include GitHub CLI and Asia/Tokyo timezone

## Claude Code Worktree Integration

Claude Code Web/Desktop uses native features for worktree management, which coexist with the custom `git-worktree-add` script.

**`.worktreeinclude`**: Located at the repository root, specifies which gitignored files to copy into new worktrees (gitignore pattern syntax). When Claude Code creates a worktree, it copies matching files automatically.

**SessionStart hook** (`dotfiles/.claude/settings.json`): Triggers on new session start to auto-install dependencies. Detection order: `bun.lockb` → `pnpm-lock.yaml` → `package-lock.json` → `deno.json`/`deno.jsonc` → `package.json` (fallback).

Workflow when Claude Code creates a worktree:

1. Claude Code creates the worktree
2. Files matching `.worktreeinclude` patterns are copied from the main worktree
3. On session start, the SessionStart hook detects the package manager and runs install

## Core Principles

- Correspond to the current codebase, data, and terminology over theory or general practices; always review thoroughly
- Choose simple over easy; prefer clarity over cleverness
- Avoid adding new dependencies unless necessary; remove when possible
- Write comments that explain Why, not What
- Use descriptive variable and function names
- Remove unused code and arguments immediately
- Follow Conventional Commits for commit messages unless otherwise instructed

## Language Policy

- Follow the user's language for comments, commits, and tests
- The following files must always be written in English:
  - CLAUDE.md, AGENTS.md
  - Files under dotfiles/.claude/
  - Files under docs/agents/
