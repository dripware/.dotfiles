#!/usr/bin/env
# if an alias for entered command ( or part of the command) is available
# stop execution of command and force user to use the alias instead
# useful to learn new aliases and detect unnecessary ones
# this requires alias-finder plugin from ohmyzsh to work
function __alias_trainer(){
	local RESULT=$(alias-finder "$BUFFER")
	if [[ "$RESULT" != "" ]]; then 
		echo '\n\033[0;34mUse Alias Instead\033[0;30m'
		alias-finder "$BUFFER"
		echo -ne '\n'
		BUFFER=""
		p10k display -r
	else
		zle accept-line
	fi
}
zle -N __alias_trainer
bindkey '^M' __alias_trainer
