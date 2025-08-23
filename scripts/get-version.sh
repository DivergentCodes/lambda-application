#!/bin/bash

set -euo pipefail

# A dummy token is set to avoid the missing token warning. We just need the version.
export GH_TOKEN="${GH_TOKEN:-dummy}"
base_version="$(uv run semantic-release version --print)"

if [[ "$base_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+- ]]; then
    # Pre-release version. Add build metadata.
    sha="$(git rev-parse --short HEAD)"
    branch_raw="$(git rev-parse --abbrev-ref HEAD)"
    branch_slug="$(echo "$branch_raw" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^0-9a-z-]+/-/g' | sed -E 's/^-+|-+$//g')"
    version="$(uv run semantic-release version --print --build-metadata $sha.$branch_slug)"
else
    # Full release version.
    version="$base_version"
fi

echo "$version"