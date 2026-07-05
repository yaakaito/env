# Sync Workflow

この reference は、この clone 済み repo の root で dotfiles と skills を実際に同期するときに読む。

## 1. Safety snapshot

作業前に読み取り中心で状態を集める。

```bash
test -f setup.yaml && test -f setup.sh && test -d dotfiles && test -d skills
git status --short
git log --oneline --decorate --max-count=20 -- setup.yaml setup.sh dotfiles skills .claude/skills/dotfiles-skill-sync
./setup.sh --check
find dotfiles skills -maxdepth 5 -type f | sort
```

端末側の棚卸し対象は `setup.yaml` から導出する。`files` / `dirs` / `git_clones` の各エントリの端末側パス(`-> ` の右側、`~` は `$HOME` に読み替える)と `${ZDOTDIR:-$HOME}/.zshrc` について存在を確認する。秘密情報を含む可能性があるため、内容表示は必要最小限にする。

```bash
# パス一覧は setup.yaml から導出して埋める
for p in <setup.yaml から導出した端末側パス> "${ZDOTDIR:-$HOME}/.zshrc"; do
  [ -e "$p" ] && printf 'exists %s\n' "$p" || printf 'missing %s\n' "$p"
done
```

必要なら作業用ディレクトリを `umask 077` の上で `mktemp -d` で作り、差分ログや退避コピーを置く。退避コピーには秘密情報が入り得るため、固定名の `/tmp` パスや repo 配下には置かない。秘密情報を repo の `references/` に保存しない。

## 2. Diff policy

repo 版と端末版を比較する。比較ペアは `setup.yaml` の `files` / `dirs` エントリそのもの。ファイル単位で足りなければ directory diff を使う。

```bash
# 例(実際のペアは setup.yaml から導出する)
diff -u dotfiles/.gitconfig "$HOME/.gitconfig"
diff -ru dotfiles/.claude "$HOME/.claude"
diff -ru skills "$HOME/.claude/skills"
```

`skills` の diff は端末側の変更を repo に取り込むかどうかの分類にだけ使う。repo → 端末方向の反映はファイルコピーではなく `gh skill install` で行う(6. Apply and verify を参照)。

差分は以下に分類する。

| Classification    | Meaning                             | Action                                                              |
| ----------------- | ----------------------------------- | ------------------------------------------------------------------- |
| Repository update | 一般化でき、他端末にも有用          | repo の `dotfiles/`、`skills/`、`setup.sh`、または skill に取り込む |
| Local keep        | 端末固有、秘密値、個人設定          | 端末側に残し、repo には入れない                                     |
| Merge needed      | 両方の変更に意味がある              | 手動マージ案を提示する                                              |
| Remove candidate  | 古い設定、現行 setup から外れたもの | 削除確認を取る                                                      |

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
- skills: 本文・reference・script の改善は repo root `skills/` への repository update 候補。ユーザー固有ワークフローや社内情報は local keep。取り込み時は Agent Skills 仕様（ディレクトリ名 = frontmatter `name`、`allowed-tools` は文字列）を保つ。repo → 端末の反映は `gh skill install`（`--from-local`）で行い、`~/.claude/skills` を直接編集・コピーしない。
- `.zshrc`: source 行は idempotent に追加する。既存の手書き構成を並べ替えない。
- 配布対象の増減（新しい dotfile を配る、配布をやめる）は `setup.yaml` の該当セクションを編集し、`./setup.sh --check` で検証する。`setup.sh` 本体は挙動を変えるときだけ触る。

## 5. Cleanup rules

古くなったファイルや設定の削除は重要だが、必ず確認する。

削除候補にしてよい例:

- repo から削除済みで、端末側にも参照が残っていない skill
- `setup.yaml` から外れ、`.zshrc` からも source されていない zsh helper
- cache、生成物、インストール途中の一時ファイル
- 同じ source 行の重複
- `~/.claude/.claude` や `~/.codex/.codex` のようなネスト（旧 setup.sh の `cp -r` 再実行で生じた生成物）

削除前に提示する情報:

- 対象パス
- なぜ古いと判断したか
- 参照元の有無
- バックアップを作るか、そのまま残すか

## 6. Apply and verify

skills を端末へ反映する場合は、`setup.yaml` の `skills` セクションから対象と agent を導出し、setup.sh と同じ形の `gh skill install` を repo root で実行する。

```bash
# 例(実際のエントリは setup.yaml の skills セクションから導出する)
gh skill install . --from-local --all --agent claude-code --scope user --force
gh skill install . adr-writer --from-local --agent codex --scope user --force
```

repo 変更を加えたら以下を実行する。

```bash
./setup.sh --check
git diff --check
git status --short
```

変更種別に応じて軽量検証を追加する。

```bash
bash -n setup.sh
zsh -n dotfiles/zsh/*.zsh
jq empty dotfiles/.claude/settings.json
git config --file dotfiles/.gitconfig --list
```

端末側へ反映した場合は、適用後に対象ファイルの存在、重複 source 行、必要な CLI の存在を確認する。
