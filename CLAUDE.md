# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## リポジトリ概要

このリポジトリは、開発環境の自動設定を提供するdotfiles/開発環境セットアップリポジトリです。シェル設定、VS Code拡張機能、devcontainerテンプレートが含まれています。

## よく使用するコマンド

### 初期セットアップ

**Linux/WSL:**
```bash
./setup.sh
```

**macOS:**
```bash
./setup-mac.sh
```

**devcontainerテンプレートのクローン:**
```bash
# Deno devcontainer
npx tiged yaakaito/env/devcontainers/deno .devcontainer
npx tiged yaakaito/env/.github .github
npx tiged yaakaito/env/.vscode .vscode

# Node.js with pnpm
npx tiged yaakaito/env/devcontainers/node-pnpm .devcontainer

# Bun runtime
npx tiged yaakaito/env/devcontainers/bun .devcontainer
```

### インストールされるツールとエイリアス

**.gitconfigで設定されるGitエイリアス:**
- `git co` - checkout
- `git st` - status
- `git sw` - switch
- `git ci` - commit
- `git push-force` - push with lease and force-if-includes

**Pecoキーバインディング:**
- `Ctrl+R` - インタラクティブなコマンド履歴検索
- `Ctrl+S` - 最近のディレクトリからのインタラクティブなディレクトリナビゲーション
- `lb` - pecoを使用したGitブランチ選択

## アーキテクチャと構造

### 主要コンポーネント

1. **セットアップスクリプト**
   - `setup.sh`: Linux/WSL環境のセットアップ
   - `setup-mac.sh`: Oh My Zshを含むmacOS環境のセットアップ
   - 両スクリプトでインストールされるもの: zshプラグイン（autosuggestions、syntax-highlighting）、peco、VS Code拡張機能、Claude Code CLI

2. **シェル拡張機能**
   - `peco.zsh`: コマンド履歴とディレクトリナビゲーションのインタラクティブフィルタリング
   - `vscode-extensions.zsh`: 初回実行時のVS Code拡張機能自動インストール
   - より快適なターミナル体験のためのZsh autosuggestionsとsyntax highlighting

3. **Devcontainerテンプレート** (`devcontainers/`内)
   - Deno、Node.js/pnpm、Bun用の事前設定済み開発コンテナ
   - GitHub CLIとタイムゾーン設定（Asia/Tokyo）を含む
   - VS Code Remote Containersですぐに使用可能

4. **AI開発ワークフロー**
   - `memory-bank.txt`: Roo/Claude AIアシスタントワークフローのドキュメント
   - AI支援開発のためのメモリバンク構造を重視
   - Claude Code CLIがnpmでグローバルインストール

### 開発ワークフロー

1. **環境セットアップ**: OSに適したセットアップスクリプトを実行
2. **VS Code統合**: 初回ターミナル起動時に拡張機能が自動インストール
3. **コンテナ開発**: tigedを使用して適切なdevcontainerテンプレートをクローン
4. **AI支援**: Claude Code CLIがグローバルで利用可能、メモリバンクワークフローが文書化済み

### 設定ファイル

- `.gitconfig`: Gitユーザー設定とエイリアス
- `.devcontainer/`: アクティブなdevcontainer設定（現在はDeno基盤）
- `.vscode/settings.json`: Biomeフォーマッタ設定
- `.github/dependabot.yml`: 自動依存関係更新

## 重要な注意事項

- このリポジトリはJavaScript/TypeScriptのデフォルトフォーマッタとしてBiomeを使用
- VS CodeがGitの可視化、リンティング、AI支援のための拡張機能を含む主要エディタ
- セットアップスクリプトは冪等性があり、複数回実行しても安全
- メモリバンクワークフローは、セッション間でのAIアシスタントのコンテキスト維持を重視
