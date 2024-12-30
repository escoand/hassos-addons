FROM python:slim AS builder

COPY facerecognition-external-model/Makefile /app/

RUN apt update -yq \
    && apt install -yq bzip2 cmake g++ make wget \
    && pip wheel -w /app/ dlib \
    && make -C /app/ download-models

FROM python:slim

COPY --from=builder /app/dlib*.whl /tmp/
COPY --from=builder /app/vendor/ /app/vendor/

RUN pip install flask numpy gunicorn \
    && pip install --no-index -f /tmp/ dlib \
    && rm /tmp/dlib*.whl

COPY facerecognition-external-model/facerecognition-external-model.py /app/
COPY facerecognition-external-model/gunicorn_config.py /app/

WORKDIR /app/

EXPOSE 5000

ARG GUNICORN_WORKERS="1" \
    PORT="5000"
ENV GUNICORN_WORKERS="${GUNICORN_WORKERS}"\
    PORT="${PORT}"\
    API_KEY=some-super-secret-api-key\
    FLASK_APP=facerecognition-external-model.py

#ENTRYPOINT ["gunicorn"  , "-c", "gunicorn_config.py", "facerecognition-external-model:app"]

# custom
#ARG BUILD_FROM
#FROM $BUILD_FROM
RUN apt update -y && \
    apt install -y jq && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]
