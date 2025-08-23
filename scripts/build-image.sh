#!/bin/bash

set -e  # Exit on any error

AWS_ACCOUNT_ID="${1}"
AWS_REGION="${2}"

function ensure_env_vars_are_set() {
    USAGE="Usage: $0 <AWS_ACCOUNT_ID> <AWS_REGION>"
    if [ -z "${AWS_ACCOUNT_ID}" ]; then
        echo "AWS_ACCOUNT_ID is required"
        echo "${USAGE}"
        exit 1
    elif [ -z "${AWS_REGION}" ]; then
        echo "AWS_REGION is required"
        echo "${USAGE}"
        exit 1
    fi
}

function build() {
    echo "Building Lambda deployment package..."
    docker build -t lambda-application .
    echo "Build completed successfully."
}

function tag() {
    echo "Tagging image..."
    docker tag lambda-application:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/lambda-application:latest
    echo "Tagging completed successfully."
}

function main() {
    ensure_env_vars_are_set;
    build;
    tag;
}

main