FROM alpine:3.22

ARG VERSION=1.1.0

RUN apk add --no-cache wget tar ca-certificates curl \
 && wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v${VERSION}/nginx-prometheus-exporter_${VERSION}_linux_amd64.tar.gz \
 && tar -xzf nginx-prometheus-exporter_*.tar.gz \
 && mv nginx-prometheus-exporter /usr/local/bin/ \
 && rm -rf *.tar.gz

EXPOSE 9113

ENTRYPOINT ["/usr/local/bin/nginx-prometheus-exporter"]
CMD ["-nginx.scrape-uri=http://nginx:8080/stub_status", "-web.listen-address=:9113"]