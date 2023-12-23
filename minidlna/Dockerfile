ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk --no-cache add minidlna=1.3.2-r1

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
