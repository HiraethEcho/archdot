# Arch cli install

## 

## wifi
pacman -S grub efibootmgr vim iwd dhcpcd sudo networkmanager

systemctl enable dhcpcd NetworkManager iwd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=<你想要在efi引导时显示的名字，建议为ArchLinux>
