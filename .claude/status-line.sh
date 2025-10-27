#!/usr/bin/env bash

# stdinからJSONデータを読み取る
input=$(cat)

# 現在のディレクトリとGitブランチ情報を取得
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# カレントディレクトリを表示（グレー色）
dirpart=$(printf "\033[0;37m%s " "$current_dir")

# Gitブランチ情報を取得（bashrcの実装に基づく）
gitbranch=""
if git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null >/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null >/dev/null; then
    branch=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        # ahead/behind の計算
        ahead_behind=""
        if [ "$branch" != "main" ] && [ "$branch" != "master" ]; then
            # 親ブランチを特定（origin/main または origin/master）
            parent_branch=""
            if git --no-optional-locks rev-parse --verify origin/main >/dev/null 2>&1; then
                parent_branch="origin/main"
            elif git --no-optional-locks rev-parse --verify origin/master >/dev/null 2>&1; then
                parent_branch="origin/master"
            fi

            # ahead/behind を取得
            if [ -n "$parent_branch" ]; then
                # ahead: 親ブランチにない自分のコミット数
                ahead=$(git --no-optional-locks rev-list --count "$parent_branch..HEAD" 2>/dev/null || echo "0")
                # behind: 自分にない親ブランチのコミット数
                behind=$(git --no-optional-locks rev-list --count "HEAD..$parent_branch" 2>/dev/null || echo "0")

                if [ "$ahead" -gt 0 ] || [ "$behind" -gt 0 ]; then
                    if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
                        ahead_behind=$(printf " \033[1;33m↑%d↓%d" "$ahead" "$behind")
                    elif [ "$ahead" -gt 0 ]; then
                        ahead_behind=$(printf " \033[1;33m↑%d" "$ahead")
                    elif [ "$behind" -gt 0 ]; then
                        ahead_behind=$(printf " \033[1;33m↓%d" "$behind")
                    fi
                fi
            fi
        fi

        gitbranch=$(printf "\033[0;36m[\033[1;34m⎇ %s%s" "$branch" "$ahead_behind")

        # 追加/削除された行数を取得
        if git --no-optional-locks ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then
            # 追加された行数（unstaged + staged + untracked files）
            added=$(git --no-optional-locks diff --numstat 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
            added=$((added + $(git --no-optional-locks diff --cached --numstat 2>/dev/null | awk '{sum+=$1} END {print sum+0}')))
            # untracked filesの行数も追加
            untracked_lines=$(git --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | xargs wc -l 2>/dev/null | tail -n 1 | awk '{print $1+0}')
            added=$((added + untracked_lines))

            # 削除された行数（unstaged + staged）
            deleted=$(git --no-optional-locks diff --numstat 2>/dev/null | awk '{sum+=$2} END {print sum+0}')
            deleted=$((deleted + $(git --no-optional-locks diff --cached --numstat 2>/dev/null | awk '{sum+=$2} END {print sum+0}')))

            # 新規ファイル数を取得
            untracked_count=$(git --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | wc -l)

            if [ "$added" -gt 0 ] || [ "$deleted" -gt 0 ]; then
                gitbranch="${gitbranch}$(printf "\033[0;36m] ✗ \033[1;32m+%d \033[1;31m-%d" "$added" "$deleted")"
                # 新規ファイルがある場合のみ表示
                if [ "$untracked_count" -gt 0 ]; then
                    gitbranch="${gitbranch}$(printf " \033[1;33m📄%d" "$untracked_count")"
                fi
            else
                gitbranch="${gitbranch}$(printf "\033[0;36m]")"
            fi
        else
            gitbranch="${gitbranch}$(printf "\033[0;36m]")"
        fi

        gitbranch="${gitbranch} "
    fi
fi

# リセットカラー
resetcolor="\033[0m"

# 最終出力（プロンプト記号は除外）
printf "%b%b%b" "$dirpart" "$gitbranch" "$resetcolor"
