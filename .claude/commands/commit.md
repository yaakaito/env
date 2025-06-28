Create a commit that includes **all conversation** between the user and yourself up to this point, following Conventional Commits format:

```
<type>[optional scope]: <description>

[optional body]

prompt: <user's input prompt>
----
<your response>
----
prompt: <user's input prompt>
----
<your response>

[optional footer(s)]
```

- Breaking changes: Use ! after type/scope or add BREAKING CHANGE: footer
- Common types: feat, fix, docs, style, refactor, test, chore, ci, build, perf
- Scope examples: (api), (ui), (auth), (parser)
- Description: Present tense, lowercase, under 50 chars, no period
- Separate conversation exchanges with ----

## Issue Reference

When working on a specific issue, include the issue number in the description using `#{issue_number}` format:

```
feat: implement user authentication #1234
```

This should be added when Claude recognizes that the changes are specifically resolving or working on a particular GitHub issue.
