FROM node:alpine

WORKDIR /app

RUN apk update && apk upgrade && \
    apk add --no-cache --update bash
    
COPY setting.ini /setting.ini

COPY dockerconfig/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]