# archdot

## pacman

 sudo vim /etc/pacman.d/mirrorlist

```

Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch

```


```bash
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

```bash
sudo pacman -S archlinuxcn-keyring
```

aur:

```
sudo pacman -S yay
```

clean pacman:
```bash
paccache -r # 清理缓存,仅包含最近的三个版本
paccache -rk1 # 清理缓存,仅包含最近的1个版本
pacman -Sc # 清理未安装软件包
pacman -Scc # 清理缓存中所有内容
sudo pacman -R $(pacman -Qdtq)
sudo pacman -Rns $(pacman -Qdtq)
journalctl --vacuum-size=50M #限制日志
```

## watt-toolkit

```bash
yay -S watt-toolkit-bin
```

**certificate**

```bash
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
 
 ```bash
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



## DWM
dwm: 
### auto login
/etc/systemd/system/getty@tty1.service.d/overide.conf:

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin wyz --noclear %I $TERM 

```

/etc/systemd/system/getty@tty1.service.d/autologin.conf:
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --autologin wyz --noclear %I $TERM 

```
### feh etc

### rofi

### fonts
check nerd-cheat-sheet

## sound and bluetooth

```
yay -S alsa alsa-utils 
```

```
yay -S bluez bluez-utils pulseaudio-bluetooth blueberry
```


```
1. Set  "ControllerMode = bredr"  in  /etc/bluetooth/main.conf
2. sudo /etc/init.d/bluetooth restart
3. Try to pair again.
```
## Apps

### Terminal
`st`

### shell

`zsh`

### vim/neovim


### wechat

`yay -S wewechat++ ` 
or
`yay -S electronic-wechat-uos-bin ` 

and 

`yay -S linuxqq`

### zotero

### pdf reader
`sioyek`

## useful commands
``` sh
sudo pacman -Rns --recursive --unneeded package_name
```

### mout win disk
```
/dev/nvme0n1p4: LABEL="Hiraeth" BLOCK_SIZE="512" UUID="E6361CF7361CCA87" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="54a7e2d9-5d6e-4487-8d81-1ffdc21ce6f3"
```

icloud app key
```
aqef-ukin-gehe-hqmr
```
### nvim server
```zsh
nvim --listen localhost:6666
```
this works as a server

```zsh
nvim --server localhost:6666 --remote-ui
nvim --server localhost:6666 --remote-send gg
```
