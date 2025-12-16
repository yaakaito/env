#!/bin/zsh

sudo apt update
# sudo apt install -y chromium

npm install -g @anthropic-ai/claude-code
npx playwright install --with-deps chromium
