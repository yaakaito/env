# Get the directory where this script is located
WORKTREE_SCRIPT_DIR="${0:A:h}"

# Create worktree and cd to it
git-worktree-add() {
    local worktree_path
    worktree_path=$("$WORKTREE_SCRIPT_DIR/bin/git-worktree-add" "$@")
    local exit_code=$?
    if [[ $exit_code -eq 0 && -n "$worktree_path" ]]; then
        cd "$worktree_path"
    fi
    return $exit_code
}

# Interactive remove with peco
git-worktree-remove() {
    local selected
    selected=$(git worktree list | peco --prompt "DELETE WORKTREE>")
    if [[ -n "$selected" ]]; then
        local worktree_path=$(echo "$selected" | awk '{print $1}')
        git worktree remove "$worktree_path"
        echo "Removed: $worktree_path"
    fi
}
