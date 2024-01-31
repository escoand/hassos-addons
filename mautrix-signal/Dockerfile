ARG BUILD_FROM
FROM $BUILD_FROM

RUN ls -l / && sed -i \
        -e 's#/data#/config#g' \
        -e 's# \$EXE$#& -c /config/config.yaml#' \
       /docker-run.sh
