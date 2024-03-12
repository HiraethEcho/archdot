#! /bin/sh

dmenu -p "$1" -fn  "Maple Mono NF:size=15" -nb  "#222222" -nf "#bbbbbb" -sb  "#005577" -sf  "#eeeeee" <&- && echo
# dmenu -p "$1" -nf '#204a87' -nb '#204a87' -sf black -sb '#babdb6' <&- && echo
