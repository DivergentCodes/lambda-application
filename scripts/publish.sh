#!/bin/bash

dist_path="dist"
tag="${1}"

if [ -z "$tag" ]; then
    echo "Tag is required"
    exit 1
fi

echo "Publishing distribution artifacts to GitHub Release $tag"

# Ensure distribution artifacts exist. Add more files if you have them.
ls -lah "$dist_path"

# Upload distribution artifacts to GitHub Release (idempotent if re-run).
gh release upload "$tag" "$dist_path/*" --clobber
