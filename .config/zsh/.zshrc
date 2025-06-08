# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mykhailo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

PS1="[%F{6}%n@%m %F{1}%1~%F{7}]$ "

export LC_TIME="C.UTF-8"
export LC_PAPER="C.UTF-8"
export LC_MEASUREMENT="C.UTF-8"
set -o vi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vi='nvim'

if command -v tmux >/dev/null 2>&1; then
  if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
    exec tmux
  fi
fi
