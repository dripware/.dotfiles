#!/usr/bin/env zsh
# this file will be sourced both by login shell and display managers (tty and x server)

# sets environment variables
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/env.zsh"

# exports and environment variable used by fzf
source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf_default_opts"
