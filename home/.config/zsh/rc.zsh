#!/usr/bin/env zsh
setopt no_global_rcs
source "$ZDOTDIR/alias.zsh"
autoload -Uz $ZDOTDIR/zert/* # lazy load zert
export ZERTDIR=$HOME/.local/share/zsh/zert
