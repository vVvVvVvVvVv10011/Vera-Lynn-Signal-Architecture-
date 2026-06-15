#!/bin/bash

TIMELINE="system/timeline/buffer.jsonl"
mkdir -p system/timeline

layer="$1"
shift
message="$*"

if [ -z "$layer" ] || [ -z "$message" ]; then
  echo "usage: tl <layer> <message>"
  exit 1
fi

case "$layer" in
  visil|lumen|system) ;;
  *)
    echo "error: layer must be visil, lumen, or system"
    exit 1
    ;;
esac

id="evt-$(date +%s)-$RANDOM"
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "{\"id\":\"$id\",\"type\":\"signal\",\"timestamp\":\"$ts\",\"layer\":\"$layer\",\"message\":\"$message\"}" >> "$TIMELINE"

echo "event logged: $id"
