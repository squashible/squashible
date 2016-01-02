#!/bin/bash -x
#                                             __    _ __    __
#                _________ ___  ______ ______/ /_  (_) /_  / /__
#               / ___/ __ `/ / / / __ `/ ___/ __ \/ / __ \/ / _ \
#              (__  ) /_/ / /_/ / /_/ (__  ) / / / / /_/ / /  __/
#             /____/\__, /\__,_/\__,_/____/_/ /_/_/_.___/_/\___/
#                     /_/CROSS-PLATFORM LINUX LIVE IMAGE BUILDER
#
# This script runs all scripts found within /etc/squashible/script.d/

SCRIPT_PATH='/etc/squashible/script.d/'

echo "[SQUASHIBLE] Running SQUASHIBLE scripts..."

for SCRIPT in `ls ${SCRIPT_PATH}`; do
   echo "[SQUASHIBLE] Running script: ${SCRIPT_PATH}%{SCRIPT}..."
   chmod +x ${SCRIPT_PATH}${SCRIPT}
   ${SCRIPT_PATH}${SCRIPT}
done

echo "[SQUASHIBLE] All SQUASHIBLE scripts finished."
