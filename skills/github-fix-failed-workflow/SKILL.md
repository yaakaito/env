---
name: github-fix-failed-workflow
description: Inspect or fix GitHub Actions run failures, or create and edit .github/workflows/*.yml and *.yaml files. Use for CI status or build failure requests when GitHub Actions is the CI provider.
---

# GitHub Actions Workflows

Match the work to the request. A status check or request to explain a failure calls for inspection and findings, not edits or reruns. A repair request includes implementing and verifying the fix within the user's authorized scope.

Read [Workflow File Guidelines](references/workflow-files.md) when creating or editing workflow YAML. Source-only fixes and status checks do not need that reference.

## Inspect a Run

Select the repository, branch or PR, and workflow from the request and repository context. Do not substitute the latest repository-wide failure for the requested run. Useful commands:

```bash
gh run list --branch <branch> --workflow <workflow_file> --json databaseId,headSha,status,conclusion,url
gh run view <run_id> --json headSha,headBranch,workflowName,event,attempt,status,conclusion,url
gh run view <run_id> --log-failed
```

Use only the filters needed to identify the target. Inspect the relevant job details when failed-step logs are absent or insufficient. Read source, dependency files, and workflow configuration implicated by the failure; distinguish the observed error from a suspected cause.

For inspection requests, report the run URL, revision, result, and evidence for the diagnosis. Identify missing logs or access when they prevent a conclusion.

## Repair and Verify

Apply the fix to the workflow or source responsible for the failure and run the relevant local checks. Continue through verification when authorized; do not stop at a proposed patch.

- For a transient failure supported by the logs, rerun the failed jobs with `gh run rerun <run_id> --failed` when rerunning is within scope. A repeated failure calls for renewed diagnosis, not repeated retries without new evidence.
- After a code change, an old run's rerun still tests the old revision. If pushing is authorized, use the workflow's configured trigger to obtain a run for the fix; a push does not always trigger it. Do not add a trigger merely to verify a change.
- Match the new run's workflow, event, and `headSha` to the revision being verified. Use `gh run list --commit <sha>` where applicable, and `gh run watch <run_id> --exit-status` to await the selected run. For PR events, account for a tested merge revision and identify its relationship to the PR head.
- If the new run fails, inspect its logs and continue fixing failures within scope. If verification requires unavailable access or an action outside the authorized scope, report the exact remaining step and local results. Do not call the fix verified from an older successful run, a pending run, or local checks alone.

Report the cause, change, local checks, and confirming run URL with its tested revision and conclusion. If remote verification is incomplete, state that explicitly.
