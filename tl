#!/bin/bash

CMD=$1
FILE="system/timeline/buffer.jsonl"

mkdir -p system/timeline

# -------------------------
# SIGNAL MODE
# -------------------------
if [ "$CMD" = "signal" ]; then
  TYPE=$2
  LAYER=$3
  MESSAGE=$4

  if [ -z "$TYPE" ] || [ -z "$LAYER" ] || [ -z "$MESSAGE" ]; then
    echo "usage: tl signal <type> <layer> <message>"
    exit 1
  fi

  ID="evt-$(date +%s)"
  TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  EVENT="{\"id\":\"$ID\",\"type\":\"$TYPE\",\"timestamp\":\"$TIME\",\"layer\":\"$LAYER\",\"message\":\"$MESSAGE\"}"

  echo "$EVENT" >> "$FILE"
  echo "event logged: $ID"

  # optional git sync (safe, silent)
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git add "$FILE" >/dev/null 2>&1
    git commit -m "timeline: $TYPE / $LAYER / $ID" >/dev/null 2>&1
    git push >/dev/null 2>&1
  fi

  exit 0
fi

# -------------------------
# READ MODE
# -------------------------
if [ "$CMD" = "read" ]; then
  LAYER=$2

  if [ ! -f "$FILE" ]; then
    echo "no timeline found"
    exit 1
  fi

  echo "---- TIMELINE ----"

  if [ -z "$LAYER" ]; then
    cat "$FILE"
  else
    jq -r --arg l "$LAYER" 'select(.layer==$l)' "$FILE"
  fi

  echo "------------------"
  exit 0
fi

# -------------------------
# ANALYZE MODE
# -------------------------
if [ "$CMD" = "analyze" ]; then
  LAYER=$2

  if [ ! -f "$FILE" ]; then
    echo "no timeline found"
    exit 1
  fi

  echo "---- ANALYSIS ----"

  if [ -z "$LAYER" ]; then
    TOTAL=$(wc -l < "$FILE")
    echo "total events: $TOTAL"
    echo ""

    echo "event types:"
    jq -r '.type' "$FILE" | sort | uniq -c

    echo ""
    echo "layers:"
    jq -r '.layer' "$FILE" | sort | uniq -c

  else
    echo "layer: $LAYER"

    COUNT=$(jq -r --arg l "$LAYER" 'select(.layer==$l) | .message' "$FILE" | wc -l)
    echo "events: $COUNT"
    echo ""

    echo "messages:"
    jq -r --arg l "$LAYER" 'select(.layer==$l) | .message' "$FILE"
  fi

  echo "------------------"
  exit 0
fi

# -------------------------
# HELP
# -------------------------
echo "usage:"
echo "  tl signal <type> <layer> <message>"
echo "  tl read [layer]"
echo "  tl analyze [layer]"
