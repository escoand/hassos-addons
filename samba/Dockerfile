ARG BUILD_FROM 
FROM $BUILD_FROM 

# renovate: datasource=repology depName=alpine_3_18/samba-server
ENV SAMBA_VERSION=4.18.5-r0

RUN apk --no-cache add samba-server=${SAMBA_VERSION} 

COPY run.sh / 
RUN chmod a+x /run.sh 
  
CMD [ "/run.sh" ]
