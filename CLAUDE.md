# env

Dotfiles and development environment setup for GitHub Codespaces and devcontainers.

## Find the relevant configuration

Read the files needed for the requested change; these are entry points, not a required reading list.

- Provisioning: `setup.yaml` defines what is installed or copied; `setup.sh` interprets it.
  Add or remove targets in the manifest. Its header documents the supported YAML subset.
- Home directory settings: edit sources in `dotfiles/`; `setup.yaml` defines their destinations.
  User-wide agent instructions live in `dotfiles/.claude/CLAUDE.md` and
  `dotfiles/.codex/AGENTS.md`.
- Agent skills: `skills/<name>/SKILL.md`; load supporting references only for the relevant workflow.
- Claude Code plugins: `.claude-plugin/marketplace.json` and `cc-plugins/`.
- New repository setup: `bin/setup-repository`, `devcontainers/`, and `repository-template/`.
- Shell utilities: `dotfiles/zsh/`; Raycast commands: `raycast/script-commands/`.
- Usage and formatting commands: `README.md`; devcontainer details: `devcontainers/README.md`.

## Setup and skill contracts

- Keep setup operations idempotent so repeated runs remain safe.
- For provisioning changes, `./setup.sh --check` validates manifest entries against repository
  paths without provisioning the terminal. It does not test installation or runtime behavior.
  A full `./setup.sh` provisions the machine; use `--check` for manifest validation.
- Devcontainers include GitHub CLI and use the Asia/Tokyo timezone.
- Each skill directory name must match its SKILL.md frontmatter `name`.
  `allowed-tools`, when present, must be a comma-separated string, not a YAML list.
- `setup.sh` installs local skills from `./skills` with `gh skill install --from-local`.
  Keep this discovery root: using the repository root also discovers plugin skills under `cc-plugins/`.
- Before publishing skills, validate with `gh skill publish --dry-run`.
  Installation examples are in `README.md`.

## Working principles

- Use the current codebase, data, and terminology to decide and review changes.
- Prefer simple, clear code over cleverness; add dependencies only when necessary and remove unused ones.
- Use descriptive variable and function names; remove code and arguments made unused by the change.
- Code explains how, tests explain what, commits explain why, and comments explain why not.
- Follow Conventional Commits unless otherwise instructed.
- Finish the requested change and its relevant validation, fixing failures caused by the change.
  Report what was verified and what remains unverified; a manifest check alone is not a setup test.

## Language policy

- Follow the user's language for comments, commits, and tests.
- Write CLAUDE.md, AGENTS.md, files under `dotfiles/.claude/`, and files under `docs/agents/`
  in English.
- Under `skills/`, keep SKILL.md frontmatter `name` in English and follow each skill's existing
  body language.
