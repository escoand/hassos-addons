ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && apt-get install -y \
    jq \
    && rm -rf /var/lib/apt/lists/*

COPY hassio.patch /
RUN patch -d/ -p0 -i /hassio.patch && rm /hassio.patch

COPY run.sh         /
COPY pre-install.sh /docker-entrypoint-hooks.d/pre-installation/
COPY pre-start.sh   /docker-entrypoint-hooks.d/before-starting/

ENTRYPOINT [ "/run.sh" ]
CMD [ "apache2-foreground" ]
