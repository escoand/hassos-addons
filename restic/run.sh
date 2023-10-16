#!/usr/bin/env bash
# shellcheck disable=SC2155

set -e

CONFIG_PATH=/data/options.json
SENSOR=sensor.restic

# environment variables
export RESTIC_BACKUP_SOURCE=$(jq -r '.backup_dir' $CONFIG_PATH)
export BACKUP_CRON=$(jq -r '.backup_cron' $CONFIG_PATH)
export RESTIC_REPOSITORY=$(jq -r '.restic_repository' $CONFIG_PATH)
export RESTIC_PASSWORD=$(jq -r '.restic_password' $CONFIG_PATH)
export RESTIC_BACKUP_ARGS=$(jq -r '.restic_backup_args // empty' $CONFIG_PATH)
export RESTIC_FORGET_ARGS=$(jq -r '.restic_forget_args // empty' $CONFIG_PATH)
# b2 environment
export B2_ACCOUNT_ID=$(jq -r '.b2_account_id // empty' $CONFIG_PATH)
export B2_ACCOUNT_KEY=$(jq -r '.b2_account_key // empty' $CONFIG_PATH)

# gather statistics
while true; do
  restic --no-lock snapshots latest --json > /tmp/snapshots.tmp &&
  mv /tmp/snapshots.tmp /tmp/snapshots.json
  sleep $((2 * 60 * 60))
done &
while true; do
  restic --no-lock stats latest --json > /tmp/stats.tmp &&
  mv /tmp/stats.tmp /tmp/stats.json
  sleep $((2 * 60 * 60))
done &

# post statistics
while true; do
  touch /tmp/snapshots.json /tmp/stats.json
  jq -n \
    --argfile sn /tmp/snapshots.json \
    --argfile st /tmp/stats.json \
    '{"state":"update","attributes":{"snapshots":$sn,"stats":$st}}' |
  curl -sS -XPOST \
    --header "Authorization: Bearer $SUPERVISOR_TOKEN" \
    --header "Content-Type: application/json" \
    --data @- \
    --output /dev/null \
    http://supervisor/core/api/states/$SENSOR
  sleep 60
done &

# restic main process
exec /sbin/tini -- /entrypoint
