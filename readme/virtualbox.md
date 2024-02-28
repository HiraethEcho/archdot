# following this 
# 安装软件包 virtualbox 。
内核模块的安装方式要从下面二选一：

- 如果使用的是 linux 内核，建议安装 virtualbox-host-modules-arch
- 其他的内核，包括 linux-lts ，请安装 virtualbox-host-dkms 包

为了让 virtualbox-host-dkms 包编译内核模块，需要安装对应的内核头文件（例如 linux-lts 内核的头文件是 linux-lts-headers ）。当 VirtualBox 或内核更新的时候，DKMS 的 Pacman 钩子会自动编译内核模块。

## 加载 VirtualBox 内核模块
```
sudo systemctl enable systemd-modules-load.service
```
## 用户组
gpasswd -a [用户名] vboxusers

从客体系统访问主机 USB 设备
将需要运行 VirtualBox 的用户名添加到 vboxusers 用户组，USB 设备才能被访问

## others

客体机插件光盘
安装virtualbox-guest-iso软件包之后才可以安装增强功能。这个包里有个 .iso 镜像文件，用来为 Arch 之外的客体系统安装插件

```
sudo pacman -S virtualbox-guest-iso
```
镜像文件的位置在 /usr/lib/virtualbox/additions/VBoxGuestAdditions.iso，手动在虚拟机的虚拟光驱里加载这个文件之后，即可在客体机里安装插件


修改GRUB启动参数
如果你的 Vbox 启动虚拟机卡在 starting virtual machine… 界面，可以尝试加上ibt=off

sudo vim /etc/default/grub

```
GRUB_CMDLINE_LINUX_DEFAULT="[other...] ibt=off"
```
记得运行sudo grub-mkconfig -o /boot/grub/grub.cfg来保存设置

# another one

## 加载 VirtualBox 内核模块

```
sudo modprobe vboxdrv vboxnetadp vboxnetflt
```

- vboxdrv驱动模块
- vboxnetadp 桥接网络
- vboxnetflthost-only 网络
- vboxpci：若要让虚拟机使用主体机的 PCI 设备，那么就需要这个模块。
 
## 安装扩展包
```
yay -S virtualbox-ext-oracle
```
## debug
启动虚拟机时提示sbin/vboxconfig错误：

VirtualBox启动虚拟机报错

执行以下命令安装vboxdrv模块即可解决：
```
sudo modprobe vboxdrv
```
