#!/usr/bin/env zsh
alias wget='wget --hist-file="${XDG_CACHE_HOME:-~/.cache}/wget-hsts"'
if [[ ! -z $(ps cax | grep urxvtd) ]]; then
	alias urxvt="$(which urxvtc)"
	alias urxvtc="$(which urxvt)"
fi
