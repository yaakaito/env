# env

開発環境の自動設定を提供するdotfiles/開発環境セットアップリポジトリです。シェル設定、VS Code拡張機能、devcontainerテンプレート、GitHub Issue解決ツールが含まれています。

## セットアップ

### Linux/WSL

```bash
git clone git@github.com:yaakaito/env.git ~/.env
cd ~/.env
./setup.sh
```

### macOS

```bash
git clone git@github.com:yaakaito/env.git ~/.env
cd ~/.env
./setup-mac.sh
```

## 機能

### 1. シェル拡張機能
- **peco**: コマンド履歴とディレクトリナビゲーションのインタラクティブフィルタリング
  - `Ctrl+R` - インタラクティブなコマンド履歴検索
  - `Ctrl+S` - 最近のディレクトリからのインタラクティブなディレクトリナビゲーション
  - `lb` - pecoを使用したGitブランチ選択
- **Zsh autosuggestions**: コマンド補完
- **Zsh syntax highlighting**: シンタックスハイライト

### 2. GitHub Issue Resolver
GitHub IssueをClaude Codeで自動解決するツールです。

#### 使用方法
プロジェクトのルートディレクトリで：

```bash
resolve-issue
```

#### 動作フロー
1. **Issue選択**: pecoでインタラクティブに選択
2. **ブランチ名生成**: Claude AIが適切なブランチ名を生成
3. **Worktree作成**: `.git/working-trees/`以下に作成
4. **環境セットアップ**: 
   - .envファイルのコピー
   - パッケージマネージャーの検出・インストール
5. **Claude実行**: 生成されたプロンプトでIssueを解決

#### 対応パッケージマネージャー
- Bun (`bun.lockb`)
- pnpm (`pnpm-lock.yaml`)
- npm (`package-lock.json`)
- Deno (`deno.json`, `deno.jsonc`)

### 3. VS Code拡張機能
初回ターミナル起動時にVS Code拡張機能が自動インストールされます。

### 4. Git設定
- Gitユーザー設定とエイリアス
- 便利なGitエイリアス（`git co`, `git st`, `git sw`, `git ci`, `git push-force`）

## Devcontainerテンプレート

プロジェクトに応じてdevcontainerテンプレートを適用できます：

### Deno
```bash
npx tiged yaakaito/env/devcontainers/deno .devcontainer
npx tiged yaakaito/env/.github .github
npx tiged yaakaito/env/.vscode .vscode
```

### Node.js with pnpm
```bash
npx tiged yaakaito/env/devcontainers/node-pnpm .devcontainer
```

### Bun
```bash
npx tiged yaakaito/env/devcontainers/bun .devcontainer
```

## 注意事項

### GitHub Issue Resolver使用時
- GitHub CLIの認証が必要です: `gh auth login`
- Claude Code CLIがインストールされている必要があります
- `.env`ファイルがある場合は自動的にコピーされます
- 既存のブランチがある場合は削除して再作成されます
- **初回使用時**: `--dangerously-skip-permissions`の警告が表示される場合があります。警告を読んで同意してください
- 一度警告に同意すると、以降は自動で動作します

### その他
- セットアップスクリプトは冪等性があり、複数回実行しても安全です
- VS CodeがGitの可視化、リンティング、AI支援のための拡張機能を含む主要エディタとして設定されます
