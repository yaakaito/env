# Get the directory where this script is located
WORKTREE_SCRIPT_DIR="${0:A:h}"

# Create worktree and cd to it
git-worktree-add() {
    local worktree_path
    worktree_path=$("$WORKTREE_SCRIPT_DIR/bin/git-worktree-add" "$@")
    local exit_code=$?
    if [[ $exit_code -eq 0 && -d "$worktree_path" ]]; then
        cd "$worktree_path"
    fi
    return $exit_code
}

# Helper: interactively select a non-main worktree via peco
_git-worktree-select() {
    local prompt="${1:-SELECT WORKTREE>}"
    local main_worktree
    main_worktree=$(git worktree list --porcelain | grep -m1 '^worktree ' | sed 's/^worktree //')
    git worktree list | grep -v "^${main_worktree} " | peco --prompt "$prompt"
}

# Interactive remove with peco
git-worktree-remove() {
    local selected
    selected=$(_git-worktree-select "DELETE WORKTREE>")
    if [[ -n "$selected" ]]; then
        local worktree_path=$(echo "$selected" | awk '{print $1}')
        git worktree remove "$worktree_path"
        echo "Removed: $worktree_path"
    fi
}

# Checkout a branch from worktree into the current workspace
# Removes the worktree and switches to its branch
git-worktree-checkout() {
    local selected
    selected=$(_git-worktree-select "CHECKOUT WORKTREE BRANCH>")
    if [[ -n "$selected" ]]; then
        local worktree_path=$(echo "$selected" | awk '{print $1}')
        local branch=$(echo "$selected" | sed 's/.*\[//' | sed 's/\]//')
        if [[ -z "$branch" || "$selected" == *"(detached"* ]]; then
            echo "Error: Selected worktree is in detached HEAD state"
            return 1
        fi
        git worktree remove "$worktree_path" && \
        git switch "$branch" && \
        echo "Switched to branch: $branch"
    fi
}
