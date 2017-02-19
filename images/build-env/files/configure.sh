#!/bin/bash

set -e

SCRIPTNAME="$(which "$0" || echo "$0")"
BINDIR="$(dirname "$SCRIPTNAME")"

function configure() {
  python "$BINDIR/configure.py"
}

configure "$@"
