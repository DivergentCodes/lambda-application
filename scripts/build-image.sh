#!/bin/bash

set -euo pipefail

# Arguments
IMAGE_NAME="${1:-${IMAGE_NAME:-}}"
: "${IMAGE_NAME:?IMAGE_NAME is required. Pass as first arg or set IMAGE_NAME env var.}"

AWS_ACCOUNT_ID="${2:-${AWS_ACCOUNT_ID:-}}"
AWS_REGION="${3:-${AWS_REGION:-}}"

# Derived variables
IMAGE_VERSION=$(uv run ./scripts/get-version.sh)
SHA=$(git rev-parse --short HEAD)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

function build() {
    echo "Building Lambda deployment package..."
    docker build \
        --build-arg IMAGE_NAME="$IMAGE_NAME" \
        --build-arg IMAGE_VERSION="$IMAGE_VERSION" \
        --build-arg COMMIT_SHA="$SHA" \
        --build-arg BRANCH="$BRANCH" \
        --build-arg BUILD_DATE="$DATE" \
        -t "$IMAGE_NAME:$IMAGE_VERSION" .
    echo "Build completed successfully."
}

function tag_ecr() {
    echo "Tagging image..."
    docker tag "$IMAGE_NAME:$IMAGE_VERSION" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/$IMAGE_NAME:$IMAGE_VERSION"
    echo "Tagging completed successfully."
}

function main() {
    build;
    if [ -n "${AWS_ACCOUNT_ID}" ] && [ -n "${AWS_REGION}" ]; then
        tag_ecr;
    else
        echo "AWS_ACCOUNT_ID and AWS_REGION are not both set. Skipping ECR tagging."
    fi
}

main