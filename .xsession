#!/bin/sh
. $HOME/profile

export EDITOR="vim"
export LANG=en_US.UTF-8

xsetroot -solid dimgray
xsetroot -cursor_name left_ptr
dunst &
xrdb -merge "$HOME/.Xresources"
~/.local/bin/bar.sh &
~/.local/bin/net_popup.sh &
ulimit -Sc 0
cwm
