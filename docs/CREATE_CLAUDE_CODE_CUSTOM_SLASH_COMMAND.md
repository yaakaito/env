# Claude Code カスタムスラッシュコマンド作成ガイド

このドキュメントでは、Claude Code 向けのカスタムスラッシュコマンドを作成する方法について説明します。

## 概要

Claude Code では、`.claude/commands/` ディレクトリにマークダウンファイルを配置することで、カスタムスラッシュコマンドを作成できます。これにより、繰り返し行う作業を自動化し、効率的な開発ワークフローを構築できます。

**推奨事項**: コマンド名、description、およびプロンプト内容はすべて英語で記述することを推奨します。また、Claude Code は作成時に必ず英語で出力を行う必要があります。これにより、チーム開発や国際的なプロジェクトでの利用がしやすくなります。

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

Please check the project structure and display the contents of README.md. Always provide output in English.
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

Execute tests and generate a report following these steps:

1. Run the project test suite
2. Analyze test results
3. Create the `reports/` directory
4. Save test result summary to `reports/test-summary.md`

The report should include:
- Number of tests executed
- Number of successes/failures
- Details of failed tests
- Execution time

Always provide output in English.
```

### 例2: コードレビュー準備

````markdown
---
allowed-tools: Bash(git diff:*), Bash(git log:*), Read(*), Write(*)
description: Prepare code review for pull request
---

Prepare for pull request by executing the following:

1. Check recent commits with `git log --oneline -10`
2. Get changes with `git diff main..HEAD`
3. Identify changed files and analyze important modifications
4. Generate pull request description in the following format:

Always provide output in English.

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
````

### 例3: 環境セットアップ確認

````markdown
---
allowed-tools: Bash(node --version:*), Bash(npm --version:*), Bash(which:*), Read(package.json)
description: Check development environment status
---

Check if the development environment is properly set up:

1. **Runtime Verification**
   - Node.js version
   - npm/yarn version
   - Check existence of required CLI tools

2. **Project Configuration Check**
   - package.json dependencies
   - Required environment variables setup
   - Configuration files existence check

3. **Results Report**
   Display results in the following format:
   
Always provide output in English.
   ```
   ## 環境確認結果
   
   ### ✅ 正常な項目
   - [項目名]: [状態]
   
   ### ⚠️ 要確認項目
   - [項目名]: [問題内容]
   
   ### ❌ エラー項目
   - [項目名]: [エラー内容]
   ```
````

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

### 5. 英語出力の徹底
````markdown
**重要**: すべてのカスタムコマンドは必ず英語で出力を行う必要があります

**推奨実装:**
- プロンプト内に "Always provide output in English." を明記
- 出力形式の例も英語で提供
- エラーメッセージや警告も英語で表示

**例:**
```
Check the project status and provide a summary report.

Always provide output in English.
```
````

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
