ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk --no-cache add redis

CMD [ "redis-server", "--appendonly", "no", "--protected-mode", "no", "--save", "" ]
