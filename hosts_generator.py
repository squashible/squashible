#!/usr/bin/env python
#
# This file is downright hideous but it pulls our chroot path from the vars
# file so that users only have to make configuration adjustments in that
# single file.
#
# Many thanks to the rax.py ansible inventory plugin and @vincentvdk's LDAP
# ansible inventory plugin for the inspiration.
#
import argparse
import json
import sys
import yaml

# Pick up our group_vars file
stream = open("group_vars/all", 'r')
vars = yaml.load(stream, Loader=yaml.FullLoader)


hosts = {
    "chroot": {
        "hosts": [
            vars['chrootpath']
        ],
        "vars": {
            "ansible_connection": "chroot"
        }
    },
    "builder": {
        "hosts": [
            "localhost"
        ],
        "vars": {
            "ansible_connection": "local"
        }
    }
}

def parse_args():
    parser = argparse.ArgumentParser(description='Squashible inventory module')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--list', action='store_true',
                       help='List active servers')
    group.add_argument('--host', help='List details about the specific host')
    return parser.parse_args()

def main():
    args = parse_args()
    if args.list:
        print(json.dumps(hosts, indent=2))
    elif args.host:
        print(json.dumps(hosts, indent=2))
    sys.exit(0)


if __name__ == '__main__':
    main()

