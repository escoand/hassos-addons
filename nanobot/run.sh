#!/bin/sh

set -e

CONFIG=/data/options.json
PIDS=$(mktemp)

run_dir() {
	DIR=/config/$1
	if [ ! -d "$DIR" ]; then
		echo "create nanobot dir $DIR"
		mkdir "$DIR"
		nanobot onboard --config "$DIR/config.json" --workspace "$DIR/workspace"
	fi
	echo "start nanobot dir $DIR"
	nanobot gateway --config "$DIR/config.json" --workspace "$DIR/workspace"
}

# start
jq -r '.instance[].directory' "$CONFIG" |
	while read -r DIR; do
		run_dir "$DIR" &
		echo $! >> "$PIDS"
	done

# wait
while \
	sed 's|[0-9]*|/proc/&/status|g' <"$PIDS" |
	xargs ls 2>/dev/null |
	grep -q .
do sleep 5; done
