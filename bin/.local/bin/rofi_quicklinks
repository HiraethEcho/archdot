#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Quick Links

# Import Current Theme
theme="~/.config/rofi/themes/quick.rasi"

# Theme Elements
prompt='Links'

efonts="Maple Mono NF 20"

# Options
option_1="󰟴 bilibili"
option_2="󰚩 gpt"
option_3="󰖟 blog"
option_4=" github"
option_5="󰣇 arch wiki"
option_6=" apple"
option_7=" picx"
option_8=" twitter"

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "listview {columns: 1; lines: 8;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -theme-str "element-text {font: \"$efonts\";}" \
    -dmenu \
    -p "$prompt" \
    -markup-rows \
    -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_8" | rofi_cmd
}

run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    xdg-open 'https://www.bilibili.com/'
  elif [[ "$1" == '--opt2' ]]; then
    xdg-open 'https://chat.rawchen.com/'
  elif [[ "$1" == '--opt3' ]]; then
    xdg-open 'https://hiraethecho.github.io/hexo/'
  elif [[ "$1" == '--opt4' ]]; then
    xdg-open 'https://www.github.com/'
  elif [[ "$1" == '--opt5' ]]; then
    xdg-open 'https://wiki.archlinux.org/'
  elif [[ "$1" == '--opt6' ]]; then
    xdg-open 'https://www.icloud.com.cn/'
  elif [[ "$1" == '--opt7' ]]; then
    xdg-open 'https://picx.xpoet.cn/'
  elif [[ "$1" == '--opt8' ]]; then
    xdg-open 'https://www.twitter.com/'
  fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
    run_cmd --opt1
        ;;
    $option_2)
    run_cmd --opt2
        ;;
    $option_3)
    run_cmd --opt3
        ;;
    $option_4)
    run_cmd --opt4
        ;;
    $option_5)
    run_cmd --opt5
        ;;
    $option_6)
    run_cmd --opt6
        ;;
    $option_7)
    run_cmd --opt7
        ;;
    $option_8)
    run_cmd --opt8
        ;;
esac
