#!/usr/bin/env bash
# shellcheck disable=SC2155

CONFIG_PATH=/data/options.json

# environment variables
export RESTIC_BACKUP_SOURCES=$(jq -r '.backup_dirs' $CONFIG_PATH)
export BACKUP_CRON=$(jq -r '.backup_cron' $CONFIG_PATH)
export RESTIC_REPOSITORY=$(jq -r '.restic_repository' $CONFIG_PATH)
export RESTIC_PASSWORD=$(jq -r '.restic_password' $CONFIG_PATH)
export RESTIC_BACKUP_ARGS=$(jq -r '.restic_backup_args // empty' $CONFIG_PATH)
export RESTIC_FORGET_ARGS=$(jq -r '.restic_forget_args // empty' $CONFIG_PATH)
export RESTIC_PROGRESS_FPS=0.016666
# b2 environment
export B2_ACCOUNT_ID=$(jq -r '.b2_account_id // empty' $CONFIG_PATH)
export B2_ACCOUNT_KEY=$(jq -r '.b2_account_key // empty' $CONFIG_PATH)
# s3 environment
export AWS_ACCESS_KEY_ID=$(jq -r '.s3_access_key // empty' $CONFIG_PATH)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.s3_secret_key // empty' $CONFIG_PATH)
