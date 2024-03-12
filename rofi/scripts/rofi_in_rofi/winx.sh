#!/usr/bin/env bash
#
theme="~/.config/rofi/themes/quick.rasi"

option_1="󰟴 Bilibili"
option_2="󰚩 GPT"
option_3="󰖟 Blog"

rofi_cmd() {
  rofi -theme-str "listview {columns: 1; lines: 4;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -kb-select-1 1 \
    -markup-rows \
    -theme ${theme}
}

run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n" | rofi_cmd
}

run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    xdg-open 'https://www.bilibili.com/'
  elif [[ "$1" == '--opt2' ]]; then
    xdg-open 'https://chat.rawchen.com/'
  fi
}

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
esac
