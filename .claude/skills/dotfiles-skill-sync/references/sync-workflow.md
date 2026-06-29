# Sync Workflow

この reference は、この clone 済み repo の root で dotfiles と skills を実際に同期するときに読む。

## 1. Safety snapshot

作業前に読み取り中心で状態を集める。

```bash
test -f setup.sh && test -d dotfiles
git status --short
git log --oneline --decorate --max-count=20 -- setup.sh dotfiles .claude/skills/dotfiles-skill-sync
find dotfiles -maxdepth 5 -type f | sort
```

端末側のファイルが存在するか確認する。秘密情報を含む可能性があるため、内容表示は必要最小限にする。

```bash
for p in \
  "$HOME/.gitconfig" \
  "$HOME/.config/git/ignore" \
  "$HOME/.claude" \
  "$HOME/.codex" \
  "${ZDOTDIR:-$HOME}/.zshrc" \
  "$HOME/.zsh/peco.zsh" \
  "$HOME/.zsh/git-worktree.zsh" \
  "$HOME/.zsh/vscode-extensions.zsh" \
  "$HOME/.zsh/bin/git-worktree-add"
do
  [ -e "$p" ] && printf 'exists %s\n' "$p" || printf 'missing %s\n' "$p"
done
```

必要なら作業用ディレクトリを `/tmp/dotfiles-skill-sync-YYYYMMDD-HHMMSS/` に作り、差分ログや退避コピーを置く。秘密情報を repo の `references/` に保存しない。

## 2. Diff policy

repo 版と端末版を比較する。ファイル単位で足りなければ directory diff を使う。

```bash
diff -u dotfiles/.gitconfig "$HOME/.gitconfig"
diff -u dotfiles/.config/git/ignore "$HOME/.config/git/ignore"
diff -ru dotfiles/.claude "$HOME/.claude"
diff -ru dotfiles/.codex "$HOME/.codex"
```

差分は以下に分類する。

| Classification | Meaning | Action |
| --- | --- | --- |
| Repository update | 一般化でき、他端末にも有用 | repo の `dotfiles/`、`setup.sh`、または skill に取り込む |
| Local keep | 端末固有、秘密値、個人設定 | 端末側に残し、repo には入れない |
| Merge needed | 両方の変更に意味がある | 手動マージ案を提示する |
| Remove candidate | 古い設定、現行 setup から外れたもの | 削除確認を取る |

## 3. Secret and local-only checks

repo へ取り込む前に、次の兆候があれば停止して確認する。

- token, key, secret, password, credential, cookie, session
- 個人メールアドレス、個人名、端末ユーザー名
- `/Users/...`, `/home/...`, `/workspaces/...` などの absolute path
- 社内ドメイン、非公開 repository URL、VPN / proxy 設定
- tool のログイン状態、cache、履歴、生成物

秘密情報があるかもしれない場合、値そのものを会話に貼りすぎない。キー名、ファイル名、行番号、値の種類だけを示す。

## 4. Merge rules

- `.gitconfig`: `[user]` は基本的に local keep。alias、credential helper、diff/merge 設定は一般化できるか判断する。
- `.config/git/ignore`: OS・エディタ・言語ツールの一般 ignore は repository update 候補。個人プロジェクト名は local keep。
- `.claude/settings.json` / `.codex/config.toml`: 権限、sandbox、モデル、MCP、approval は端末依存が混ざりやすい。既存値を尊重し、一般化できるデフォルトだけ取り込む。
- skills: 本文・reference・script の改善は repository update 候補。ユーザー固有ワークフローや社内情報は local keep。
- `.zshrc`: source 行は idempotent に追加する。既存の手書き構成を並べ替えない。

## 5. Cleanup rules

古くなったファイルや設定の削除は重要だが、必ず確認する。

削除候補にしてよい例:

- repo から削除済みで、端末側にも参照が残っていない skill
- `setup.sh` がもう使わず、`.zshrc` からも source されていない zsh helper
- cache、生成物、インストール途中の一時ファイル
- 同じ source 行の重複

削除前に提示する情報:

- 対象パス
- なぜ古いと判断したか
- 参照元の有無
- バックアップを作るか、そのまま残すか

## 6. Apply and verify

repo 変更を加えたら以下を実行する。

```bash
git diff --check
git status --short
```

変更種別に応じて軽量検証を追加する。

```bash
zsh -n dotfiles/zsh/*.zsh
jq empty dotfiles/.claude/settings.json
git config --file dotfiles/.gitconfig --list
```

端末側へ反映した場合は、適用後に対象ファイルの存在、重複 source 行、必要な CLI の存在を確認する。
