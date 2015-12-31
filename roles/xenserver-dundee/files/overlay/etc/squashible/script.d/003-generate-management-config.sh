#!/bin/bash
#                                             __    _ __    __
#                _________ ___  ______ ______/ /_  (_) /_  / /__
#               / ___/ __ `/ / / / __ `/ ___/ __ \/ / __ \/ / _ \
#              (__  ) /_/ / /_/ / /_/ (__  ) / / / / /_/ / /  __/
#             /____/\__, /\__,_/\__,_/____/_/ /_/_/_.___/_/\___/
#                     /_/CROSS-PLATFORM LINUX LIVE IMAGE BUILDER
#
# Generate management.conf

management_file=/etc/firstboot.d/data/management.conf

# Grab all networking information from command line
ifline=`cat /proc/cmdline | sed 's/ /\n/g' | grep '^ip=' | cut -d = -f 2`
nameservers=`cat /proc/cmdline | sed 's/ /\n/g' | grep '^nameserver=' | cut -d = -f 2`
ifaddress="$(echo ${ifline} | cut -f1 -d ':')"
ifnetmask="$(echo ${ifline} | cut -f4 -d ':')"
ifgateway="$(echo ${ifline} | cut -f3 -d ':')"
hostname="$(echo ${ifline} | cut -f5 -d ':')"
mgmtdevice="$(echo ${ifline} | cut -f6 -d ':')"
ns1="$(echo ${nameservers} | cut -f1 -d ',')"
ns2="$(echo ${nameservers} | cut -f2 -d ',')"

# Generate managemnet.conf
if [ ! -f /etc/firstboot.d/data/management.conf ]; then
	cat > "$management_file" <<EOF
LABEL='$mgmtdevice'
MODE='static'
IP='$ifaddress'
NETMASK='$ifnetmask'
GATEWAY='$ifgateway'
DNS1='$ns1'
DNS2='$ns2'
MODEV6='none'
EOF
fi

