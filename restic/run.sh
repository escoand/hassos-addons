#!/usr/bin/env bash
# shellcheck disable=SC2155

set -euo pipefail

CONFIG_PATH=/data/options.json
SENSOR=sensor.restic

# environment variables
export RESTIC_BACKUP_SOURCES=$(jq -r '.backup_dirs' $CONFIG_PATH)
export BACKUP_CRON=$(jq -r '.backup_cron' $CONFIG_PATH)
export RESTIC_REPOSITORY=$(jq -r '.restic_repository' $CONFIG_PATH)
export RESTIC_PASSWORD=$(jq -r '.restic_password' $CONFIG_PATH)
export RESTIC_BACKUP_ARGS=$(jq -r '.restic_backup_args // empty' $CONFIG_PATH)
export RESTIC_FORGET_ARGS=$(jq -r '.restic_forget_args // empty' $CONFIG_PATH)
# b2 environment
export B2_ACCOUNT_ID=$(jq -r '.b2_account_id // empty' $CONFIG_PATH)
export B2_ACCOUNT_KEY=$(jq -r '.b2_account_key // empty' $CONFIG_PATH)
# Home Assistant events
export PRE_COMMANDS="curl -sS -XPOST -H 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_started"
export POST_COMMANDS_SUCCESS="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_success"
export POST_COMMANDS_FAILURE="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_failure"
export POST_COMMANDS_INCOMPLETE="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_incomplete"

# ssh
if [[ $RESTIC_REPOSITORY = sftp:* ]]; then
  mkdir -p ~/.ssh
  ln -s /config/sss_config ~/.ssh/config
  # config
  if [ ! -f /config/ssh_config ]; then
    printf 'Host *\nStrictHostKeyChecking no\nIdentityFile /config/ssh.key\n' >/config/ssh_config
  fi
  # ssh key
  if [ ! -f /config/ssh.key ]; then
    ssh-keygen -t rsa -q -f /config/ssh.key -N ""
  fi
  echo "### SSH Key ###"
  cat /config/ssh.key.pub
  echo "###############"
fi

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
