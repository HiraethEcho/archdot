# Tips about Arch

## sh

```sh
nohup onedrivegui & > /dev/null
```

## dev
### net

Using iwd as backend of NetworkManager:

/etc/NetworkManager/NetworkManager.conf :
```
[device]
wifi.backend=iwd
```
then
```sh
systemctl mask wpa_supplicant
systemctl enable iwd
```

### sound

ALSA: is a set of built-in Linux kernel modules.
PulseAudio: is a general purpose sound server intended to run as a middleware between your applications and your hardware devices, either using ALSA or OSS.
pamixer: cli mixer of PulseAudio
pavucontrol: gui of PulseAudio

```
sudo pacman -S alsa-ultis pulseaudio pavucontrol
pulseaudio --check
pulseaudio -D
```

### light

`sudo pacman -S acpilight`

`sudo gpasswd video -a _username_ `

### power

```
upower -e

/org/freedesktop/UPower/devices/line_power_ACAD
/org/freedesktop/UPower/devices/battery_BAT1
/org/freedesktop/UPower/devices/DisplayDevice
```

check battery `sudo upower -i /org/freedesktop/UPower/devices/battery_BAT1 `

### keyboard

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

## pacman

```sh
pacman -Qqe | fzf --preview 'pacman -Qiil {}' --layout=reverse --bind 'enter:execute(pacman -Qiil {} | less)'
```

```sh
pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse
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
