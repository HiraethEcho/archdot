**WARNING THIS PROCEDURE INVOLVES DIRECTLY ACCESSING TO STORAGE DEVICES. SUCH PROCEDURES HAVE RISK OF DATA LOSS. SO BE CAREFUL. THIS INSTRUCTIONS COMES WITH ABSOLUTELY NO WARRANTY EXPRESSED OR IMPLIED. THEREFORE I AM NOT RESPONSİBLE FOR ANY DAMAGE CAUSED BY FOLLOWING PROCEDURES BELOW. DO AT YOUR OWN RISK. IF YOU APPLY PROCEDURES YOU SHOULD KNOW THAT YOU ARE DOING IT UNDER YOUR OWN WILL. YOU SHOULD TAKE BACKUPS AND, IF YOU UNSURE ABOUT ANY STEP BELOW MAKE RESEARCH OR ASK SOMEBODY (IN HERE OR TO SOMEBODY ELSE).**

**IT IS HIGHLY RECOMMENDED TO READ TILL THE END PRIOR TO APPLYING PROCEDURES**

Disclaimer aside lets get into the topic.

On Arch wiki there is instructions for old MBR systems. [Arch Wiki](https://wiki.archlinux.org/index.php/QEMU#Using_the_device-mapper) For modern systems using UEFI bios and GPT things change a bit.

First you have to make sure that fast startup on Windows is disabled and disable if it is enabled. (You should keep it disabled)

Then on Linux run `sudo fdisk -l` and on there you will see sectors of your all partitions of all disks on your system. For my SSD it is like that:

```
Device             Start       End   Sectors   Size Type
/dev/nvme0n1p1      2048   1085439   1083392   529M Windows recovery environment
/dev/nvme0n1p2   1085440   1290239    204800   100M EFI System
/dev/nvme0n1p3   1290240   1323007     32768    16M Microsoft reserved
/dev/nvme0n1p4   1323008 167774207 166451200  79.4G Microsoft basic data
/dev/nvme0n1p5 169871360 462366719 292495360 139.5G Microsoft basic data
/dev/nvme0n1p6 462366720 500118158  37751439    18G Linux filesystem
/dev/nvme0n1p7 167774208 169871359   2097152     1G Linux extended boot

Partition table entries are not in disk order.
```

If yours also says `Partition table entries are not in disk order.` You should be careful about pyhsical order of partitions rather than numbering since it is what we care about. I will assume that in your system just like mine first boot and recovery related stuff then Windows C: drive and then Linux root and another stuff related to Linux. On my system Boot-Recovery staff is in between 0 (beginning of the disk) and 1323007(end of Microsoft reserved). First you should create a copy of that portion to some folder in your Linux installation using dd. Before that I highly recommend you to remove Linux boot manager and its entry. Only Windows Boot Manager should remain otherwise it will cause problems at later stages. You can consult Arch Wiki depending on your boot manager. After doing that make sure that none of the partitions in this interval is mounted. Probably EFI System is mounted so unmount it. Then take the copy of the portion. Command is like that: **(Command below uses dd so be careful while typing any mistake may cause severe data loss)**

```
# sudo dd if=/dev/nvme0n1 count=&lt;End of Microsoft Reserved + 1&gt; of=/path/to/boot/image status=progress 
```

Value of count will be E**nd of Microsoft Reserved + 1**. (Adding 1 is important). On my system it is 1323007 + 1 = **1323008**.

Then remount back the ESP to where it was. If you don't know check **/etc/fstab** . Then reinstall the Linux boot manager that you removed previously. And verify that it is restored using `efibootmgr` command.

**(ANY MISTAKE IN VALUES BELOW MAY CAUSE DATA LOSS BE CAREFUL. ALWAYS DOUBLE OR EVEN TRIPLE CHECK YOUR VALUES.)**

For the commands that I stated from that point on untill the creation of VM (not included) you have to run the commands everytime after you reboot before running the VM so I highly recommend you to script it. First become root with `sudo su` since we are dealing with variables sudo may cause problem.

```
# loop=`losetup --show -f /path/to/boot/image`
```

**/path/to/boot/image** will be the path to the file that you created using the command with dd above.

```
# start=`blockdev --report /dev/&lt;Windows C: Partition&gt; | tail -1 | awk '{print $5}'`
# size=`blockdev --getsz /dev/&lt;Windows C: Partition&gt;`
```

**<Windows C: Partition>** will be C: drive of your Windows installation. In my case it is **nvme0n1p4**.

```
# disksize=`blockdev --getsz /dev/&lt;SSD&gt;`
```

**<SSD>** will be the device that your Windows and Linux installations reside. In my case it is **nvme0n1**.

Now the part that we created our "mapped device" for our VM.

```
# echo "0 &lt;End of Microsoft Reserved + 1&gt; linear $loop 0
$start $size linear /dev/&lt;Windows C: Partition&gt; 0
$((start+size)) $((disksize-start-size)) zero" | dmsetup create qemu
```

On above there is single command with 3 lines. In first line we are adding loop device of the copy of the Boot-Recovery stuff that we created at the beginning.

If your Windows C: drive starts just after Boot-Recovery stuff (**$start = <End of Microsoft Reserved + 1>**). Then by just setting the **<Windows C: Partition>** to corresponding string for your system (**nvme0n1p4** in my case) you can skip to the step of setting up the VM.

If that is not the case than you need to add the line below to between lines 1 and 2:

```
&lt;End of Microsoft Reserved + 1&gt; $start zero
```

**\--------------------------------VM Setup Continues Below In The Answer---------------------------**