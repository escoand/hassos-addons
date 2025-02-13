#!/usr/bin/env bash

set -euo pipefail

CONFIG_PATH=/data/options.json

DB_DATABASE_NAME=$(jq -r '.database_name // empty' $CONFIG_PATH)
[ -n "$DB_DATABASE_NAME" ] && export DB_DATABASE_NAME
DB_HOSTNAME=$(jq -r '.database_host // empty' $CONFIG_PATH)
[ -n "$DB_HOSTNAME" ] && export DB_HOSTNAME
DB_PASSWORD=$(jq -r '.database_password // empty' $CONFIG_PATH)
[ -n "$DB_PASSWORD" ] && export DB_PASSWORD
DB_USERNAME=$(jq -r '.database_user // empty' $CONFIG_PATH)
[ -n "$DB_USERNAME" ] && export DB_USERNAME
IMMICH_MACHINE_LEARNING_URL=$(jq -r '.ml_url // empty' $CONFIG_PATH)
[ -n "$IMMICH_MACHINE_LEARNING_URL" ] && export IMMICH_MACHINE_LEARNING_URL
REDIS_HOSTNAME=$(jq -r '.redis_host // empty' $CONFIG_PATH)
[ -n "$REDIS_HOSTNAME" ] && export REDIS_HOSTNAME
REDIS_PORT=$(jq -r '.redis_port // empty' $CONFIG_PATH)
[ -n "$REDIS_PORT" ] && export REDIS_PORT

export IMMICH_MEDIA_LOCATION=/config

exec /usr/src/app/start.sh
