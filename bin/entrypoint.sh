#!/bin/bash

set -e

EXEC_BIN=$(which "$ENTRYPOINT_BIN" || echo "$ENTRYPOINT_BIN")

# Acquire DHCP lease
if [[ ! -z "$ENTRYPOINT_ACQUIRE_DHCP" ]]; then
  sudo udhcpc
fi

# # Configure runtime directory
# # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# if [[ -z "$XDG_RUNTIME_DIR" ]]; then
#   export XDG_RUNTIME_DIR=/run/user/$(id -u)
#   sudo mkdir -p "$XDG_RUNTIME_DIR"
#   sudo chown -R $(id -u):$(id -g) "$XDG_RUNTIME_DIR"
#   sudo chmod -R 0700 "$XDG_RUNTIME_DIR"
# fi

# # Configure PulseAudio
# pactl load-module module-tunnel-sink "server=10.0.1.4 sink_name=sink-remote"
# pacmd set-default-sink sink-remote

# Allow arguments to be passed
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == "$ENTRYPOINT_BIN" || ${1} == "$EXEC_BIN" ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi
echo "$ENTRYPOINT_BIN" "$EXEC_BIN" $EXTRA_ARGS

# Default behavior is to launch the app
if [[ -z "$1" ]]; then
  exec "$EXEC_BIN" $EXTRA_ARGS
else
  exec "$@"
fi
