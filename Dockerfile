FROM ubuntu:16.04
MAINTAINER Kyunam Jo <kyunam.jo@gmail.com>

# Set Timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# apt-get settings
RUN dpkg --add-architecture i386

# git 2.25.0
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24

# Python 3.8
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu xenial main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/deadsnakes/ppa/ubuntu xenial main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776

RUN apt-get update && apt-get -y upgrade &&\
  apt-get -y install --no-install-recommends python3.8 git locales apt-utils \
  sudo openssh-server ssh && \
  apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  

# default settings
RUN locale-gen --purge en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Change python default version (3.5 -> 3.8, 2 -> 3)
RUN ln -sf /usr/bin/python3.8 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.8 /usr/bin/python

#ssh server
RUN sed  -i -e "s/^#?UsePAM yes/UsePAM no/g"  -e 's/^.*Port 22$/Port 22/g' /etc/ssh/sshd_config

# Adding REPO
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/bin/repo
RUN chmod +rx /usr/bin/repo

EXPOSE 22
