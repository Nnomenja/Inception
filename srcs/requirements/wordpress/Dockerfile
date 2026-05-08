FROM  alpine:3.19

LABEL maintainer="mamenosoa42@gmail.com" \
      version="1.0" \
      description="Custom WordPress image based on Alpine Linux"

RUN apk update && \
    apk add --no-cache php83 php83-fpm php83-mysqli php83-json php83-gd php83-curl php83-mbstring wget\
    && rm -rf /var/cache/apk/*

RUN mkdir -p /var/www  && wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz -C /var/www && rm latest.tar.gz

COPY ./config/wp-config.php /var/www/wordpress/wp-config.php

