---
name: playwright-cli
description: Use playwright-cli to interact with live web pages for browser testing, form filling, screenshots, or data extraction. Use when the task needs browser state or UI interaction; ordinary web research or editing Playwright tests alone does not require this skill.
allowed-tools: Bash(playwright-cli:*)
---

# Browser Automation with playwright-cli

Complete the requested browser interaction and verify the resulting page state or artifact. Use the user's chosen browser and session when specified.

## Observe, act, verify

1. Open the target page, or inspect the existing session and tab. Read the snapshot returned by the CLI; use `snapshot` when the current state is missing or stale.
2. Act on refs observed in that page's snapshot. After navigation, tab changes, or a changed page invalidates a ref, inspect a fresh snapshot instead of guessing another ref.
3. Check the resulting state before continuing. Completion means the requested result is observed, not merely that a click succeeded. Report the result and relevant artifact paths, or the specific blocker.

```bash
playwright-cli open https://example.com
playwright-cli snapshot
# Read the snapshot before choosing the ref and action:
playwright-cli click e3
```

`e3` is illustrative. Keep the same `-s=<name>` on commands when using a named session. Use screenshots when the task needs visual evidence; snapshots expose page structure and refs.

Snapshot output can link to a file such as `.playwright-cli/page-<timestamp>.yml`; read that file to inspect the elements. Keep automatic snapshot names unless a named artifact is part of the requested result (`snapshot --filename=after-click.yaml`).

## Sessions and command lookup

Use `playwright-cli --help` to check available commands. If the global binary is unavailable, the local fallback is `npx playwright-cli`; check its help before use. Do not guess flags when the installed version differs from an example.

Browser profiles are in memory by default. Use `--persistent` when persistence is needed, and a custom `--profile` directory only when explicitly requested. Close sessions created for the task when finished unless they are needed for continued work. Scope cleanup to those sessions; `close-all`, `kill-all`, and `delete-data` affect more than the current page and are not routine cleanup.

Read only the reference relevant to the next operation:

- [Commands](references/commands.md): element actions, navigation, keyboard/mouse, screenshots/PDFs, tabs, and console/network inspection.
- [Session management](references/session-management.md): named sessions, browser selection, extension connection, profiles, and configuration.
- [Storage state](references/storage-state.md): saving/restoring authentication, cookies, localStorage, and sessionStorage. State files containing tokens must not be committed.
- [Request mocking](references/request-mocking.md): intercepting or changing requests for a test that needs it.
- [Running Playwright code](references/running-code.md): `run-code` for operations not covered by a CLI command, including frames, downloads, and emulation.
- [Test generation](references/test-generation.md): turning observed actions into test code; generated actions still need assertions about the expected result.
- [Tracing](references/tracing.md): recording DOM, network, and console evidence for debugging.
- [Video recording](references/video-recording.md): producing a recording of the browser flow.
