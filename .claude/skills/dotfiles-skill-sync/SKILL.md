---
name: dotfiles-skill-sync
description: Clone 済みのこの環境リポジトリのルートで実行し、setup.yaml(唯一の真実)と dotfiles/、skills/ を基準に端末上の dotfiles、Claude/Codex skills、関連 CLI 設定を安全に同期・更新・整理する。Use when the user asks to set up, reconcile, migrate, update, clean, prune, or merge this repository's dotfiles or skills with an existing terminal, especially when existing local files must be inspected before applying repository versions.
---

# Dotfiles Skill Sync

この skill は、このリポジトリを clone した作業ツリーのルートで使う。同期対象の唯一の真実は `setup.yaml` で、`setup.sh` はそれを適用するだけのエンジン。`setup.yaml` と `dotfiles/`、`skills/` を基準に、端末固有の変更を壊さずに dotfiles と skills を同期する。端末へ配る skill は repo root の `skills/` にあり、`gh skill` で管理する。

## Core Rule

既存ファイルを確認せずに上書きしない。削除、秘匿情報を含む可能性がある内容の取り込み、競合解消、外部コマンドのインストールは、判断材料を示してから必要に応じてユーザーに確認する。

## Initial Checks

1. 現在地がこの repo の root か確認する。
   - `test -f setup.yaml && test -f setup.sh && test -d dotfiles`
   - 違う場合は repo root へ移動してから続ける。
2. 作業ツリーを確認する。
   - `git status --short`
   - ユーザーの未コミット変更を上書きしない。
3. `setup.yaml` を読み、同期対象の全体像を把握する。`./setup.sh --check` で repo との整合性を検証する。

## Read First

必要な作業に応じて reference を読む。

- `references/repository-map.md`: `setup.yaml` の構造、skill 配置、注意が必要な対象を確認する。
- `references/sync-workflow.md`: 調査、分類、マージ、削除確認、検証の具体的な手順を確認する。
- `references/history.md`: 過去バージョンを辿る場面と `git log` / `git show` の使い方を確認する。

## Workflow

1. リポジトリ状態を確認する。
   - `git status --short`
   - `git log --oneline --decorate --max-count=20 -- setup.yaml setup.sh dotfiles skills .claude/skills/dotfiles-skill-sync`
   - `setup.yaml`、`dotfiles/`、`skills/` の現在内容
2. 端末側の対象ファイルを棚卸しする。対象一覧はここに書かれていない。`setup.yaml` の `files` / `dirs` / `git_clones` の端末側パスと `zshrc_source` の各行、および `${ZDOTDIR:-$HOME}/.zshrc` を、manifest から導出して確認する。
3. 各差分を分類する。
   - **Repository update**: 一般化でき、秘匿情報を含まず、このリポジトリに取り込むべき変更。
   - **Local keep**: 端末固有、秘密情報、個人パス、業務固有値など、外に持ち出さず維持する変更。
   - **Merge needed**: repo 版と local 版の両方に意味がある変更。
   - **Remove candidate**: `setup.yaml` や現行 dotfiles から外れ、古くなった可能性があるファイルや設定。
4. 同期計画を短く提示する。
   - 取り込むもの、ローカルに残すもの、マージするもの、削除候補を分ける。
   - 削除候補は必ずユーザー確認を得る。
   - 秘匿情報の可能性がある差分は内容をそのまま表示しすぎず、キー名や構造だけで確認する。
5. 合意済みの変更だけ実施する。
   - repo に入れる変更は `dotfiles/`、`skills/`、`setup.yaml`、または関連 skill に反映する。配布対象の追加・削除は `setup.yaml` だけを編集し、engine である `setup.sh` は挙動変更が必要なときだけ触る。
   - 端末へ反映する変更はバックアップまたは一時退避を作ってから適用する。
   - `.zshrc` への追記は重複しないように検査してから行う。
6. 検証する。
   - `./setup.sh --check`
   - `git diff --check`
   - 変更した Markdown / shell / YAML / TOML / JSON の構文確認
   - 必要なら `bash -n setup.sh`、`zsh -n`、`jq`、`git config --get` などの軽量検証

## Confirmation Rules

必ず確認する操作:

- 端末側ファイルの削除、移動、破壊的な上書き
- 秘密情報、トークン、個人メール、社内 URL、個人パスを repo に取り込む可能性がある変更
- `curl | sh`、`npm install -g`、`playwright install-deps`、`apt install` などネットワークや管理者権限を使う操作
- 既存 skill や plugin の削除

確認なしで進めてよい操作:

- 読み取り、差分確認、構文確認
- repo 内でのこの skill / reference の改善
- 明らかな typo 修正

## Output Style

日本語で、判断単位ごとに短く報告する。差分が多い場合は表にして、`対象`, `分類`, `理由`, `提案`, `確認要否` を示す。
