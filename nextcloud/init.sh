#!/bin/sh

if [ -s /var/www/html/config/config.php ]; then
    php /var/www/html/occ upgrade
    php /var/www/html/occ maintenance:update:htaccess
fi