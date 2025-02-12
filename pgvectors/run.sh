#!/usr/bin/env bash
# shellcheck disable=SC2155

set -euo pipefail

CONFIG_PATH=/data/options.json

POSTGRES_DB=$(jq -r '.database_name // empty' $CONFIG_PATH)
[ -n "$POSTGRES_DB" ] && export POSTGRES_DB
POSTGRES_PASSWORD=$(jq -r '.database_password // empty' $CONFIG_PATH)
[ -n "$POSTGRES_PASSWORD" ] && export POSTGRES_PASSWORD
POSTGRES_USER=$(jq -r '.database_user // empty' $CONFIG_PATH)
[ -n "$POSTGRES_USER" ] && export POSTGRES_USER

export PGDATA=/config
export POSTGRES_INITDB_ARGS='--data-checksums'

# shellcheck disable=SC2016
docker-entrypoint.sh \
    postgres \
    -c shared_preload_libraries=vectors.so \
    -c 'search_path="$user", public, vectors' \
    -c logging_collector=on \
    -c max_wal_size=2GB \
    -c shared_buffers=512MB \
    -c wal_compression=on

