FROM node:alpine
WORKDIR /opt/resource
ADD bin .
ADD package.json .
ADD yarn.lock .

RUN NODE_ENV=production yarn --quiet
RUN apk update \
 && apk add jq \
 && rm -rf /var/cache/apk/*
