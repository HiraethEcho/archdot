#!/usr/bin/env bash

theme="~/.config/rofi/themes/winx.rasi"

option_u="power u"
option_k="gparted k"
option_i="terminal i"

rofi_cmd() {
  rofi -theme-str "listview {columns: 1; lines: 3;}" \
    -dmenu \
    -kb-select-1 u \
    -kb-select-2 k \
    -kb-select-3 i \
    -markup-rows \
    -theme ${theme}
}

run_rofi() {
  echo -e "$option_u\n$option_k\n$option_i\n" | rofi_cmd
}


chosen="$(run_rofi)"
case ${chosen} in
    $option_u)
      ~/scripts/rofi/powermenu.sh
        ;;
    $option_k)
      sudo -A gparted
        ;;
    $option_i)
      alacritty
        ;;
esac
