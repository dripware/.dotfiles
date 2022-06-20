#!/usr/bin/env zsh
# i add custom function and variables for powerlevel10k prompt here
# for easier access

# manually control transient_prompt. after running each command
# the prompt will change to become only the current directory
# and the prompt_char
function p10k-on-post-prompt() { # ran after pressing enter
	MAIN_LEFT_PROMPT=$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS # save full left prompt configs
	MAIN_RIGHT_PROMPT=$POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS # save full right prompt configs

	p10k display '1/*/*'=hide # hide everything
	p10k display '1/left/(dir|prompt_char)'=show # print mini prompt left
	p10k display '1/right/()'=show #print mini prompt right
}
function p10k-on-pre-prompt()  { # ran before new prompt prints
	[[ ! -z "$MAIN_LEFT_PROMPT" ]] && {
	p10k display '1/*/*'=hide # hide everything
	p10k display "1/left/(${MAIN_LEFT_PROMPT// /|})"=show #print full left prompt
	p10k display "1/right/(${MAIN_RIGHT_PROMPT// /|})"=show #print full right prompt
	}
}
