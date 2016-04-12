# squashible

### Cross-Platform Linux Live Image Builder

## Getting Started

### Requirements

Recommended Build Server Versions:

    Fedora 23
    Ubuntu 15.10

Required Packages:

    Ansible >= 2.0.1.0
    Docker

### Building an image

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

### Booting the images

Here are some examples for booting the image once you've generated one:

#### iPXE

    kernel http://$deployment_server/images/images/fedora-23-kvm/vmlinuz
    module http://$deployment_server/images/images/fedora-23-kvm/initrd.img
    imgargs vmlinuz root=live:http://$deployment_server/images/fedora-23-kvm/rootfs.img ip=dhcp nameserver=8.8.8.8 nomodeset rd.writable.fsimg rd.info rd.shell

#### kexec

    kexec -l vmlinuz —initrd=initrd.img \
    —command-line=“root=live:http://$deployment_server/images/fedora-23-kvm/rootfs.img \
    ip=dhcp nameserver=8.8.8.8 rd.writable.fsimg rd.info rd.shell”
    kexec -e
