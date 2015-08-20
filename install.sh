NEWHOSTNAME=VM-ArchLinux
ROOTPASSWD=vmpass

# Setup HDD
parted /dev/sda mklabel gpt
parted /dev/sda mkpart primary btrfs 1049KB 18GB
parted /dev/sda mkpart primary linux-swap 18GB 10.20GB
mkfs.btrfs /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2

# Install Base system
mount /dev/sda1 /mnt
grep jp /etc/pacman.d/mirrorlist > mirrorlist
cat /etc/pacman.d/mirrorlist >> mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel

# fstab
genfstab -p /mnt >> /mnt/etc/fstab

# Create Setup Script on chroot environment
cat <<++EOS>>/mnt/setup.sh
#!/bin/bash
echo $NEWHOSTNAME >> /etc/hostname

ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf

echo root:$ROOTPASSWD | chpasswd

## Network
systemctl enable dhcpcd.service

## bootloader
pacman -S --noconfirm gptfdisk
pacman -S --noconfirm syslinux
syslinux-install_update -iam
sed -i 's%root=/dev/sda[0-9]%root=/dev/sda1%g' /boot/syslinux/syslinux.cfg

## vm-tools
pacman -S --noconfirm open-vm-tools
systemctl enable vmtoolsd
++EOS

chmod +x /mnt/setup.sh

# Setup chroot environment
arch-chroot /mnt "/setup.sh"

# end
umount -R /mnt
reboot
