FROM alpine:3.20

ARG EXPORTER_VERSION=2.2.0

RUN apk add --no-cache curl tar

WORKDIR /tmp

RUN curl -L -o php-fpm_exporter.tar.gz \
    https://github.com/hipages/php-fpm_exporter/releases/download/v${EXPORTER_VERSION}/php-fpm_exporter_${EXPORTER_VERSION}_linux_amd64.tar.gz \
    && tar -xzf php-fpm_exporter.tar.gz \
    && mv php-fpm_exporter /usr/local/bin/php-fpm_exporter \
    && chmod +x /usr/local/bin/php-fpm_exporter \
    && rm -rf /tmp/*

COPY ./config/.php-fpm_exporter.yaml /home/

EXPOSE 9253

CMD ["/usr/local/bin/php-fpm_exporter", "server", "--config=$HOME/.php-fpm_exporter.yaml"]
