---
name: gh-stack-reconcile
description: remote 側で rebase や force-push により履歴が書き換わった gh-stack を、local 固有の変更を退避してから remote に合わせて安全に再構築する。gh stack sync/push が non-fast-forward になる場合や、同名の local/remote branch が diverge している場合に使う。通常の fast-forward sync には使わない。
---

# gh-stack reconcile

remote を正として local stack を再構築する。
remote を一切更新せず、純粋な rebase と内容の乖離を layer ごとに区別し、失われ得る local state を先に退避する。

## 安全条件

- 実行前に `gh stack --version`、`gh stack sync --help`、`gh stack checkout --help`、`gh stack unstack --help` を確認する。
  CLI の挙動は変わり得るため、古い手順を無条件に適用しない。
- audit が完了するまで `gh stack sync`、`gh stack push`、`gh stack submit`、force-push を実行しない。
  stack 構成の divergence と Git branch 履歴の divergence は別物である。
- local branch の ref を動かすのは、ユーザーが再構築を依頼している場合だけにする。
  診断だけなら audit と退避案を報告して止める。
- remote は引数で指定されたものを使う。
  未指定なら `remote.pushDefault`、単一 remote の順に解決する。
  複数候補が残る場合は推測しない。
- コマンドはすべて非対話で実行する。
  `gh stack view` には必ず `--json`、`gh stack checkout` には stack number、PR number、または PR URL を渡す。
- rebase、merge、cherry-pick、revert、`gh stack modify` の recovery が進行中なら何も変更せず止める。
- 対象 stack に queued PR があれば、merge queue が branch を更新し得るため止める。
  queue から外れた後に最初から audit する。

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

### 未 commit 変更

status が空でなければ、local branch の ref を動かす前に tracked、staged、untracked changes をまとめて stash する。

```bash
git stash push --include-untracked -m "gh-stack-reconcile <UTC timestamp> <current-branch>"
git stash list -1 --format='%gd %H %gs'
git status --porcelain=v1 --untracked-files=all
```

stash entry の selector と SHA を記録する。
stash 後も status が空でなければ、submodule など stash されなかった state があるため止める。
再構築後に自動で `stash pop` しない。

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
local を remote refs に合わせても gh-stack を再構築できないため、退避後に止めて報告する。

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

## 4. local state を退避する

1 layer でも `content-diverged` または構成差があれば、元の chain を丸ごと復元できるよう、trunk と全 local stack branch の記録済み SHA に backup branch を作る。
remote には push しない。

```bash
git check-ref-format --branch backup/gh-stack-reconcile/<UTC timestamp>/<original-branch>
git branch backup/gh-stack-reconcile/<UTC timestamp>/<original-branch> <recorded-local-SHA>
git rev-parse refs/heads/backup/gh-stack-reconcile/<UTC timestamp>/<original-branch>
```

作成前に同名 branch がないことを確認し、作成後の SHA が記録値と一致することを trunk と全 branch で検証する。
どれか一つでも失敗したら再構築へ進まない。

`rebase-only` だけの場合も、ref を動かす前に同じ backup branches を作って rollback point を残す。
内容の乖離がある場合は保存用、ない場合は操作失敗時の recovery 用である。
削除はユーザーが明示的に依頼するまで行わない。

backup を gh-stack として継続利用したいという明示的な要望がある場合に限り、再構築完了後、コピーした branch chain を bottom-to-top 順で別 stack に `gh stack init --base <trunk> <backup-branches...>` する。
通常は ordinary local branches のまま残す。

## 5. local stack を remote に合わせて再構築する

remote stack を特定できる PR number または stack number を先に控える。
その後、現在の stack branch 上で local tracking だけを外す。

```bash
gh stack unstack --local
```

remote chain が全 layer で有効な場合だけ再構築へ進む。
ref を動かす直前に対象 active branch を再度 fetch し、remote SHA が audit 時の記録から変わっていないことを確認する。
変わっていれば audit からやり直す。

clean な detached HEAD へ移動し、local trunk と各 active local branch ref を対応する remote SHA へ動かす。
全 ref は一つの `git update-ref --stdin` transaction で更新する。
各 `update` には記録済み local SHA を old-value として渡し、途中の競合や別 process の更新を検出する。
active branch ごとに `update` 行を一つずつ渡す。

```bash
git switch --detach <remote>/<trunk>
printf '%s\n' \
  'start' \
  'update refs/heads/<trunk> <recorded-remote-trunk-SHA> <recorded-local-trunk-SHA>' \
  'update refs/heads/<branch> <recorded-remote-SHA> <recorded-local-SHA>' \
  'prepare' \
  'commit' | git update-ref --stdin
```

remote stack にない local branch は削除せず ordinary branch として残す。
remote にだけある branch は `gh stack checkout` に取得させる。

Stacked PRs がある場合は、remote source of truth から local metadata を再作成する。

```bash
gh stack checkout <stack-number-or-pr-number>
```

複数 remote があり `checkout` の remote 解決が曖昧なら、既存設定を無断で変更せず、選んだ remote と `remote.pushDefault` を一致させてから実行する。
Stacked PRs がない場合は、remote と一致させた既存 branch を bottom-to-top 順で採用する。

```bash
gh stack init --base <trunk> <branch-1> <branch-2> ...
```

ref 更新や checkout/import が一部でも失敗したら、それ以上進めない。
backup branch と記録済み SHA から復元できる状態を保って報告する。

## 6. 検証して引き渡す

以下をすべて確認する。

- `gh stack view --json` の trunk と branch 順が remote stack と一致する。
- local trunk SHA が `refs/remotes/<remote>/<trunk>` と一致する。
- 各 active local branch SHA が `refs/remotes/<remote>/<branch>` と一致する。
- remote chain の parent が各 child の ancestor である。
- working tree が clean である。
- `git ls-remote --heads <remote> refs/heads/<branch>` の SHA が audit 時の active remote SHA と一致し、操作中に remote ref が変わっていない。

この時点でも `gh stack sync` や push は自動実行しない。
rebase-only layer、内容差のある layer、作成した backup branches、stash entry、未解決事項を報告する。
stash は、ユーザーが適用先を選んだ後に `git stash apply <recorded-stash-selector>` で戻せるよう残す。
