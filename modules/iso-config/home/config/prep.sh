#!/usr/bin/env bash
DISK=/dev/vda

parted --script --align=optimal  "${DISK}" -- \
mklabel gpt \
mkpart EFI 0% 512MiB \
mkpart primary 512MiB 100% \
set 1 esp on 

partprobe "${DISK}"
udevadm settle

mkfs.fat -F 32 -n boot ${DISK}1

mkfs.ext4 -L nixos ${DISK}2

udevadm settle

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt

cd /mnt/etc/nixos
rsync -avP --copy-links /home/nixos/config/* .
chmod -R 644 *
git init
git add .

nixos-install --flake \.#host --root /mnt --no-root-password


