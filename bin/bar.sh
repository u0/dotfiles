#!/usr/bin/env sh

MAINFONT="dinamedium8"
BARHEIGHT="1900x20+10+10"
FGCOLOR="#EEEEEE"
BGCOLOR="#000000"

clock() {
	TIME=`date +"%a %b %Y %T"`
	echo -e "$TIME"
}

groups() {
    # print current group and shown groups
    cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`

    for wid in `xprop -root _NET_CLIENT_LIST | sed '/_LIST(WINDOW)/!d;s/.*# //;s/,//g'`; do
        grp=`xprop -id $wid _NET_WM_DESKTOP | awk '{print $3}'`
        shown="$shown $grp"
    done

    shown=`echo $shown | tr " " "\n" | sort -g | uniq`

    for g in `seq 1 9`; do
        if test $g == $cur; then
            groups="${groups} [$g] "
        elif echo "$shown" | grep -q $g; then
            groups="${groups} $g "
        else
            groups="${groups}"
        fi
    done

	echo -e " $groups"
}

title() {
    curwin=`xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2`

    if [ $curwin != "0x0" ]
    then
        curwin=`xprop -id ${curwin} _NET_WM_NAME | awk -F '"' '{print $2}' | cut -c -80`
    else
        curwin=""
    fi

    echo -e "$curwin"
}


tasks() {
    total=`task +READY count`
    today=`task +READY +TODAY count`
    tomorrow=`task +READY +DUETOMORROW count`
    urgent=`task +READY urgency \> 10 count`
    overdue=`task +READY +OVERDUE count`

    tasks="\ue1f2 $total"

    if [ $today -gt 0 ]; then
        tasks="${tasks} \ue225 $today"
    fi
    if [ $tomorrow -gt 0 ]; then
        tasks="${tasks} \ue226 $tomorrow"
    fi
    if [ $urgent -gt 0 ]; then
        tasks="${tasks} \ue227 $urgent"
    fi
    if [ $overdue -gt 0 ]; then
        tasks="${tasks} \ue076 $overdue"
    fi

    echo -e "$tasks"
}

if pgrep lemonbar > /dev/null; then
	doas pkill -9 lemonbar
fi

monitors=$(xrandr | grep -o "^.* connected" | sed "s/ connected//" | wc -l)

while true; do
    # panel_layout="%{l}$(groups)  $(title)  %{r} $(tasks) | $(battery) | $(clock) "
    panel_layout="%{l}$(groups) %{c} $(title) %{r} | $(clock) "

    if [ $monitors -gt 1 ]; then
        echo "%{Sl}${panel_layout}%{Sf}${panel_layout} "
    else
        # panel_layout="%{l}$(groups)  $(title)  %{r} $(tasks) | $(battery) | $(clock) "
	panel_layout="%{l}$(groups) %{c} $(title) %{r} | $(clock) "
        echo "${panel_layout} "
    fi

done | lemonbar -d -g "${BARHEIGHT}" -B "${BGCOLOR}" -F "${FGCOLOR}" -f "$MAINFONT" | sh > /dev/null 2>&1
