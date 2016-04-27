# squashible

### Cross-Platform Linux Live Image Builder

## What is this?

Squashible is a tool created to generate a bootable LiveOS rapidly and consistently
across multiple operating systems.  It primarily relies on dracut to boot the
LiveOS.

It utilizes docker to create enough operating system for Ansible to function and
apply all configuration changes from that point.  It then packages up the build into
a vmlinuz, an initrd.img, and a rootfs.img.

This is a work in progress.  Things will probably blow up.
Pull requests and issues welcome!

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

### Logging into the image

You can use the user live and the password live from the console.  The user is disabled from remote ssh access.  If you want to log in remotely, be sure to set a
public ssh key in group_vars/all.

### Known Issues

OpenSUSE currently has issues booting due to the DHCP daemon it uses.

### Test using iPXE Squashible Boot Images

These iPXE disks will automatically load into boot.squashible.com.  These contain live images that have been generated for demonstration puposes.  Make sure you
assign 4GB to 8GB of RAM for the images to load properly.  If you run into any errors or kernel panics, usually the cause is not enough memory being available.

| Type | Bootloader | Description |
|------|------------|-------------|
|ISO| [boot.squashible.com.iso](http://boot.squashible.com/ipxe/boot.squashible.com.iso)| Used for CD/DVD, Virtual CDs like DRAC/iLO, VMware, Virtual Box|
|USB| [boot.squashible.com.usb](http://boot.squashible.com/ipxe/boot.squashible.com.usb)| Used for creation of USB Keys|
|Kernel| [boot.squashible.com.lkrn](http://boot.squashible.com/ipxe/boot.squashible.com.lkrn)| Used for booting from GRUB/EXTLINUX|
|DHCP| [boot.squashible.com.kpxe](http://boot.squashible.com/ipxe/boot.squashible.com.kpxe)| DHCP boot image file, uses built-in iPXE NIC drivers|
|DHCP-undionly | [boot.squashible.com-undionly.kpxe](http://boot.squashible.com/ipxe/boot.squashible.com-undionly.kpxe)| DHCP boot image file, use if you have NIC issues|

You can also chainload into boot.squashible.com if you already have [netboot.xyz](http://netboot.xyz):

    chain --autofree http://boot.squashible.com


