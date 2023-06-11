#!/usr/bin/env bash

languages=$(echo "php typescript javascript rust scss css html" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")

selected=$(echo -e "$languages\n$core_utils" | fzf)
window_size=40

read -p "provide query: " query

if echo "$languages" | grep -qs $selected 2> /dev/null; then
	tmux split-window -p $window_size -v bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less"
else
	tmux split-window -p $window_size -v bash -c "curl cht.sh/$selected~$query | less"
fi
