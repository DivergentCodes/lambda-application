#!/bin/bash

set -e

operation="$1"
image="$2"

function usage() {
    echo "Usage: $0 <start|stop> <image>"
    echo "Example: $0 start lambda-application:3.2.1-dev.1"
}

function ensure_parameters() {
    if [ -z "${operation}" ]; then
        echo "Error: Operation is required"
        usage
        exit 1
    fi

    if [ -z "${image}" ]; then
        echo "Error: Image is required"
        usage
        exit 1
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

    docker run --rm -d \
        --name "${container_name}" \
        -p "${container_port}:8080" \
        "${image}"

    wait_for_container_ready

    echo "Example invocation: curl -s -X POST ${invoke_url} -d '{\"name\":\"Foo\"}' | jq"
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
            start_container
            ;;
        "stop")
            echo -e "\n\nStopping container ${container_name}..."
            stop_container
            ;;
    esac
}

ensure_parameters
image_name="$(echo ${image} | cut -d ':' -f 1)"
image_tag="$(echo ${image} | cut -d ':' -f 2)"
container_name="${image_name}-${image_tag}-integration-test"
container_port=9000
invoke_url="http://localhost:${container_port}/2015-03-31/functions/function/invocations"

main