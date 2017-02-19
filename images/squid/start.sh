#!/bin/sh

set -e

# http://stackoverflow.com/a/3951175
function is_integer() {
  case $1 in
      ''|*[!0-9]*) return 1;;
      *)
  esac
}

SQUID=$(which squid)

# Update permissions.
chown -R "$CACHE_EFFECTIVE_USER:$CACHE_EFFECTIVE_GROUP" /var/cache/squid /var/log/squid
chmod -R ug+rw /var/cache/squid /var/log/squid

# Create effective group if it does not exist.
if ! getent group "$CACHE_EFFECTIVE_GROUP" > /dev/null; then
  if is_integer "$CACHE_EFFECTIVE_GROUP"; then
    GROUP_ID=$CACHE_EFFECTIVE_GROUP
    export CACHE_EFFECTIVE_GROUP=$(getent group "$CACHE_EFFECTIVE_GROUP" | cut -d : -f 1)
    addgroup -g "$GROUP_ID" -S "$CACHE_EFFECTIVE_GROUP"
  else
    addgroup -S "$CACHE_EFFECTIVE_GROUP"
  fi
elif is_integer "$CACHE_EFFECTIVE_GROUP"; then
    export CACHE_EFFECTIVE_GROUP=$(getent group "$CACHE_EFFECTIVE_GROUP" | cut -d : -f 1)
fi

# Create effective user if it does not exist.
if ! getent passwd "$CACHE_EFFECTIVE_USER" > /dev/null; then
  if is_integer "$CACHE_EFFECTIVE_USER"; then
    USER_ID=CACHE_EFFECTIVE_USER
    export CACHE_EFFECTIVE_USER=$(getent passwd "$CACHE_EFFECTIVE_USER" | cut -d : -f 1)
    adduser -u "$USER_ID" -SG "$CACHE_EFFECTIVE_GROUP" "u$CACHE_EFFECTIVE_USER"
  else
    adduser -SG "$CACHE_EFFECTIVE_GROUP" "$CACHE_EFFECTIVE_USER"
  fi
elif is_integer "$CACHE_EFFECTIVE_USER"; then
  export CACHE_EFFECTIVE_USER=$(getent passwd "$CACHE_EFFECTIVE_USER" | cut -d : -f 1)
fi

# Copy user configuration.
if [ -f /etc/squid/squid.conf.local ]; then
  cp /etc/squid/squid.conf.local /etc/squid/squid.conf
fi

# Apply configuration from the environment.
if [ -w /etc/squid/squid.conf ]; then
  sed -i -e '/cache_effective_user/D' -e '/cache_effective_group/D' /etc/squid/squid.conf
  echo "cache_effective_user $CACHE_EFFECTIVE_USER" >> /etc/squid/squid.conf
  echo "cache_effective_group $CACHE_EFFECTIVE_GROUP" >> /etc/squid/squid.conf
else
  su "$CACHE_EFFECTIVE_USER"
fi

$SQUID -z

exec $SQUID "$@"
