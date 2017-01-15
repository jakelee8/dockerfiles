FROM jakelee8/steam
MAINTAINER Jake Lee <jake@jakelee.net>

# Allow members of sudo to sudo without password.
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudo && \
    chmod 0440 /etc/sudoers.d/sudo

# Allow custom user creation.
ONBUILD ARG USER=steam
ONBUILD ARG UID=1000

# Create user.
ONBUILD RUN useradd -ms /bin/bash -u "$UID" -G audio,video,sudo "$USER"

# Configure user environment.
ONBUILD VOLUME /home/$USER
ONBUILD WORKDIR /home/$USER
ONBUILD USER $USER
