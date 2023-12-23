#!/bin/sh

set -e

if [ ! -s /var/www/html/config/config.php ]; then
    echo '<?php $CONFIG=array("localstorage.allowsymlinks"=>true);' >/var/www/html/config/config.php
fi
