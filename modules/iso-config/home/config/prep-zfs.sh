#!/usr/bin/env bash
DISK=
POOL=

parted --script $DISK -- mklabel gpt
parted --script $DISK -- mkpart ESP fat32 1MiB 512MiB
parted --script $DISK -- mkpart primary 512MiB -8GiB
parted --script $DISK -- mkpart primary linux-swap -8GiB 100%
parted --script $DISK -- set 1 esp on

mkswap ${DISK}3
mkfs.fat -F 32 -n boot ${DISK}1

# to enable encryption, -O encryption=aes-256-gcm -O keyformat=passphrase
zpool create -O mountpoint=none -O atime=off -O compression=lz4 -O xattr=sa -O acltype=posixacl -o ashift=12 -o autotrim=on -R /mnt $POOL ${DISK}2

zfs set recordsize=64k $POOL

zfs create -o mountpoint=legacy "${POOL}/local"
zfs create -o mountpoint=legacy "${POOL}/system"
zfs create -o mountpoint=legacy "${POOL}/user"
zfs create -o mountpoint=legacy "${POOL}/reserved"


zfs create "${POOL}/local/nix"
zfs create "${POOL}/system/var"
zfs create "${POOL}/system/root"
zfs create "${POOL}/user/home"
# zfs create "${POOL}/user/home/${MY_USER}"

# reserve 10% of drive for better wear leveling
zfs set reservation=40G "${POOL}/reserved"
zfs set quota=40G "${POOL}/reserved"

# Mount the root partition itself
mount -t zfs "${POOL}/system/root" /mnt

# Make directory entries for the subsequent mounts
mkdir -p /mnt/boot
mkdir -p /mnt/nix
mkdir -p /mnt/var
mkdir -p /mnt/home
# mkdir -p "/mnt/home/${MY_USER}"

# Mount the boot partition
mount "${DISK}1" /mnt/boot

# Mount the rest of our zfs datasets
mount -t zfs "${POOL}/local/nix" /mnt/nix
mount -t zfs "${POOL}/system/var" /mnt/var
mount -t zfs "${POOL}/user/home" "/mnt/home"
# mount -t zfs "${POOL}/user/home/${MY_USER}" "/mnt/home/${MY_USER}"

nixos-generate-config --root /mnt

cd /mnt/etc/nixos
rsync -avP --copy-links /home/nixos/config/* .
chmod -R 644 *
git init
git add .

nixos-install --flake \.#host --root /mnt --no-root-password
cd /
zpool export "${POOL}"
