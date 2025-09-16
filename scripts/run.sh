#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$SCRIPT_DIR/config.env"
source "$SCRIPT_DIR/lib/common.sh"

PROJECT_ID="${1:-${PROJECT_ID:-autora}}"

# prompt until valid
echo "📌 Using project ID: $PROJECT_ID"
until validate_project_id "$PROJECT_ID"; do
  echo "❌ Invalid project_id: '$PROJECT_ID'"
  echo "Must be 6–30 chars, lowercase letters, digits, or hyphens; start with a letter."
  read -r -p "Enter a valid project ID: " PROJECT_ID
done

export PROJECT_ID DISPLAY_NAME WEBAPP_NAME REGION BUILD_DIR SERVICE_ACCOUNT_KEY_FILE FIREBASE_CONFIG_FILE

# Execute steps in order

bash "$SCRIPT_DIR/steps/bootstrap-tools.sh"
bash "$SCRIPT_DIR/steps/auth-login-firebase.sh"
bash "$SCRIPT_DIR/steps/project-ensure.sh"
bash "$SCRIPT_DIR/steps/auth-login-gcloud.sh"
bash "$SCRIPT_DIR/steps/write-firebaserc.sh"
bash "$SCRIPT_DIR/steps/webapp-ensure.sh"
bash "$SCRIPT_DIR/steps/export-sdk-config.sh"
bash "$SCRIPT_DIR/steps/write-env-from-sdk.sh"
bash "$SCRIPT_DIR/steps/admin-key.sh"
bash "$SCRIPT_DIR/steps/firestore-ensure.sh"
bash "$SCRIPT_DIR/steps/hosting-config.sh"
bash "$SCRIPT_DIR/steps/build-and-deploy.sh"

echo "🎉 All steps completed."
