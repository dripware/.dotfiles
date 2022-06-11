#!/usr/bin/env zsh
ANTIGEN=${XDG_DATA_HOME:~/.local/share}/antigen.zsh
if [ ! -f $ANTIGEN ]; then
	echo "installing antigen... (this only happens once"
	curl -L git.io/antigen > ${XDG_DATA_HOME:~/.local/share}/antigen.zsh
fi
$ANTIGEN
