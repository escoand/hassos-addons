#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

set -e

# gobal
USER_=$(bashio::config user root)
HOSTNAME=$(bashio::info.hostname)
{
echo "[global]"
echo "log level = 2"
echo "netbios name = $HOSTNAME"
echo "security = user"
echo "ntlm auth = yes"
echo "load printers = no"
echo "disable spoolss = yes"
echo "wins support = no"
echo "map to guest = bad user"
echo "guest account = $USER_"
echo "guest ok = yes"
} > /etc/samba/smb.conf

CNT=0
while bashio::config.exists "shares[$CNT]"; do
  NAME=$(bashio::config "shares[$CNT].name")
  PATH_=$(bashio::config "shares[$CNT].path")
  USERS=$(bashio::config "shares[$CNT].users")
  WRITABLE=$(bashio::config "shares[$CNT].writable" no)

  echo "[$NAME]"
  echo "browseable = yes"
  echo "path = $PATH_"
  echo "writable = $WRITABLE"
  if [ "$USERS" != null ]; then
    echo "valid users = $USERS"
  else
    echo "guest only = yes"
  fi

  CNT=$((CNT+1))
done >> /etc/samba/smb.conf

CNT=0
while bashio::config.exists "users[$CNT]"; do
  USERNAME=$(bashio::config "users[$CNT].username")
  PASSWD=$(bashio::config "users[$CNT].password")

  addgroup "$USERNAME"
  adduser -D -H -G "$USERNAME" -s /bin/false "$USERNAME"
  printf '%s\n%s\n' "$PASSWD" "$PASSWD" |
  smbpasswd -a -s -c /etc/samba/smb.conf "$USERNAME"

  CNT=$((CNT+1))
done

/usr/sbin/nmbd --foreground --debug-stdout --no-process-group &
exec /usr/sbin/smbd --foreground --debug-stdout --no-process-group
