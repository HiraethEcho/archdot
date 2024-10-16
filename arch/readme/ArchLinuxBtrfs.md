## backup

首先运行 `pacman -Qe`，这个命令可以列出系统中所有手动指定安装的包，运行 `pacman -Qe >> list.txt` 可以将这个软件包名单保存到 `list.txt` 文件里面，再将这个文件保存到方便查看的地方，比如自己的手机里什么的，方便重装后参照这个名单将软件装回来。

之后是备份整个家目录，以便重装完后恢复绝大多数的个人数据。我找到一个闲置的空的移动硬盘，不是空的也没关系，只要剩余空间够放下家目录的内容就行，将其挂载在 `/mnt` 目录下，并新建一个空文件夹 `backup`。为了在恢复数据时保留所有文件的权限，我使用 rsync 命令：

```
sudo rsync -avrh --progress /home/ /mnt/backup/
```

重启进入新系统后，因为还未安装图形界面，会进入 tty，因为之后要恢复家目录文件，所以这里暂时先不用普通用户登录，而是登录进 root 用户，开始着手恢复家目录文件，将之前用于备份家目录的移动硬盘重新挂载到 `/mnt` 目录，一样使用 rsync 恢复文件，只需将之前备份命令里两个路径互换位置即可：

```
rsync -avrh --progress /mnt/backup/ /home/
```

恢复过程同样需要较长时间，请耐心等待，恢复完成后退出 root 登录，使用普通用户登录。参照之前备份的软件包列表将所需的软件包装回来，再启用一些需要的服务，就可以正常使用了，就和重装前一样。

## snapper
快照/子卷GUI管理，没啥好说的，安装就行了

`sudo pacman -S btrfs-assistant`

### Arch Linux 风格特有的配置
虽然看着很麻烦，但其实基本照做即可（假设目标分区是 /dev/nvme0n1p1）。大致的操作就是把 Snapper 创建的 @/.snapshots 删掉，替换成独立的子卷 @snapshots。

sudo umount /.snapshots
sudo rm -r /.snapshots
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -o subvol=/ /dev/nvme0n1p1 /mnt
sudo btrfs subvolume create /mnt/@snapshots
然后修改 /etc/fstab，参考子卷的方式增加一条将子卷 subvol=@snapshots 挂载到 /.snapshots 的即可。运行 sudo mount -a 生效。

### 从快照中恢复
假设我们已经为`/`创建了快照，如果想要从快照中恢复系统，可以先进入Arch Linux live USB，然后挂载Btrfs分区
```sh
sudo mount /dev/nvme0n1p6 /mnt
cd /mnt
sudo mv /mnt/@ /mnt/@.broken
sudo btrfs subvolume snapshot /mnt/@snapshots/{number}/snapshot /mnt/@
sudo btrfs subvolume delete /mnt/@.broken
```

### Another rollback
```sh
sudo mount -o subvol=/ /dev/nvme0n1p1 /mnt
sudo btrfs subvolume snapshot /mnt/@ /mnt/@bad
sudo btrfs subvolume delete /mnt/@
sudo btrfs subvolume snapshot /mnt/@snapshots/要恢复的快照号/snapshot /mnt/@
```

```sh
#!/bin/sh
set -e
if [[ x"$1" == x ]]; then
  echo "No snapshot number given." 1>&2
  echo "Usage: rollback [snapshot to rollback]" 1>&2
  exit 1
fi
root_dev=`findmnt -n -o SOURCE / | sed 's/\[.*\]//g'`
root_subvol=`findmnt -n -o SOURCE / | sed 's/.*\[\(.*\)\].*/\1/'`
echo ">= Rollback to #$1 on device $root_dev"
# create snapshot before
sudo snapper create --read-only --type single -d "Before rollback to #$1" --userdata important=yes
sudo mount -o subvol=/ $root_dev /mnt
# check enviornment
if [[ x"$root_subvol" == x/@ ]]; then
  echo "Warning: Not run in a snapshot, a subvolume @old will be created. You should consider remove it after reboot." 1>&2
  if [[ -d /mnt/@old ]]; then
    echo "Found last @old, remove it."
    sudo btrfs subvolume delete /mnt/@old >/dev/null
  fi
  sudo mv /mnt/@ /mnt/@old
else
  sudo btrfs subvolume delete /mnt/@ >/dev/null
fi
sudo btrfs subvolume snapshot /mnt/@snapshots/$1/snapshot /mnt/@ >/dev/null
sudo umount /mnt
```

## Reference

1.  [ArchWiki-Btrfs](https://wiki.archlinux.org/title/Btrfs)
2.  [Working with Btrfs – General Concepts](https://fedoramagazine.org/working-with-btrfs-general-concepts/)
3.  [Working with Btrfs – Subvolumes](https://fedoramagazine.org/working-with-btrfs-subvolumes/)
4.  [Working with Btrfs – Snapshots](https://fedoramagazine.org/working-with-btrfs-snapshots/)
5.  [ArchWiki-Snapper](https://wiki.archlinux.org/title/snapper)
6.  [BTRFS snapshots and system rollbacks on Arch Linux](https://www.dwarmstrong.org/btrfs-snapshots-rollbacks/)
