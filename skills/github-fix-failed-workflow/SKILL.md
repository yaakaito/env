---
name: github-fix-failed-workflow
description: Diagnose and fix failed GitHub Actions workflow runs, and write or edit workflow files following clear, minimal conventions. Use when workflows fail, CI/CD issues occur, debugging GitHub Actions runs, or when creating or editing .github/workflows/*.yml files. Triggers on "fix workflow", "why did the build fail", "check CI status", "workflow failed", "create a workflow", "add GitHub Actions", or "set up CI".
---

# Fix Failed GitHub Workflow

Diagnose GitHub Actions workflow failures, apply fixes, and verify them. When a fix involves creating or editing workflow files, follow the Workflow File Guidelines below.

## Fix Workflow

1. **Identify failed runs**: Use `gh run list` with `--branch` or `--workflow` flag
2. **Analyze logs**: Use `gh run view <run_id> --log-failed` to view error details
3. **Diagnose issues**: Identify root cause from log output
4. **Fix issues**: Apply necessary fixes to workflow files or source code
5. **Verify**: Confirm the fix with a new run (see Verify the Fix)

### By Branch (Current Branch)

Find and fix failed workflows on the current branch:

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# List runs on this branch
gh run list --branch "$BRANCH"

# View failed run logs
gh run view <run_id> --log-failed
```

### By Workflow File

Find and fix failed workflows for a specific workflow file:

```bash
# List runs for a workflow file
gh run list --workflow=<workflow_file>

# View failed run logs
gh run view <run_id> --log-failed
```

### Verify the Fix

- If the failure looks transient (network flake, runner outage), re-run without changes: `gh run rerun <run_id> --failed`
- If the fix changed files, a new run starts after the changes are pushed; watch it with `gh run watch <run_id>` or check `gh run list --branch "$BRANCH"`
- If the run fails again, return to log analysis instead of retrying blindly

## Common Issues

- **Dependency failures**: Check package versions and lock files
- **Test failures**: Review test output and fix failing tests
- **Build errors**: Check syntax errors and type issues
- **Permission errors**: Verify workflow permissions and secrets
- **Timeout issues**: Optimize long-running steps or increase timeout

## Workflow File Guidelines

Write clear, minimal GitHub Actions workflow files.

### Naming Guidelines

#### Do NOT name

- `run` steps that are self-explanatory from the command itself
- `uses` steps for common, obvious actions like:
  - `actions/checkout`
  - `actions/setup-node`
  - `oven-sh/setup-bun`
  - `pnpm/action-setup`
  - `actions/cache`

#### DO name

- `uses` steps with `actions/github-script` (explain what the script does)
- Complex multi-line shell scripts (summarize the purpose)
- Steps where the intent is not obvious from the code

### Examples

#### Good

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: oven-sh/setup-bun@v2
      - run: bun install
      - run: bun run build
      - run: bun test

      - name: Post build status to Slack
        uses: actions/github-script@v7
        with:
          script: |
            const webhook = process.env.SLACK_WEBHOOK;
            // ... complex logic
```

#### Bad

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
      - name: Install dependencies
        run: bun install
      - name: Build project
        run: bun run build
      - name: Run tests
        run: bun test
```

### Best Practices

- Pin action versions with full SHA or major version tag (`@v4`, not `@main`)
- Use `workflow_dispatch` for manual triggers when useful
- Set appropriate `permissions` to follow least privilege
- Use `concurrency` to cancel redundant runs
- Prefer `${{ github.token }}` over PAT when possible
- Avoid emoji in workflow names and step names
- Use `$GITHUB_STEP_SUMMARY` to output execution results in Markdown format
- Avoid obvious comments; only add comments to explain complex logic

### Step Summary Example

```yaml
- name: Report test results
  run: |
    echo "## Test Results" >> $GITHUB_STEP_SUMMARY
    echo "| Suite | Passed | Failed |" >> $GITHUB_STEP_SUMMARY
    echo "|-------|--------|--------|" >> $GITHUB_STEP_SUMMARY
    echo "| Unit  | 42     | 0      |" >> $GITHUB_STEP_SUMMARY
```
