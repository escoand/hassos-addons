ARG BUILD_FROM
FROM $BUILD_FROM

# renovate: datasource=repology depName=alpine_3_23/minidlna versioning=loose
ENV MINIDLNA_VERSION=1.3.3-r3

RUN apk --no-cache add minidlna=${MINIDLNA_VERSION}

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
