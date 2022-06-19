#!/usr/bin/env zsh
__prompt_flusher(){
	echo "$region"
	# echo -ne "\r\033[2K" # clear line
	zle accept-line
}
zle -N __prompt_flusher
bindkey '^M' __prompt_flusher
