---
name: gh-stack-reconcile
description: remote の rebase や force-push 後に diverge した gh-stack を診断し、local state を退避して remote に合わせて再構築する。履歴書き換えが疑われる non-fast-forward の調査と復旧に使う。通常の sync や一般の Git branch 管理には使わない。
---

# gh-stack reconcile

remote を正として local stack を再構築する。
remote を一切更新せず、純粋な rebase と内容の乖離を layer ごとに区別し、失われ得る local state を先に退避する。

## 安全条件

- 実行前に `gh stack --version` と使う subcommand の `--help` を確認する。
  CLI の挙動は変わり得るため、古い手順を無条件に適用しない。
- この手順では `gh stack sync`、`gh stack push`、`gh stack submit`、force-push を実行しない。
  stack 構成の divergence と Git branch 履歴の divergence は別物である。
- 再構築はユーザーが依頼した場合だけ行う。
  診断だけなら audit と退避案を報告し、stash、backup branch 作成、local branch の ref 更新、stack metadata 変更を行わない。
- remote は引数で指定されたものを使う。
  未指定なら `remote.pushDefault`、単一 remote の順に解決する。
  複数候補が残る場合は推測しない。
- コマンドはすべて非対話で実行する。
  `gh stack view` には必ず `--json`、`gh stack checkout` には stack number、PR number、または PR URL を渡す。
- rebase、merge、cherry-pick、revert、`gh stack modify` の recovery が進行中なら何も変更せず止める。
- 対象 stack に queued PR があれば、merge queue が branch を更新し得るため止める。
  queue から外れた後に最初から audit する。

## 診断と再構築

1. [audit.md](references/audit.md) を読み、local state、remote 構成、layer ごとの内容差を記録する。
   診断だけの依頼は、その結果と退避案を報告して完了とする。
2. 再構築を依頼されている場合は、audit 後に [rebuild.md](references/rebuild.md) を読む。
   未 commit 変更と元の全 branch を退避し、remote chain が有効な場合だけ ref と local metadata を再構築する。
3. 再構築の完了は、branch 順と SHA、working tree、remote に途中変更がないことを検証して判断する。
   backup と stash は保持し、未解決事項と復元に必要な情報を報告する。

診断結果があっても、別の作業を挟んだ場合は状態を取り直す。
競合や前提の変化を検出したら、古い記録で ref を更新しない。
