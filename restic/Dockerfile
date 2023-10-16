ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk --no-cache add jq

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
