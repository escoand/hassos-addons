FROM local/nanobot-upstream

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends jq && \
    rm -rf /var/lib/apt/lists/*

RUN uv pip install --system --no-cache nanobot-ai[matrix]

COPY run.sh /usr/local/bin/
ENTRYPOINT [ "run.sh" ]
