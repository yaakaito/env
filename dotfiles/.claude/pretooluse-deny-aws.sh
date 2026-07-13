#!/usr/bin/env bash
# PreToolUse hook: block Bash access to AWS credentials under ~/.aws.
#
# Why: settings.json sets "respectGitignore": false and allows broad Bash
# patterns (cat/grep/head/...). The permissions.deny "Read(~/.aws/**)" rule only
# covers the Read tool, so `cat ~/.aws/credentials` via Bash would still leak
# credentials without a prompt. Bash argument rules alone are bypassable, so we
# inspect the command here and deny any reference to a .aws directory.
set -euo pipefail

input="$(cat)"

if command -v jq >/dev/null 2>&1; then
  tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"
  command_str="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
else
  # Without jq, fall back to scanning the raw payload; over-matching here only
  # errs toward blocking, which is the safe direction for a credential guard.
  tool_name="Bash"
  command_str="$input"
fi

[ "$tool_name" = "Bash" ] || exit 0

# Match a .aws path segment: ~/.aws, $HOME/.aws, ./.aws/credentials, etc.
if printf '%s' "$command_str" | grep -Eq '\.aws(/|[[:space:]]|["'\'']|$)'; then
  echo "Blocked: access to AWS credentials under .aws is not permitted." >&2
  exit 2
fi

exit 0
