#!/bin/sh
    # elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
battery_warning()
{
capacity=""
charging=""
note=""
while true
do
  capacity=$(cat /sys/class/power_supply/BAT1/capacity)
  charging=$(cat /sys/class/power_supply/BAT1/status)
  if [ $capacity -le 20 ]; then
      note="Only $capacity% power left"
    if [ "$charging" == "Charging" ]; then
      notify-send -u normal "$note" "Charging"
    else
      notify-send -u critical "$note" "Not Charging"
    fi
  fi
  sleep 120
done
}

battery_warning
