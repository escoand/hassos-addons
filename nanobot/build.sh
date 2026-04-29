#!/bin/bash

set -eo pipefail

VERSION=$(grep ^version: config.yaml | cut -d" " -f2)
BASEVERSION=${VERSION%-*}
TMPDIR=$(mktemp -d)

# shellcheck disable=SC2064
trap "rm -rf '$TMPDIR'" EXIT

git clone --branch "v$BASEVERSION" --depth 1 git@github.com:HKUDS/nanobot.git "$TMPDIR"

docker build --tag "local/amd64-addon-nanobot:$VERSION" .
