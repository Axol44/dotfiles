#!/usr/bin/env bash

set -euo pipefail

# These variables will be defined externally
# shellcheck disable=SC2154
if ! { xrandr --listmonitors | grep "$screen"; } &> /dev/null; then
  OUT=$(xrandr | grep -A1 "Screen 0" | tail -1)

  grep -oP '\d+(?=mm)' <<< "$OUT"
  awk '{ print $1 }' <<< "$OUT"

  exit 1
fi

