#!/bin/sh
killall xbindkeys
xbindkeys &

killall fcitx5
fcitx5 &

killall blueman-applet 
blueman-applet &

killall nm-applet 
nm-applet &

killall dunst
dunst &

picom -b

~/scripts/wallpapers.sh &

~/scripts/dwm/battery_warning.sh &
# onedrivegui &

# killall pa-applet 
# pa-applet &

# killall blueberry-tray
# blueberry-tray &

# killall slstatus 
# slstatus &

sleep 3

# ~/.dwm/dwm_bar.sh &
~/scripts/dwm/dwm_bar_colored.sh &
