#!/bin/sh

# A dwm_bar function to show the master volume of PulseAudio
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: pamixer

dwm_pulse () {
    VOL=$(pamixer --get-volume)
    STATE=$(pamixer --get-mute)
    # BLUETOOTH=$(bluetooth | awk {'print $3'})

    printf "^f3^^c#96CDFB^" 

    if [ "$STATE" = "true" ] || [ "$VOL" -eq 0 ]; then
      printf "󰸈"
    else
      printf "󰕾"
    fi

    a=$[17*$VOL/100]
    b=$[19-$a]
    printf "^f3^^c#96CDFB^^r0,1,7,19^^c#000000^^r1,2,5,17^^c#96CDFB^^r1,%s,5,%s^^f10^" "$b" "$a"

    printf "%s%%" "$VOL"
}
# 󰥰 󱡏
dwm_pulse
