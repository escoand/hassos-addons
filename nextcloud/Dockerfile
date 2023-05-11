ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && apt-get install -y \
    jq \
    && rm -rf /var/lib/apt/lists/*

COPY hassio.patch /
RUN patch -d/ -p0 -i /hassio.patch && rm /hassio.patch

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
CMD [ "apache2-foreground" ]
