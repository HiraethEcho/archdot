#!/bin/sh
killall xbindkeys
mykeys &

killall fcitx5
fcitx5 &

killall dunst
dunst &

killall picom
picom &

killall blueberry-tray
blueberry-tray

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# killall wallpaper_loop
# wallpaper_loop &
wallpaper_change

# killall battery_warning 
# battery_warning &

killall dwmblocks
dwmblocks &
