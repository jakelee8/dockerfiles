FROM debian:jessie-slim
MAINTAINER Jake Lee

# Run in non-interactive mode.
ARG DEBIAN_FRONTEND=noninteractive

# Install Wine.
ARG DEB_PACKAGE_NAME=winehq-devel
ADD https://dl.winehq.org/wine-builds/Release.key wine.key
RUN dpkg --add-architecture i386 && \

    # Add WineHQ repository.
    apt-key add wine.key \
    install -d /etc/apt/sources.list.d && \
    echo 'deb http://dl.winehq.org/wine-builds/debian/ jessie main' > /etc/apt/sources.list.d/wine.list && \

    # Install wine.
    apt-get update && \
    apt-get install -qy --install-recommends "$DEB_PACKAGE_NAME" && \
    rm -rf /var/lib/apt/lists/* wine.key
