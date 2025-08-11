#!/bin/bash

tag="${1}"
sha256="${2}"
dist_path="dist"

if [ -z "$tag" ] || [ "$tag" = "none" ]; then
    echo "Valid tag is required (got: '$tag')"
    exit 1
elif [ -z "$sha256" ] || [ "$sha256" = "none" ]; then
    echo "Valid SHA256 hash is required (got: '$sha256')"
    exit 1
elif [ ! -d "$dist_path" ]; then
    echo "Distribution directory $dist_path does not exist"
    exit 1
fi

function publish_github_release() {
    # Upload distribution artifacts to GitHub Release (idempotent if re-run).
    echo "Publishing distribution artifacts to GitHub Release $tag"
    gh release upload "$tag" "$dist_path/*" --clobber
}

function publish_s3_object() {
    bucket_path="lambda/lambda-application/$tag/$sha256/lambda.zip"
    echo "Publishing distribution artifacts to S3 bucket $bucket_path"
}

function main() {
    ls -lah "$dist_path"

    publish_github_release
}

main