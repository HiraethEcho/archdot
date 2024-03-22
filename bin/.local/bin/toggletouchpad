#!/bin/sh
#

id=$(xinput list | grep -i "Touchpad" | sed -n -e 's/^.*id=/ /p' | cut -f1 )
able=$(xinput list-props $id | grep "Device Enabled" | awk '{print $4}')
if [[ "$able" == 1 ]]; then
  xinput disable $id
  else
  xinput enable $id
fi
