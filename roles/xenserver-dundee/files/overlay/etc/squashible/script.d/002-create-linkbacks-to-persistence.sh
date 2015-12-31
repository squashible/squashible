#!/bin/bash
#                                             __    _ __    __
#                _________ ___  ______ ______/ /_  (_) /_  / /__
#               / ___/ __ `/ / / / __ `/ ___/ __ \/ / __ \/ / _ \
#              (__  ) /_/ / /_/ / /_/ (__  ) / / / / /_/ / /  __/
#             /____/\__, /\__,_/\__,_/____/_/ /_/_/_.___/_/\___/
#                     /_/CROSS-PLATFORM LINUX LIVE IMAGE BUILDER
#
# This script creates symbolic links from the live filesystem to the 
# persistent disk.

# persistent data store location
DATA_MOUNT=/persist

# list of dirs to linkback to
LINKBACKS="/var/lib/openvswitch
           /var/lib/xcp
           /etc/xapi
           /etc/ssh
           /etc/firstboot.d/data
           /etc/firstboot.d/state
           /etc/firstboot.d/log
           /etc/udev/rules.d
           /var/log"

echo "[SQUASHIBLE] Creating linkbacks..."

for ITEM in $LINKBACKS; do

  # Does the item already exist in persistent storage?
  if [[ ! -e ${DATA_MOUNT}${ITEM} ]] || [[ $ITEM == "/opt/rackstack" ]]; then
    echo "[SQUASHIBLE] Syncing ${ITEM} from live image to persistent disk... "
    # For directories
    if [[ ${ITEM: -1} == "/" ]]; then
      mkdir -vp ${DATA_MOUNT}${ITEM}
      if [ -e ${ITEM} ]; then
        if [ $ITEM == "/opt/rackstack" ]; then
          # Exclude current -- it's a symlink
          echo skipping...
          #rsync -aX ${ITEM} ${DATA_MOUNT}${ITEM} --exclude=current
        else
          rsync -aX ${ITEM} ${DATA_MOUNT}${ITEM}
        fi
      fi
    # For files
    else
      mkdir -vp ${DATA_MOUNT}`dirname ${ITEM}`
      if [ -e ${ITEM} ]; then
        rsync -aX ${ITEM} ${DATA_MOUNT}`dirname ${ITEM}`
      fi
    fi
  else
    echo "[SQUASHIBLE] Found ${ITEM} in persistent store -- no changes made"
  fi

  # Remove the file from the live filesystem and make a symlink
  echo "[SQUASHIBLE] Creating symlink ${ITEM%/*} -> ${DATA_MOUNT}${ITEM}"
  rm -rf ${ITEM}
  ln -vs ${DATA_MOUNT}${ITEM} ${ITEM%/*}

done

# Ensure ssh host keys have the right permissions
chmod 0600 /etc/ssh/ssh_host*

echo "[SQUASHIBLE] Linkbacks completed."
