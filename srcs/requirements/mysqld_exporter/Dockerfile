FROM alpine:3.20

RUN apk add --no-cache wget ca-certificates tar

ENV EXPORTER_VERSION=0.15.1

RUN wget https://github.com/prometheus/mysqld_exporter/releases/download/v${EXPORTER_VERSION}/mysqld_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz \
    && tar -xzf mysqld_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz \
    && mv mysqld_exporter-${EXPORTER_VERSION}.linux-amd64/mysqld_exporter /usr/local/bin/ \
    && chmod +x /usr/local/bin/mysqld_exporter \
    && rm -rf mysqld_exporter-*


COPY ./tools/setup-msqld-exporter.sh /setup-msqld-exporter.sh
RUN chmod +x /setup-msqld-exporter.sh
    
EXPOSE 9104

ENTRYPOINT ["/setup-msqld-exporter.sh"]

CMD ["/usr/local/bin/mysqld_exporter"]