# Squashible

### Cross-Platform Linux Live Image Builder

## Getting Started

#### Requirements

Recommended Build Server Versions:

    Fedora 23
    Ubuntu 15.10

Packages

    Ansible >= 2.0.1.0
    Docker

#### Building an image

Edit the group_vars/all file and set the appropriate settings.  Recommended
settings to change are:

|variable|description|
|--------|-----------|
| live_os | set to one of the listed supported_live_os |
| user_ssh_keys | set the public ssh keys you'd like to inject |

To run squashible:

    ansible-playbook -i hosts_generator.py <playbook.yml>

Available playbooks to run:

|type|description|
|----|-----------|
| squashible.yml | minimal install |
| squashible_kvm.yml | minimal install + kvm + nova compute |
| squashible_xen.yml | minimal install + xen + nova compute |

Output of the build will be put into {{ outputpath }} which by default is
./live_output directory.
