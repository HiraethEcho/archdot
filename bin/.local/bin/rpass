#!/bin/sh

# Take password prompt from STDIN, print password to STDOUT
# the sed piece just removes the colon from the provided
# prompt: rofi -p already gives us a colon
rofi -dmenu \
  -config ~/.config/rofi/themes/passwd.rasi \
	-password \
	-p "$1"
# 󰌋
