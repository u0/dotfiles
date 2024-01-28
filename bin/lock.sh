#!/usr/bin/env sh

icon="$HOME/.xlock/lock.png"
tmpbg='/tmp/screen.png'
res="$(xdpyinfo | grep 'dimensions:' | tr x ' ' | awk '{print $2 "x" $3}')"

(( $# )) && { icon=$1; }

scrot "$tmpbg"
ffmpeg -f x11grab -video_size $res -y -i $DISPLAY -i $icon -filter_complex "boxblur=5,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $tmpbg
i3lock -i "$tmpbg"
