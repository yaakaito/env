# Repository Map

この reference は、この clone 済みリポジトリが管理対象としている dotfiles / skills / setup 操作を確認するために読む。

## Preconditions

- この skill は repo root の `.claude/skills/dotfiles-skill-sync` から使われる。
- 作業対象 repo root には `setup.yaml`、`setup.sh`、`dotfiles/`、`skills/` が存在する。
- `dotfiles/` は端末へ配る内容、root `.claude/` はこの repo で作業するための Claude 設定として扱う。

## setup.yaml is the single source of truth

端末へ何を配置・インストールするかは、すべて `setup.yaml` に定義されている。個別の対象一覧をこの reference に複製しない。同期作業では必ず `setup.yaml` を読み、そこから対象を導出する。

- `setup.sh` は `setup.yaml` を解釈して適用するだけの engine。配布対象の追加・削除では `setup.yaml` だけを編集する。
- `./setup.sh --check` は端末に変更を加えずに、manifest のエントリが repo の実体と整合しているか(参照先ファイルの存在、skill の存在、エントリ形式)を検証する。
- `setup.yaml` は制約付き YAML サブセット。トップレベルキー + 文字列のブロックリストのみで、`A -> B` 形式でコピー元と端末側パスを表す。フォーマットの詳細は `setup.yaml` 冒頭のコメントに従う。

セクションの意味:

| Section                                  | Meaning                                                                                    |
| ---------------------------------------- | ------------------------------------------------------------------------------------------ |
| `apt_packages`                           | `sudo apt-get install -y` でインストールするパッケージ                                     |
| `files`                                  | repo → 端末への単一ファイルコピー                                                          |
| `dirs`                                   | repo → 端末へのディレクトリのマージコピー(端末側にだけあるファイルは残る)                  |
| `git_clones`                             | 端末に存在しない場合だけ clone するリポジトリ                                              |
| `zshrc_source`                           | `${ZDOTDIR:-$HOME}/.zshrc` に idempotent に追記する `source` 行                            |
| `skills`                                 | `gh skill install . --from-local --scope user` で配る skill と対象 agent(`all` は全 skill) |
| `installers` / `run`                     | 順序どおり実行するコマンド(CLI インストール、事後設定)                                     |
| `claude_marketplaces` / `claude_plugins` | `claude plugin marketplace add` / `claude plugin install` の対象                           |
| `npm_globals`                            | `npm install -g` でインストールするパッケージ                                              |

## Targets that need extra care

対象ごとの注意点(何を配るかではなく、扱い方のメモ):

- `~/.gitconfig`: ユーザー名、メール、credential 設定が混ざりやすい。`[user]` は基本 local keep。
- `~/.config/git/ignore`: 一般化しやすいが、個人ツール名が混ざることがある。
- `~/.claude`(`dirs` 経由): commands / settings を含む。skills は含まない(repo root の `skills/` を参照)。端末固有設定や秘密値に注意する。
- `~/.codex`(`dirs` 経由): Codex config。端末固有モデル設定や sandbox 設定に注意する。
- Codex への skill 配布は `skills` セクションの `--agent codex` エントリで行う。

## External install / side effects

`installers` / `run` / `apt_packages` / `npm_globals` / `claude_*` の各セクションは、ネットワークや sudo を使って端末状態を変更する。これらは同期作業中に勝手に再実行しない。必要性、既存状態、ネットワーク・権限影響を確認してから実施する。

## Skill locations

この repo には複数の skill 配置がある。

- `.claude/skills`: この repo を clone した作業ツリーで使う Claude skill。この skill の配置先。
- `skills`: 端末へ配る個人 skill 群。Agent Skills 仕様(`skills/*/SKILL.md`)に従い、`gh skill` で install / publish する。ディレクトリ名は frontmatter の `name` と一致させ、`allowed-tools` は文字列(YAML リスト不可)にする。
- `cc-plugins/*/skills`: Claude plugin として配る skill。

同期時は skill の用途と配布先を混同しない。repo root の `.claude/skills` にあるものは、この repo の保守作業を助けるためのものとして扱う。

## Known consistency checks

- `./setup.sh --check` を通す。manifest が参照するファイル・skill が repo に存在しない場合はここで検出される。
- `.zshrc` への source 行は同じ行を複数回追加しない(engine 側で idempotent だが、手動編集時も守る)。
- repo に入れるファイルは秘密情報、端末固有 absolute path、個人 token、社内固有 URL を含めない。
- root `.claude/settings.local.json` は端末ローカル設定の可能性が高い。内容を repo へ一般化する前に必ず確認する。
