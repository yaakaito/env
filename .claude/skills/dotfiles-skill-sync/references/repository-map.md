# Repository Map

この reference は、この clone 済みリポジトリが管理対象としている dotfiles / skills / setup 操作を確認するために読む。

## Preconditions

- この skill は repo root の `.claude/skills/dotfiles-skill-sync` から使われる。
- 作業対象 repo root には `setup.sh` と `dotfiles/` が存在する。
- `dotfiles/` は端末へ配る内容、root `.claude/` はこの repo で作業するための Claude 設定として扱う。

## setup.sh の主な管理対象

`setup.sh` は現在、以下を端末へ配置または設定する。

| Repository source | Terminal target | Notes |
| --- | --- | --- |
| `dotfiles/.gitconfig` | `~/.gitconfig` | Git のグローバル設定。ユーザー名、メール、credential 設定が混ざりやすい。 |
| `dotfiles/.config/git/ignore` | `~/.config/git/ignore` | グローバル ignore。一般化しやすいが、個人ツール名が混ざることがある。 |
| `dotfiles/.claude` | `~/.claude` | Claude commands / skills / settings。端末固有設定や秘密値に注意する。 |
| `dotfiles/.codex` | `~/.codex` | Codex config / skills。端末固有モデル設定や sandbox 設定に注意する。 |
| `dotfiles/.claude/skills/adr-writer` | `~/.codex/skills/adr-writer` | Claude skill を Codex skill としても配る意図がある。 |
| `dotfiles/zsh/peco.zsh` | `~/.zsh/peco.zsh` | `.zshrc` から source する。 |
| `dotfiles/zsh/git-worktree.zsh` | `~/.zsh/git-worktree.zsh` | `.zshrc` から source する。 |
| `dotfiles/zsh/vscode-extensions.zsh` | `~/.zsh/vscode-extensions.zsh` | `.zshrc` から source する。 |
| `dotfiles/zsh/bin/git-worktree-add` | `~/.zsh/bin/git-worktree-add` | 現在の repo に存在しない場合は setup.sh と実体の不整合として扱う。 |

## External install / side effects

`setup.sh` は以下のような端末状態を変更する操作も含む。

- `sudo apt update && sudo apt install peco`
- zsh plugin repository の clone
- `.zshrc` への `source ...` 追記
- Claude / Codex / Playwright / TypeScript 関連 CLI のインストール
- Claude plugin marketplace / plugin install
- `git config --global credential.helper '!gh auth git-credential'`

これらは同期作業中に勝手に再実行しない。必要性、既存状態、ネットワーク・権限影響を確認してから実施する。

## Skill locations

この repo には複数の skill 配置がある。

- `.claude/skills`: この repo を clone した作業ツリーで使う Claude skill。この skill の配置先。
- `dotfiles/.claude/skills`: 端末の `~/.claude/skills` へ配る個人 skill 群。
- `dotfiles/.codex/skills`: 端末の `~/.codex/skills` へ配る個人 skill 群。
- `cc-plugins/*/skills`: Claude plugin として配る skill。

同期時は skill の用途と配布先を混同しない。repo root の `.claude/skills` にあるものは、この repo の保守作業を助けるためのものとして扱う。

## Known consistency checks

- `setup.sh` が参照するファイルが repo に存在するか確認する。
- `.zshrc` への source 行は同じ行を複数回追加しない。
- repo に入れるファイルは秘密情報、端末固有 absolute path、個人 token、社内固有 URL を含めない。
- root `.claude/settings.local.json` は端末ローカル設定の可能性が高い。内容を repo へ一般化する前に必ず確認する。
