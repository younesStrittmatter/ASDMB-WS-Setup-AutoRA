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
bash "$SCRIPT_DIR/steps/auth-login.sh"
#bash "$SCRIPT_DIR/steps/02-project-ensure.sh"
#bash "$SCRIPT_DIR/steps/03-write-firebaserc.sh"
#bash "$SCRIPT_DIR/steps/04-webapp-ensure.sh"
#bash "$SCRIPT_DIR/steps/05-export-sdk-config.sh"
#bash "$SCRIPT_DIR/steps/06-write-env-from-sdk.sh"
#bash "$SCRIPT_DIR/steps/07-admin-key.sh"
#bash "$SCRIPT_DIR/steps/08-firestore-ensure.sh"
#bash "$SCRIPT_DIR/steps/09-hosting-config.sh"
#bash "$SCRIPT_DIR/steps/10-build-and-deploy.sh"

echo "🎉 All steps completed."
