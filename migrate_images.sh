#!/bin/bash

SRC="us-central1-docker.pkg.dev/methodical-mark-482504-j3/probestack-nonprod-apps"
DEST="us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps"
LOCATION="us-central1"

echo "Authenticating docker..."
gcloud auth configure-docker $LOCATION-docker.pkg.dev --quiet

echo "Fetching images + tags..."

gcloud artifacts docker images list $SRC \
  --include-tags \
  --format="value(IMAGE,TAGS)" | while read -r IMAGE TAGS
do
  # remove repo prefix
  NAME=${IMAGE#"$SRC/"}

  # TAGS may be comma separated
  IFS=',' read -ra TAG_ARRAY <<< "$TAGS"

  for TAG in "${TAG_ARRAY[@]}"; do
    TAG=$(echo "$TAG" | xargs)

    # skip empty tags
    if [[ -z "$TAG" || "$TAG" == "<none>" ]]; then
      continue
    fi

    SRC_IMAGE="$SRC/$NAME:$TAG"
    DEST_IMAGE="$DEST/$NAME:$TAG"

    echo ""
    echo "Processing $NAME:$TAG"

    docker pull "$SRC_IMAGE" || { echo "Pull failed"; continue; }
    docker tag "$SRC_IMAGE" "$DEST_IMAGE"
    docker push "$DEST_IMAGE" || { echo "Push failed"; continue; }

    echo "SUCCESS"

  done

done

echo ""
echo "Migration complete"