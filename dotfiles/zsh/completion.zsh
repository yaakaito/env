autoload -Uz compinit
compinit

# Do not suggest history entries that contain literal tab characters.
if [[ -z ${ZSH_AUTOSUGGEST_HISTORY_IGNORE:-} ]]; then
  ZSH_AUTOSUGGEST_HISTORY_IGNORE=$'*\t*'
fi

# Make Tab complete only. If no completion is available, zle beeps instead of
# inserting a literal tab into the command line.
zstyle ':completion:*' insert-tab false
bindkey -M emacs '^I' complete-word
bindkey -M viins '^I' complete-word
