FROM tianon/steam
MAINTAINER Jake Lee <jake@jakelee.net>
USER root

# Configure system
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
 && apt-get install -qy psmisc udhcpc
 # && rm -rf /var/lib/apt/lists/*

# Install entrypoint
ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Configure default display
ENV DISPLAY=:0

# Configure entrypoint
USER steam
ENV ENTRYPOINT_BIN=steam
ENTRYPOINT ["/sbin/entrypoint.sh"]
