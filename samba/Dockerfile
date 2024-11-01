ARG BUILD_FROM 
FROM $BUILD_FROM 

# renovate: datasource=repology depName=alpine_3_20/samba-server versioning=loose
ENV SAMBA_VERSION=4.19.9-r0

RUN apk --no-cache add samba-server=${SAMBA_VERSION} samba-common-tools

COPY run.sh / 
RUN chmod a+x /run.sh 
  
CMD [ "/run.sh" ]
