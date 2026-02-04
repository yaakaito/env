Create a specification document from the current context.

## Arguments

- `$ARGUMENTS`: Target directory (optional)

Examples:

- `/spec:create-md` → Auto-detect directory
- `/spec:create-md docs/specs` → Use specified directory

## Pre-check

### 1. Determine Target Directory

If `$ARGUMENTS` specifies a directory, use it.

Otherwise, search in order:

1. `specs/`
2. `.specs/`
3. `docs/specs/`
4. `.dev-plans/`

If none found, ask user which directory to create.

### 2. Check Existing Specs

List existing specs in target directory to avoid duplicates.

### 3. Review Context

Review conversation context and decisions made.

## File Management

Follow the naming convention from `spec-file-manager` skill:

```
{directory}/YYYY-MM-DD-{slug}.md
```

- Date: Today's date in ISO format
- Slug: Kebab-case, English only, max 20 characters

## Document Format

```md
# ${title}

Brief description of the feature or change.

## Purpose

Why this feature is needed and what problem it solves.

## Target Users

Who will use this feature.

## ${section_title}

Describe the specific aspect of the feature.

### Requirements

- [Must] ...
- [Should] ...

### Targets

- `${filename}` - ${note}

### References

- `${filename}` - ${note}

## Tech Stack

Technologies to be used.

## Open Questions

- Undecided items that need further discussion
- Items to be resolved in Plan mode
```

## Post-creation

After creating the specification:

1. Confirm the file location
2. Suggest next step: **Plan mode** for task breakdown and implementation
