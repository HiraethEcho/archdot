## backup

备份整个家目录，以便重装完后恢复绝大多数的个人数据。我找到一个闲置的空的移动硬盘，不是空的也没关系，只要剩余空间够放下家目录的内容就行，将其挂载在 `/mnt` 目录下，并新建一个空文件夹 `backup`。为了在恢复数据时保留所有文件的权限，我使用 rsync 命令：

```sh
sudo rsync -avrh --progress /home/ /mnt/backup/
```

重启进入新系统后，因为还未安装图形界面，会进入 tty，因为之后要恢复家目录文件，所以这里暂时先不用普通用户登录，而是登录进 root 用户，开始着手恢复家目录文件，将之前用于备份家目录的移动硬盘重新挂载到 `/mnt` 目录，一样使用 rsync 恢复文件，只需将之前备份命令里两个路径互换位置即可：

```sh
rsync -avrh --progress /mnt/backup/ /home/
```

恢复过程同样需要较长时间，请耐心等待，恢复完成后退出 root 登录，使用普通用户登录。参照之前备份的软件包列表将所需的软件包装回来，再启用一些需要的服务，就可以正常使用了，就和重装前一样。


### Arch Linux 风格特有的snapper配置
虽然看着很麻烦，但其实基本照做即可（假设目标分区是 /dev/nvme0n1p5）。大致的操作就是把 Snapper 创建的 @/.snapshots 删掉，替换成独立的子卷 @snapshots。
```sh
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -o subvol=/ /dev/nvme0n1p5 /mnt
sudo btrfs subvolume create /mnt/@snapshots
```
然后修改 /etc/fstab，参考子卷的方式增加一条将子卷 subvol=@snapshots 挂载到 /.snapshots 的即可。运行 sudo mount -a 生效。

### 用live恢复快照
假设我们已经为`/`创建了快照，如果想要从快照中恢复系统，可以先进入Arch Linux live USB，然后挂载Btrfs分区
```sh
sudo mount /dev/nvme0n1p5 /mnt
cd /mnt
sudo mv /mnt/@ /mnt/@.broken
sudo btrfs subvolume snapshot /mnt/@snapshots/{number}/snapshot /mnt/@
sudo btrfs subvolume delete /mnt/@.broken
```

### 在当前系统rollback
```sh
sudo mount -o subvol=/ /dev/nvme0n1p5 /mnt
sudo btrfs subvolume snapshot /mnt/@ /mnt/@bad
sudo btrfs subvolume delete /mnt/@
sudo btrfs subvolume snapshot /mnt/@snapshots/要恢复的快照号/snapshot /mnt/@
```
用sh脚本实现：
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

# Tips about Arch

## sh
后台挂起
```sh
nohup onedrivegui & > /dev/null
```

## configuration
**net**
Using iwd as backend of NetworkManager:

/etc/NetworkManager/NetworkManager.conf :
```
[device]
wifi.backend=iwd
```
then
```sh
systemctl mask wpa_supplicant
systemctl enable iwd
```

**sound**
- ALSA: is a set of built-in Linux kernel modules.
- PulseAudio: is a general purpose sound server intended to run as a middleware between your applications and your hardware devices, either using ALSA or OSS.
- pamixer: cli mixer of PulseAudio
- pavucontrol: gui of PulseAudio

```
sudo pacman -S alsa-ultis pulseaudio pavucontrol
pulseaudio --check
pulseaudio -D
```

**light**
```sh

sudo pacman -S acpilight
sudo gpasswd video -a _username_ # 或者
sudo usermod -aG video _username_
```

**keyboard**:

find id of touchpad:
```
xinput list | grep -i "Touchpad" | awk '{print $6}' | sed 's/[^0-9]//g'
```

config keys, <kbd>caps</kbd> as <kbd>escape</kbd> and <kbd>ctrl</kbd>
```sh
setxkbmap -option ctrl:nocaps &
xcape -e 'Control_L=Return' &
xcape -e 'Alt_L=Escape' &
```


### wifi

pacman -S grub efibootmgr vim iwd dhcpcd sudo networkmanager

systemctl enable dhcpcd NetworkManager iwd

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
- lightDM

### windows manger

dwm: This is great! But also difficult to config.


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

可能导致pacman更新时的curl ssl certification问题。安装证书后用
```sh
update-ca-trust
```

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

### zotero

### pdf reader

`sioyek`

mail services:
```json
{
    "Aliyun": {
        "domains": ["aliyun.com"],
        "host": "smtp.aliyun.com",
        "port": 465,
        "secure": true
    },

    "Gmail": {
        "aliases": ["Google Mail"],
        "domains": ["gmail.com", "googlemail.com"],
        "host": "smtp.gmail.com",
        "port": 465,
        "secure": true
    },

    "Hotmail": {
        "aliases": ["Outlook", "Outlook.com", "Hotmail.com"],
        "domains": ["hotmail.com", "outlook.com"],
        "host": "smtp-mail.outlook.com",
        "port": 587
    },

    "iCloud": {
        "aliases": ["Me", "Mac"],
        "domains": ["me.com", "mac.com"],
        "host": "smtp.mail.me.com",
        "port": 587
    },

    "OpenMailBox": {
        "aliases": ["OMB", "openmailbox.org"],
        "host": "smtp.openmailbox.org",
        "port": 465,
        "secure": true
    },

    "Outlook365": {
        "host": "smtp.office365.com",
        "port": 587,
        "secure": false
    },

    "QQ": {
        "domains": ["qq.com"],
        "host": "smtp.qq.com",
        "port": 465,
        "secure": true
    },

    "QQex": {
        "aliases": ["QQ Enterprise"],
        "domains": ["exmail.qq.com"],
        "host": "smtp.exmail.qq.com",
        "port": 465,
        "secure": true
    },

    "Yahoo": {
        "domains": ["yahoo.com"],
        "host": "smtp.mail.yahoo.com",
        "port": 465,
        "secure": true
    },

    "Yandex": {
        "domains": ["yandex.ru"],
        "host": "smtp.yandex.ru",
        "port": 465,
        "secure": true
    },

    "126": {
        "host": "smtp.126.com",
        "port": 465,
        "secure": true
    },

    "163": {
        "host": "smtp.163.com",
        "port": 465,
        "secure": true
    }
}
```

```config
# MODIFIED
/etc/fstab
/etc/group
/etc/hosts
/etc/passwd
/etc/resolv.conf
/etc/locale.gen
/etc/default/grub
/etc/mkinitcpio.conf
/etc/NetworkManager/NetworkManager.conf
/etc/ssh/sshd_config
```

```config
[device]
wifi.backend=iwd
```
/etc/pacman.conf
```config
# Misc options
#UseSyslog
Color
#NoProgressBar
CheckSpace
VerbosePkgLists
ParallelDownloads = 5
ILoveCandy

SigLevel    = Never
LocalFileSigLevel = Never
#RemoteFileSigLevel = Required
```
/etc/zsh/zshenv
```config
export ZDOTDIR="$HOME"/.config/zsh
export PATH="$HOME/.local/bin:$PATH"
```
# Pacman

## EXAMPLES
pacman -U /home/user/ceofhack-0.6-1-x86_64.pkg.tar.gz
Install ceofhack-0.6-1 package from a local file.

pacman -Syu
Update package list and upgrade all packages afterwards.

pacman -Syu gpm
Update package list, upgrade all packages, and then install gpm if it wasn’t already installed.

```sh
pacman -Qqe | fzf --preview 'pacman -Qiil {}' --layout=reverse --bind 'enter:execute(pacman -Qiil {} | less)'
```

```sh
pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse
```

```sh
pacman -D --asdeps $(pacman -Qqe)
```

```sh
pacman -D --asexplicit base linux linux-firmware
```

```sh
cat explicit | sudo pacman -D --asexplicit -
```

```sh
pacman -Qii | awk '/^MODIFIED/ {print $2}'
```

## Usage

pacman **operation** [options] [targets]

OPERATIONS:
- -D, --database
- -Q, --query
- -R, --remove
- -S, --sync
- -T, --deptest
Check dependencies; this is useful in scripts such as makepkg to check installed packages. This operation will check each dependency
specified and return a list of dependencies that are not currently satisfied on the system. This operation accepts no other options.
Example usage: pacman -T qt "bash>=3.2".
- -U, --upgrade
Upgrade or add package(s) to the system and install the required dependencies from sync repositories. Either a URL or file path can be
specified. This is a “remove-then-add” process. See Upgrade Options below; also see Handling Config Files for an explanation on how
pacman takes care of configuration files.
- -F, --files
Query the files database. This operation allows you to look for packages owning certain files or display files owned by certain
packages. Only packages that are part of your sync databases are searched. See File Options below.

OPTIONS:
- -b, --dbpath **path**
Specify an alternative database location (the default is /var/lib/pacman). This should not be used unless you know what you are doing.
NOTE: If specified, this is an absolute path, and the root path is not automatically prepended.
- -r, --root **path**
Specify an alternative installation root (default is /). This should not be used as a way to install software into /usr/local instead
of /usr.  NOTE: If database path or log file are not specified on either the command line or in pacman.conf(5), their default location
will be inside this root path.  NOTE: This option is not suitable for performing operations on a mounted guest system. See --sysroot
instead.
- -v, --verbose
Output paths such as the Root, Conf File, DB Path, Cache Dirs, etc.
- --cachedir **dir**
Specify an alternative package cache location (the default is /var/cache/pacman/pkg). Multiple cache directories can be specified, and
they are tried in the order they are passed to pacman.  NOTE: This is an absolute path, and the root path is not automatically
prepended.
- --config **file**
Specify an alternate configuration file.
- --debug
Display debug messages. When reporting bugs, this option is recommended to be used.
- --gpgdir **dir**
Specify a directory of files used by GnuPG to verify package signatures (the default is /etc/pacman.d/gnupg). This directory should
contain two files: pubring.gpg and trustdb.gpg.  pubring.gpg holds the public keys of all packagers.  trustdb.gpg contains a so-called
trust database, which specifies that the keys are authentic and trusted.  NOTE: This is an absolute path, and the root path is not
automatically prepended.
- --hookdir **dir**
Specify a alternative directory containing hook files (the default is /etc/pacman.d/hooks). Multiple hook directories can be specified
with hooks in later directories taking precedence over hooks in earlier directories.  NOTE: This is an absolute path, and the root path
is not automatically prepended.
- --logfile **file**
Specify an alternate log file. This is an absolute path, regardless of the installation root setting.
- --noconfirm
Bypass any and all “Are you sure?” messages. It’s not a good idea to do this unless you want to run pacman from a script.
- --confirm
Cancels the effects of a previous --noconfirm.
- --disable-download-timeout
Disable defaults for low speed limit and timeout on downloads. Use this if you have issues downloading files with proxy and/or security
gateway.
- --sysroot **dir**
Specify an alternative system root. Pacman will chroot and chdir into the system root prior to running. This allows mounted guest
systems to be properly operated on. Any other paths given will be interpreted as relative to the system root. Requires root privileges.

### REMOVE OPTIONS (APPLY TO -R)

-c, --cascade
Remove all target packages, as well as all packages that depend on one or more target packages. This operation is recursive and must be
used with care, since it can remove many potentially needed packages.

-n, --nosave
Instructs pacman to ignore file backup designations. Normally, when a file is removed from the system, the database is checked to see
if the file should be renamed with a .pacsave extension.

-s, --recursive
Remove each target specified including all of their dependencies, provided that (A) they are not required by other packages; and (B)
they were not explicitly installed by the user. This operation is recursive and analogous to a backwards --sync operation, and it helps
keep a clean system without orphans. If you want to omit condition (B), pass this option twice.

-u, --unneeded
Removes targets that are not required by any other packages. This is mostly useful when removing a group without using the -c option,
to avoid breaking any dependencies.

### TRANSACTION OPTIONS (APPLY TO -S, -R AND -U)

-d, --nodeps
Skips dependency version checks. Package names are still checked. Normally, pacman will always check a package’s dependency fields to
ensure that all dependencies are installed and there are no package conflicts in the system. Specify this option twice to skip all
dependency checks.

--assume-installed **package=version**
Add a virtual package "package" with version "version" to the transaction to satisfy dependencies. This allows to disable specific
dependency checks without affecting all dependency checks. To disable all dependency checking, see the --nodeps option.
%l" for location, "%r" for repository, and "%s" for size. Implies --print.

### UPGRADE OPTIONS (APPLY TO -S AND -U)

-w, --downloadonly
Retrieve all packages from the server, but do not install/upgrade anything.

--asdeps
Install packages non-explicitly; in other words, fake their install reason to be installed as a dependency. This is useful for makepkg
and other build-from-source tools that need to install dependencies before building the package.

--asexplicit
Install packages explicitly; in other words, fake their install reason to be explicitly installed. This is useful if you want to mark a
dependency as explicitly installed so it will not be removed by the --recursive remove operation.

--ignore **package**
Directs pacman to ignore upgrades of package even if there is one available. Multiple packages can be specified by separating them with
a comma.

--ignoregroup **group**
Directs pacman to ignore upgrades of all packages in group, even if there is one available. Multiple groups can be specified by
separating them with a comma.

--needed
Do not reinstall the targets that are already up-to-date.

--overwrite **glob**
Bypass file conflict checks and overwrite conflicting files. If the package that is about to be installed contains files that are
already installed and match glob, this option will cause all those files to be overwritten. Using --overwrite will not allow
overwriting a directory with a file or installing packages with conflicting files and directories. Multiple patterns can be specified
by separating them with a comma. May be specified multiple times. Patterns can be negated, such that files matching them will not be
overwritten, by prefixing them with an exclamation mark. Subsequent matches will override previous ones. A leading literal exclamation
mark or backslash needs to be escaped.

### QUERY OPTIONS (APPLY TO -Q)

-c, --changelog
View the ChangeLog of a package if it exists.

-d, --deps
Restrict or filter output to packages installed as dependencies. This option can be combined with -t for listing real orphans -
packages that were installed as dependencies but are no longer required by any installed package.

-e, --explicit
Restrict or filter output to explicitly installed packages. This option can be combined with -t to list explicitly installed packages
that are not required by any other package.

-g, --groups
Display all packages that are members of a named group. If a name is not specified, list all grouped packages.

-i, --info
Display information on a given package. The -p option can be used if querying a package file instead of the local database. Passing two
--info or -i flags will also display the list of backup files and their modification states.

-k, --check
Check that all files owned by the given package(s) are present on the system. If packages are not specified or filter flags are not
provided, check all installed packages. Specifying this option twice will perform more detailed file checking (including permissions,
file sizes, and modification times) for packages that contain the needed mtree file.

-l, --list
List all files owned by a given package. Multiple packages can be specified on the command line.

-m, --foreign
Restrict or filter output to packages that were not found in the sync database(s). Typically these are packages that were downloaded
manually and installed with --upgrade.

-n, --native
Restrict or filter output to packages that are found in the sync database(s). This is the inverse filter of --foreign.

-o, --owns **file**
Search for packages that own the specified file(s). The path can be relative or absolute, and one or more files can be specified.

-p, --file
Signifies that the package supplied on the command line is a file and not an entry in the database. The file will be decompressed and
queried. This is useful in combination with --info and --list.

-q, --quiet
Show less information for certain query operations. This is useful when pacman’s output is processed in a script. Search will only show
package names and not version, group, and description information; owns will only show package names instead of "file is owned by pkg"
messages; group will only show package names and omit group names; list will only show files and omit package names; check will only
show pairs of package names and missing files; a bare query will only show package names rather than names and versions.

-s, --search **regexp**
Search each locally-installed package for names or descriptions that match regexp. When including multiple search terms, only packages
with descriptions matching ALL of those terms are returned.

-t, --unrequired
Restrict or filter output to print only packages neither required nor optionally required by any currently installed package. Specify
this option twice to include packages which are optionally, but not directly, required by another package.

-u, --upgrades
Restrict or filter output to packages that are out-of-date on the local system. Only package versions are used to find outdated
packages; replacements are not checked here. This option works best if the sync database is refreshed using -Sy.


### SYNC OPTIONS (APPLY TO -S)

-c, --clean
Remove packages that are no longer installed from the cache as well as currently unused sync databases to free up disk space. When
pacman downloads packages, it saves them in a cache directory. In addition, databases are saved for every sync DB you download from and
are not deleted even if they are removed from the configuration file pacman.conf(5). Use one --clean switch to only remove packages
that are no longer installed; use two to remove all files from the cache. In both cases, you will have a yes or no option to remove
packages and/or unused downloaded databases.

If you use a network shared cache, see the CleanMethod option in pacman.conf(5).

-g, --groups
Display all the members for each package group specified. If no group names are provided, all groups will be listed; pass the flag
twice to view all groups and their members.

-i, --info
Display information on a given sync database package. Passing two --info or -i flags will also display those packages in all
repositories that depend on this package.

-l, --list
List all packages in the specified repositories. Multiple repositories can be specified on the command line.

-q, --quiet
Show less information for certain sync operations. This is useful when pacman’s output is processed in a script. Search will only show
package names and not repository, version, group, and description information; list will only show package names and omit databases and
versions; group will only show package names and omit group names.

-s, --search **regexp**
This will search each package in the sync databases for names or descriptions that match regexp. When you include multiple search
terms, only packages with descriptions matching ALL of those terms will be returned.

-u, --sysupgrade
Upgrades all packages that are out-of-date. Each currently-installed package will be examined and upgraded if a newer package exists. A
report of all packages to upgrade will be presented, and the operation will not proceed without user confirmation. Dependencies are
automatically resolved at this level and will be installed/upgraded if necessary.

Pass this option twice to enable package downgrades; in this case, pacman will select sync packages whose versions do not match with
the local versions. This can be useful when the user switches from a testing repository to a stable one.

Additional targets can also be specified manually, so that -Su foo will do a system upgrade and install/upgrade the "foo" package in
the same operation.

-y, --refresh
Download a fresh copy of the master package database from the server(s) defined in pacman.conf(5). This should typically be used each
time you use --sysupgrade or -u. Passing two --refresh or -y flags will force a refresh of all package databases, even if they appear
to be up-to-date.

### DATABASE OPTIONS (APPLY TO -D)

--asdeps **package**
Mark a package as non-explicitly installed; in other words, set their install reason to be installed as a dependency.

--asexplicit **package**
Mark a package as explicitly installed; in other words, set their install reason to be explicitly installed. This is useful if you want
to keep a package installed even when it was initially installed as a dependency of another package.

-k, --check
Check the local package database is internally consistent. This will check all required files are present and that installed packages
have the required dependencies, do not conflict and that multiple packages do not own the same file. Specifying this option twice will
perform a check on the sync databases to ensure all specified dependencies are available.

-q, --quiet
Suppress messages on successful completion of database operations.

### FILE OPTIONS (APPLY TO -F)

-y, --refresh
Download fresh package databases from the server. Use twice to force a refresh even if databases are up to date.

-l, --list
List the files owned by the queried package.

-x, --regex
Interpret each query as a regular expression.

-q, --quiet
Show less information for certain file operations. This is useful when pacman’s output is processed in a script, however, you may want
to use --machinereadable instead.

--machinereadable
Print each match in a machine readable output format. The format is repository\0pkgname\0pkgver\0path\n with \0 being the NULL
character and \n a linefeed.

## HANDLING CONFIG FILES

Pacman uses the same logic as rpm to determine action against files that are designated to be backed up. During an upgrade, three MD5
hashes are used for each backup file to determine the required action: one for the original file installed, one for the new file that is
about to be installed, and one for the actual file existing on the file system. After comparing these three hashes, the following scenarios
can result:

original=X, current=X, new=X
All three files are the same, so overwrites are not an issue. Install the new file.

original=X, current=X, new=Y
The current file is the same as the original, but the new one differs. Since the user did not ever modify the file, and the new one may
contain improvements or bug fixes, install the new file.

original=X, current=Y, new=X
Both package versions contain the exact same file, but the one on the file system has been modified. Leave the current file in place.

original=X, current=Y, new=Y
The new file is identical to the current file. Install the new file.

original=X, current=Y, new=Z
All three files are different, so install the new file with a .pacnew extension and warn the user. The user must then manually merge
any necessary changes into the original file.

original=NULL, current=Y, new=Z
The package was not previously installed, and the file already exists on the file system. Install the new file with a .pacnew extension
and warn the user. The user must then manually merge any necessary changes into the original file.


# stow MAN
stow(8)                                                 User Contributed Perl Documentation                                                stow(8)

NAME
       stow - manage farms of symbolic links

SYNOPSIS
       stow [ options ] package ...

TERMINOLOGY
       A "package" is a related collection of files and directories that you wish to administer as a unit -- e.g., Perl or Emacs -- and that needs
       to be installed in a particular directory structure -- e.g., with bin, lib, and man subdirectories.

       A "target directory" is the root of a tree in which one or more packages wish to appear to be installed. A common, but by no means the only
       such location is /usr/local.  The examples in this manual page will use /usr/local as the target directory.

       A "stow directory" is the root of a tree containing separate packages in private subtrees. When Stow runs, it uses the current directory as
       the default stow directory. The examples in this manual page will use /usr/local/stow as the stow directory, so that individual packages
       will be, for example, /usr/local/stow/perl and /usr/local/stow/emacs.

       An "installation image" is the layout of files and directories required by a package, relative to the target directory. Thus, the
       installation image for Perl includes: a bin directory containing perl and a2p (among others); an info directory containing Texinfo
       documentation; a lib/perl directory containing Perl libraries; and a man/man1 directory containing man pages.

       A "package directory" is the root of a tree containing the installation image for a particular package. Each package directory must reside
       in a stow directory -- e.g., the package directory /usr/local/stow/perl must reside in the stow directory /usr/local/stow.  The "name" of a
       package is the name of its directory within the stow directory -- e.g., perl.

       Thus, the Perl executable might reside in /usr/local/stow/perl/bin/perl, where /usr/local is the target directory, /usr/local/stow is the
       stow directory, /usr/local/stow/perl is the package directory, and bin/perl within is part of the installation image.

       A "symlink" is a symbolic link. A symlink can be "relative" or "absolute". An absolute symlink names a full path; that is, one starting
       from /.  A relative symlink names a relative path; that is, one not starting from /.  The target of a relative symlink is computed starting
       from the symlink's own directory.  Stow only creates relative symlinks.

OPTIONS
       The stow directory is assumed to be the value of the "STOW_DIR" environment variable or if unset the current directory, and the target
       directory is assumed to be the parent of the current directory (so it is typical to execute stow from the directory /usr/local/stow).  Each
       package given on the command line is the name of a package in the stow directory (e.g., perl).  By default, they are installed into the
       target directory (but they can be deleted instead using "-D").

       -n
       --no
           Do not perform any operations that modify the filesystem; merely show what would happen.

       -d DIR
       --dir=DIR
           Set  the  stow directory to "DIR" instead of the current directory.  This also has the effect of making the default target directory be
           the parent of "DIR".

       -t DIR
       --target=DIR
           Set the target directory to "DIR" instead of the parent of the stow directory.

       -v
       --verbose[=N]
           Send verbose output to standard error describing what Stow is doing. Verbosity levels are from 0 to 5; 0 is the default.  Using "-v" or
           "--verbose" increases the verbosity by one; using ‘--verbose=N' sets it to N.

       -S
       --stow
           Stow the packages that follow this option into the target directory.  This is the default action and so can be omitted if you are  only
           stowing packages rather than performing a mixture of stow/delete/restow actions.

       -D
       --delete
           Unstow the packages that follow this option from the target directory rather than installing them.

       -R
       --restow
           Restow  packages  (first unstow, then stow again). This is useful for pruning obsolete symlinks from the target tree after updating the
           software in a package.

       --adopt
           Warning!  This behaviour is specifically intended to alter the contents of your stow directory.  If you do not want that,  this  option
           is not for you.

           When  stowing,  if a target is encountered which already exists but is a plain file (and hence not owned by any existing stow package),
           then normally Stow will register this as a conflict and refuse to proceed.  This option changes that behaviour  so  that  the  file  is
           moved  to  the  same  relative  place  within  the package's installation image within the stow directory, and then stowing proceeds as
           before.  So effectively, the file becomes adopted by the stow package, without its contents changing.

       --no-folding
           Disable folding of newly stowed directories when stowing, and refolding of newly foldable directories when unstowing.

       --ignore=REGEX
           Ignore files ending in this Perl regex.

       --defer=REGEX
           Don't stow files beginning with this Perl regex if the file is already stowed to another package.

       --override=REGEX
           Force stowing files beginning with this Perl regex if the file is already stowed to another package.

       --dotfiles
           Enable special handling for "dotfiles" (files or folders whose name begins with a period) in the package directory. If this  option  is
           enabled, Stow will add a preprocessing step for each file or folder whose name begins with "dot-", and replace the "dot-" prefix in the
           name  by  a period (.). This is useful when Stow is used to manage collections of dotfiles, to avoid having a package directory full of
           hidden files.

           For example, suppose we have a package containing two files, stow/dot-bashrc and stow/dot-emacs.d/init.el. With this option, Stow  will
           create symlinks from .bashrc to stow/dot-bashrc and from .emacs.d/init.el to stow/dot-emacs.d/init.el. Any other files, whose name does
           not begin with "dot-", will be processed as usual.

       -V
       --version
           Show Stow version number, and exit.

       -h
       --help
           Show Stow command syntax, and exit.

INSTALLING PACKAGES
       The default action of Stow is to install a package. This means creating symlinks in the target tree that point into the package tree.  Stow
       attempts  to do this with as few symlinks as possible; in other words, if Stow can create a single symlink that points to an entire subtree
       within the package tree, it will choose to do that rather than create a directory in the target tree and populate it with symlinks.

       For example, suppose that no packages have yet been installed in /usr/local; it's completely empty (except for the  stow  subdirectory,  of
       course).  Now  suppose  the  Perl  package is installed.  Recall that it includes the following directories in its installation image: bin;
       info; lib/perl; man/man1.  Rather than creating the directory /usr/local/bin and populating it with symlinks to  ../stow/perl/bin/perl  and
       ../stow/perl/bin/a2p  (and so on), Stow will create a single symlink, /usr/local/bin, which points to stow/perl/bin.  In this way, it still
       works to refer to /usr/local/bin/perl and /usr/local/bin/a2p, and fewer symlinks have been created. This is called "tree folding", since an
       entire subtree is "folded" into a single symlink.

       To complete this example, Stow will also create the symlink /usr/local/info pointing to stow/perl/info; the symlink /usr/local/lib pointing
       to stow/perl/lib; and the symlink /usr/local/man pointing to stow/perl/man.

       Now suppose that instead of installing the Perl package into an empty target tree, the target tree is not empty to begin with. Instead,  it
       contains  several files and directories installed under a different system-administration philosophy. In particular, /usr/local/bin already
       exists and is a directory, as are /usr/local/lib and /usr/local/man/man1.  In this case, Stow will descend into /usr/local/bin  and  create
       symlinks  to  ../stow/perl/bin/perl  and  ../stow/perl/bin/a2p  (etc.), and it will descend into /usr/local/lib and create the tree-folding
       symlink perl pointing to ../stow/perl/lib/perl, and so on. As a rule, Stow only descends as far as necessary into the target tree  when  it
       can create a tree-folding symlink.

       The  time often comes when a tree-folding symlink has to be undone because another package uses one or more of the folded subdirectories in
       its installation image. This operation is called "splitting open" a folded tree. It involves removing the original symlink from the  target
       tree, creating a true directory in its place, and then populating the new directory with symlinks to the newly-installed package and to the
       old  package that used the old symlink. For example, suppose that after installing Perl into an empty /usr/local, we wish to install Emacs.
       Emacs's installation image includes a bin directory containing the emacs and etags executables, among others. Stow must  make  these  files
       appear  to  be installed in /usr/local/bin, but presently /usr/local/bin is a symlink to stow/perl/bin.  Stow therefore takes the following
       steps: the  symlink  /usr/local/bin  is  deleted;  the  directory  /usr/local/bin  is  created;  links  are  made  from  /usr/local/bin  to
       ../stow/emacs/bin/emacs   and   ../stow/emacs/bin/etags;   and   links   are   made   from   /usr/local/bin  to  ../stow/perl/bin/perl  and
       ../stow/perl/bin/a2p.

       When splitting open a folded tree, Stow makes sure that the symlink it is about to remove points inside a valid package in the current stow
       directory.

   Stow will never delete anything that it doesn't own.
       Stow "owns" everything living in the target tree that points into a package in the stow directory. Anything Stow owns, it can recompute  if
       lost. Note that by this definition, Stow doesn't "own" anything in the stow directory or in any of the packages.

       If  Stow  needs to create a directory or a symlink in the target tree and it cannot because that name is already in use and is not owned by
       Stow, then a conflict has arisen. See the "Conflicts" section in the info manual.

DELETING PACKAGES
       When the "-D" option is given, the action of Stow is to delete a package from the target tree. Note that Stow will not delete  anything  it
       doesn't "own". Deleting a package does not mean removing it from the stow directory or discarding the package tree.

       To  delete a package, Stow recursively scans the target tree, skipping over the stow directory (since that is usually a subdirectory of the
       target tree) and any other stow directories it encounters (see "Multiple stow directories" in the info manual). Any symlink it  finds  that
       points  into  the package being deleted is removed. Any directory that contained only symlinks to the package being deleted is removed. Any
       directory that, after removing symlinks and empty subdirectories, contains only symlinks to a single other package, is considered to  be  a
       previously "folded" tree that was "split open."  Stow will re-fold the tree by removing the symlinks to the surviving package, removing the
       directory, then linking the directory back to the surviving package.

RESOURCE FILES
       Stow  searches  for  default  command  line  options  at  .stowrc (current directory) and ~/.stowrc (home directory) in that order. If both
       locations are present, the files are effectively appended together.

       The effect of options in the resource file is similar to simply prepending the options to the command line.  For  options  that  provide  a
       single  value,  such as --target or --dir, the command line option will overwrite any options in the resource file. For options that can be
       given more than once, --ignore for example, command line options and resource options are appended together.

       Environment variables and the tilde character (~) will be expanded for options that take a file path.

       The options -D, -R, -S, and any packages listed in the resource file are ignored.

       See the info manual for more information on how stow handles resource file.

SEE ALSO
       The full documentation for stow is maintained as a Texinfo manual.  If the info and stow programs are properly installed at your site,  the
       command

           info stow

       should give you access to the complete manual.
# tmux

## prefix

```
tmux show-options -g | grep prefix
```

```
tmux set -g prefix C-x tmux unbind C-b tmux bind C-x send-prefix
```

```
set -g prefix C-x unbind C-b bind C-x send-prefix
```

## session

```
tmux new -s $session_name

Ctrl+b :kill-session

tmux a -t $session_name

Ctrl+b :kill-server

session tmux kill-session -t $session_name

Ctrl+b $ // rename a session
```

## window

window in tmux is like tab in vim, and window can be moved into different sessions.

```
Ctrl+b +c       // creat a window
Ctrl+b &        // delete a window
Ctrl+b n        // next window
Ctrl+b p        // previous window
window Ctrl+b , // rename the window
Ctrl+b f        // search in windows
Ctrl+b l        // switch between windows
```

## pane

pane in tmux is like window in vim.
```
horizontal Ctrl+b ”               // vsplit pane
vertical Ctrl+b %                 // split pane
Ctrl+b o                          // move in panes
Ctrl+b :resize-pane -U
Ctrl+b :resize-pane -D
Ctrl+b :resize-pane -L
Ctrl+b :resize-pane -R
Ctrl+b :resize-pane -D 50         // resize pane
Ctrl+b {                          // movie pane to left
Ctrl+b }                          // movie pane to right
Ctrl+b x                          // delete pane
Ctrl+b <space>                    // change layout of panes
Ctrl+b !                          // move pane to a new window
Ctrl+b :join-pane -t $window_name // move pane into a window
Ctrl+b q                          // show pane index
```

# ssh
after add sshkey, if using watt to connect github, there are problems with port.
use 
```bash
ssh -T -p 443 git@ssh.github.com
```
to verify. should return
```bash
... You've successfully authenicated, but GitHub does not provide shell acess.
```

add following to `~/.ssh/config` 
```
Host github.com
Hostname ssh.github.com
Port 443
User git
```

# Reference

1.  [ArchWiki-Btrfs](https://wiki.archlinux.org/title/Btrfs)
2.  [Working with Btrfs – General Concepts](https://fedoramagazine.org/working-with-btrfs-general-concepts/)
3.  [Working with Btrfs – Subvolumes](https://fedoramagazine.org/working-with-btrfs-subvolumes/)
4.  [Working with Btrfs – Snapshots](https://fedoramagazine.org/working-with-btrfs-snapshots/)
5.  [ArchWiki-Snapper](https://wiki.archlinux.org/title/snapper)
6.  [BTRFS snapshots and system rollbacks on Arch Linux](https://www.dwarmstrong.org/btrfs-snapshots-rollbacks/)
