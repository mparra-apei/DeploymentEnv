#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"
CONFIG_FILE="${2:-}"

if [[ -z "$ENVIRONMENT" ]]; then
  echo "Usage: $0 <stg|prod> [config.json]"
  exit 1
fi

if [[ -n "$CONFIG_FILE" && ! -f "$CONFIG_FILE" ]]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

APP_NAME=""
ARTIFACT=""
TARGET_REGION=""

if [[ -n "$CONFIG_FILE" ]]; then
  APP_NAME="$(jq -r '.appName // ""' "$CONFIG_FILE")"
  ARTIFACT="$(jq -r '.artifact // ""' "$CONFIG_FILE")"
  TARGET_REGION="$(jq -r '.targetRegion // ""' "$CONFIG_FILE")"
fi

# Placeholder deploy command. Replace this with your real deployment logic.
echo "[deploy] Starting deployment for '$ENVIRONMENT'..."
if [[ -n "$CONFIG_FILE" ]]; then
  echo "[deploy] Config file: $CONFIG_FILE"
  echo "[deploy] appName=$APP_NAME artifact=$ARTIFACT targetRegion=$TARGET_REGION"
fi
echo "[deploy] Deployment completed for '$ENVIRONMENT'."
