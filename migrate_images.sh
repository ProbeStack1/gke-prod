#!/bin/bash

# ---------------------------------------------------------------------------
# IMAGE MIGRATION SCRIPT
# From: Non-Prod (methodical-mark...)
# To:   Prod (probestack-prod)
# ---------------------------------------------------------------------------

# Source Registry URL
SRC_REGISTRY="us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-nonprod-apps"

# Destination Registry URL
DEST_REGISTRY="us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps"

# List of images to migrate (Name:Tag)
# Based on your existing variables.tf
IMAGES=(
  "react-vite:1.0"
  "react-admin:11.0"
  "admin-backend:5.0"
  "cutover:1.0"
  "apigee-edge-mock-service:1.0"
  "probestack-apigee-assessment-service:1.0"
  "probestack-apigee-deployments-service:1.0"
  "probestack-apigee-discovery-service:1.0"
  "probestack-apigee-migration-service:1.0"
  "probestack-profile-config-service:1.0"
)

echo "=========================================================="
echo "Starting Image Migration"
echo "From: $SRC_REGISTRY"
echo "To:   $DEST_REGISTRY"
echo "=========================================================="

# 1. Authenticate Docker with Google Cloud
echo "Authenticating with Artifact Registry..."
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet

for IMAGE in "${IMAGES[@]}"; do
  SRC_IMAGE="$SRC_REGISTRY/$IMAGE"
  DEST_IMAGE="$DEST_REGISTRY/$IMAGE"

  echo ""
  echo "Processing: $IMAGE"
  
  # 2. Pull from Source
  echo "  - Pulling..."
  docker pull "$SRC_IMAGE"
  
  if [ $? -ne 0 ]; then
    echo "  ! ERROR: Failed to pull $SRC_IMAGE. Check permissions or if image exists."
    continue
  fi

  # 3. Re-tag for Destination
  echo "  - Retagging..."
  docker tag "$SRC_IMAGE" "$DEST_IMAGE"

  # 4. Push to Destination
  echo "  - Pushing to Prod..."
  docker push "$DEST_IMAGE"

  if [ $? -eq 0 ]; then
    echo "  + SUCCESS: Migrated $IMAGE"
  else
    echo "  ! ERROR: Failed to push $DEST_IMAGE"
  fi
done

echo ""
echo "=========================================================="
echo "Migration Complete"
echo "=========================================================="