#!/bin/sh

case "$1" in
	1) notify-send "This Month" "$(cal | sed "s/\<$(date +'%e'|sed 's/ //g')\>/<b><span color='red'>&<\/span><\/b>/")" && notify-send "Appointments" "$(calcurse -d3)" ;;
	2) notify-send "cal$1" ;;
	3) notify-send "cal$1" ;;
	4) notify-send "cal$1" ;;
	5) notify-send "cal$1" ;;
esac
