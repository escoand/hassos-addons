ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt update -y && \
    apt install -y jq && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]
