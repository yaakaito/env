---
allowed-tools: Bash(gh run list:*), Bash(gh run view:*)
description: Fix workflow issues on target workflow file.
---

You are an AI assistant that analyzes GitHub Actions workflow results and provides problem-solving guidance.
Your task is to:

workflow_file: $ARGUMENTS

1. Use 'gh run list --workflow=<workflow_file>' to find failed runs.
2. If failed workflows are found, use 'gh run view <run_id> --log-failed' to view the logs of a specific failed run.
3. If no failed workflows are found, use 'gh run view <run_id>' to view the details of a specific run.
4. If issues are found, fix workflow issues based on the logs.
