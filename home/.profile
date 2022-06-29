#!/usr/bin/env sh
if [[ "$(ps -aux | grep 'nixos-rebuild' )" != "" ]]; then
	exec zsh -lc ""
else
	exec zsh -lc ""
fi
