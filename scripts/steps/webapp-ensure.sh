#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
source "$SCRIPT_DIR/config.env"
source "$SCRIPT_DIR/lib/common.sh"

echo "🔍 Looking for existing Firebase Web App..."
APP_ID="$(fb apps:list --project "$PROJECT_ID" --json | jq -r '.result // [] | .[] | select(.platform=="WEB") | .appId' | head -n1)"

if [ -z "$APP_ID" ]; then
  echo "🌐 No Web App found, creating one..."
  if ! CREATE_OUTPUT="$(fb apps:create web "$WEBAPP_NAME" --project "$PROJECT_ID" --json 2>firebase_error.log)"; then
    echo "❌ firebase apps:create failed:"; cat firebase_error.log; exit 1
  fi
  echo "$CREATE_OUTPUT" > .firebase_app_create_output.json
  APP_ID="$(echo "$CREATE_OUTPUT" | jq -r '.appId')"
  [[ -z "$APP_ID" || "$APP_ID" = "null" ]] && { echo "❌ Failed to create Web App."; cat .firebase_app_create_output.json; exit 1; }
else
  echo "✅ Found existing Web App: $APP_ID"
fi

# persist APP_ID for next steps
echo "$APP_ID" > .firebase_app_id
