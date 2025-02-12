FROM docker.io/tensorchord/pgvecto-rs:pg16-v0.2.0

RUN apt-get update && \
    apt-get install -y jq && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]

