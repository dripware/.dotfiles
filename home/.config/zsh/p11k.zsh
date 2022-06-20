#!/usr/bin/env zsh
# i add custom function and variables for powerlevel10k prompt here
# for easier access

# manually control transient_prompt. after running each command
# the prompt will change to become only the current directory
# and the prompt_char
function p10k-on-post-prompt() { # ran after pressing enter
  # left full prompt configs
  POWERLEVEL11K_MAIN_LEFT_PROMPT=$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS 
  # right full prompt configs
  POWERLEVEL11K_MAIN_RIGHT_PROMPT=$POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS 
  # left mini prompt configs
  POWERLEVEL11K_MINI_LEFT_PROMPT="dir|prompt_char"
  # right mini prompt configs
  POWERLEVEL11K_MINI_RIGHT_PROMPT=""
  # keep last executed command
  POWERLEVEL11K_LAST_COMMAND="$BUFFER"
  
  # hide everything
  p10k display '1/*/*'=hide 
  # print left mini prompt
  p10k display "1/left/($POWERLEVEL11K_MINI_LEFT_PROMPT)"=show 
  #print mini prompt right
  p10k display "1/right/($POWERLEVEL11K_MINI_RIGHT_PROMPT)"=show 
}
function p10k-on-pre-prompt()  { # ran before new prompt prints
  [[ ! -z "$POWERLEVEL11K_LAST_COMMAND" ]] && [[ "clear" != "$POWERLEVEL11K_LAST_COMMAND" ]] && echo
  [[ ! -z "$POWERLEVEL11K_MAIN_LEFT_PROMPT" ]] && {
    # hide everything
    p10k display '1/*/*'=hide 
    #print full left prompt
    p10k display "1/left/(${POWERLEVEL11K_MAIN_LEFT_PROMPT// /|})"=show 
    #print full right prompt
    p10k display "1/right/(${POWERLEVEL11K_MAIN_RIGHT_PROMPT// /|})"=show 
  }
}
