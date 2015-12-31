#!/bin/bash
#                                             __    _ __    __
#                _________ ___  ______ ______/ /_  (_) /_  / /__
#               / ___/ __ `/ / / / __ `/ ___/ __ \/ / __ \/ / _ \
#              (__  ) /_/ / /_/ / /_/ (__  ) / / / / /_/ / /  __/
#             /____/\__, /\__,_/\__,_/____/_/ /_/_/_.___/_/\___/
#                     /_/CROSS-PLATFORM LINUX LIVE IMAGE BUILDER
#
# This script prepares the persistent disk.

# Ensure that the /persist mountpoint exists so that we can use it in /etc/fstab
mkdir -p /persist

# Which disk device should we use?
# NOTE: *da is used here so that we catch /dev/sda on production systems
# as well as /dev/vda on KVM test environments.
DISK=`parted -l -m -s 2>/dev/null | grep "/dev/.*da" | head -n 1 | sort | cut -d: -f 1`
echo "[SQUASHIBLE] Found persistent disk device: ${DISK}"

# Do we already have some partitions on this volume?
PART_COUNT=`parted -m -s ${DISK} print | tail -n+3 | wc -l`
echo "[SQUASHIBLE] Current partition cound for ${DISK}: ${PART_COUNT}"

if [ $PART_COUNT -gt "0" ]; then
  echo "[SQUASHIBLE] We already have partitions on ${DISK} (found ${PART_COUNT}) -- no changes made"
else
  echo "[SQUASHIBLE] Creating partitions and filesystems on ${DISK}..."
  parted $DISK -s -a optimal -- mklabel gpt
  parted $DISK -s -a optimal -- mkpart primary 1 4295
  parted $DISK -s -a optimal -- mkpart secondary 4296 8590
  parted $DISK -s -a optimal -- mkpart sr 8591 -1
  parted $DISK -s -a optimal -- set 1 boot on
  parted $DISK -s -a optimal -- toggle 3 lvm
  parted $DISK -s print
  mkfs.ext3 ${DISK}1
  mkfs.ext3 ${DISK}2
  echo "[SQUASHIBLE] ${DISK} is ready to be used as persistent storage"
fi

echo "[SQUASHIBLE] Generating /etc/fstab"
cat > "/etc/fstab" <<EOF
${DISK}1         /persist    ext3     defaults                       0  0
/persist/swapfile    swap         swap     defaults                       0  0
EOF

echo "[SQUASHIBLE] Mounting all disks..."
mount -a

echo "[SQUASHIBLE] Creating swapfile if it doesn't exist..."
SWAPFILE=/persist/swapfile
if [[ ! -f $SWAPFILE ]]
  then
    echo Swap file not found, generating one
    dd if=/dev/zero of=$SWAPFILE bs=1M count=512
    chmod 0600 $SWAPFILE
    mkswap $SWAPFILE
    swapon $SWAPFILE
else
  swapon $SWAPFILE
fi

exit 0
