#!/usr/bin/env bash

set -e

CONFIG_PATH=/data/options.json

export MYSQL_DATABASE=$(jq -r '.database_name // empty' $CONFIG_PATH)
export MYSQL_HOST=$(jq -r '.database_host // empty' $CONFIG_PATH)
export MYSQL_PASSWORD=$(jq -r '.database_password // empty' $CONFIG_PATH)
export MYSQL_USER=$(jq -r '.database_user // empty' $CONFIG_PATH)

NEXTCLOUD_CONFIG_DIR=$(jq -r '.config_dir // empty' $CONFIG_PATH)
NEXTCLOUD_DATA_DIR=$(jq -r '.data_dir // empty' $CONFIG_PATH)
export NEXTCLOUD_TRUSTED_DOMAINS=$(jq -r '.domains // empty' $CONFIG_PATH)

export REDIS_HOST=$(jq -r '.redis_host // empty' $CONFIG_PATH)
export REDIS_HOST_PORT=$(jq -r '.redis_port // empty' $CONFIG_PATH)

if [ ! -e /var/www/html/config ]; then
  ln -s "$NEXTCLOUD_CONFIG_DIR" /var/www/html/config
  chown -h www-data:www-data /var/www/html/config
fi
if [ ! -e /var/www/html/data ]; then
  ln -s "$NEXTCLOUD_DATA_DIR" /var/www/html/data
  chown -h www-data:www-data /var/www/html/data
fi

/cron.sh &
exec /entrypoint.sh "$@"
