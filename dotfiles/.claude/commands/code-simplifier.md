---
description: Simplify and refactor code while ensuring tests pass
allowed-tools: Task(code-simplifier:code-simplifier)
---

Simplify and refactor code using the code-simplifier subagent, then verify behavior is unchanged by running tests.

## Instructions

1. Use the `code-simplifier:code-simplifier` subagent to perform the refactoring
   - Focus on clarity, consistency, and maintainability
   - Preserve all existing functionality
2. After refactoring, run the project's test suite to verify behavior is unchanged
3. If tests fail, investigate and fix any regressions introduced by the refactoring
4. Report the changes made and test results

## Additional Context

$ARGUMENTS
