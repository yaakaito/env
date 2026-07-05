# History

この reference は、過去バージョンを確認しながら同期判断をする必要があるときに読む。

## When to inspect history

履歴を辿る場面:

- 端末側のファイルが repo より新しいが、どの変更が一般化済みか分からない。
- `setup.sh` が参照するファイルと repo の実体が食い違う。
- skill が repo から消えているが、端末側に残っていて削除してよいか判断できない。
- ある設定が意図的に削除されたのか、移動したのか、誤って消えたのか確認したい。

## Useful commands

関連する履歴を狭く見る。

```bash
git log --oneline --decorate -- setup.sh dotfiles skills .claude/skills/dotfiles-skill-sync
git log --oneline --decorate -- skills dotfiles/.codex .claude/skills
git log --name-status -- setup.sh dotfiles skills .claude/skills
```

端末へ配る skill は過去 `dotfiles/.claude/skills` に置かれていた。repo root `skills/` への移動より前の履歴は旧 path か `git log --follow` で辿る。

特定ファイルの過去内容を見る。

```bash
git show <commit>:setup.sh
git show <commit>:dotfiles/.codex/config.toml
git show <commit>:dotfiles/.claude/settings.json
git show <commit>:.claude/skills/dotfiles-skill-sync/SKILL.md
```

削除・リネームを追う。

```bash
git log --diff-filter=D --summary -- dotfiles skills .claude/skills
git log --follow -- dotfiles/path/to/file
```

コミット間で setup 対象の変化を見る。

```bash
git diff <old>..<new> -- setup.sh dotfiles skills .claude/skills
```

## Recording findings

履歴調査の結果は会話内の同期計画に要約する。端末固有ファイルの内容や秘密情報を repo の `references/` に記録しない。

一般化できるルールが見つかった場合だけ、この skill または reference に反映する。
