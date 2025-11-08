#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Chrome for DevTools MCP
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author yaakaito
# @raycast.authorURL https://raycast.com/yaakaito

open -n -a "Google Chrome" --args --remote-debugging-port=9222 --user-data-dir=/tmp/devtools-mcp
