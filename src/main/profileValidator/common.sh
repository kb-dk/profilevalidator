#!/bin/bash

source $CONFIG

SCRIPT_PATH="$(dirname $(readlink -f $0))"

source $SCRIPT_PATH/logging.sh

breakup() {
  if [ -n "$1" ]; then
    error "$*"
    rm -r $TEMPDIR
    exit 1
  fi
}
