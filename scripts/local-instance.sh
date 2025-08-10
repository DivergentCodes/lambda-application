#!/bin/bash

set -e

operation="$1"

dist_path="$PWD/dist"
lambda_zip_path="$dist_path/lambda.zip"
lambda_task_path=".lambda_task"
lambda_task_handler="main.handler"

image="public.ecr.aws/lambda/python:3.11"
container_name="lambda-integration-test"
container_port=9000
invoke_url="http://localhost:${container_port}/2015-03-31/functions/function/invocations"

function unzip_lambda_archive() {
    rm -rf "${lambda_task_path}" && mkdir -p "${lambda_task_path}"
    unzip -q "${lambda_zip_path}" -d "${lambda_task_path}"
}

function clean_lambda_archive() {
    rm -rf "${lambda_task_path}"
}

function wait_for_container_ready() {
    echo "Waiting for container to be ready..."
    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "${invoke_url}" > /dev/null 2>&1; then
            echo "Container is ready!"
            echo "Waiting 2 seconds for container to stabilize..."
            sleep 2
            return 0
        fi

        echo "Attempt $attempt/$max_attempts: Container not ready yet, waiting..."
        sleep 2
        attempt=$((attempt + 1))
    done

    echo "Container failed to become ready after $max_attempts attempts"
    return 1
}

function start_container() {
    docker run --rm -d \
        --name "${container_name}" \
        -p "${container_port}:8080" \
        -v "$PWD/${lambda_task_path}":/var/task:ro \
        "${image}" \
        "${lambda_task_handler}"

    wait_for_container_ready
}

function stop_container() {
    docker stop "${container_name}"
}

function main() {
    case "$operation" in
        "start")
            echo "Starting container ${container_name}..."
            stop_container || true
            clean_lambda_archive || true
            unzip_lambda_archive
            start_container
            ;;
        "stop")
            echo -e "\n\nStopping container ${container_name}..."
            stop_container
            clean_lambda_archive
            ;;
    esac
}

main