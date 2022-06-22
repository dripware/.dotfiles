#!/usr/bin/env zsh
# colored man pages for less
export LESS_TERMCAP_md="$(tput bold; tput setaf 4)"
export LESS_TERMCAP_me="$(tput sgr0)"
export LESS_TERMCAP_mb="$(tput blink)"
export LESS_TERMCAP_us="$(tput setaf 4)"
export LESS_TERMCAP_ue="$(tput sgr0)"
export LESS_TERMCAP_so="$(tput smso)"
export LESS_TERMCAP_se="$(tput rmso)"
