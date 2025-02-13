ARG BUILD_FROM
FROM $BUILD_FROM

ARG RKNN_VERSION=2.3.0

COPY immich.patch /tmp/

RUN apt-get update && \
    apt-get install -y jq

# rknn only on aarch64
ARG BUILD_FROM
RUN if echo "$BUILD_FROM" | grep -q -- -armnn$; then \
    apt-get install -y patch wget && \
    wget -O /usr/local/lib/librknnrt.so https://github.com/airockchip/rknn-toolkit2/raw/refs/tags/v${RKNN_VERSION}/rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so && \
    patch -p3 </tmp/immich.patch && \
    apt-get remove -y patch wget && \
    python3 -m venv /opt/venv && \
    pip install "rknn-toolkit-lite2==${RKNN_VERSION}" \
    ; fi

RUN rm -rf /tmp/immich.patch /var/lib/apt/lists/*
