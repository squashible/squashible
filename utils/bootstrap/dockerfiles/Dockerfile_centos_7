FROM centos:centos7
MAINTAINER Antony Messerli <antony@mes.ser.li>

# Add a directory to hold our chroot
RUN mkdir /tmp/bootstrap

# Build the chroot as soon as the docker container starts
CMD ["yum", "install", "-y", "--installroot=/tmp/bootstrap", "--releasever=7", "--nogpg", "systemd", "passwd", "yum", "centos-release", "vim-minimal", "openssh-server", "procps-ng"]
