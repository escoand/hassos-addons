#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=env.sh
. /env.sh

# Home Assistant events
export PRE_COMMANDS="curl -sS -XPOST -H 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_started"
export POST_COMMANDS_SUCCESS="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_success"
export POST_COMMANDS_FAILURE="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_failure"
export POST_COMMANDS_INCOMPLETE="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_incomplete"

# ssh
if [[ $RESTIC_REPOSITORY = sftp:* ]]; then
  mkdir -p ~/.ssh
  printf 'Host *\nStrictHostKeyChecking no\nIdentityFile /config/ssh.key\n' >~/.ssh/config
  # ssh key
  if [ ! -f /config/ssh.key ]; then
    ssh-keygen -t rsa -q -f /config/ssh.key -N ""
  fi
  echo "### SSH Key ###"
  cat /config/ssh.key.pub
  echo "###############"
fi

/stats.sh &

# restic main process
exec /sbin/tini -- /entrypoint
