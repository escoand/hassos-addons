FROM ghcr.io/immich-app/immich-server:v1.135.3

RUN apt-get update && \
    apt-get install -y jq && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]

