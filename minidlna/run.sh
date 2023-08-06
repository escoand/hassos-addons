#!/usr/bin/with-contenv bashio

set -e

FRIENDLY_NAME=$(
  wget -O- --header "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/info |
  jq -r .data.hostname
)
sed -i 's/^friendly_name/#&/' /etc/minidlna.conf
echo "friendly_name = $FRIENDLY_NAME" >> /etc/minidlna.conf

MEDIA_DIRS=$(bashio::config 'media_dirs')
if [ "$MEDIA_DIRS" != null ]; then
  sed -i 's/^media_dir/#&/' /etc/minidlna.conf
  echo "$MEDIA_DIRS" | sed 's/^/media_dir = /' >> /etc/minidlna.conf
fi

USERID=$(bashio::config 'user') #|
if [ "$USERID" != null ]; then
  sed -i 's/^user/#&/' /etc/minidlna.conf
  echo "user = $USERID" >> /etc/minidlna.conf
fi

exec /usr/sbin/minidlnad -S
