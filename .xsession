#!/bin/sh
PREFIX_LOCAL="/usr/local/"
PREFIX="/usr/X11R6"
EXEC_PREFIX="${PREFIX}"
EXEC_LOCAL="${PREFIX_LOCAL}"

# Export important environment variables
export EDITOR="vim"
export LANG=en_US.UTF-8

# X11 modifications, background, cursor, merge .Xresources
${EXEC_PREFIX}/bin/xsetroot -solid \#000000
${EXEC_PREFIX}/bin/xsetroot -cursor_name left_ptr
${EXEC_PREFIX}/bin/xrdb -merge "$HOME/.Xresources"

# Initialize dunst for notifications
${EXEC_LOCAL}/bin/dunst &

# Lemonbar script and internet checker on startup
${HOME}/.local/bin/bar.sh &
${HOME}/.local/bin/net_popup.sh &

ulimit -Sc 0 # Disable core dump files (*.core)
exec cwm # Execute CWM
