#!/bin/sh

set -e

eval "$@" && pkill -x --signal=SIGUSR1 i3status
