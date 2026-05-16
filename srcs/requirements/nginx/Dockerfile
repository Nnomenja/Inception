FROM alpine:3.19

LABEL maintainer="mamenosoa42@gmail.com" \
      version="1.0" \
      description="Custom Nginx image based on Alpine Linux"

RUN echo "https://mirrors.edge.kernel.org/alpine/latest-stable/main" > /etc/apk/repositories

RUN apk update && apk add --no-cache nginx openssl bash\
    && rm -rf /var/cache/apk/*

COPY ./config/default.conf /etc/nginx/http.d/default.conf

COPY ./tools/setup-ssl.sh .

RUN chmod +x setup-ssl.sh && ./setup-ssl.sh && rm setup-ssl.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]