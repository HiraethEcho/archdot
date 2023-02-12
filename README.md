# archdot

## init

### pacman etc

 sudo vim /etc/pacman.d/mirrorlist

```

Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch


```


```shell
sudo pacman -S archlinux-keyring
```

then update.
```shell
sudo pacman -Syyu
```

`sudo vim /etc/pacman.conf`, add

```
[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

```shell
sudo pacman -S archlinuxcn-keyring
```

aur:

```
sudo pacman -S yay
```

clean pacman:
```shell
paccache -r # 清理缓存,仅包含最近的三个版本
paccache -rk1 # 清理缓存,仅包含最近的1个版本
pacman -Sc # 清理未安装软件包
pacman -Scc # 清理缓存中所有内容
sudo pacman -R $(pacman -Qdtq)
sudo pacman -Rns $(pacman -Qdtq)
journalctl --vacuum-size=50M #限制日志
```

### misc

If manjaro kde:

```
sudo chown -R sddm:sddm /var/lib/sddm/.config
```

## DE

### Display Manager
[Arch wiki for DE](https://wiki.archlinux.org/title/Display_manager)

- sddm
- lightDM
- ly
- GDM

Or just start from tty.

### Desktop Environment

- xfce
- wayfire

Maybe use Xfce as DE and dwm as WM. See [here](https://wiki.archlinux.org/title/Xfce#Use_a_different_window_manager)
  
### windows manger

#### i3
**Maybe Not**

![来自 2023-02-02 19-35-15 的截图](https://user-images.githubusercontent.com/108179798/216314424-de609e26-df66-4794-9a09-f65f2ed9fa9a.png)

```shell
exec_always --no-startup-id $HOME/.config/polybar/launch.sh

exec_always feh --bg-fill /usr/share/bachgrounds/i3/wall.png

exec_always picom -f

bindsym $mod+x exec betterlockscreen -l

bindsym $mod+Shift+s exec shutdown now

bindsym $mod+b workspace 5; exec firefox
bindsym $mod+Shift+d exec --no-startup-id rofi -show run -theme Monokai
bindsym $mod+Shift+d exec --no-startup-id rofi -show drun -theme Monokai -icon-theme "Tela-circle" -show-icons
```

#### dwm
This is great! But also hard to config.



### tools

#### conky

```shell
${alignr}${font Unifont:style=regular:pixelsize=50}${time %H:%M}${font}

```

```
${alignr}${font Unifont:style=regular:pixelsize=18}${time %A %d %B %Y}${font}
```

```shell
mkdir -p ~/.config/conky && conky --print-config > ~/.config/conky/conky.conf
```

#### feh etc

sudo pacman -S feh

#### rofi

#### slock

## web

### watt-toolkit

```shell
yay -S watt-toolkit-bin
```

**certificate**

```shell
sudo trust anchor --store SteamTools.Certificate.cer
sudo setcap cap_net_bind_service=+eip /opt/watt-toolkit/Steam++
sudo chmod a+r /etc/hosts
sudo chmod a+w /etc/hosts
pk12util -d sql:$HOME/.pki/nssdb -i XXXX.pfx
```

> Currently Arch Linux uses p11-kit from Fedora, which has more features (e.g. explicit distrusts) than the older scripts from Debian. To import a trust anchor using p11-kit, do:
> Run trust anchor --store myCA.crt 
> as root.
>
> The certificate will be written to /etc/ca-certificates/trust-source/myCA.p11-kit and the "legacy" directories automatically updated.
> If you get "no configured writable location" or a similar error, import the CA manually:
> Copy the certificate to the /etc/ca-certificates/trust-source/anchors directory.
> Run update-ca-trust as root.
> For more information, see the update-ca-trust(8) manual page.
> Arch 系的用户可能需要使用
 
 ```shell
 sudo trust anchor --store SteamTools.Certificate.cer 
 ```
 
> 导入证书才能正常加速 Steam
> 证书路径请参考 下方存储空间位置
> Steam 信任证书 ( Chrome 内核浏览器 )
> 由于 Steam 使用 Chrome 内核浏览器，使用自管理证书库。
> 需要使用 Chrome 打开 设置 - 隐私设置和安全性 - 安全 - 管理证书
> 选择 授权机构( Authorities )
> 在 Watt Toolkit 的设置 - 通用设置 - 存储空间 - 打开 AppData 目录中的. 
> SteamTools.Certificate.pem文件 导入
> 注：如文件不存在可修改 SteamTools.Certificate.cer 为 SteamTools.Certificate.pem勾选 信任该证书，以标识网站身份
> 火狐浏览器 
> 打开 设置 - 隐私与安全 - 安全 - 证书 - 查看证书
> 选择 证书颁发机构( Authorities )
> 在 Watt Toolkit 的设置 - 通用设置 - 存储空间 - 打开 AppData 目录中的
> SteamTools.Certificate.pem文件 ( 火狐支持 cer 或者 pem 格式导入 )
> 勾选 信任由此证书颁发机构来标识网站

## Basic app

### Terminal
For Xorg:
- st
- kitty
- alacritty
- etc

For wayland
- foot

### shell

- zsh
- fish

### vim/neovim

## apps

### wechat

`yay -S wewechat++ ` 
or
`yay -S electronic-wechat-uos-bin ` 

`freechat` is fucked, since web version wechat is dennied. 

and 

`yay -S linuxqq`

### zotero

### pdf reader


