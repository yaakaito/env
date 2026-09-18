# Reviewing Agent Instructions

Use this reference for a broad structure or content review. A targeted command or wording fix rarely needs it.

## Choose What Belongs Here

Keep information that changes an agent's decisions in this repository: an unexpected build prerequisite, an architectural boundary, a compatibility contract, or a required check that is easy to miss. Remove generic advice and facts agents can readily derive when they need them.

A concise document is a result of selecting useful instructions, not meeting a line or instruction count. Do not remove a necessary operational constraint to reach a size target.

## Preserve Project Decisions

For each proposed rule, identify its source: an explicit user decision, an existing applicable instruction, or repository evidence. Distinguish established policy from an inferred convention. Do not turn one example into a universal requirement.

When editing, compare against parent and nested instructions. Preserve the scope and exceptions of existing rules. Resolve stale or contradictory guidance only with evidence or the user's direction.

## Keep Detail Near Its Use

Link to existing documentation instead of copying code, schemas, or full procedures. Explain when an agent should read each linked document. Prefer stable file paths and named sections over line numbers that drift after edits.

Move substantial task-specific guidance into a relevant existing document or scoped instruction file when that improves discovery. Small documents do not need splitting. Verify the target tool's loading behavior before treating a link or import as deferred reading.

For example, a database guide can be linked with “Before changing migrations, read `docs/database.md`.” Use the actual repository path, not this example verbatim.

## Check the Result

- Commands exist, include required working directories or prerequisites, and match the project's tooling.
- References resolve and describe when their contents are needed.
- Templates leave no placeholder policies or invented directories.
- Required checks, compatibility contracts, and authorization boundaries retain their meaning.
- A narrow request stays narrow; structural changes have a reason tied to the request.
