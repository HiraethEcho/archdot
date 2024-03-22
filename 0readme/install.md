# Arch cli install

## init

### wifi

pacman -S grub efibootmgr vim iwd dhcpcd sudo networkmanager

systemctl enable dhcpcd NetworkManager iwd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=<你想要在efi引导时显示的名字，建议为ArchLinux>

### pacman etc

`sudo vim /etc/pacman.d/mirrorlist`

```
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

```sh
sudo pacman -S archlinux-keyring
sudo pacman -Syyu
```

`sudo vim /etc/pacman.conf`, add

```
[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

```sh
sudo pacman -S archlinuxcn-keyring
```

aur:

```sh
sudo pacman -S yay
```

clean pacman:

```sh
paccache -r # 清理缓存,仅包含最近的三个版本
paccache -rk1 # 清理缓存,仅包含最近的1个版本
pacman -Sc # 清理未安装软件包
pacman -Scc # 清理缓存中所有内容
sudo pacman -Rcsn $(pacman -Qdtq -)
journalctl --vacuum-size=50M #限制日志
```

## DE

### Display Manager

[Arch wiki for DE](https://wiki.archlinux.org/title/Display_manager)

- sddm
- lightDM
- ly
- GDM

Or just start from tty.

### windows manger

dwm: This is great! But also hard to config.

## web

### watt-toolkit

```shell
yay -S watt-toolkit-bin
```

**certificate**

```shell
sudo setcap cap_net_bind_service=+eip /opt/watt-toolkit/Steam++
sudo chmod a+r /etc/hosts
sudo chmod a+w /etc/hosts
```

Arch 系的用户可能需要使用

```sh
sudo trust anchor --store SteamTools.Certificate.cer
```

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

### vim/neovim

## apps

### wechat

`yay -S electronic-wechat-uos-bin `

`yay -S linuxqq`

### zotero

### pdf reader

sioyek
