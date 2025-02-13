FROM python:3.11-slim

RUN apt-get update -q && \
    apt-get install -qy cmake g++ libgl1 libglib2.0-0 && \
    pip install rknn-toolkit2

COPY run.py /

ENTRYPOINT [ "python", "/run.py" ]
