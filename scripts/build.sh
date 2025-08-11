#!/bin/bash

set -e  # Exit on any error


ENTRYPOINT_CODE_FILE="main.py"
DIST_FILE="lambda.zip"
DIST_PATH="dist/${DIST_FILE}"


function cleanup() {
    echo "Cleaning up previous build..."
    rm -rf dist
    mkdir -p dist
}


function build() {
    echo "Building Lambda deployment package..."
    # Create zip with source files at root level, excluding test and cache files
    pushd src > /dev/null
    zip -r ../${DIST_PATH} . \
        -x "*.pyc" \
        -x "__pycache__/*" \
        -x "*.pyo" \
        -x "*.pyd" \
        -x "*.so" \
        -x "*.egg" \
        -x "*.egg-info" \
        -x "*.test.py" \
        -x "*_test.py" \
        -x "test_*.py" \
        -x "tests/*" \
        -x ".pytest_cache/*" \
        -x ".coverage" \
        -x "*.log" \
        -x ".DS_Store" \
        -x "Thumbs.db"

    popd > /dev/null

    echo "Build completed successfully!"
}

function verify_build() {
    echo "Verifying archive structure..."

    # Verify no test files are included
    if unzip -l ${DIST_PATH} | grep -q "test"; then
        echo "ERROR: Test files found in archive ${DIST_PATH}!"
        echo "Contents:"
        unzip -l ${DIST_PATH} | grep "test"
        exit 1
    fi

    # Verify no cache files are included
    if unzip -l ${DIST_PATH} | grep -q "__pycache__\|\.pyc\|\.pyo"; then
        echo "ERROR: Cache files found in archive ${DIST_PATH}!"
        echo "Contents:"
        unzip -l ${DIST_PATH} | grep "__pycache__\|\.pyc\|\.pyo"
        exit 1
    fi

    # Verify source files are at root level
    if ! zipinfo -1 ${DIST_PATH} | grep -q "^${ENTRYPOINT_CODE_FILE}$"; then
        echo "ERROR: Entrypoint file ${ENTRYPOINT_CODE_FILE} not found at root level in ${DIST_PATH}!"
        echo "Contents:"
        unzip -l ${DIST_PATH} | grep "^${ENTRYPOINT_CODE_FILE}$"
        exit 1
    fi

    # Verify archive is not empty
    ARCHIVE_SIZE=$(unzip -l ${DIST_PATH} | tail -1 | awk '{print $2}')
    if [ "$ARCHIVE_SIZE" -eq 0 ]; then
        echo "ERROR: Archive ${DIST_PATH} is empty!"
        exit 1
    fi

    echo "Archive structure is correct."
}

function sha256_hash() {
    # shasum is available on macOS, sha256sum is available on Linux
    if uname -a | grep -q "Darwin"; then
        shasum -a 256 ${DIST_PATH} | awk '{print $1}'
    else
        sha256sum ${DIST_PATH} | awk '{print $1}'
    fi
}

function write_gha_outputs() {
    echo "size=$1" >> "$GITHUB_OUTPUT"
    echo "sha256=$2" >> "$GITHUB_OUTPUT"
}

function main() {
    cleanup
    build
    verify_build

    zip_size=$(ls -lh dist/lambda.zip | awk '{print $5}')
    zip_sha256=$(sha256_hash)
    echo "Lambda deployment package built"
    echo "path=${DIST_PATH}"
    echo "size=${zip_size}"
    echo "sha256=${zip_sha256}"

    if [ -n "$GITHUB_OUTPUT" ]; then
        write_gha_outputs "$zip_size" "$zip_sha256"
    fi
}

main
