ARG BUILD_FROM
FROM $BUILD_FROM

RUN sed -i \
        -e 's#/data#/config#g' \
        -e 's#/usr/bin/mautrix-whatsapp$#/usr/bin/mautrix-whatsapp -c /config/config.yaml#' \
       /docker-run.sh
