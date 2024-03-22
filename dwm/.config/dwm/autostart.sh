#!/bin/sh

CONF_DIR=~/.config/dwm

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

# killall pa-applet 
# pa-applet &

# killall blueberry-tray
# blueberry-tray &

# killall slstatus 
# slstatus &
# onedrivegui &

picom -b &



sleep 3

# ~/.dwm/dwm_bar.sh &
. "$CONF_DIR"/dwm_bar_colored.sh &
# . "$CONF_DIR"/wallpapers.sh &
wallpapersleep &
. "$CONF_DIR"/battery_warning.sh &
