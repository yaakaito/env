---
name: agents-md
description: Create, edit, or review AGENTS.md and CLAUDE.md repository instructions. Use for agent instruction setup and structure advice, not ordinary code changes that merely read those files.
---

# Agents MD

Write repository instructions that help an agent make decisions it cannot reliably infer from the code, tooling, or existing documentation.

## Scope and Format

Use the filename, location, and format the user requested. For an edit, keep the existing format and structure unless the requested improvement calls for changing them. Do not ask the user to choose again.

For a new document with no specified format, inspect the repository's existing instruction files and target tools. Ask only if the intended tool or scope remains ambiguous and would change the result. Read the relevant format reference when selecting a format or changing loading, imports, or nested instructions:

- [AGENTS.md](references/agents-md-spec.md): Markdown conventions and directory scope.
- [CLAUDE.md](references/claude-md-features.md): Claude Code loading and imports.

Review-only requests produce findings; creation and editing requests produce the requested file changes. Do not rename files or change other tools' configuration as an incidental part of an edit.

## Content

Inspect applicable parent and nested instructions, relevant project documentation, package manifests, scripts, and CI configuration. Use them to establish actual commands, scope, and conventions; do not invent missing project policies.

Keep existing requirements unless they are obsolete, contradictory, or within the requested policy change. Preserve concrete safety boundaries and fragile-operation constraints when shortening prose. If evidence cannot resolve a material conflict, identify it rather than silently choosing a new policy.

Choose sections for the repository's needs. Useful content may include non-obvious architecture, commands and prerequisites, testing contracts, compatibility requirements, and links to task-specific documentation. A small edit does not require a full document rewrite or a directory tree.

Do not impose template defaults for compatibility, dependencies, test strategy, commit format, or language. Record the project's decisions. Avoid duplicating rules already enforced by tooling unless agents need instructions for running that tooling or handling exceptions.

For a new document, [assets/template.md](assets/template.md) provides optional headings. Replace placeholders with verified information and omit unused sections. For a broader structure review, read [references/best-practices.md](references/best-practices.md).

## Completion

Check changed commands against their definitions and working directories, verify referenced paths, and review applicable instructions for contradictions. Run commands when safe and useful to validate a changed instruction; document any unverified behavior without claiming it was tested.

Confirm that the result fits the requested scope, retains necessary constraints, and does not add unrelated policy. Report the changes and any unresolved ambiguity.
