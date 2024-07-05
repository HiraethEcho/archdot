#!/bin/sh
case "$1" in
    1) notify-send "cpu$1" ;;
    2) exec "$TERMINAL" -e top ;;
    3) notify-send "cpu$1" ;;
	4) notify-send "cpu$1" ;;
	5) notify-send "cpu$1" ;;
esac
