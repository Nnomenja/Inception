FROM alpine:3.22

RUN echo "https://mirrors.edge.kernel.org/alpine/latest-stable/main" > /etc/apk/repositories

RUN apk update && apk add --no-cache \
    mariadb mariadb-client bash \
    su-exec \
    openrc \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld

EXPOSE 3306

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./config/mariadb-server.cnf /etc/my.cnf.d

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mariadbd" ]