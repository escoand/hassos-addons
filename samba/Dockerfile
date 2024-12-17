ARG BUILD_FROM 
FROM $BUILD_FROM 

# renovate: datasource=repology depName=alpine_3_20/samba-server versioning=loose
ENV SAMBA_VERSION=4.20.6-r1

RUN apk --no-cache add samba-server=${SAMBA_VERSION} samba-common-tools

COPY run.sh / 
RUN chmod a+x /run.sh 
  
CMD [ "/run.sh" ]
