#!/bin/bash

# Record previous tag (if any).
before="$(git describe --tags --abbrev=0 2>/dev/null || echo none)"

# Determine next version from commit history.
uv run python -m semantic_release publish
after="$(git describe --tags --abbrev=0 2>/dev/null || echo none)"

# Determine if a release was created.
released=false
tag=""
if [ "$after" != "none" ] && [ "$after" != "$before" ]; then
    released=true
    tag="$after"
fi

if [ -z "$GITHUB_OUTPUT" ]; then
    echo "GITHUB_OUTPUT is not set"
    exit 1
fi

echo "released=$released" >> "$GITHUB_OUTPUT"
echo "tag=$tag" >> "$GITHUB_OUTPUT"