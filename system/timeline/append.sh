#!/bin/bash

ID="evt-$(date +%s)"
TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

read -p "type: " TYPE
read -p "layer: " LAYER
read -p "message: " MESSAGE

echo "{\"id\":\"$ID\",\"type\":\"$TYPE\",\"timestamp\":\"$TIME\",\"layer\":\"$LAYER\",\"message\":\"$MESSAGE\"}" >> system/timeline/events.jsonl

echo "event logged: $ID"
