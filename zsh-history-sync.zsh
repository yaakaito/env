# zsh-history-sync.zsh
# プロジェクトルートの.zsh_historyを使って履歴を永続化する

# プロジェクトルートを取得
function get_project_root() {
    local current_dir="$PWD"
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        echo "$git_root"
    else
        echo ""
    fi
}

# 履歴を同期する関数
function sync_history_from_project() {
    local project_root=$(get_project_root)
    if [[ -n "$project_root" && -f "$project_root/.zsh_history" ]]; then
        # プロジェクトルートから履歴を読み込み
        cp "$project_root/.zsh_history" "$HOME/.zsh_history" 2>/dev/null
        # 履歴を再読み込み
        fc -R
    fi
}

function sync_history_to_project() {
    local project_root=$(get_project_root)
    if [[ -n "$project_root" && -f "$HOME/.zsh_history" ]]; then
        # 現在の履歴をプロジェクトルートに保存
        cp "$HOME/.zsh_history" "$project_root/.zsh_history" 2>/dev/null
    fi
}

# シェル終了時に履歴を同期するトラップを設定
function setup_history_sync_trap() {
    # SIGTERM, SIGINT, EXIT時に履歴を同期
    trap 'sync_history_to_project' TERM INT EXIT
}

# ディレクトリ変更時に履歴を同期
function chpwd_sync_history() {
    sync_history_from_project
}

# zsh hook システムが利用可能な場合のみ設定
if [[ -n $(echo ${^fpath}/add-zsh-hook(N)) ]]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd chpwd_sync_history
fi

# 初期化時に履歴を同期
sync_history_from_project

# トラップを設定
setup_history_sync_trap