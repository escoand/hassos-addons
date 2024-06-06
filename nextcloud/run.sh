#!/usr/bin/env bash
# shellcheck disable=SC2155

set -euo pipefail
trap "" SIGWINCH

CONFIG_PATH=/data/options.json

# environment variables
NEXTCLOUD_TRUSTED_DOMAINS=$(jq -r '.domains // empty' $CONFIG_PATH)
[ -n "$NEXTCLOUD_TRUSTED_DOMAINS" ] && export NEXTCLOUD_TRUSTED_DOMAINS
MYSQL_DATABASE=$(jq -r '.database_name // empty' $CONFIG_PATH)
[ -n "$MYSQL_DATABASE" ] && export MYSQL_DATABASE
MYSQL_HOST=$(jq -r '.database_host // empty' $CONFIG_PATH)
[ -n "$MYSQL_HOST" ] && export MYSQL_HOST
MYSQL_PASSWORD=$(jq -r '.database_password // empty' $CONFIG_PATH)
[ -n "$MYSQL_PASSWORD" ] && export MYSQL_PASSWORD
MYSQL_USER=$(jq -r '.database_user // empty' $CONFIG_PATH)
[ -n "$MYSQL_USER" ] && export MYSQL_USER
REDIS_HOST=$(jq -r '.redis_host // empty' $CONFIG_PATH)
[ -n "$REDIS_HOST" ] && export REDIS_HOST
REDIS_HOST_PORT=$(jq -r '.redis_port // empty' $CONFIG_PATH)
[ -n "$REDIS_HOST_PORT" ] && export REDIS_HOST_PORT

# cronjobs
jq -r '.cronjobs // empty | .[]' $CONFIG_PATH >>/var/spool/cron/crontabs/www-data

# directories
NEXTCLOUD_APPS_DIR=$(jq -r '.apps_dir // empty' $CONFIG_PATH)
if [ -n "$NEXTCLOUD_APPS_DIR" ] && [ ! -e /var/www/html/custom_apps ]; then
  ln -s "$NEXTCLOUD_APPS_DIR" /var/www/html/custom_apps
  chown -h www-data:www-data /var/www/html/custom_apps
fi
NEXTCLOUD_DATA_DIR=$(jq -r '.data_dir // empty' $CONFIG_PATH)
if [ -n "$NEXTCLOUD_DATA_DIR" ] && [ ! -e /var/www/html/data ]; then
  ln -s "$NEXTCLOUD_DATA_DIR" /var/www/html/data
  chown -h www-data:www-data /var/www/html/data
fi

# config directory
ln -s /config /var/www/html/config
chown -h www-data:www-data /var/www/html/config
# migrate config dir
NEXTCLOUD_CONFIG_DIR=$(jq -r '.config_dir // empty' $CONFIG_PATH)
if [ -n "$NEXTCLOUD_CONFIG_DIR" ] && ls "$NEXTCLOUD_CONFIG_DIR"/* >/dev/null 2>&1; then
  rsync --remove-source-files "$NEXTCLOUD_CONFIG_DIR"/* /config/
fi

# start
sudo -u www-data webhook -hooks /hooks.yaml -verbose &
# don't exec entrypoint.sh, because apache stops on SIGWINCH
/entrypoint.sh "$@" &
exec /cron.sh
