#!/bin/sh
    VOL=$(pamixer --get-volume)
    STATE=$(pamixer --get-mute)
    a=$[17*$VOL/100]
    b=$[19-$a]

    if [ "$STATE" = "true" ] || [ "$VOL" -eq 0 ]; then
      printf "MUTE %s" "$VOL"
    else
      printf "%s" "$VOL"
    fi
