FROM  alpine:3.19

LABEL maintainer="mamenosoa42@gmail.com" \
      version="1.0" \
      description="Custom WordPress image based on Alpine Linux"

RUN apk update && \
    apk add --no-cache bash su-exec  curl php83 php83-fpm php83-mysqli php83-json php83-gd php83-curl php83-mbstring wget\
    && rm -rf /var/cache/apk/*


RUN mkdir -p /var/www/html/wordpress

COPY ./config/wp-config.php /var/www/html/wordpress/wp-config.php

COPY ./tools/setup-wordpress.sh /setup-wordpress.sh
RUN chmod +x /setup-wordpress.sh


ENTRYPOINT ["/setup-wordpress.sh"]

EXPOSE 9000

CMD ["php-fpm83", "-F"]