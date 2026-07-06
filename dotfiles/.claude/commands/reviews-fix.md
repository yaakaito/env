---
allowed-tools: Bash(gh pr view:*), Bash(gh repo view:*), Bash(gh api graphql:*)
description: Fetch and apply fixes based on GitHub PR comments.
---

Fetch unresolved review comments for the current branch's PR, then apply fixes based on those comments.

## Steps

1. **Fetch unresolved comments:**

   ```bash
   OWNER=$(gh repo view --json owner -q '.owner.login')
   REPO=$(gh repo view --json name -q '.name')
   PR_NUMBER=$(gh pr view --json number -q '.number')

   gh api graphql -f query='
   query($owner: String!, $repo: String!, $number: Int!) {
       repository(owner: $owner, name: $repo) {
           pullRequest(number: $number) {
               reviewThreads(first: 100) {
                   pageInfo { hasNextPage endCursor }
                   nodes {
                       id
                       isResolved
                       isOutdated
                       path
                       line
                       comments(first: 100) {
                           pageInfo { hasNextPage endCursor }
                           nodes {
                               author { login }
                               body
                           }
                       }
                   }
               }
           }
       }
   }' -f owner="$OWNER" -f repo="$REPO" -F number="$PR_NUMBER" \
   | jq '{more_threads: .data.repository.pullRequest.reviewThreads.pageInfo,
       threads: [.data.repository.pullRequest.reviewThreads.nodes[]
       | select(.isResolved == false and .isOutdated == false)
       | {id, path, line, more_comments: .comments.pageInfo,
          comments: [.comments.nodes[] | {author: .author.login, body}]}]}'
   ```

   Each entry in `threads` is one unresolved review thread. Read all comments in a thread — replies may narrow, change, or withdraw the original request. Both levels are capped at 100, so before acting check the pagination flags:
   - If `more_threads.hasNextPage` is true, re-run the query with `reviewThreads(first: 100, after: <more_threads.endCursor>)`
   - If a thread's `more_comments.hasNextPage` is true, fetch its remaining comments with `node(id: "<thread id>") { ... on PullRequestReviewThread { comments(first: 100, after: <more_comments.endCursor>) { nodes { author { login } body } } } }`

2. **Analyze and apply fixes:**
   - For each thread, read the file at `path`
   - Identify the section around `line` that needs modification
   - Apply the fix based on the thread's comments
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
