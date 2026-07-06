#!/usr/bin/env zsh
# prompt.zsh のディレクトリ省略表示のテスト。実行: zsh dotfiles/zsh/prompt.test.zsh
emulate -L zsh
source ${0:a:h}/prompt.zsh

typeset -i failures=0

assert_abbrev() {
  local input=$1 expected=$2
  local actual=$(__prompt_abbrev_pwd $input)
  if [[ $actual == $expected ]]; then
    print -r -- "ok:   $input -> $actual"
  else
    print -r -- "FAIL: $input -> $actual (expected: $expected)"
    (( failures++ ))
  fi
}

# 短いパスはそのまま(省略対象の親ディレクトリが ~ や / しかない)
assert_abbrev '~' '~'
assert_abbrev '/' '/'
assert_abbrev '~/src' '~/src'

# 親ディレクトリは頭文字 1 文字、最後の要素だけフル表示
assert_abbrev '/workspaces/aiblio' '/w/aiblio'
assert_abbrev '~/src/github.com/yaakaito/editor' '~/s/g/y/editor'

# 隠しディレクトリは . だけでは区別できないので .g のように 2 文字残す
assert_abbrev '~/src/github.com/yaakaito/editor/.git/threads/claude/sidepane-04-html-preview' \
  '~/s/g/y/e/.g/t/c/sidepane-04-html-preview'

# 名前付きディレクトリ(~editor など)は短縮すると意味が消えるのでそのまま
assert_abbrev '~editor/foo/bar' '~editor/f/bar'

if (( failures > 0 )); then
  print -r -- "$failures test(s) failed"
  exit 1
fi
print 'all passed'
