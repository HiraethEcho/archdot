
using `r!cmd` to print output of `cmd` in vim

#### upower

```
upower -e

/org/freedesktop/UPower/devices/line_power_ACAD
/org/freedesktop/UPower/devices/battery_BAT1
/org/freedesktop/UPower/devices/DisplayDevice
```
check battery `sudo upower -i /org/freedesktop/UPower/devices/battery_BAT1 `

find id of touchpad

```
xinput list | grep -i "Touchpad" | awk '{print $6}' | sed 's/[^0-9]//g'
```

keys:

```sh
setxkbmap -option ctrl:nocaps &
xcape -e 'Control_L=Return' &
xcape -e 'Alt_L=Escape' &
```


```sh
nohup onedrivegui & > /dev/null
```

## pacman

```
pacman -Qqe | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'
```


```sh
pacman -D --asdeps $(pacman -Qqe)
```

```sh
pacman -D --asexplicit base linux linux-firmware
```

```sh
cat explicit | sudo pacman -D --asexplicit -
```

```sh
pacman -Qii | awk '/^MODIFIED/ {print $2}'
```
