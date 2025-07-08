# git worktree を作成し、そのディレクトリに移動
function git-create-worktree() {
    local branch_name="$1"
    
    # パラメータチェック
    if [[ -z "$branch_name" ]]; then
        echo "Usage: git-create-worktree <branch_name>"
        return 1
    fi
    
    # Git リポジトリかチェック
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: Not in a git repository"
        return 1
    fi
    
    # worktree のパスを設定
    local worktree_path=".git/working-trees/$branch_name"
    
    # 既存の worktree をチェック
    if [[ -d "$worktree_path" ]]; then
        echo "Worktree '$branch_name' already exists. Changing to directory..."
        cd "$worktree_path"
        return 0
    fi
    
    # ブランチの存在確認
    if git show-ref --verify --quiet refs/heads/"$branch_name" || git show-ref --verify --quiet refs/remotes/origin/"$branch_name"; then
        echo "Branch '$branch_name' exists. Creating worktree..."
        git worktree add "$worktree_path" "$branch_name"
    else
        echo "Branch '$branch_name' does not exist. Creating from main..."
        git worktree add -b "$branch_name" "$worktree_path" main
    fi
    
    # worktree の作成が成功したかチェック
    if [[ $? -eq 0 ]]; then
        echo "Worktree created successfully. Changing to directory..."
        cd "$worktree_path"
    else
        echo "Error: Failed to create worktree"
        return 1
    fi
}