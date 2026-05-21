FROM alpine:3.22

LABEL maintainer="mamenosoa42@gmail.com" \
      version="1.0" \
      description="Custom WordPress image based on Alpine Linux"


RUN apk update && \
    apk add --no-cache bash su-exec  curl php83 php83-fpm php83-mysqli php83-json php83-gd \
    php83-curl php83-phar php83-mbstring php83-cli php83-tokenizer wget mariadb-client php83-pecl-redis php83-ctype \
    php83-session \
    && rm -rf /var/cache/apk/*
RUN ln -s /usr/bin/php83 /usr/bin/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp


COPY ./config/www.conf /etc/php83/php-fpm.d/www.conf

COPY ./tools/setup-wordpress.sh /setup-wordpress.sh
RUN chmod +x /setup-wordpress.sh


ENTRYPOINT ["/setup-wordpress.sh"]  

EXPOSE 9000

CMD ["php-fpm83", "-F"]