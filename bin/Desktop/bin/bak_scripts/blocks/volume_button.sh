#!/bin/sh
case "$1" in
	1) pamixer -i 5 ;;
	2) pamixer -t ;;
	3) pamixer -d 5 ;;
	4) notify-send "vol$1" ;;
	5) notify-send "vol$1" ;;
esac
