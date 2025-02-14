#!/bin/bash

set -e  # Exit immediately if a command fails

REPO_NAME="$1"
KEEP_IMAGES="$2"

if [ -z "$REPO_NAME" ] || [ -z "$KEEP_IMAGES" ]; then
  echo "Usage: ./entrypoint.sh <ECR_REPOSITORY> <NUMBER_TO_KEEP>"
  exit 1
fi

echo "Cleaning up ECR repository: $REPO_NAME"
echo "Keeping the latest $KEEP_IMAGES images..."

# Get image digests sorted by push time, keeping only older images beyond the most recent $KEEP_IMAGES
DIGESTS=$(aws ecr describe-images --repository-name "$REPO_NAME" --query "sort_by(imageDetails, &imagePushedAt)[0:-$KEEP_IMAGES].imageDigest" --output json | jq -r '.[]')

if [ -z "$DIGESTS" ]; then
  echo "No old images to delete."
else
  echo "The following images will be deleted: $DIGESTS"

  # Format for batch delete
  IMAGE_IDS=$(echo "$DIGESTS" | jq -R '[{"imageDigest": .}]' | jq -s '{imageIds: add}')

  echo "Final JSON Payload for Deletion:"
  echo "$IMAGE_IDS"

  aws ecr batch-delete-image --repository-name "$REPO_NAME" --cli-input-json "$IMAGE_IDS"
fi
