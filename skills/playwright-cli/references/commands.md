# Browser Commands

Read the section for the operation you need. Check the installed CLI help when syntax differs from these examples. Element refs are examples; use refs from the current page snapshot and keep the same session on each command.

Contents: Core, Navigation, Keyboard, Mouse, Save as, Tabs, DevTools.

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
