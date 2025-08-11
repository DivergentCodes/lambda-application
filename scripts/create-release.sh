#!/bin/bash

# Create a GitHub release.
# - Bootstrap the version tag if it doesn't exist.
# - Determine the next version from commit history.
# - Tag the commit with the new version and push it.
# - Create a GitHub release with semantic-release.
# - Output the release tag and whether a release was created.

PUSH_TAG="${1:-false}"
INITIAL_VERSION_TAG="v0.0.0"

# Only configure Git identity in CI environment
if [[ -n "${CI:-}" || -n "${GITHUB_ACTIONS:-}" ]]; then
    echo "Configuring Git identity for CI environment"
    git config --local user.email "actions@users.noreply.github.com"
    git config --local user.name "github-actions"
fi

# Bootstrap the version tag if it doesn't exist.
if ! git describe --tags --abbrev=0 >/dev/null 2>&1; then
    first_commit="$(git rev-list --max-parents=0 HEAD)"
    git tag -a "$INITIAL_VERSION_TAG" "$first_commit" -m "bootstrap"
    echo "No version tags found; bootstrapping $INITIAL_VERSION_TAG on first commit $first_commit"

    if [ "$PUSH_TAG" = "true" ]; then
        echo "Pushing tag $INITIAL_VERSION_TAG"
        git push -f origin "${INITIAL_VERSION_TAG}"
    else
        echo "Pushing bootstrap tag is disabled (PUSH_TAG=$PUSH_TAG)"
    fi
fi

# Record previous tag (if any).
before="$(git describe --tags --abbrev=0 2>/dev/null || echo none)"

# Publish with semantic release.
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