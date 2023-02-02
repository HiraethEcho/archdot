# archdot



## init
## pacman etc


```
sudo pacman -S archlinux-keyring
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

`sudo pacman -Syyu`
`sudo pacman -S yay`
### manjaro kde

```
sudo chown -R sddm:sddm /var/lib/sddm/.config
```

## app config

### conky
```
${alignr}${font Unifont:style=regular:pixelsize=50}${time %H:%M}${font}

${alignr}${font Unifont:style=regular:pixelsize=18}${time %A %d %B %Y}${font}

mkdir -p ~/.config/conky && conky --print-config > ~/.config/conky/conky.conf
```
### i3
![来自 2023-02-02 19-35-15 的截图](https://user-images.githubusercontent.com/108179798/216314424-de609e26-df66-4794-9a09-f65f2ed9fa9a.png)
```
exec_always --no-startup-id $HOME/.config/polybar/launch.sh

exec_always feh --bg-fill /usr/share/bachgrounds/i3/wall.png

exec_always picom -f

bindsym $mod+x exec betterlockscreen -l

bindsym $mod+Shift+s exec shutdown now

bindsym $mod+b workspace 5; exec firefox
bindsym $mod+Shift+d exec --no-startup-id rofi -show run -theme Monokai
bindsym $mod+Shift+d exec --no-startup-id rofi -show drun -theme Monokai -icon-theme "Tela-circle" -show-icons
```
### feh etc
sudo pacman -S feh


## watt
```
yay -S watt-toolkit-bin
```


```
sudo trust anchor --store SteamTools.Certificate.cer
sudo setcap cap_net_bind_service=+eip /opt/watt-toolkit/Steam++
sudo chmod a+r /etc/hosts
sudo chmod a+w /etc/hosts
pk12util -d sql:$HOME/.pki/nssdb -i XXXX.pfx
```
### certificate
Currently Arch Linux uses p11-kit from Fedora, which has more features (e.g. explicit distrusts) than the older scripts from Debian. To import a trust anchor using p11-kit, do:

Run trust anchor --store myCA.crt as root.
The certificate will be written to /etc/ca-certificates/trust-source/myCA.p11-kit and the "legacy" directories automatically updated.

If you get "no configured writable location" or a similar error, import the CA manually:

Copy the certificate to the /etc/ca-certificates/trust-source/anchors directory.

Run update-ca-trust as root.

For more information, see the update-ca-trust(8) manual page.

Arch 系的用户可能需要使用
```
sudo trust anchor --store SteamTools.Certificate.cer 
```
导入证书才能正常加速 Steam
证书路径请参考 下方存储空间位置
Steam 信任证书 ( Chrome 内核浏览器 )
由于 Steam 使用 Chrome 内核浏览器，使用自管理证书库。
需要使用 Chrome 打开 设置 - 隐私设置和安全性 - 安全 - 管理证书
选择 授权机构( Authorities )
在 Watt Toolkit 的设置 - 通用设置 - 存储空间 - 打开 AppData 目录中的
SteamTools.Certificate.pem文件 导入
注：如文件不存在可修改 SteamTools.Certificate.cer 为 SteamTools.Certificate.pem勾选 信任该证书，以标识网站身份
火狐浏览器
打开 设置 - 隐私与安全 - 安全 - 证书 - 查看证书
选择 证书颁发机构( Authorities )
在 Watt Toolkit 的设置 - 通用设置 - 存储空间 - 打开 AppData 目录中的
SteamTools.Certificate.pem文件 ( 火狐支持 cer 或者 pem 格式导入 )
勾选 信任由此证书颁发机构来标识网站
