FROM docker.io/mazzolino/restic:1.8.2

RUN apk --no-cache add jq

COPY --chmod=0755 *.sh /

ENTRYPOINT [ "/run.sh" ]
