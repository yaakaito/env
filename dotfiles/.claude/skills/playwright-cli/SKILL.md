---
name: playwright-cli
description: Automates browser interactions for web testing, form filling, screenshots, and data extraction. Use when the user needs to navigate websites, interact with web pages, fill forms, take screenshots, test web applications, or extract information from web pages.
allowed-tools: Bash(playwright-cli:*)
---

# Browser Automation with playwright-cli

## Quick start

```bash
# open new browser
playwright-cli --browser chromium open
# navigate to a page
playwright-cli --browser chromium goto https://playwright.dev
# interact with the page using refs from the snapshot
playwright-cli --browser chromium click e15
playwright-cli --browser chromium type "page.click"
playwright-cli --browser chromium press Enter
# take a screenshot (rarely used, as snapshot is more common)
playwright-cli --browser chromium screenshot
# close the browser
playwright-cli --browser chromium close
```

## Commands

### Core

```bash
playwright-cli --browser chromium open
# open and navigate right away
playwright-cli --browser chromium open https://example.com/
playwright-cli --browser chromium goto https://playwright.dev
playwright-cli --browser chromium type "search query"
playwright-cli --browser chromium click e3
playwright-cli --browser chromium dblclick e7
playwright-cli --browser chromium fill e5 "user@example.com"
playwright-cli --browser chromium drag e2 e8
playwright-cli --browser chromium hover e4
playwright-cli --browser chromium select e9 "option-value"
playwright-cli --browser chromium upload ./document.pdf
playwright-cli --browser chromium check e12
playwright-cli --browser chromium uncheck e12
playwright-cli --browser chromium snapshot
playwright-cli --browser chromium snapshot --filename=after-click.yaml
playwright-cli --browser chromium eval "document.title"
playwright-cli --browser chromium eval "el => el.textContent" e5
playwright-cli --browser chromium dialog-accept
playwright-cli --browser chromium dialog-accept "confirmation text"
playwright-cli --browser chromium dialog-dismiss
playwright-cli --browser chromium resize 1920 1080
playwright-cli --browser chromium close
```

### Navigation

```bash
playwright-cli --browser chromium go-back
playwright-cli --browser chromium go-forward
playwright-cli --browser chromium reload
```

### Keyboard

```bash
playwright-cli --browser chromium press Enter
playwright-cli --browser chromium press ArrowDown
playwright-cli --browser chromium keydown Shift
playwright-cli --browser chromium keyup Shift
```

### Mouse

```bash
playwright-cli --browser chromium mousemove 150 300
playwright-cli --browser chromium mousedown
playwright-cli --browser chromium mousedown right
playwright-cli --browser chromium mouseup
playwright-cli --browser chromium mouseup right
playwright-cli --browser chromium mousewheel 0 100
```

### Save as

```bash
playwright-cli --browser chromium screenshot
playwright-cli --browser chromium screenshot e5
playwright-cli --browser chromium screenshot --filename=page.png
playwright-cli --browser chromium pdf --filename=page.pdf
```

### Tabs

```bash
playwright-cli --browser chromium tab-list
playwright-cli --browser chromium tab-new
playwright-cli --browser chromium tab-new https://example.com/page
playwright-cli --browser chromium tab-close
playwright-cli --browser chromium tab-close 2
playwright-cli --browser chromium tab-select 0
```

### Storage

```bash
playwright-cli --browser chromium state-save
playwright-cli --browser chromium state-save auth.json
playwright-cli --browser chromium state-load auth.json

# Cookies
playwright-cli --browser chromium cookie-list
playwright-cli --browser chromium cookie-list --domain=example.com
playwright-cli --browser chromium cookie-get session_id
playwright-cli --browser chromium cookie-set session_id abc123
playwright-cli --browser chromium cookie-set session_id abc123 --domain=example.com --httpOnly --secure
playwright-cli --browser chromium cookie-delete session_id
playwright-cli --browser chromium cookie-clear

# LocalStorage
playwright-cli --browser chromium localstorage-list
playwright-cli --browser chromium localstorage-get theme
playwright-cli --browser chromium localstorage-set theme dark
playwright-cli --browser chromium localstorage-delete theme
playwright-cli --browser chromium localstorage-clear

# SessionStorage
playwright-cli --browser chromium sessionstorage-list
playwright-cli --browser chromium sessionstorage-get step
playwright-cli --browser chromium sessionstorage-set step 3
playwright-cli --browser chromium sessionstorage-delete step
playwright-cli --browser chromium sessionstorage-clear
```

### Network

```bash
playwright-cli --browser chromium route "**/*.jpg" --status=404
playwright-cli --browser chromium route "https://api.example.com/**" --body='{"mock": true}'
playwright-cli --browser chromium route-list
playwright-cli --browser chromium unroute "**/*.jpg"
playwright-cli --browser chromium unroute
```

### DevTools

```bash
playwright-cli --browser chromium console
playwright-cli --browser chromium console warning
playwright-cli --browser chromium network
playwright-cli --browser chromium run-code "async page => await page.context().grantPermissions(['geolocation'])"
playwright-cli --browser chromium tracing-start
playwright-cli --browser chromium tracing-stop
playwright-cli --browser chromium video-start
playwright-cli --browser chromium video-stop video.webm
```

## Open parameters
```bash
# Use specific browser when creating session
playwright-cli --browser chromium open --browser=chrome
playwright-cli --browser chromium open --browser=firefox
playwright-cli --browser chromium open --browser=webkit
playwright-cli --browser chromium open --browser=msedge
# Connect to browser via extension
playwright-cli --browser chromium open --extension

# Use persistent profile (by default profile is in-memory)
playwright-cli --browser chromium open --persistent
# Use persistent profile with custom directory
playwright-cli --browser chromium open --profile=/path/to/profile

# Start with config file
playwright-cli --browser chromium open --config=my-config.json

# Close the browser
playwright-cli --browser chromium close
# Delete user data for the default session
playwright-cli --browser chromium delete-data
```

## Snapshots

After each command, playwright-cli provides a snapshot of the current browser state.

```bash
> playwright-cli --browser chromium goto https://example.com
### Page
- Page URL: https://example.com/
- Page Title: Example Domain
### Snapshot
[Snapshot](.playwright-cli/page-2026-02-14T19-22-42-679Z.yml)
```

You can also take a snapshot on demand using `playwright-cli --browser chromium snapshot` command.

If `--filename` is not provided, a new snapshot file is created with a timestamp. Default to automatic file naming, use `--filename=` when artifact is a part of the workflow result.

## Browser Sessions

```bash
# create new browser session named "mysession" with persistent profile
playwright-cli --browser chromium -s=mysession open example.com --persistent
# same with manually specified profile directory (use when requested explicitly)
playwright-cli --browser chromium -s=mysession open example.com --profile=/path/to/profile
playwright-cli --browser chromium -s=mysession click e6
playwright-cli --browser chromium -s=mysession close  # stop a named browser
playwright-cli --browser chromium -s=mysession delete-data  # delete user data for persistent session

playwright-cli --browser chromium list
# Close all browsers
playwright-cli --browser chromium close-all
# Forcefully kill all browser processes
playwright-cli --browser chromium kill-all
```

## Local installation

In some cases user might want to install playwright-cli locally. If running globally available `playwright-cli` binary fails, use `npx playwright-cli` to run the commands. For example:

```bash
npx playwright-cli --browser chromium open https://example.com
npx playwright-cli --browser chromium click e1
```

## Example: Form submission

```bash
playwright-cli --browser chromium open https://example.com/form
playwright-cli --browser chromium snapshot

playwright-cli --browser chromium fill e1 "user@example.com"
playwright-cli --browser chromium fill e2 "password123"
playwright-cli --browser chromium click e3
playwright-cli --browser chromium snapshot
playwright-cli --browser chromium close
```

## Example: Multi-tab workflow

```bash
playwright-cli --browser chromium open https://example.com
playwright-cli --browser chromium tab-new https://example.com/other
playwright-cli --browser chromium tab-list
playwright-cli --browser chromium tab-select 0
playwright-cli --browser chromium snapshot
playwright-cli --browser chromium close
```

## Example: Debugging with DevTools

```bash
playwright-cli --browser chromium open https://example.com
playwright-cli --browser chromium click e4
playwright-cli --browser chromium fill e7 "test"
playwright-cli --browser chromium console
playwright-cli --browser chromium network
playwright-cli --browser chromium close
```

```bash
playwright-cli --browser chromium open https://example.com
playwright-cli --browser chromium tracing-start
playwright-cli --browser chromium click e4
playwright-cli --browser chromium fill e7 "test"
playwright-cli --browser chromium tracing-stop
playwright-cli --browser chromium close
```

## Specific tasks

* **Request mocking** [references/request-mocking.md](references/request-mocking.md)
* **Running Playwright code** [references/running-code.md](references/running-code.md)
* **Browser session management** [references/session-management.md](references/session-management.md)
* **Storage state (cookies, localStorage)** [references/storage-state.md](references/storage-state.md)
* **Test generation** [references/test-generation.md](references/test-generation.md)
* **Tracing** [references/tracing.md](references/tracing.md)
* **Video recording** [references/video-recording.md](references/video-recording.md)
