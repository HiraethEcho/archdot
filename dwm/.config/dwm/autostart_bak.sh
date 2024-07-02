#!/bin/sh

CONF_DIR=~/.config/dwm

# killall xbindkeys
# xbindkeys &

killall mykeys
mykeys &

killall fcitx5
fcitx5 &

# killall blueman-applet 
# blueman-applet &

# killall nm-applet 
# nm-applet &

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

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &


sleep 3

# ~/.dwm/dwm_bar.sh &
# . "$CONF_DIR"/dwm_bar_colored.sh &
killall dwmbar
dwmbar &

# . "$CONF_DIR"/wallpapers.sh &
killall wallpaper_loop
wallpaper_loop &
# . "$CONF_DIR"/battery_warning.sh &
killall battery_warning 
battery_warning &
