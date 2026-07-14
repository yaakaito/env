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
│   │   ├── commands/     # Slash commands (workflow-fix, worktree-add, etc.)
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
│       └── prompt.zsh    # Prompt without oh-my-zsh (pwd, git status, duration, clock)
├── raycast/              # Raycast integrations
│   └── script-commands/  # Raycast script commands
├── repository-template/  # Template files for new repositories (used by bin/setup-repository)
├── skills/               # Agent skills (adr-writer, codex-review, github-create-pr, dig, discuss, research, ...), one directory per skill with SKILL.md
├── setup.sh              # Linux/WSL environment setup; applies setup.yaml
└── setup.yaml            # Manifest of everything setup.sh provisions (single source of truth)
```

- `setup.yaml` is the single source of truth for what gets provisioned on a terminal; `setup.sh` only interprets it. Add or remove sync targets in `setup.yaml`, and validate with `./setup.sh --check`
- Setup scripts are idempotent and safe to run multiple times
- Biome is the default formatter for JavaScript/TypeScript
- Devcontainers include GitHub CLI and Asia/Tokyo timezone

## Skills

Skills in `skills/` follow the Agent Skills specification (`skills/*/SKILL.md`) so they can be managed with `gh skill` (https://cli.github.com/manual/gh_skill):

- Install: `gh skill install yaakaito/env <skill-name>` (or `--all`); `setup.sh` installs them from the local clone via `--from-local`
- Validate before publishing: `gh skill publish --dry-run`
- Each skill directory name must match the `name` field in its SKILL.md frontmatter, and `allowed-tools` must be a comma-separated string (not a YAML list)

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
  - SKILL.md frontmatter `name` under skills/ (body language follows each skill's existing language)
