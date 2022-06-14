#!/usr/bin/env zsh
ANTIGEN="${XDG_DATA_HOME:-~/.local/share}/antigen/antigen.zsh"
if [ ! -f $ANTIGEN ]; then
	[ ! -d $(dirname $ANTIGEN) ] && mkdir $(dirname $ANTIGEN)
	echo "installing antigen plugin manager for zsh (this only happens once)..."
	curl -L git.io/antigen -o $ANTIGEN -s
	chmod +x $ANTIGEN
fi

export ADOTDIR=${XDG_DATA_HOME:-~/.local/share}/antigen
export ANTIGEN_LOCK=${XDG_DA
source $ANTIGEN
