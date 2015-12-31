#!/bin/bash
#                                             __    _ __    __
#                _________ ___  ______ ______/ /_  (_) /_  / /__
#               / ___/ __ `/ / / / __ `/ ___/ __ \/ / __ \/ / _ \
#              (__  ) /_/ / /_/ / /_/ (__  ) / / / / /_/ / /  __/
#             /____/\__, /\__,_/\__,_/____/_/ /_/_/_.___/_/\___/
#                     /_/CROSS-PLATFORM LINUX LIVE IMAGE BUILDER
#
# Migrates data from /var/xapi to /var/lib/xcp
DATA_MOUNT=/persist

# migrate xapi state to new location in 6.6
if [ -f ${DATA_MOUNT}/var/xapi/state.db ]; then
	cp -R ${DATA_MOUNT}/var/xapi/* ${DATA_MOUNT}/var/lib/xcp/
    mv ${DATA_MOUNT}/var/xapi ${DATA_MOUNT}/var/xapi.migrated 
fi

# if xensource inventory exists on persist volume, use that instead of local
if [ -f ${DATA_MOUNT}/etc/xensource-inventory ]; then
	rm /etc/xensource-inventory
	ln -s ${DATA_MOUNT}/etc/xensource-inventory /etc/xensource-inventory
fi
