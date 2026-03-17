#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"

if [[ -z "$ENVIRONMENT" ]]; then
  echo "Usage: $0 <stg|prod>"
  exit 1
fi

if [[ -z "${DEPLOY_TOKEN:-}" ]]; then
  echo "DEPLOY_TOKEN is not set for environment '$ENVIRONMENT'."
  exit 1
fi

# Placeholder deploy command. Replace this with your real deployment logic.
echo "[deploy] Starting deployment for '$ENVIRONMENT'..."
echo "[deploy] Deployment completed for '$ENVIRONMENT'."
