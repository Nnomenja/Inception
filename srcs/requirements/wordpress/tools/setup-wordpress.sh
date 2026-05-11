#!/bin/bash

set -e

TARGET="/var/www/wordpress/index.php"

echo "Checking for WordPress in $TARGET ..."


if [ ! -f "$TARGET" ]; then
    curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz

    tar -xzf /tmp/wordpress.tar.gz -C /tmp

    cp -r /tmp/wordpress /var/www/
else
    echo "WordPress already exists in $TARGET. Skipping download and extraction."
fi


exec "$@"