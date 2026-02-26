#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════
# Cloud Run Deploy — Serverpod + Supabase (chatapp493)
# Run from REPO ROOT: ./cloud-run-deploy.sh
# ═══════════════════════════════════════════════════════════════════════
set -e

PROJECT_ID="chatapp493"
REGION="europe-west1"
SERVICE_NAME="chatapp-server"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"
DOCKERFILE_PATH="backend/server/Dockerfile"
PRODUCTION_CONFIG="backend/server/config/production.yaml"

echo "══════════════════════════════════════════════════"
echo "🚌 Lasta 493 — Cloud Run Deploy"
echo "══════════════════════════════════════════════════"

# 1. Enable required APIs
echo "🔧 Enabling APIs..."
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  containerregistry.googleapis.com \
  --project="${PROJECT_ID}" \
  --quiet || true

# 2. Build Docker image from repo root (monorepo context)
echo "🐳 Building Docker image from monorepo root..."
gcloud builds submit . \
  --config cloudbuild.yaml \
  --project="${PROJECT_ID}"

# 3. Deploy to Cloud Run
echo "🚀 Deploying to Cloud Run..."
gcloud run deploy "${SERVICE_NAME}" \
  --image "${IMAGE_NAME}" \
  --platform managed \
  --region "${REGION}" \
  --project "${PROJECT_ID}" \
  --port 8080 \
  --allow-unauthenticated \
  --memory 512Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 3 \
  --set-env-vars "runmode=production,serverid=default,logging=normal,role=monolith" \
  --quiet

# 4. Get deployed URL
API_URL=$(gcloud run services describe "${SERVICE_NAME}" \
  --region "${REGION}" \
  --project "${PROJECT_ID}" \
  --format='value(status.url)')

# Strip https:// to get just the host for Serverpod config
API_HOST=$(echo "${API_URL}" | sed 's|https://||')

# 5. Auto-update publicHost in production.yaml
echo "📝 Updating publicHost in ${PRODUCTION_CONFIG}..."
sed -i "s|publicHost:.*|publicHost: ${API_HOST}|g" "${PRODUCTION_CONFIG}"
echo "   ✅ Set publicHost = ${API_HOST}"

echo ""
echo "══════════════════════════════════════════════════"
echo "✅ DEPLOY SUCCESSFUL!"
echo "══════════════════════════════════════════════════"
echo ""
echo "🌐 API URL:      ${API_URL}"
echo "📱 Flutter:      Update serverUrl in main.dart to: ${API_URL}/"
echo "📊 Logs:         gcloud run services logs read ${SERVICE_NAME} --region ${REGION}"
echo "🔄 Re-deploy:    ./cloud-run-deploy.sh"
echo ""
echo "⚠️  NEXT STEPS:"
echo "   1. publicHost in production.yaml updated automatically ✅"
echo "   2. ‼️  Update serverUrl in apps/mobile_app/lib/ to: ${API_URL}/"
echo "   3. Run DB migrations if first deploy:"
echo "      cd backend/server && dart run serverpod_cli apply-migrations --mode=production"
echo ""
