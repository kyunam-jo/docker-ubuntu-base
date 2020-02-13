FROM ubuntu:16.04
MAINTAINER Kyunam Jo <kyunam.jo@gmail.com>

# Set Timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# apt-get settings
RUN dpkg --add-architecture i386
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install git

# default settings
RUN apt-get install -y locales apt-utils sudo
RUN locale-gen --purge en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

#ssh server
RUN apt-get -y install openssh-server ssh
RUN sed  -i -e "s/^#?UsePAM yes/UsePAM no/g"  -e 's/^.*Port 22$/Port 22/g' /etc/ssh/sshd_config

# Adding REPO
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/bin/repo
RUN chmod +rx /usr/bin/repo

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
