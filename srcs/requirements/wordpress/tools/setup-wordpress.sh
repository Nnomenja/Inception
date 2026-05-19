#!/bin/bash

set -e

WP_PATH="/var/www/html/wordpress"

echo "Checking for WordPress in $WP_PATH ..."


if [ ! -f "$WP_PATH"/wp-config.php ]; then


    # validation: reject unsafe usernames
    if echo "$WORDPRESS_ADMIN_USER" | grep -Eqi "admin"; then
        echo "ERROR: Admin username cannot contain 'admin'"
        exit 1
    fi

    # Create WordPress directory if it doesn't exist
    mkdir -p "$WP_PATH"


    # Download and extract WordPress
    php -d memory_limit=512M /usr/local/bin/wp core download --path="$WP_PATH" --allow-root

    # Create wp-config.php with database credentials
    wp config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$(cat ${WORDPRESS_DB_PASSWORD})" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --dbprefix="$WORDPRESS_DB_PREFIX" \
    --path="$WP_PATH" \
    --skip-check

    # Install WordPress with site details and admin credentials
    wp core install --url="https://$WORDPRESS_DOMAIN_NAME" --title="$SITE_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$(cat ${WORDPRESS_ADMIN_PASSWORD})" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" --path="$WP_PATH" --allow-root

    echo "WordPress installed successfully in $WP_PATH"
    # Create a subscriber user with credentials from secrets
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
    --role=subscriber \
    --user_pass="$(cat ${WORDPRESS_USER_PASSWORD})" \
    --allow-root \
    --path="$WP_PATH"

    # set redis cache settings
    wp plugin install redis-cache --activate --path="$WP_PATH" --allow-root --quiet
    wp config set WP_CACHE true --raw --path="$WP_PATH" --allow-root --quiet
    wp config set WP_REDIS_HOST "$REDIS_HOST" --path="$WP_PATH" --allow-root --quiet
    wp config set WP_REDIS_PORT "6379" --path="$WP_PATH" --allow-root --quiet
    wp config set WP_REDIS_PASSWORD "$(cat ${REDIS_PASSWORD})" --path="$WP_PATH" --allow-root --quiet
    wp redis enable --path="$WP_PATH" --allow-root
    

else
    echo "WordPress already exists in $WP_PATH. Skipping download and extraction."
fi


exec "$@"