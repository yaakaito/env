---
allowed-tools: Bash(gh pr view:*), Bash(gh repo view:*)
description: Fetch and apply fixes based on GitHub PR comments.
---

Use the github-pr-unresolved-review-fetcher skill to fetch unresolved review comments, then apply fixes based on those comments.

## Steps

1. **Fetch unresolved comments:**
   - Follow the "Auto-detect from Current Branch" section in the github-pr-unresolved-review-fetcher skill
   - Run the skill's script to get XML-formatted review comments

2. **Analyze and apply fixes:**
   - For each `<review-comment>`, read the file at `<file>` path
   - Identify the section around `<line>` that needs modification
   - Apply the fix based on the `<body>` content
   - Only apply fixes for clear, actionable comments (ignore general discussions or ambiguous feedback)

3. **Stage changes:**
   - Use `git add` to stage the modified files
   - Provide a summary of what was changed

## Output format

```
## Applied Fixes

### File: {path}
**Comment by @{author}:** {comment_body}
**Applied fix:** {description_of_change}

[Repeat for each fix]

## Summary
- Modified {N} files
- Addressed {N} review comments
- Files changed: {list_of_files}
```

## Important guidelines

- Skip comments that require human judgment or architectural decisions
- If a comment is ambiguous, skip it and note in the output
- Preserve existing code structure and style
- Do not commit changes - only stage them for review
