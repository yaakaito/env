# Workflow File Guidelines

Use these conventions when creating or editing GitHub Actions workflow YAML.

## Step Names

Omit names for self-explanatory `run` commands and common `uses` steps such as `actions/checkout`, `actions/setup-node`, `oven-sh/setup-bun`, `pnpm/action-setup`, and `actions/cache`.

Name `actions/github-script` steps, complex multi-line shell scripts, and steps whose intent is not obvious from their code. Describe their purpose.

## Workflow Conventions

- Pin action references to a full commit SHA or major version tag, never a moving branch such as `@main`.
- Set least-privilege `permissions` and prefer `${{ github.token }}` over a PAT when possible.
- Add `workflow_dispatch` when manual execution is useful.
- Use `concurrency` to cancel redundant runs when cancellation is appropriate for the job.
- Avoid emoji in workflow and step names.
- Use `$GITHUB_STEP_SUMMARY` for Markdown execution results, populated from actual results rather than illustrative counts.
- Omit obvious comments; use comments to explain non-obvious constraints or rejected alternatives.
