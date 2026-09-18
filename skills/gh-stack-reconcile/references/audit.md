# 履歴と構成の audit

SKILL.md の安全条件を確認してから行う。
診断では remote-tracking ref の取得と記録にとどめ、working tree、local branch、stack metadata を変更しない。

## 1. 現在の状態を記録する

`gh stack view --json` から trunk、現在 branch、bottom-to-top の branch 順、各 PR number を記録する。
続けて以下を記録する。

```bash
git status --porcelain=v1 --untracked-files=all
git worktree list --porcelain
git rev-parse --git-dir
```

trunk と全 stack branch について、local SHA を `git rev-parse refs/heads/<branch>` で記録する。
この記録は後の `git update-ref` の old-value と検証に使う。

trunk または対象 branch が別 worktree で checkout されている場合は、ref を動かさず worktree path を報告して止める。

## 2. remote の事実を取得する

trunk と全 active stack branch を、具体的な branch 名を含む強制 fetch refspec で取得する。
これは remote-tracking ref だけを更新し、local branch は動かさない。

```bash
git fetch <remote> +refs/heads/<branch>:refs/remotes/<remote>/<branch>
```

Stacked PRs が有効で PR がある場合は、任意の既知 PR を使って read-only API `repos/{owner}/{repo}/stacks?pull_request=<pr-number>` を取得し、remote stack の PR 順を確認する。
各 PR は `gh pr view <number> --json number,headRefName,baseRefName,state` で head/base branch を確認する。
remote にだけある branch も同じ明示的 refspec で fetch する。
local の記録だけから remote 構成を推測しない。

remote stack が存在しない場合は、記録済みの local branch 順を比較対象とする。
ただし remote に存在しない active branch は内容不明として扱い、再構築を止める。
merged branch の remote ref が削除済みなら、内容比較と ref 更新の対象から外す。

## 3. rebase 以外の乖離を audit する

まず local trunk と remote trunk を比較する。
同じ SHA または local が remote の祖先なら、trunk は remote と一致させられる。
local にだけ commit がある場合や両者が diverge している場合は `content-diverged` とする。

次に remote の active bottom-to-top chain を検証する。
bottom の parent は `<remote>/<trunk>`、それより上の parent は直下の active `<remote>/<branch>` とする。

```bash
git merge-base --is-ancestor <remote-parent> <remote-head>
```

exit 0 は有効な親子関係、exit 1 は ancestry の不一致、それ以外は判定不能として扱う。
失敗する layer があれば remote 自体が有効な linear stack ではない。
local を remote refs に合わせても gh-stack を再構築できない。
診断だけならその結果を報告して止める。
再構築依頼なら [rebuild.md](rebuild.md) の退避までを行い、再構築せずに報告する。

次に layer ごとに、local と remote の「その layer が追加した commit range」を比較する。

- bottom: `local-trunk..local-bottom` と `remote/trunk..remote/bottom`
- それより上: `local-parent..local-branch` と `remote/parent..remote/branch`

```bash
git range-diff --no-color --no-patch <local-range> <remote-range>
git rev-list --merges <local-range>
git rev-list --merges <remote-range>
```

判定は保守的に行う。

- SHA が同じなら `same`。
- 全 commit が同じ順序で一対一に対応し、`range-diff` が `=` だけなら `rebase-only`。
- `!`、`<`、`>`、順序変更、merge commit、構成差、remote-only/local-only commit、または比較不能があれば `content-diverged`。
  commit message の変更も乖離として扱う。
- 一見似ていることを理由に `rebase-only` と推測しない。
  不明なら `content-diverged` とする。

結果を `layer / local SHA / remote SHA / classification / evidence` の表でまとめる。
