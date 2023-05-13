ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk --no-cache add minidlna

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
