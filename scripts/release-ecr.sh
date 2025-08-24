#!/bin/bash

set -euo pipefail

# Arguments
IMAGE_NAME="${1:-${IMAGE_NAME:-}}"
: "${IMAGE_NAME:?IMAGE_NAME is required. Pass as first arg or set IMAGE_NAME env var.}"

AWS_ACCOUNT_ID="${2:-${AWS_ACCOUNT_ID:-}}"
: "${AWS_ACCOUNT_ID:?AWS_ACCOUNT_ID is required. Pass as second arg or set AWS_ACCOUNT_ID env var.}"

AWS_REGION="${3:-${AWS_REGION:-}}"
: "${AWS_REGION:?AWS_REGION is required. Pass as third arg or set AWS_REGION env var.}"

# Derived variables
IMAGE_VERSION=$(uv run ./scripts/get-version.sh)
ECR_REPOSITORY_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME"

function ecr_login() {
    aws ecr get-login-password --region "$AWS_REGION" | \
        docker login --username AWS --password-stdin "$ECR_REPOSITORY_URL"
}

function ecr_tag() {
    echo "Tagging image: $ECR_REPOSITORY_URL:$IMAGE_VERSION"
    docker tag "$IMAGE_NAME:$IMAGE_VERSION" "$ECR_REPOSITORY_URL:$IMAGE_VERSION"
}

function ecr_push() {
    echo "Pushing image to ECR: $ECR_REPOSITORY_URL:$IMAGE_VERSION"
    docker push "$ECR_REPOSITORY_URL:$IMAGE_VERSION"
}

function main() {
    ecr_login
    ecr_tag
    ecr_push
}

main