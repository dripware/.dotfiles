#!/usr/bin/env zsh
# i add custom function and variables for powerlevel10k prompt here
# for easier access

# manually control transient_prompt. after running each command
# the prompt will change to become only the current directory
# and the prompt_char
function p10k-on-post-prompt() { # ran after pressing enter
	MAIN_PROMPT=$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS # save full prompt configs
	p10k display '1/*/*'=hide # hide everything
	p10k display '1/left/(dir|prompt_char)'=show # print mini prompt
}
function p10k-on-pre-prompt()  { # ran before new prompt prints
	[[ ! -z "$MAIN_PROMPT" ]] && {
	p10k display '1/*/*'=hide # hide everything
	p10k display "1/left/(${MAIN_PROMPT// /|})"=show #print full prompt
	}
}
