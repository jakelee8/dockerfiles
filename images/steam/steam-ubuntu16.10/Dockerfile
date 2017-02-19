# Thank you GitHub contributors:
# https://github.com/tianon/dockerfiles/tree/master/steam
# https://github.com/sassmann/docker/blob/master/ubuntu-steam/Dockerfile

FROM ubuntu:16.10
MAINTAINER Jake Lee <jake@jakelee.net>
ARG DEBIAN_FRONTEND=noninteractive

# Configure system
RUN dpkg --add-architecture i386
RUN apt-get update -q && apt-get upgrade -qy && apt-get install -f

# Install DHCP client
RUN apt-get install -qy udhcpc

# Install 32-bit libraries
RUN apt-get install -qy \
      libc6:i386 \
      libgl1-mesa-dri:i386 \
      libgl1-mesa-glx:i386 \
      ;

# Install steam dependencies
RUN apt-get install -qy --no-install-recommends \
      curl \
      python-apt \
      sudo \
      xterm \
      xz-utils \
      zenity \
      ;

# Install steam key
RUN apt-get install -qy dirmngr \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv F24AEA9FB05498B7 \
 && apt-get purge -qy dirmngr

# Install steam
ARG STEAM_APT_SOURCE='deb [arch=amd64,i386] http://repo.steampowered.com/steam/ precise steam'
RUN echo "$STEAM_APT_SOURCE" > /etc/apt/sources.list.d/steam-launcher.list \
 && apt-get update -q \
 && apt-get install -qy steam-launcher \
 && rm /etc/apt/sources.list.d/steam-launcher.list

# Install steam runtime
RUN apt-get install -qy --no-install-recommends \
      ca-certificates \
      dbus-x11:i386 \
      libgpg-error0 \
      libgpg-error0:i386 \
      libstdc++-6-dev \
      libstdc++-6-dev:i386 \
      libxcb1 \
      libxcb1:i386 \
      libxtst6 \
      libxtst6:i386 \
      ;

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Install entrypoint
ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Create user steam
RUN useradd -m -s /bin/bash -u 1000 -U -G audio -G video -m steam && \
    mkdir -p /etc/sudoers.d && \
    echo "steam ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/steam && \
    chmod 0440 /etc/sudoers.d/steam

# Configure runtime directory
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
ENV XDG_RUNTIME_DIR=/run/user/1000
RUN mkdir -p "$XDG_RUNTIME_DIR" \
 && chown -R steam:steam "$XDG_RUNTIME_DIR" \
 && chmod -R 0700 "$XDG_RUNTIME_DIR"

# Configure display
ENV DISPLAY=:0

# Configure entrypoint
USER steam
VOLUME /home/steam
ENV USER=steam
ENV HOME=/home/steam
ENV ENTRYPOINT_BIN=steam
ENTRYPOINT ["/sbin/entrypoint.sh"]
