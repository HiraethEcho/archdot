# 从快照中恢复

假设我们已经为`/`创建了快照，如果想要从快照中恢复系统，可以先进入Arch Linux live USB，然后挂载Btrfs分区
```
sudo mount /dev/nvme0n1p6 /mnt
cd /mnt
```

移除旧的`@`子卷
```
sudo mv /mnt/@ /mnt/@.broken
```
列出所有快照和对应的时间信息
```

$ sudo grep -r '<date>' /mnt/@snapshots/*/info.xml
/.snapshots/1/info.xml:  <date>2023-07-11 06:21:53</date>  # Snapper使用UTC时间记录快照创建时间
/.snapshots/2/info.xml:  <date>2022-07-11 06:22:39</date>
```

由于Snapper创建的快照是只读子卷，所以需要从快照中创建可读写快照作为`@`子卷
```

sudo btrfs subvolume snapshot /mnt/@snapshots/{number}/snapshot /mnt/@
```

然后就可以删除旧的`@`子卷
```

sudo btrfs subvolume delete /mnt/@.broken
```
## Another rollback
```sh
sudo mount /dev/nvme0n1p1 /mnt
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
