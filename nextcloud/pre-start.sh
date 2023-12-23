#!/bin/sh

set -e

if [ -s /var/www/html/config/config.php ]; then
    php /var/www/html/occ config:system:delete localstorage.allowsymlinks
    php /var/www/html/occ upgrade
    php /var/www/html/occ maintenance:update:htaccess
fi
