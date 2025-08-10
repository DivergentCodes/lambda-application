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
    if [ -d "${lambda_task_path}" ]; then
        rm -rf "${lambda_task_path}"
    fi
}

function wait_for_container_ready() {
    echo "Waiting for container ${container_name} to be ready..."
    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "${invoke_url}" > /dev/null 2>&1; then
            echo "Container ${container_name} is ready!"
            return 0
        fi

        echo "Attempt $attempt/$max_attempts: Container ${container_name} not ready yet, waiting..."

        # Check if container is still running
        if ! docker ps -q -f name="${container_name}" | grep -q .; then
            echo "Container ${container_name} has stopped unexpectedly. Checking logs:"
            docker logs "${container_name}" 2>/dev/null || echo "Could not retrieve logs"
            return 1
        fi

        sleep 2
        attempt=$((attempt + 1))
    done

    echo "Container ${container_name} failed to become ready after $max_attempts attempts"
    echo "Container logs:"
    docker logs "${container_name}" 2>/dev/null || echo "Could not retrieve logs"
    return 1
}

function start_container() {
    echo "Starting container ${container_name} with image: ${image}"
    echo "Port mapping: ${container_port}:8080"
    echo "Handler: ${lambda_task_handler}"

    docker run --rm -d \
        --name "${container_name}" \
        -p "${container_port}:8080" \
        -v "$PWD/${lambda_task_path}":/var/task:ro \
        "${image}" \
        "${lambda_task_handler}"

    wait_for_container_ready
}

function stop_container() {
    if docker ps -q -f name="${container_name}" | grep -q .; then
        docker stop "${container_name}"
    else
        echo "Container ${container_name} is not running"
    fi
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