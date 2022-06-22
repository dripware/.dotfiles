#!/usr/bin/env zsh
# enable powerlevel10k instant prompt if available
# this should always be at the top of zshrc
# makes prompt lag disappear
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
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

# LOCAL PLUGINS
#####################

# don't execute command if a alias is available and force user to use the alias
source $ZDOTDIR/src/alias_trainer.plugin.zsh

# colored man page
source $ZDOTDIR/src/colored_man_page.plugin.zsh

# NORMAL PLUGINS
#####################

# syntax highlighting
zert load https://github.com/zdharma-continuum/fast-syntax-highlighting

# prompt 
zert load https://github.com/romkatv/powerlevel10k
source "${ZDOTDIR}/p11k.zsh"


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

# recommend available aliases for entered command
zert load @ohmyzsh:plugin:alias-finder

#####################
# ZSH OPTIONS 
#####################
# automatically add directories to "directory stack" after each cd
# required for 'cd -' and 'cd -1','cd -2' etc.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_minus

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

# don't store the "history" command itself in history
setopt hist_no_store

# add entered command to $HISTFILE immediatly
setopt inc_append_history

# don't export this if you don't want shared history between zsh and bash
HISTFILE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history

# how big should $HISTFILE be
SAVEHIST=4000

# run background jobs at lower priority
setopt bg_nice

# no beep
setopt no_beep

# if a globbing pattern has no result return an error
setopt no_match

# on ambigous completion insert the first completion immediatly
setopt menu_complete

# include hidden files in completions
_comp_options+=(globdots)

# if a p10k config is available use it
[[ -f $ZDOTDIR/p10k.zsh ]] && source $ZDOTDIR/p10k.zsh
