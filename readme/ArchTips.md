# Tips about Arch

## alsa

ALSA: is a set of built-in Linux kernel modules.
PulseAudio: is a general purpose sound server intended to run as a middleware between your applications and your hardware devices, either using ALSA or OSS. 
pamixer: cli mixer of PulseAudio
pavucontrol: gui of PulseAudio

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
