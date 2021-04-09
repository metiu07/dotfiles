#!/bin/sh

set -e  # Exit on failure

BASE_DEV="/dev/nvme0n1p"     # Disk where to install arch: /dev/sda
USERNAME="asd"               # Default user account for the system
USERNAME_SHELL="/bin/fish"   # bash: /bin/bash
ROOT_PERCENTAGE=40           # Size of the root partition
DEFAULT_ZONE="Europe/Prague" # Timezone
PREF_LANG="en_US.UTF-8"      # Preferred system language
HOSTNAME="arch-nb"           # Preferred system hostname

# Example: /dev/nvme0n1p3
DEV_BOOT="${BASE_DEV}1"
DEV_EFI="${BASE_DEV}2"
DEV_CRYPTO="${BASE_DEV}3"

CRYPTO_NAME="cryptlvm"
VG_ARCH="arch"

ESP="/efi"

# swapoff --all
# umount -R /mnt || true
# cryptsetup close "${CRYPTO_NAME}"

timedatectl set-ntp true

cryptsetup luksFormat "${DEV_CRYPTO}"
cryptsetup open "${DEV_CRYPTO}" "${CRYPTO_NAME}"

pvcreate "/dev/mapper/${CRYPTO_NAME}"
vgcreate "${VG_ARCH}" "/dev/mapper/${CRYPTO_NAME}"
lvcreate -L 16G "${VG_ARCH}" -n swap
lvcreate -l ${ROOT_PERCENTAGE}%FREE "${VG_ARCH}" -n root
lvcreate -l 100%FREE "${VG_ARCH}" -n home

mkfs.fat -F32 "${DEV_BOOT}"
mkfs.fat -F32 "${DEV_EFI}"
mkfs.ext4 "/dev/mapper/${VG_ARCH}-home"
mkfs.btrfs "/dev/mapper/${VG_ARCH}-root"
mkswap "/dev/mapper/${VG_ARCH}-swap"

mount "/dev/mapper/${VG_ARCH}-root" /mnt
mkdir "/mnt/home"
mkdir "/mnt/boot"
mkdir "/mnt${ESP}"

mount "/dev/mapper/${VG_ARCH}-home" /mnt/home
mount "${DEV_BOOT}" "/mnt/boot"
mount "${DEV_EFI}" "/mnt${ESP}"
swapon "/dev/mapper/${VG_ARCH}-swap"

pacstrap /mnt base linux linux-firmware lvm2 grub efibootmgr vim networkmanager fish tmux git sudo python3

genfstab -U /mnt >> /mnt/etc/fstab

# Configure mkinitcpio hooks
echo "# HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)" >> /mnt/etc/mkinitcpio.conf
vim /mnt/etc/mkinitcpio.conf

# Configure grub kernel options
DEV_CRYPTO_UUID=$(blkid ${DEV_CRYPTO} -o value -s UUID)  # NOTE: This needs to be updated on every format of the disk
echo "# GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${DEV_CRYPTO_UUID}:${CRYPTO_NAME} root=/dev/mapper/${VG_ARCH}-root\"" >> /mnt/etc/default/grub
echo "# GRUB_CMDLINE_LINUX=\"cryptdevice=${DEV_CRYPTO}:${CRYPTO_NAME} root=/dev/mapper/${VG_ARCH}-root\"" >> /mnt/etc/default/grub
echo "# GRUB_CMDLINE_LINUX=\"cryptdevice=${DEV_CRYPTO}:${CRYPTO_NAME}\"" >> /mnt/etc/default/grub
vim /mnt/etc/default/grub

# Configure system language
echo "LANG=${PREF_LANG}" >> /mnt/etc/locale.conf
echo "${PREF_LANG} UTF-8" >> /mnt/etc/locale.gen

# Configure hostname and hosts
echo "${HOSTNAME}" > /mnt/etc/hostname
echo -e "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\t${HOSTNAME}.localdomain ${HOSTNAME}" > /mnt/etc/hosts

# Arch-chroot
echo "ln -sf /usr/share/zoneinfo/${DEFAULT_ZONE} /etc/localtime
hwclock --systohc
locale-gen
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=${ESP} --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable bluetooth
useradd -s ${USERNAME_SHELL} -m ${USERNAME}
gpasswd -a ${USERNAME} wheel
gpasswd -a ${USERNAME} video # for the light" | arch-chroot /mnt

# Configure system passwords
echo "Change root and ${USERNAME} password: passwd"
arch-chroot /mnt

echo "Unmount disks: umount -R /mnt (if busy use fuser)"
echo "Reboot the system: reboot"
