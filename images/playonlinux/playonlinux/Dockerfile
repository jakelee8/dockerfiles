FROM jakelee8/wine
MAINTAINER Jake Lee

# Run in non-interactive mode.
ARG DEBIAN_FRONTEND=noninteractive

# Install PlayOnLinux 4.
ADD http://www.playonlinux.com/script_files/PlayOnLinux/4.2.10/PlayOnLinux_4.2.10.deb /tmp
RUN dpkg -i /tmp/PlayOnLinux_4.2.10.deb ; \
    apt-get update && \
    apt-get install -fqy && \
    apt-get install -qy \
      bzip2 \
      gettext \
      libcanberra-gtk-module \
      netcat && \
    rm -rf /var/lib/apt/lists/* /tmp/PlayOnLinux_4.2.10.deb

# Default command is to run playonlinux.
CMD ["playonlinux"]


# # Use backports.
# RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

# # Install PlayOnLinux 5 dependencies.
# RUN mkdir -p /usr/share/man/man1 && \
#     apt-get update && \
#     apt-get -t jessie-backports -qy install openjdk-8-jdk openjfx && \
#     apt-get -qy install libcanberra-gtk-module git && \
#     rm -rf /var/lib/apt/lists/*

# # Install PlayOnLinux 5.
# ADD phoenicis-dist.zip /tmp
# RUN cd /opt && \
#     jar xf /tmp/phoenicis-dist.zip && \
#     mv phoenicis-dist playonlinux5 && \
#     rm /tmp/phoenicis-dist.zip && \
#     chmod 0755 /opt/playonlinux5/PlayOnLinux.sh
# ADD playonlinux.sh /usr/local/bin/playonlinux5

LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# Install utilities.
RUN apt-get update && \
    apt-get install -qy sudo udhcpc && \
    rm -rf /var/lib/apt/lists/*

# Allow members of sudo to sudo without password.
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudo && \
    chmod 0440 /etc/sudoers.d/sudo

# Allow custom user creation.
ARG USER=jake
ARG UID=1000

# Create user.
RUN useradd -ms /bin/bash -u "$UID" -G audio,video,sudo "$USER"

# Configure user environment.
VOLUME /home/$USER
WORKDIR /home/$USER
USER $USER
ENV USER $USER

ENV ENTRYPOINT_BIN=playonlinux
ENV ENTRYPOINT_ACQUIRE_DHCP on
ADD entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["entrypoint"]
CMD
