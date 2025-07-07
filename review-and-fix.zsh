# review-and-fix.zsh - PR Review and Fix Workflow for Claude Code
# This file provides review and fix functions that automate PR review and correction

# Get the directory where this script is located
DIRNAME="${0:A:h}"

# PR Review function
claude-review() {
    local script_output working_dir prompt current_dir
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: Not in a git repository" >&2
        return 1
    fi
    
    # Find the script relative to this file's location
    local script_path="$DIRNAME/bin/review-pr"
    
    # Check if script exists
    if [[ ! -f "$script_path" ]]; then
        echo "Error: review-pr script not found at $script_path" >&2
        echo "Make sure you're using the dotfiles repository that includes the review tools" >&2
        return 1
    fi
    
    # Store current directory
    current_dir=$(pwd)
    
    # Execute the review script with all arguments passed through
    script_output=$("$script_path" "$@")
    if [ $? -eq 0 ]; then
        # First line is working directory, rest is prompt
        working_dir=$(echo "$script_output" | head -n1)
        prompt=$(echo "$script_output" | tail -n+2)
        
        # Only change directory if working_dir is different from current directory
        if [[ "$working_dir" != "$current_dir" ]]; then
            echo "Setup completed! Changing to working directory: $working_dir" >&2
            if cd "$working_dir"; then
                echo "$prompt" | claude --dangerously-skip-permissions
            else
                echo "Error: Failed to change directory to $working_dir" >&2
                return 1
            fi
        else
            echo "Setup completed! Working in current directory: $working_dir" >&2
            echo "$prompt" | claude --dangerously-skip-permissions
        fi
    else
        echo "Error: Review setup failed" >&2
        return 1
    fi
}

# PR Comments fetching function
claude-pr-comments() {
    local script_output working_dir prompt current_dir
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: Not in a git repository" >&2
        return 1
    fi
    
    # Find the script relative to this file's location
    local script_path="$DIRNAME/bin/get-pr-comments"
    
    # Check if script exists
    if [[ ! -f "$script_path" ]]; then
        echo "Error: get-pr-comments script not found at $script_path" >&2
        echo "Make sure you're using the dotfiles repository that includes the review tools" >&2
        return 1
    fi
    
    # Store current directory
    current_dir=$(pwd)
    
    # Execute the PR comments script with all arguments passed through
    script_output=$("$script_path" "$@")
    if [ $? -eq 0 ]; then
        # First line is working directory, rest is prompt
        working_dir=$(echo "$script_output" | head -n1)
        prompt=$(echo "$script_output" | tail -n+2)
        
        # Only change directory if working_dir is different from current directory
        if [[ "$working_dir" != "$current_dir" ]]; then
            echo "Setup completed! Changing to working directory: $working_dir" >&2
            if cd "$working_dir"; then
                echo "$prompt" | claude --dangerously-skip-permissions
            else
                echo "Error: Failed to change directory to $working_dir" >&2
                return 1
            fi
        else
            echo "Setup completed! Working in current directory: $working_dir" >&2
            echo "$prompt" | claude --dangerously-skip-permissions
        fi
    else
        echo "Error: PR comments setup failed" >&2
        return 1
    fi
}

# Combined review and fix workflow
claude-review-fix() {
    local script_output working_dir prompt current_dir
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: Not in a git repository" >&2
        return 1
    fi
    
    # Find the script relative to this file's location
    local script_path="$DIRNAME/bin/review-and-fix-pr"
    
    # Check if script exists
    if [[ ! -f "$script_path" ]]; then
        echo "Error: review-and-fix-pr script not found at $script_path" >&2
        echo "Make sure you're using the dotfiles repository that includes the review tools" >&2
        return 1
    fi
    
    # Store current directory
    current_dir=$(pwd)
    
    # Execute the review and fix script with all arguments passed through
    script_output=$("$script_path" "$@")
    if [ $? -eq 0 ]; then
        # First line is working directory, rest is prompt
        working_dir=$(echo "$script_output" | head -n1)
        prompt=$(echo "$script_output" | tail -n+2)
        
        # Only change directory if working_dir is different from current directory
        if [[ "$working_dir" != "$current_dir" ]]; then
            echo "Setup completed! Changing to working directory: $working_dir" >&2
            if cd "$working_dir"; then
                echo "$prompt" | claude --dangerously-skip-permissions
            else
                echo "Error: Failed to change directory to $working_dir" >&2
                return 1
            fi
        else
            echo "Setup completed! Working in current directory: $working_dir" >&2
            echo "$prompt" | claude --dangerously-skip-permissions
        fi
    else
        echo "Error: Review and fix setup failed" >&2
        return 1
    fi
}

# Export the functions so they're available in the shell
export -f claude-review 2>/dev/null || true
export -f claude-pr-comments 2>/dev/null || true
export -f claude-review-fix 2>/dev/null || true

# Add completions for the commands (basic)
if command -v compdef &> /dev/null; then
    compdef _default claude-review
    compdef _default claude-pr-comments
    compdef _default claude-review-fix
fi