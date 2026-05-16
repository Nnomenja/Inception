FROM alpine:3.18.3

LABEL maintainer="mamenosoa42@gmail.com" \
      description="Custom FTP image based on Alpine Linux"

RUN apk update && \
    apk add --no-cache vsftpd bash shadow \
    && rm -rf /var/cache/apk/*

COPY ./config/vsftpd.conf /etc/vsftpd/vsftpd.conf


COPY ./tools/setup-ftp-server.sh .

RUN chmod +x setup-ftp-server.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["/setup-ftp-server.sh"]
CMD ["vsftpd"]