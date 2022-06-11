#!/usr/bin/env zsh
ANTIGEN="${XDG_DATA_HOME:-~/.local/share}/antigen.zsh"
if [ ! -f $ANTIGEN ]; then
	curl -L git.io/antigen -o $ANTIGEN
	chmod +x $ANTIGEN
fi
source $ANTIGEN
