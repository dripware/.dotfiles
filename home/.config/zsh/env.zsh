#!/usr/bin/env zsh
# sourced by both display managers and login shells (tty and xserver)

export SHELL="$(which zsh)" # default shell

# XDG variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"

# move application specific config, data and cache to XDG directories for cleaner $HOME
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc" # GNU read line library (bash,sqlite,bc)
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh" # zsh config folder
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible.cfg"
export MOST_INITFILE="${XDG_CONFIG_HOME:-$HOME/.config}/most/lesskeys.rc" # most pager

export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wine/default"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/sahre}/go"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison" # file sync
export ELECTRUMDIR="${XDG_DATA_HOME:-$HOME/.local/share}/electrum"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"

export LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst" # history cache for less

export TMUX_TMPDIR="$XDG_RUNTIME_DIR"


export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
command -v most &> /dev/null && export PAGER="most" || export PAGER="less"
