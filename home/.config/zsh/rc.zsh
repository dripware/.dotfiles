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

# don't use any default rc files
setopt no_global_rcs 

# use bash-like extended globbing (!,@,#,+)
setopt ksh_glob

# if globbing has no matches throw an error
setopt no_match

# ignore contigouos duplicates
setopt hist_ignore_dups

# don't add commands which start with a space (or an alias with a leading space)
setopt hist_ignore_space

# don't export if you don't want shared history between zsh and bash
HISTFILE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history

# run background jobs at lower priority
setopt bg_nice

# no beep
setopt no_beep

# if a globbing pattern has no result return an error
setopt no_match

# on ambigous completion insert the first completion immediatly
setopt menu_complete

# Disable Ctrl-s to freeze terminal
stty stop undef

# include hidden files in completions
_comp_options+=(globdots)
