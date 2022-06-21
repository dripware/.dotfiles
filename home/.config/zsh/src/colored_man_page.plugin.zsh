#!/usr/bin/env zsh
# colored man pages for less (default pager is most. so this will only be useful
# if most is not installed or less is explicitly chosen)
export LESS_TERMCAP_md="$(tput bold; tput setaf 4)"
export LESS_TERMCAP_me="$(tput sgr0)"
export LESS_TERMCAP_mb="$(tput blink)"
export LESS_TERMCAP_us="$(tput setaf 4)"
export LESS_TERMCAP_ue="$(tput sgr0)"
export LESS_TERMCAP_so="$(tput smso)"
export LESS_TERMCAP_se="$(tput rmso)"
