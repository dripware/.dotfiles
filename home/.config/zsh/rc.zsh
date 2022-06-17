#!/usr/bin/env zsh
source "$ZDOTDIR/alias.zsh"

# set colors for ls command
[[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )) && eval "$(dircolors -b)"
# use ls colors for zsh file completions aswell
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#####################
# PLUGINS 
#####################
# initialize zert (zsh diy package manager)
autoload -Uz "$ZDOTDIR/zert/zert"
zert init

# OH MY ZSH 
#####################
# all plugins and libraries from oh my zsh framework should be defined
# here. make sure oh my zsh utilization is done after loading normal plugins
# and utilizing prezto
zert utilize ohmyzsh

# cross-platform clipboard integration (clipcopy and clippaste commands)
# clipcopy <file> # copies file content to clipboard
# <command> | clipcopy # copies stdout to clipboard
# clippaste > <file> # paste clipboard to file
# clippaste | <command> # paste clipboard to stdin
zert load @ohmyzsh:lib:clipboard

#####################
# ZSH OPTIONS 
#####################
# automatically add directories to "directory stack" after each cd
# required for 'cd -' and 'cd -1','cd -2' etc.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt no_global_rcs
setopt ksh_glob
