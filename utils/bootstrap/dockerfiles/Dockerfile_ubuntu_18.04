FROM ubuntu:bionic
MAINTAINER Antony Messerli <antony@mes.ser.li>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y install debootstrap

RUN mkdir /tmp/bootstrap

CMD ["/usr/sbin/debootstrap", "--variant=minbase", "--arch=amd64", "--include=python", "bionic", "/tmp/bootstrap", "http://mirror.rackspace.com/ubuntu/"]
