# Use phusion/baseimage as base image. 
# Use a specific version not `latest`
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.

FROM phusion/baseimage:0.9.18

MAINTAINER Alex Gonzalez <alex.gonzalez@digi.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Replace dash with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update Ubuntu and Install Yocto Proyect Quick Start and DEY ependencies
RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm cpio

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install repo
RUN curl -o /usr/local/bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo

# User management
RUN groupadd -g 1000 dey && useradd -u 1000 -g 1000 -ms /bin/bash dey

# Install Digi Embedded Yocto
ENV DEY_INSTALL_PATH="/usr/local/dey-2.0"
RUN install -o 1000 -g 1000 -d $DEY_INSTALL_PATH
WORKDIR $DEY_INSTALL_PATH
USER dey

RUN repo init -u https://github.com/digi-embedded/dey-manifest.git -b refs/tags/2.0-r2 && repo sync -j4 --no-repo-verify

RUN echo "echo Welcome to Digi Embedded Yocto base docker image!" >> /home/dey/.bashrc
