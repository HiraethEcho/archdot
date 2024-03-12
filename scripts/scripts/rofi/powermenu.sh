#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
theme='~/.config/rofi/themes/powermenu.rasi'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
  rofi -dmenu \
    -p "Uptime: $uptime" \
    -mesg "Uptime: $uptime" \
    -theme ${theme}
}


# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
# TODO: change cmd for shutdown etc

run_cmd() {
    if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
      systemctl reboot
    elif [[ $1 == '--suspend' ]]; then
      mpc -q pause
      pamixer -m
      systemctl suspend
    # elif [[ $1 == '--logout' ]]; then
    #   if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
    #     openbox --exit
    #   elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
    #     bspc quit
    #   elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
    #     i3-msg exit
    #   elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
    #     qdbus org.kde.ksmserver /KSMServer logout 0 0 0
    #   fi
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
    run_cmd --shutdown
        ;;
    $reboot)
    run_cmd --reboot
        ;;
    $lock)
    i3lock --clock --blur 20
        ;;
    $suspend)
    run_cmd --suspend
        ;;
    $logout)
    run_cmd --logout
        ;;
esac
