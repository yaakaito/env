# env

開発環境の自動設定を提供するdotfiles/開発環境セットアップリポジトリです。シェル設定、VS Code拡張機能、devcontainerテンプレートが含まれています。

## セットアップ

```bash
git clone git@github.com:yaakaito/env.git ~/.env
cd ~/.env
./setup.sh
```

## 機能

### 1. シェル拡張機能

- **peco**: コマンド履歴とディレクトリナビゲーションのインタラクティブフィルタリング
  - `Ctrl+R` - インタラクティブなコマンド履歴検索
  - `Ctrl+S` - 最近のディレクトリからのインタラクティブなディレクトリナビゲーション
  - `lb` - pecoを使用したGitブランチ選択
- **Zsh autosuggestions**: コマンド補完
- **Zsh syntax highlighting**: シンタックスハイライト

### 2. Git Worktree

並行開発のための独立したworktreeを作成します。デフォルトでClaudeがブランチ名を生成します。

#### 使用方法

```bash
# worktree作成（Claudeがブランチ名を生成）
git-worktree-add "ログイン機能の追加"

# 明示的にブランチ名を指定
git-worktree-add -b feature/login

# オプション付き
git-worktree-add -b fix/typo --no-deps --no-copy

# worktree削除（pecoでインタラクティブに選択）
git-worktree-remove
```

#### オプション

| オプション     | 説明                                         |
| -------------- | -------------------------------------------- |
| `-b, --branch` | ブランチ名を直接指定（Claude生成をスキップ） |
| `--no-deps`    | 依存関係インストールをスキップ               |
| `--no-copy`    | .envファイルのコピーをスキップ               |

#### 設定ファイル (.worktreerc)

リポジトリルートに `.worktreerc` を配置してカスタマイズできます：

```yaml
# コピーするファイル（glob対応）
copy:
  - .env
  - .env.local
  - packages/*/.env

# worktree作成後に実行するコマンド
run:
  - npm install
  - npm run build
```

デフォルト動作（.worktreerc なし）：

- コピー: `.env`, `packages/*/.env`, `apps/*/.env`
- 実行: パッケージマネージャーを自動検出してインストール

### 3. VS Code拡張機能

初回ターミナル起動時にVS Code拡張機能が自動インストールされます。

### 4. Git設定

- Gitユーザー設定とエイリアス
- 便利なGitエイリアス（`git co`, `git st`, `git sw`, `git ci`, `git push-force`）

### 5. コードフォーマット

[oxfmt](https://oxc.rs/docs/formatter.html)を使用。`.editorconfig`を自動検出するため設定ファイル不要。

```bash
# フォーマット実行
bunx oxfmt

# チェックのみ（CI用）
bunx oxfmt --check
```

## Devcontainerテンプレート

以下のコマンドでdevcontainer、GitHub Actions、VS Code設定を一括セットアップできます：

### Deno

```bash
curl -fsSL https://raw.githubusercontent.com/yaakaito/env/main/bin/setup-repository | bash -s -- deno
```

### Node.js with pnpm

```bash
curl -fsSL https://raw.githubusercontent.com/yaakaito/env/main/bin/setup-repository | bash -s -- node-pnpm
```

### Bun

```bash
curl -fsSL https://raw.githubusercontent.com/yaakaito/env/main/bin/setup-repository | bash -s -- bun
```

### 新規ディレクトリに作成

```bash
curl -fsSL https://raw.githubusercontent.com/yaakaito/env/main/bin/setup-repository | bash -s -- deno my-project
```

### 対話モード（テンプレート選択）

```bash
curl -fsSL https://raw.githubusercontent.com/yaakaito/env/main/bin/setup-repository | bash
```

## 注意事項

- セットアップスクリプトは冪等性があり、複数回実行しても安全です
- VS CodeがGitの可視化、リンティング、AI支援のための拡張機能を含む主要エディタとして設定されます
- `claude --plugin-dir` でプラグインをテストできます
