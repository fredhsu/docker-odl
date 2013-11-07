# OpenDaylight
#
# VERSION 	1.0


FROM ubuntu
MAINTAINER Fred Hsu <fredlhsu@gmail.com>

# make sure package repo is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# install tools
RUN apt-get install -y supervisor openssh-server
RUN mkdir -p /var/run/sshd

# install dependencies
RUN apt-get install -y maven git openjdk-7-jre openjdk-7-jdk unzip

# copy opendaylight image and unpack
RUN unzip distribution.opendaylight-osgipackage.zip
RUN export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64

ENTRYPOINT ["opendaylight/run.sh -start 9090"]

# expose bgp port
EXPOSE 179

# expose ssh
EXPOSE 22

# expose openflow
EXPOSE 6633:6633

# expose osgi
EXPOSE 9090

# expose web
EXPOSE 8080
