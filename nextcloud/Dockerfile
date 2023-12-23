ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && apt-get install -y \
    jq sudo webhook \
    && rm -rf /var/lib/apt/lists/*

COPY hassio.patch /
RUN patch -d/ -p0 -i /hassio.patch && rm /hassio.patch

COPY run.sh \
     hooks.yaml \
     maintenance-on.sh \
     maintenance-off.sh  /
COPY pre-install.sh /docker-entrypoint-hooks.d/pre-installation/
COPY pre-start.sh   /docker-entrypoint-hooks.d/before-starting/

EXPOSE 80/tcp
EXPOSE 9000/tcp

ENTRYPOINT [ "/run.sh" ]
CMD [ "apache2-foreground" ]
