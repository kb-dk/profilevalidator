#!/bin/bash

SCRIPT_PATH="$(dirname $(readlink -f $0))"

source $SCRIPT_PATH/logging.sh

breakup() {
  if [ -n "$1" ]; then
    error "$*"
    exit 1
  fi
}
