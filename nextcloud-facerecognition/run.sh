#!/usr/bin/env bash

set -euo pipefail

CONFIG_PATH=/data/options.json

# environment variables
API_KEY=$(jq -r '.api_key // empty' $CONFIG_PATH)
[ -n "$API_KEY" ] && export API_KEY
GUNICORN_WORKERS=$(jq -r '.workers // empty' $CONFIG_PATH)
[ -n "$GUNICORN_WORKERS" ] && export GUNICORN_WORKERS

exec flask run -h 0.0.0.0
