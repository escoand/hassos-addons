#!/bin/sh

set -eu

if [ ! -s /var/www/html/config/config.php ]; then
    # shellcheck disable=SC2016
    echo '<?php $CONFIG=array("localstorage.allowsymlinks"=>true);' >/var/www/html/config/config.php
fi
