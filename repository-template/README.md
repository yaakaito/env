# GitHub Workflows

このディレクトリには、リポジトリの CI/CD と AI 自動化のためのワークフローが含まれています。

## 必要な Secrets

### 必須

| Secret                    | 説明                                     | 用途                        |
| ------------------------- | ---------------------------------------- | --------------------------- |
| `CLAUDE_CODE_OAUTH_TOKEN` | Claude Code の OAuth トークン            | AI 自動化ワークフロー全般   |
| `AI_USER_GH_TOKEN`        | AI 用 GitHub Personal Access Token (PAT) | PR 作成・マージ、Issue 操作 |

### デプロイ用（使用するサービスに応じて設定）

| Secret                 | 説明                    | 用途                            |
| ---------------------- | ----------------------- | ------------------------------- |
| `CLOUDFLARE_API_TOKEN` | Cloudflare API トークン | Cloudflare Workers へのデプロイ |
| `VERCEL_TOKEN`         | Vercel トークン         | Vercel へのデプロイ             |
| `NETLIFY_AUTH_TOKEN`   | Netlify 認証トークン    | Netlify へのデプロイ            |
| `NETLIFY_SITE_ID`      | Netlify サイト ID       | Netlify へのデプロイ            |

## Secrets の取得方法

### CLAUDE_CODE_OAUTH_TOKEN

1. [Claude Code](https://claude.ai/code) にアクセス
2. 設定から OAuth トークンを生成
3. リポジトリの Settings > Secrets and variables > Actions に追加

### AI_USER_GH_TOKEN

AI 自動化用の GitHub Personal Access Token を作成します。

1. GitHub の Settings > Developer settings > Personal access tokens > Fine-grained tokens
2. 「Generate new token」をクリック
3. 以下の権限を付与:
   - **Repository permissions:**
     - Contents: Read and write
     - Issues: Read and write
     - Pull requests: Read and write
     - Metadata: Read-only
4. トークンを生成し、リポジトリの Secrets に追加

> **Note:** Dependabot の自動マージには、CODEOWNERS 以外のユーザーからの approve が必要です。
> そのため、リポジトリオーナーとは別のユーザー（bot アカウントなど）の PAT を使用することを推奨します。

### Dependabot 用の Secrets

Dependabot が使用する secrets は、通常の Actions secrets とは別に設定が必要です。

1. リポジトリの Settings > Secrets and variables > Dependabot
2. 「New repository secret」をクリック
3. `AI_USER_GH_TOKEN` を追加

> **Important:** `dependabot-auto-merge.yaml` は `pull_request_target` イベントを使用するため、
> Dependabot secrets ではなく通常の Actions secrets から `AI_USER_GH_TOKEN` を読み取ります。

## ワークフロー一覧

### AI 自動化

| ワークフロー                       | トリガー                    | 説明                               |
| ---------------------------------- | --------------------------- | ---------------------------------- |
| `claude.yaml`                      | `@claude` メンション        | Issue/PR で Claude に質問・依頼    |
| `ai-automate.yaml`                 | `ai-automate:claude` ラベル | Issue から自動実装して PR 作成     |
| `ai-automate-coderabbit-plan.yaml` | CodeRabbit Plan             | CodeRabbit の計画に基づいて実装    |
| `ai-fix-unresolved-review.yaml`    | レビュー / `.fix-reviews`   | 未解決のレビューコメントを自動修正 |

### CI/CD

| ワークフロー                 | トリガー              | 説明                     |
| ---------------------------- | --------------------- | ------------------------ |
| `test.yaml`                  | push/PR to main       | テスト実行               |
| `deploy-preview.yaml`        | PR / push (main 以外) | プレビュー環境にデプロイ |
| `deploy.yaml`                | workflow_dispatch     | 本番環境にデプロイ       |
| `dependabot-auto-merge.yaml` | Dependabot PR         | 依存関係更新の自動マージ |

## Issue テンプレート

| テンプレート     | ラベル               | 説明          |
| ---------------- | -------------------- | ------------- |
| `ai-automate.md` | `ai-automate:claude` | AI 自動実装用 |
| `ai-planning.md` | `ai-planning`        | AI 実装計画用 |

## カスタマイズ

### パッケージマネージャーの変更

デフォルトは Bun です。npm に変更する場合は、各ワークフローのコメントを参照してください。

### モノレポ対応

`defaults.run.working-directory` のコメントを解除し、適切なディレクトリを指定してください。

### デプロイ先の変更

`deploy.yaml` と `deploy-preview.yaml` には、Cloudflare Workers / Vercel / Netlify の設定例があります。
使用するサービスに応じてコメントを解除してください。
