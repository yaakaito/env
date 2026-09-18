# CLAUDE.md Loading and Imports

Consult the [Claude Code memory documentation](https://code.claude.com/docs/en/memory) when changing loading behavior; details depend on the installed version.

## Scope

Project instructions can live in `CLAUDE.md` or `.claude/CLAUDE.md`; user instructions live in `~/.claude/CLAUDE.md`. Keep private project preferences in a gitignored `CLAUDE.local.md`.

Ancestor files load at startup; nested files load when Claude reads files in those directories. Loaded instructions are combined, so remove conflicts rather than assuming one file overrides another. `/memory` helps inspect loaded instruction files.

## Imports

`@path/to/file` imports content. Relative paths resolve from the containing file. Code spans and fenced blocks do not import. Imports load with their parent; splitting text into imports does not defer its context cost. Use ordinary links for task-specific reading. Check the current documentation before relying on recursion limits or external-file approval behavior.

Claude Code does not automatically read AGENTS.md. When supporting both tools is requested, a CLAUDE.md containing `@AGENTS.md` can share instructions, with Claude-specific guidance below it. Keep shared text free of assumptions unique to one consumer.
