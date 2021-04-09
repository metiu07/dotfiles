#!/bin/sh

set -e  # Exit on failure

BASE_DEV="/dev/sda"          # Disk where to install arch: /dev/sda
USERNAME="user"              # Default user account for the system
USERNAME_SHELL="/bin/fish"   # bash: /bin/bash
DEFAULT_ZONE="Europe/Prague" # Timezone
PREF_LANG="en_US.UTF-8"      # Preferred system language
HOSTNAME="arch-usb"          # Preferred system hostname

# Example: /dev/nvme0n1p3
DEV_EFI="${BASE_DEV}1"
DEV_ROOT="${BASE_DEV}2"

ESP="/efi"

# swapoff --all
# umount -R /mnt || true
# cryptsetup close "${CRYPTO_NAME}"

timedatectl set-ntp true

mkfs.fat -F32 "${DEV_EFI}"
mkfs.ext4 -O "^has_journal" "${DEV_ROOT}"

mount "${DEV_ROOT}" /mnt
mkdir "/mnt${ESP}"
mount "${DEV_EFI}" "/mnt${ESP}"

pacstrap -c /mnt base linux linux-firmware lvm2 btrfs-progs grub efibootmgr vim networkmanager fish tmux git xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau python3 exa fd ripgrep neovim nodejs yarn binwalk zip unzip atool wireshark-cli gcc clang nethack bat cmake dash bluez-utils exfat-utils fzf lynx htop ipython net-tools ntfs-3g ranger radare2 pv openssh strace sway waybar nmap network-manager-applet ttf-hack ttf-inconsolata time ttf-font-awesome hyperfine wl-clipboard tcpdump tcpflow unrar usbutils swaylock zathura zathura-pdf-mupdf arch-install-scripts netctl dialog firefox alacritty

genfstab -U /mnt >> /mnt/etc/fstab

# Configure mkinitcpio hooks
echo "# HOOKS=(base udev block keyboard autodetect modconf filesystems fsck)" >> /mnt/etc/mkinitcpio.conf
vim /mnt/etc/mkinitcpio.conf

# Configure system language
echo "LANG=${PREF_LANG}" >> /mnt/etc/locale.conf
echo "${PREF_LANG} UTF-8" >> /mnt/etc/locale.gen

# Systemd journal should be in the RAM 
mkdir -p /mnt/etc/systemd/journald.conf.d
echo "[Journal]
Storage=volatile
RuntimeMaxUse=30M" > /mnt/etc/systemd/journald.conf.d/usbstick.conf

# Configure hostname and hosts
echo "${HOSTNAME}" > /mnt/etc/hostname
echo -e "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\t${HOSTNAME}.localdomain ${HOSTNAME}" > /mnt/etc/hosts

git clone https://www.github.com/metiu07/dotfiles /mnt/root/dotfiles

# Arch-chroot
echo "ln -sf /usr/share/zoneinfo/${DEFAULT_ZONE} /etc/localtime
hwclock --systohc
locale-gen
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=${ESP} --bootloader-id=GRUB_USB --removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable bluetooth
chsh -s /bin/fish
useradd -s ${USERNAME_SHELL} -m ${USERNAME}
cd ~/dotfiles && ./install.py -a linux" | arch-chroot /mnt

# Configure system passwords
echo "Change root and ${USERNAME} password: passwd"
arch-chroot /mnt

echo "Unmount disks: umount -R /mnt (if busy use fuser)"
echo "Reboot the system: reboot"
