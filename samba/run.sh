#!/usr/bin/with-contenv bashio

set -e 

# gobal
HOSTNAME=$(
  wget -O- --header "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/info |
  jq -r .data.hostname
)
{
echo "[global]"
echo "guest account = root"
echo "log file = /dev/stdout"
echo "netbios name = $HOSTNAME"
} > /etc/samba/smb.conf

SHARES=$(bashio::config 'shares')
if [ "$SHARES" != null ]; then
  echo "$SHARES" |
  while read NAME PATH; do
    echo "[$NAME]"
    echo "browseable = yes"
    echo "guest only = yes"
    echo "path = $PATH"
    echo "read only = yes"
  done >> /etc/samba/smb.conf
fi
 
/usr/sbin/nmbd -D
exec /usr/sbin/smbd -F
