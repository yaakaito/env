autoload -Uz compinit
compinit

# Make Tab complete only. If no completion is available, zle beeps instead of
# inserting a literal tab into the command line.
bindkey -M emacs '^I' expand-or-complete
bindkey -M viins '^I' expand-or-complete
