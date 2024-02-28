# Arch cli install

## 

##

## wifi

sudo systemctl start wpa_supplicant.servicei
nmcli dev wifi list


nmcli device wifi connect "your wifi name"password "your wifi password"

### csdn
`pacman -S iw wireless_tools wpa_supplicant`

 

wifi的连接步骤为：

•获取可用无线网卡，通过命令#ifconfig -a可以查看无线网卡，以下假设为wlan0

•接口激活：#ifconfig wlan0 up或者#ip link set wlan0 up

•配置wifi：使用iw,wireless_tools,wpa_supplicant等

•ip地址分配：

•动态IP，此时自动分配：#dhcpcd wlan0

•静态IP，需要：

#ip addr add 192.168.0.2/24 dev wlan0 也可以加入广播地址变成#ip addr add 192.168.0.10/24 broadcast 192.168.0.255 dev wlan0

#ip route add default via 192.168.0.1

其中192.168.0.2是IP地址，24是子网掩码

•关闭wifi

 

下面介绍的是"配置wifi"和"关闭wifi"。

2 配置wifi
2.1 连接公共网络和WEP加密网络
对于这种情况，只需要使用iw或者wireless_tools其一即可，以下是它们的终端命令解释：



例如，假设要连接一个名为HIT-WLAN的公共网络，则只需用命令：

`#iw dev wlan0 connect HIT-WLAN   或者   #iwconfig wlan0 essid HIT-WLAN`

例如，扫描附近热点，可用命令：

`#iw dev wlan0 scan    或者   #iwlist wlan0 scan`

2.2 连接WPA2PSK或者WPA加密网络
此时便是大多数wifi的情况，假设wifi的名称(即essid)是test，密码是123456，这时wpa_supplicant工具便派上用场，用以下命令依次配置即可：

`#wpa_passphrase test "123456" > /etc/wpa_supplicant.conf~`

`#wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf`

其中-B表示后台运行

3 关闭wifi
若是动态ip地址，关闭的时候直接用命令

`#ip link set dev wlan0 down   或者   #ifconfig wlan0 down`

若是静态ip地址，为了更好的关闭，可以用以下指令
```
#ip addr flush dev wlp13s1

#ip route flush dev wlp13s1

#ip link set dev wlan0 down   或者   #ifconfig wlan0 down s
```

###

pacman -S grub efibootmgr vim iwd dhcpcd sudo networkmanager

systemctl enable dhcpcd NetworkManager iwd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=<你想要在efi引导时显示的名字，建议为ArchLinux>
