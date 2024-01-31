ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt update -qy \
    && apt install -qy jq yq

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]
