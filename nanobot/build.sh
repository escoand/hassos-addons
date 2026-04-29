#!/bin/bash

set -eo pipefail

IMAGE=local/amd64-addon-nanobot
VERSION=$(grep ^version: config.yaml | cut -d" " -f2)
BASEVERSION=${VERSION%-*}

docker build --tag "local/nanobot:upstream" "https://github.com/HKUDS/nanobot.git#v$BASEVERSION"

docker build --tag "$IMAGE:$VERSION" .

docker rmi "local/nanobot:upstream"
