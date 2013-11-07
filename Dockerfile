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

# Fake a fuse install
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# install dependencies
RUN apt-get install -y maven git openjdk-7-jre openjdk-7-jdk unzip wget

# copy opendaylight image and unpack
RUN wget https://jenkins.opendaylight.org/controller/job/controller-merge/lastSuccessfulBuild/artifact/opendaylight/distribution/opendaylight/target/distribution.opendaylight-osgipackage.zip 
RUN unzip distribution.opendaylight-osgipackage.zip
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

#ENTRYPOINT ["opendaylight/run.sh", "-start", "9090"]
#ENTRYPOINT ["JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64 /opendaylight/run.sh"]
ENTRYPOINT cd /opendaylight && /opendaylight/run.sh
#ENTRYPOINT ["ls"]

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
