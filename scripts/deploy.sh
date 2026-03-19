#!/usr/bin/env bash
set -euo pipefail

ENV_SELECTOR="${1:-all}"
CONFIG_FILE="${2:-config/deploy/main.json}"

usage() {
  echo "Usage: $0 [all|env1,env2,...] [config.json]"
}

if [[ "$ENV_SELECTOR" == "-h" || "$ENV_SELECTOR" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

APP_NAME=""
ARTIFACT=""
TARGET_REGION=""
ALLOWED_ENVIRONMENTS=()
DEPLOY_ENVIRONMENTS=()

APP_NAME="$(jq -r '.appName // ""' "$CONFIG_FILE")"
ARTIFACT="$(jq -r '.artifact // ""' "$CONFIG_FILE")"
TARGET_REGION="$(jq -r '.targetRegion // ""' "$CONFIG_FILE")"
mapfile -t ALLOWED_ENVIRONMENTS < <(jq -r '.environments // [] | .[]' "$CONFIG_FILE")

if (( ${#ALLOWED_ENVIRONMENTS[@]} == 0 )); then
  echo "No environments found in $CONFIG_FILE"
  exit 1
fi

contains_environment() {
  local target="$1"
  for env in "${ALLOWED_ENVIRONMENTS[@]}"; do
    if [[ "$env" == "$target" ]]; then
      return 0
    fi
  done
  return 1
}

if [[ "$ENV_SELECTOR" == "all" ]]; then
  DEPLOY_ENVIRONMENTS=("${ALLOWED_ENVIRONMENTS[@]}")
else
  IFS=',' read -r -a requested <<< "$ENV_SELECTOR"
  invalid=()

  for raw_env in "${requested[@]}"; do
    # Trim spaces around comma-separated values.
    env="${raw_env#"${raw_env%%[![:space:]]*}"}"
    env="${env%"${env##*[![:space:]]}"}"

    if [[ -z "$env" ]]; then
      continue
    fi

    if contains_environment "$env"; then
      DEPLOY_ENVIRONMENTS+=("$env")
    else
      invalid+=("$env")
    fi
  done

  if (( ${#invalid[@]} > 0 )); then
    echo "Invalid environment(s): ${invalid[*]}"
    echo "Allowed environments: ${ALLOWED_ENVIRONMENTS[*]}"
    exit 1
  fi

  if (( ${#DEPLOY_ENVIRONMENTS[@]} == 0 )); then
    usage
    exit 1
  fi
fi

# Placeholder deploy command. Replace this with your real deployment logic.
for ENVIRONMENT in "${DEPLOY_ENVIRONMENTS[@]}"; do
  echo "[deploy] Starting deployment for '$ENVIRONMENT'..."
  echo "[deploy] Config file: $CONFIG_FILE"
  echo "[deploy] appName=$APP_NAME artifact=$ARTIFACT targetRegion=$TARGET_REGION"
  echo "[deploy] Deployment completed for '$ENVIRONMENT'."
done
