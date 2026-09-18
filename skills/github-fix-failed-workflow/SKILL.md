---
name: github-fix-failed-workflow
description: Fix failed GitHub Actions runs through diagnosis, implementation, and verification, or create and edit .github/workflows/*.yml and *.yaml files. Use for GitHub Actions repair requests, not routine CI status checks.
---

# Fix GitHub Actions Workflows

Explicit invocation of this skill or a request to fix a GitHub Actions failure calls for diagnosis, an actual fix, and verification. Continue until the failure is resolved and verified, or a concrete blocker prevents progress. Do not stop at findings or ask whether to apply the fix. Stop after diagnosis only when the user explicitly limits the task to investigation or prohibits changes.

Carry forward authorization already established in the conversation, including pushing changes and remote validation. Do not ask again for ordinary steps covered by that authorization. If missing access, a destructive operation, or an action outside the task blocks progress, identify the specific blocker and complete the remaining work that can proceed.

Read [Workflow File Guidelines](references/workflow-files.md) when creating or editing workflow YAML. Source-only fixes and investigation-only tasks do not need that reference.

## Inspect a Run

Select the repository, branch or PR, and workflow from the request and repository context. Do not substitute the latest repository-wide failure for the requested run. Useful commands:

```bash
gh run list --branch <branch> --workflow <workflow_file> --json databaseId,headSha,status,conclusion,url
gh run view <run_id> --json headSha,headBranch,workflowName,event,attempt,status,conclusion,url
gh run view <run_id> --log-failed
```

Use only the filters needed to identify the target. Inspect the relevant job details when failed-step logs are absent or insufficient. Read source, dependency files, and workflow configuration implicated by the failure; distinguish the observed error from a suspected cause.

When the user explicitly requests investigation only, report the run URL, revision, result, and evidence for the diagnosis. Identify missing logs or access when they prevent a conclusion.

## Repair and Verify

Apply the fix to the workflow or source responsible for the failure, run the relevant local checks, and verify the result in GitHub Actions. A proposed patch or a diagnosis alone does not complete a repair request.

- For a transient failure supported by the logs, rerun the failed jobs with `gh run rerun <run_id> --failed`. A repeated failure calls for renewed diagnosis, not repeated retries without new evidence.
- After a code change, an old run's rerun still tests the old revision. Push the fix and use the workflow's configured trigger to obtain a run for that revision; a push does not always trigger it. Do not add a trigger merely to verify a change.
- Match the new run's workflow, event, and `headSha` to the revision being verified. Use `gh run list --commit <sha>` where applicable, and `gh run watch <run_id> --exit-status` to await the selected run. For PR events, account for a tested merge revision and identify its relationship to the PR head.
- If the new run fails, inspect its logs, apply the next fix, and verify again. Continue until the targeted failure is resolved or a concrete blocker prevents further work; do not repeatedly rerun without new evidence. Do not call the fix verified from an older successful run, a pending run, or local checks alone.

Report the cause, applied change, local checks, and confirming run URL with its tested revision and conclusion. If a blocker prevents remote verification, state what remains unverified and the exact action or access needed to finish.
