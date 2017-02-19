#!/bin/bash
set -e

EXEC_BIN=$(which "$ENTRYPOINT_BIN")

# acquire DHCP lease
sudo udhcpc

# allow arguments to be passed
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == "$ENTRYPOINT_BIN" || ${1} == "$EXEC_BIN" ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behavior is to launch the app
if [[ -z $1 ]]; then
  exec "$EXEC_BIN" $EXTRA_ARGS
else
  exec "$@"
fi
