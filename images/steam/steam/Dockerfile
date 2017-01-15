FROM debian:jessie
MAINTAINER Jake Lee <jake@jakelee.net>

# Run in non-interactive mode.
ARG DEBIAN_FRONTEND=noninteractive

# Add i386 support to install steam.
RUN dpkg --add-architecture i386

# Install Steam.
ADD http://steamcdn-a.akamaihd.net/client/installer/steam.deb .
RUN apt-get update && \
    apt-get install -qy \
      libc6:i386 \
      libgl1-mesa-dri:i386 \
      libgl1-mesa-glx:i386 \
      sudo && \
    dpkg -i steam.deb ; \
    apt-get install -fqy && \
    rm -rf /var/lib/apt/lists/* steam.deb

# Default command is to launch steam.
CMD ["/usr/bin/steam"]
