#!/bin/sh

# A dwm_bar module to display the current backlight brighness with xbacklight
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: xbacklight

dwm_backlight () {
  light=$(xbacklight -get) 
  a=$[$light/2]
  printf "^f3^^c#EBCB8B^^f2^^r0,8,52,5^^c#000000^^r1,9,50,3^^c#EBCB8B^^r1,9,%s,3^^f54^%s" "$a" "$light" 
}

dwm_backlight
