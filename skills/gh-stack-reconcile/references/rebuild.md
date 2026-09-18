# local stack の退避と再構築

再構築の依頼があり、[audit.md](audit.md) の記録が揃った場合にだけ行う。
SKILL.md の安全条件を引き続き適用する。

## 1. 未 commit 変更を退避する

status が空でなければ、local branch の ref を動かす前に tracked、staged、untracked changes をまとめて stash する。

```bash
git stash push --include-untracked -m "gh-stack-reconcile <UTC timestamp> <current-branch>"
git stash list -1 --format='%gd %H %gs'
git status --porcelain=v1 --untracked-files=all
```

stash entry の selector と SHA を記録する。
stash 後も status が空でなければ、submodule など stash されなかった state があるため止める。
再構築後に自動で `stash pop` しない。

## 2. local branch を退避する

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

## 3. local stack を remote に合わせて再構築する

remote stack を特定できる PR number または stack number を先に控える。
remote chain が全 layer で有効な場合だけ再構築へ進む。
変更直前に trunk と対象 active branch を再度 fetch し、remote SHA が audit 時の記録から変わっていないことを確認する。
worktree の使用状況、進行中の操作、merge queue も再確認する。
変わっていれば変更せず audit からやり直す。

その後、現在の stack branch 上で local tracking だけを外す。

```bash
gh stack unstack --local
```

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

## 4. 検証して引き渡す

以下をすべて確認する。

- `gh stack view --json` の trunk と branch 順が remote stack と一致する。
- local trunk SHA が `refs/remotes/<remote>/<trunk>` と一致する。
- 各 active local branch SHA が `refs/remotes/<remote>/<branch>` と一致する。
- remote chain の parent が各 child の ancestor である。
- working tree が clean である。
- trunk と全 active branch について、`git ls-remote --heads <remote> refs/heads/<branch>` の SHA が audit 時の remote SHA と一致し、操作中に remote ref が変わっていない。

この時点でも `gh stack sync` や push は自動実行しない。
rebase-only layer、内容差のある layer、作成した backup branches、stash entry、未解決事項を報告する。
stash は、ユーザーが適用先を選んだ後に `git stash apply <recorded-stash-selector>` で戻せるよう残す。
