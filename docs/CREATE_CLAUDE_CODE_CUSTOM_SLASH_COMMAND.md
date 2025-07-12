# Claude Code カスタムスラッシュコマンド作成ガイド

このドキュメントでは、Claude Code 向けのカスタムスラッシュコマンドを作成する方法について説明します。

## 概要

Claude Code では、`.claude/commands/` ディレクトリにマークダウンファイルを配置することで、カスタムスラッシュコマンドを作成できます。これにより、繰り返し行う作業を自動化し、効率的な開発ワークフローを構築できます。

**推奨事項**: コマンド名と description は英語で記述することを推奨します。これにより、チーム開発や国際的なプロジェクトでの利用がしやすくなります。

## 基本構造

カスタムコマンドファイルは以下の構造を持ちます：

```markdown
---
allowed-tools: Bash(command:*), Read(*), Write(*)
description: Brief description of the command
---

Claude への指示内容をここに記述します。
具体的なタスクの手順や期待する動作を詳しく説明してください。
```

## 簡潔な操作例

### 基本的なコマンドの作成

#### 1. ファイル作成
`.claude/commands/example.md` を作成：

```markdown
---
allowed-tools: Bash(ls:*), Read(*)
description: Show project overview
---

プロジェクトの構造を確認し、README.md の内容を表示してください。
```

#### 2. コマンド実行
```bash
/example
```

### 一般的なコマンドパターン

- **ファイル操作**: `Bash(ls:*), Bash(find:*), Read(*), Write(*)`
- **Git操作**: `Bash(git add:*), Bash(git log:*), Bash(git push:*)`
- **GitHub操作**: `Bash(gh pr view:*), Bash(gh api:*)`

## 詳細なコマンド作成例

### 例1: テスト実行とレポート生成

```markdown
---
allowed-tools: Bash(npm test:*), Bash(mkdir:*), Write(*)
description: Run tests and generate report
---

以下の手順でテストを実行し、結果をレポートします：

1. プロジェクトのテストスイートを実行する
2. テスト結果を解析する
3. `reports/` ディレクトリを作成する
4. テスト結果サマリーを `reports/test-summary.md` に保存する

レポートには以下を含めてください：
- 実行されたテスト数
- 成功/失敗の数
- 失敗したテストの詳細
- 実行時間
```

### 例2: コードレビュー準備

```markdown
---
allowed-tools: Bash(git diff:*), Bash(git log:*), Read(*), Write(*)
description: Prepare code review for pull request
---

プルリクエストの準備として以下を実行してください：

1. `git log --oneline -10` で最近のコミットを確認
2. `git diff main..HEAD` で変更内容を取得
3. 変更されたファイルを特定し、重要な変更点を分析
4. 以下の形式でプルリクエスト説明文を生成：

```
## 変更概要
[変更の目的と概要]

## 主な変更点
- [変更点1]
- [変更点2]

## テスト方法
[テスト手順]

## 注意点
[レビュー時の注意点]
```
```

### 例3: 環境セットアップ確認

```markdown
---
allowed-tools: Bash(node --version:*), Bash(npm --version:*), Bash(which:*), Read(package.json)
description: Check development environment status
---

開発環境が正しくセットアップされているかを確認してください：

1. **ランタイム確認**
   - Node.js のバージョン
   - npm/yarn のバージョン
   - 必要な CLI ツールの存在確認

2. **プロジェクト設定確認**
   - package.json の依存関係
   - 必要な環境変数の設定状況
   - 設定ファイルの存在確認

3. **結果レポート**
   以下の形式で結果を表示：
   ```
   ## 環境確認結果
   
   ### ✅ 正常な項目
   - [項目名]: [状態]
   
   ### ⚠️ 要確認項目
   - [項目名]: [問題内容]
   
   ### ❌ エラー項目
   - [項目名]: [エラー内容]
   ```
```

## allowed-tools の設定

### 基本的なツール権限

```yaml
# ファイル操作
allowed-tools: Read(*), Write(*), Bash(ls:*), Bash(find:*)

# Git操作
allowed-tools: Bash(git add:*), Bash(git commit:*), Bash(git push:*)

# GitHub操作
allowed-tools: Bash(gh pr view:*), Bash(gh api:*)

# 開発ツール
allowed-tools: Bash(npm:*), Bash(node:*), Bash(yarn:*)
```

### セキュリティ考慮事項

- 最小権限の原則に従い、必要な権限のみを付与
- ワイルドカード `*` の使用は慎重に検討
- システムファイルへのアクセスは避ける

## 既存コマンドの参考例

このリポジトリには以下の既存コマンドがあります：

### `commit.md`
Conventional Commits 形式でのコミット作成
```yaml
allowed-tools: [Git操作のみ]
```

### `reviews-fix.md`
GitHub PR コメントに基づく自動修正
```yaml
allowed-tools: Bash(gh pr view), Bash(gh api:*)
```

### `workflow-fix.md`
GitHub Actions ワークフローの問題修正
```yaml
allowed-tools: Bash(gh run list:*), Bash(gh run view:*)
```

## ベストプラクティス

### 1. 明確な指示の記述
- タスクの目的を明確に記述
- 手順を番号付きリストで整理
- 期待する出力形式を指定

### 2. エラーハンドリング
```markdown
**エラー処理:**
- ファイルが存在しない場合の対応
- 権限エラーが発生した場合の代替手段
- 予期しない結果の場合の報告方法
```

### 3. 出力形式の統一
```markdown
**出力形式:**
```
## 実行結果

### 成功項目
- [項目]: [結果]

### 警告項目
- [項目]: [警告内容]

### エラー項目
- [項目]: [エラー詳細]
```
```

### 4. ドキュメント化
- コマンドの目的と使用場面を明記
- 依存関係や前提条件を記載
- 使用例を含める

## 参考リンク

- [Claude Code 公式ドキュメント](https://docs.anthropic.com/ja/docs/claude-code/common-workflows)
- [カスタムスラッシュコマンドの詳細解説](https://syu-m-5151.hatenablog.com/entry/2025/06/25/062736)
- [Claude Code カスタムスラッシュコマンド活用法](https://azukiazusa.dev/blog/claude-code-custom-slash-command/)

## トラブルシューティング

### コマンドが認識されない
- ファイル名に `.md` 拡張子が付いているか確認
- YAML フロントマターの形式が正しいか確認
- `.claude/commands/` ディレクトリに配置されているか確認

### 権限エラーが発生する
- `allowed-tools` の設定を確認
- 必要な権限が適切に設定されているか確認
- `.claude/settings.json` の permissions 設定を確認

### 期待通りに動作しない
- 指示内容が具体的で明確か確認
- 手順が論理的な順序で記述されているか確認
- 出力形式の指定が適切か確認