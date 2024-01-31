#!/usr/bin/env bash
# shellcheck disable=SC2155

set -euo pipefail

CONFIG_PATH=/data/options.json
APP_CONFIG=/config/homeserver.yaml

chown -R 991:991 /config

SERVER_NAME=$(jq -r '.server_name // empty' $CONFIG_PATH)

# initial start
if [ ! -f $APP_CONFIG ]; then
  exec /start.py generate -H "$SERVER_NAME"
fi

# server name
yq -iY --arg data "$SERVER_NAME" '.server_name=$data' $APP_CONFIG

# app services
DATA=$(jq -r '.app_services // empty' $CONFIG_PATH)
yq -iY --argjson data "$DATA" '.app_service_config_files=$data' $APP_CONFIG

exec /start.py "$@"
