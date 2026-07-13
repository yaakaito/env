#!/usr/bin/env bash
# PreToolUse hook: block Bash access to AWS credentials under ~/.aws.
#
# Why: settings.json sets "respectGitignore": false and allows broad Bash
# patterns (cat/grep/head/...). The permissions.deny "Read(~/.aws/**)" rule only
# covers the Read tool, so `cat ~/.aws/credentials` via Bash would still leak
# credentials without a prompt. This hook inspects the command and denies
# references to a .aws path.
#
# Scope: best-effort defense-in-depth, not a hard boundary. A regex cannot fully
# resolve shell expansion (globs such as ~/.a*/credentials, variable indirection
# via another expansion). For a hard guarantee, run Bash in an OS sandbox or
# narrow the broad allow rules in settings.json. To stay on the safe side, the
# hook fails closed whenever it cannot decode the input.
set -euo pipefail

input="$(cat)"

# jq is required: without reliable JSON decoding we would have to scan the raw,
# still-escaped payload and could miss encoded forms, so fail closed instead.
if ! command -v jq >/dev/null 2>&1; then
  echo "Blocked: jq is required to inspect Bash commands for AWS credential access." >&2
  exit 2
fi

tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null)" || {
  echo "Blocked: could not parse tool input as JSON." >&2
  exit 2
}
[ "$tool_name" = "Bash" ] || exit 0

command_str="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)" || {
  echo "Blocked: could not parse Bash command." >&2
  exit 2
}

# Collapse backslash escapes (e.g. .aws\/credentials, \~) so escape-based
# evasions reduce to their literal form before matching.
normalized="${command_str//\\/}"

# Match a .aws path segment followed by a separator (path, whitespace, quote,
# command chaining, redirection) or the end of the line, in either the raw or
# normalized command. Single quotes keep $ as a real end-of-line anchor.
if printf '%s\n%s' "$command_str" "$normalized" \
  | grep -Eq '\.aws(/|[[:space:]]|["'\'';&|()<>]|$)'; then
  echo "Blocked: access to AWS credentials under .aws is not permitted." >&2
  exit 2
fi

exit 0
