ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk --no-cache add jq

COPY --chmod=0755 *.sh /

ENTRYPOINT [ "/run.sh" ]
