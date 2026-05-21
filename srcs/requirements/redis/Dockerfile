FROM alpine:3.22


LABEL maintainer="mamenosoa42@gmail.com" \
      description="Custom Redis image based on Alpine Linux"

RUN apk update && \
    apk add --no-cache redis  bash \
    && rm -rf /var/cache/apk/*

COPY ./config/redis.conf /etc/redis.conf

COPY ./tools/setup-redis.sh .

RUN chmod +x setup-redis.sh

ENTRYPOINT ["/setup-redis.sh"]

EXPOSE 6379

CMD ["redis-server"]