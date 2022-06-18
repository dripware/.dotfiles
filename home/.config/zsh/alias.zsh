#!/usr/bin/env zsh

# make ls use colors and hide group names in ls -al
alias ls='ls --color=tty -G' 

# swap ls for lsd if possible alias ls='lsd'
command -v lsd &> /dev/null && alias ls='lsd'

# commonly used aliases for ls
alias lsa='ls -lAh'
alias l='ls -lAh'
alias la='ls -lAh'
alias ll='ls -lh'

# tree view
if command -v lsd &> /dev/null; then alias lst='lsd --tree';
elif command -v tree &> /dev/null; then alias lst='tree';
else alias lst="find . -not -path '*/.*' | sed -e \"s/[^-][^\/]*\//  |/g\" -e \"s/|\([^ ]\)/|-\1/\""; fi

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

# human readable file sizes
alias df="df -h"
alias du="du -h"
