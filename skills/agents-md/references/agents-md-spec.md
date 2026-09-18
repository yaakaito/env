# AGENTS.md Format and Scope

AGENTS.md is plain Markdown for coding-agent instructions. It has no required sections or fields. Choose content for the repository rather than copying a standard outline.

Place repository-wide guidance at the root and directory-specific guidance near the affected code when the target agent supports nested files. The format's guidance gives the closest AGENTS.md precedence for the files in its scope. Check the target tool's documentation for its discovery and merging behavior before changing instruction placement.

A Markdown link points readers to another document; it does not define automatic import behavior. Do not assume CLAUDE.md's `@path` imports work in AGENTS.md.

## Migration

When migration is requested, check which tools consume the existing file before renaming it. Preserve its instructions and scope, and replace tool-specific syntax deliberately. If both formats remain necessary, choose a supported way to share content rather than maintaining conflicting copies. Consult the CLAUDE.md reference when that tool is involved.

Source: [AGENTS.md specification and FAQ](https://agents.md/).
