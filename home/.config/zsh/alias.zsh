#!/usr/bin/env zsh

# make ls use colors and hide group names in ls -al
alias ls='ls --color=tty -G' 

# swap ls for lsd if possible alias ls='lsd'
command -v lsd &> /dev/null && LSD=true
$LSD && alias ls='lsd'

# commonly used aliases for ls
alias l='ls -lAh'
alias la='ls -lAh'
alias ll='ls -lh'
$LSD && alias lt='lsd -lth --group-dirs=none'   || alias lt='ls -lth'
$LSD && alias lS='lsd -lSh --group-dirs=none --total-size'   || alias lS='ls -lSh'
alias l.='ls -ld .*'


# make diff use colors
alias diff='diff --color'

# make grep use colors and ignore some special folders
GREP_OPTIONS="--color=auto --exclude-dir={.git,CVS,.hg,.bzr,.svn,.idea,.tox}"
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
alias fgrep="fgrep $FREP_OPTIONS"
unset GREP_OPTIONS

# make file navigation easier when trying to reach parent directories
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# don't add unnecessary commands to history. for this to work HIST_NO_SPACE
# must be set. (by default zsh keeps the last command in history even if you
# use HIST_NO_SPACE. 'fc -R' forces it to remove that aswell
alias clear=" clear && fc -R" 
alias exit=" exit"

# human readable file sizes
alias df="df -h"
alias du="du -h"

# search in history with fzf
alias history="history | fzf"

# ask before removing or overwriting
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# search through files and directories more easily
alias findd="find . -type d -name"
alias findf="find . -type f -name"

# NIXOS ALIASES
STFU="--allow-dirty" # stfu about git tree being dirty
FLKU="nix flake update $DOTFILES $STFU" # update flake inputs
GETSU="sudo echo" # ask for sudo password first (not during command execution)

alias homs="home-manager switch --flake $DOTFILES#main $STFU"
alias homu="$FLKU && homs"
alias nixs="$GETSU && nixos-rebuild switch --flake $DOTFILES#main --use-remote-sudo"
alias nixu="$GETSU && $FLKU && nixs"
alias update="nixu && homu"
alias upgrade="$GETSU && $FLKU && update"
alias zshrc="exec zshrc"

# typing man is faster than run-help
unalias run-help

unset LSD FLKU GETSU STFU
