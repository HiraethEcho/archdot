## 修改 NetworkManager 配置

修改 /etc/NetworkManager/NetworkManager.conf ，加入以下内容
```
[device]
wifi.backend=iwd
```

## 配置 Systemd 服务

屏蔽 wpa_supplicant 服务：
```
systemctl mask wpa_supplicant
```
启用 iwd 服务： 
```
systemctl enable iwd
```
