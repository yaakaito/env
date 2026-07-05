# oh-my-zsh を使わないプロンプト。表示するのは以下だけ:
#   [992 ms]                        <- 直前コマンドの実行時間
#   /workspaces/aiblio (main*?) $   <- pwd と git ステータス(右端に現在時刻)
# git ステータスの記号: + staged / * unstaged / ? untracked

zmodload zsh/datetime
autoload -Uz vcs_info add-zsh-hook

setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats '(%F{red}%b%f%F{yellow}%u%c%f) '
zstyle ':vcs_info:git:*' actionformats '(%F{red}%b%f|%F{yellow}%a%f) '
zstyle ':vcs_info:git+set-message:*' hooks git-untracked

# vcs_info の %u/%c は untracked を検出しないので ? を自前で足す
+vi-git-untracked() {
  if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null | head -n 1) ]]; then
    hook_com[unstaged]+='?'
  fi
}

__prompt_command_start=
__prompt_duration_line=

__prompt_start_timer() {
  __prompt_command_start=$EPOCHREALTIME
}

__prompt_refresh() {
  # vcs_info より先に経過時間を確定させ、git の処理時間を表示に混ぜない
  local -F now=$EPOCHREALTIME
  vcs_info
  __prompt_duration_line=
  # 空 Enter では preexec が走らない = 計測開始がないので時間表示を出さない
  [[ -n $__prompt_command_start ]] || return 0
  local -F elapsed=$((now - __prompt_command_start))
  __prompt_command_start=
  local formatted
  if (( elapsed < 1.0 )); then
    formatted=$(printf '%.0f ms' $((elapsed * 1000)))
  else
    formatted=$(printf '%.1f s' $elapsed)
  fi
  __prompt_duration_line="[%F{yellow}${formatted}%f]"$'\n'
}

add-zsh-hook preexec __prompt_start_timer
add-zsh-hook precmd __prompt_refresh

PROMPT='${__prompt_duration_line}%F{cyan}%~%f ${vcs_info_msg_0_}$ '
RPROMPT='%F{244}%*%f'
