#!/usr/bin/env zsh

# move wget history file to better place for cleaner $HOME
alias wget='wget --hist-file="${XDG_CACHE_HOME:-~/.cache}/wget-hsts"' 

# make ls use colors and hide group names in ls -al
alias ls='ls --color=tty -G' 

# commonly used aliases for ls
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

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