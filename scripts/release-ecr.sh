#!/bin/bash

set -euo pipefail

ECR_REPOSITORY_URL="${1:-$ECR_REPOSITORY_URL}"

IMAGE_NAME="$(echo "$ECR_REPOSITORY_URL" | cut -d '/' -f 2)"
IMAGE_TAG="$(./scripts/get-version.sh)"
AWS_ACCOUNT_ID="$(echo "$ECR_REPOSITORY_URL" | cut -d '.' -f 1)"
AWS_ECR_REGION="$(echo "$ECR_REPOSITORY_URL" | cut -d '.' -f 4)"

function ensure_parameters() {
    if [ -z "$ECR_REPOSITORY_URL" ]; then
        echo "ECR_REPOSITORY_URL is not set"
        exit 1
    fi
}

function ecr_login() {
    aws ecr get-login-password --region "$AWS_ECR_REGION" | \
        docker login --username AWS --password-stdin "$ECR_REPOSITORY_URL"
}

function ecr_tag() {
    echo "Tagging image: $ECR_REPOSITORY_URL:$IMAGE_TAG"
    docker tag "$IMAGE_NAME:$IMAGE_TAG" "$ECR_REPOSITORY_URL:$IMAGE_TAG"
}

function ecr_push() {
    echo "Pushing image to ECR: $ECR_REPOSITORY_URL:$IMAGE_TAG"
    docker push "$ECR_REPOSITORY_URL:$IMAGE_TAG"
}

function main() {
    ensure_parameters
    ecr_login
    ecr_tag
    ecr_push
}

main