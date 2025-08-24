#!/bin/bash

set -euo pipefail

# Arguments
AWS_ACCOUNT_ID="${1:-}"
AWS_REGION="${2:-}"

# Derived variables
APP_NAME="lambda-application"
APP_VERSION=$(uv run ./scripts/get-version.sh)
SHA=$(git rev-parse --short HEAD)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")


function build() {
    echo "Building Lambda deployment package..."
    docker build \
        --build-arg APP_NAME="$APP_NAME" \
        --build-arg APP_VERSION="$APP_VERSION" \
        --build-arg COMMIT_SHA="$SHA" \
        --build-arg BRANCH="$BRANCH" \
        --build-arg BUILD_DATE="$DATE" \
        -t "$APP_NAME:$APP_VERSION" .
    echo "Build completed successfully."
}

function tag_ecr() {
    echo "Tagging image..."
    docker tag "$APP_NAME:$APP_VERSION" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/$APP_NAME:$APP_VERSION"
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