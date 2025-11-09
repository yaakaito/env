GitHub 上の PR から対応が必要なレビューコメントを取得し、修正を行います。

1. gh を使って、現在のリポジトリの owner reponame pr-number を取得します。
2. 以下のコマンドを実行して、未解決のレビューコメントを取得してください、$ONWER $REPO $PR_NUMBER は 1. で取得したものに置き換えてください。

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
        pullRequest(number: $number) {
        reviewThreads(first: 100) {
            nodes {
                isResolved
                isOutdated
                comments(first: 10) {
                    nodes {
                        author { login }
                        body
                        path
                        line
                        }
                    }
                }
            }
        }
    }
}' -f owner="$OWNER" -f repo="$REPO" -F number=$PR_NUMBER | jq -r '.data.repository.pullRequest.reviewThreads.nodes
    | map(select(.isResolved == false))
    | .[]
    | "<review-comment>\n  <file>\(.comments.nodes[0].path)</file>\n  <line>\(.comments.nodes[0].line)</line>\n
<author>\(.comments.nodes[0].author.login)</author>\n  <body>\(.comments.nodes[0].body)</body>\n</review-comment>\n"'
```

3. 取得した review-comments を一つづつ確認してすべて修正してください。
4. 一つ修正を行う事にその内容を commit してください。
5. すべての修正が完了するまで繰り返します。
6. すべての修正が完了したら、ブランチを remote へ push してください。
