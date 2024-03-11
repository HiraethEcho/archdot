#!/bin/bash
# This script launches rofi with a list of scripts to run 
# List of scripts to run
options="uu: shutdown \nur reboot \nk gparted \ni terminal "
# Launch rofi with the options
chosen=$(echo -e $options | rofi -dmenu -i -p "Select Script:")
# Run the selected script
case $chosen in
    "uu: shutdown")
      shutdown now;;
    "ur: reboot")
      reboot;;
    "k gparted")
      sudo -A gparted;;
    "i terminal")
      alacritty;;
esac
