#!/usr/bin/env bash

set -euo pipefail

SENSOR=${SENSOR:-sensor.restic}

# gather statistics
while true; do
  restic --no-lock snapshots latest --json >/tmp/snapshots.tmp &&
    mv /tmp/snapshots.tmp /tmp/snapshots.json
  sleep $((2 * 60 * 60))
done &
while true; do
  restic --no-lock stats latest --json >/tmp/stats.tmp &&
    mv /tmp/stats.tmp /tmp/stats.json
  sleep $((2 * 60 * 60))
done &

# post statistics
while true; do
  touch /tmp/snapshots.json /tmp/stats.json
  jq -n \
    --rawfile sn /tmp/snapshots.json \
    --rawfile st /tmp/stats.json \
    '{"state":"update","attributes":{"snapshots":($sn|fromjson),"stats":($st|fromjson)}}' |
    curl -sS -XPOST \
      --header "Authorization: Bearer $SUPERVISOR_TOKEN" \
      --header "Content-Type: application/json" \
      --data @- \
      --output /dev/null \
      "http://supervisor/core/api/states/$SENSOR"
  sleep 60
done
