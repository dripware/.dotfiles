#!/usr/bin/env zsh
# sourced by both display managers and login shells (tty and xserver)
export IS_ZSH_LOADED=true

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

export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wine/default"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/sahre}/go"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison" # file sync
export ELECTRUMDIR="${XDG_DATA_HOME:-$HOME/.local/share}/electrum"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"

export LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst" # history cache for less

export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# environment variables used by fzf
source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf_default_opts"

# add npm global package binaries to path
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin:$PATH"
# add .local/bin scripts and binaries to PATH
export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"

# use neovim or vim as default editor if possible
if command -v nvim &> /dev/null; then
	export EDITOR="nvim"
elif command -v vim &> /dev/null; then
	export EDITOR="vim"
fi

# use wezterm or urxvt as terminal if possible
# you should configure your window manager to pick up $TERMINAL
# because it doesn't recognize it by default
# if command -v wezterm &> /dev/null; then 
# 	export TERMINAL="wezterm"
# elif command -v urxvtc &> /dev/null; then # because urxvt itself is a .local/bin script
# 	# if wezterm is not avilable it's probably running in a vm
# 	export TERMINAL="urxvt" 
# else
# 	export TERMINAL="xterm"
# fi
export DOTFILES="$HOME/.dotfiles"
