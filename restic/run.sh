#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=env.sh
. /env.sh

# Home Assistant events
export PRE_COMMANDS="curl -sS -XPOST -H 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_started"
export POST_COMMANDS_SUCCESS="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_success"
export POST_COMMANDS_FAILURE="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_failure"
export POST_COMMANDS_INCOMPLETE="curl -sS -XPOST --header 'Authorization: Bearer $SUPERVISOR_TOKEN' http://supervisor/core/api/events/restic_backup_incomplete"

# debug
env

/stats.sh &

# restic main process
exec /entrypoint
