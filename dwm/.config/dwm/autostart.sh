#!/bin/sh
killall xbindkeys
mykeys &

killall fcitx5
fcitx5 &

killall dunst
dunst &

killall picom
picom -b &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

killall wallpaper_loop
wallpaper_loop &

# killall battery_warning 
# battery_warning &

killall dwmblocks
dwmblocks &
