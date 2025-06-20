# resolve-issue.zsh - GitHub Issue Resolver for Claude Code
# This file provides the resolve-issue function that automates GitHub issue resolution

# Get the directory where this script is located
DIRNAME="${0:A:h}"

# GitHub Issue Resolver function
resolve-issue() {
    local script_output working_dir prompt current_dir

    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: Not in a git repository" >&2
        return 1
    fi

    # Find the script relative to this file's location
    local script_path="$DIRNAME/bin/resolve-gh-issue"

    # Check if script exists
    if [[ ! -f "$script_path" ]]; then
        echo "Error: resolve-gh-issue script not found at $script_path" >&2
        echo "Make sure you're using the dotfiles repository that includes the resolve-issue tools" >&2
        return 1
    fi

    # Store current directory for comparison
    current_dir=$(pwd)

    # Execute the script with all arguments passed through and capture output
    script_output=$("$script_path" "$@")
    if [ $? -eq 0 ]; then
        # First line is working directory, rest is prompt
        working_dir=$(echo "$script_output" | head -n1)
        prompt=$(echo "$script_output" | tail -n+2)

        # Only change directory if working_dir is different from current directory
        if [[ "$working_dir" != "$current_dir" ]]; then
            echo "Setup completed! Changing to working directory: $working_dir" >&2
            cd "$working_dir" && echo "$prompt" | claude --dangerously-skip-permissions
        else
            echo "Setup completed! Working in current directory: $working_dir" >&2
            echo "$prompt" | claude --dangerously-skip-permissions
        fi
    else
        echo "Error: Issue solver setup failed" >&2
        return 1
    fi
}

# Export the function so it's available in the shell
export -f resolve-issue 2>/dev/null || true

# Add completion for resolve-issue (basic)
if command -v compdef &> /dev/null; then
    compdef _default resolve-issue
fi

alias claude-yolo='claude --dangerously-skip-permissions'
