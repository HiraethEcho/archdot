#!/bin/bash

# Prints out battery percentage

BAT_ICON=""
ICON=""

get_battery()
{
	# The vast majority of people only use one battery.
		capacity=$(cat /sys/class/power_supply/BAT1/capacity)
		charging=$(cat /sys/class/power_supply/BAT1/status)
		# if [[ "$charging" == "Charging" ]]; then
  #     if [[ $capacity -ge 90 ]]; then
  #       BAT_ICON=󰂅
  #     elif [[ $capacity -le 10 ]]; then
  #       BAT_ICON=󰢜
  #     elif [[ $capacity -le 20 ]]; then
  #       BAT_ICON=󰂆
  #     elif [[ $capacity -le 30 ]]; then
  #       BAT_ICON=󰂇
  #     elif [[ $capacity -le 40 ]]; then
  #       BAT_ICON=󰂈
  #     elif [[ $capacity -le 50 ]]; then
  #       BAT_ICON=󰢝
  #     elif [[ $capacity -le 60 ]]; then
  #       BAT_ICON=󰂉
  #     elif [[ $capacity -le 70 ]]; then
  #       BAT_ICON=󰢞
  #     elif [[ $capacity -le 80 ]]; then
  #       BAT_ICON=󰂊
  #     elif [[ $capacity -le 90 ]]; then
  #       BAT_ICON=󰂋
  #     fi
  #   else
      if [[ $capacity -ge 90 ]]; then
        BAT_ICON=󰁹
      elif [[ $capacity -le 10 ]]; then
        BAT_ICON=󰁺
      elif [[ $capacity -le 20 ]]; then
        BAT_ICON=󰁻
      elif [[ $capacity -le 30 ]]; then
        BAT_ICON=󰁼
      elif [[ $capacity -le 40 ]]; then
        BAT_ICON=󰁽
      elif [[ $capacity -le 50 ]]; then
        BAT_ICON=󰁾
      elif [[ $capacity -le 60 ]]; then
        BAT_ICON=󰁿
      elif [[ $capacity -le 70 ]]; then
        BAT_ICON=󰂀
      elif [[ $capacity -le 80 ]]; then
        BAT_ICON=󰂁
      elif [[ $capacity -le 90 ]]; then
        BAT_ICON=󰂂
      fi

		if [[ "$charging" == "Charging" ]]; then
      ICON=
    else
      if [[ $capacity -le 25 ]]; then
        ICON=
      else
        ICON=󰚦
      fi
    fi
    printf "%s%s%s%%" "$BAT_ICON" "$ICON" "$capacity"
}

get_battery
