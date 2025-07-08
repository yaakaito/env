# https://zenn.dev/oreo2990/articles/13c80cf34a95af
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# https://qiita.com/keisukee/items/9b815e56a173a281f42f

# 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}


### 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^s' peco-cdr

alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

# git worktree list から選択して削除
alias git-worktree-remove='git worktree list | peco --prompt "DELETE WORKTREE>" | awk "{print \$1}" | xargs -I {} git worktree remove {}'

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
