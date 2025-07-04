Create a commit that includes **all conversation** between the user and yourself up to this point, following Conventional Commits format:

```
<type>[optional scope]: <description> [#issue_number]

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
- Issue reference: Add `#issue_number` when working on a specific GitHub issue
- Separate conversation exchanges with ----
