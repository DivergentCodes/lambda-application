#!/bin/bash

set -e

operation="$1"

dist_path="$PWD/dist"
lambda_zip_path="$dist_path/lambda.zip"
lambda_task_path=".lambda_task"

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

function start_container() {

    docker run --rm -d \
        --name "${container_name}" \
        -p "${container_port}:8080" \
        -v "$PWD/${lambda_task_path}":/var/task:ro \
        "${image}" \
        "main.handler"
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