#!/bin/bash

dist_path="dist"
tag="${1}"
sha256="${2}"

if [ -z "$tag" ] || [ "$tag" = "none" ]; then
    echo "Valid tag is required (got: '$tag')"
    exit 1
fi

if [ -z "$sha256" ] || [ "$sha256" = "none" ]; then
    echo "Valid SHA256 hash is required (got: '$sha256')"
    exit 1
fi

echo "Publishing distribution artifacts to GitHub Release $tag"

# Ensure distribution artifacts exist. Add more files if you have them.
if [ ! -d "$dist_path" ]; then
    echo "Distribution directory $dist_path does not exist"
    exit 1
fi

ls -lah "$dist_path"

# Upload distribution artifacts to GitHub Release (idempotent if re-run).
gh release upload "$tag" "$dist_path/*" --clobber
