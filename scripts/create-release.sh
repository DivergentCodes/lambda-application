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

# Fetch tags to ensure we have the latest version.
git fetch --tags --force --prune

# Show relevant commit history.
echo "Last 10 main commits (subject only):"
git --no-pager log --pretty=format:'%h %s' -10
echo "Commits since previous tag (if any):"
previous_tag="$(git describe --tags --abbrev=0 2>/dev/null || echo none)"
if [ "$previous_tag" != "none" ]; then
  git --no-pager log --pretty=format:'%h %s' "$previous_tag"..HEAD
fi

# Bootstrap the version tag if it doesn't exist.
if [ "$previous_tag" = "none" ]; then
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

# Create a new version tag.
uv run python -m semantic_release -vv version
new_tag="$(git describe --tags --abbrev=0 2>/dev/null || echo none)"

# Determine if a release was created.
released=false
tag=""
if [ "$new_tag" != "none" ] && [ "$new_tag" != "$previous_tag" ] && [ "$new_tag" != "${INITIAL_VERSION_TAG}" ]; then
    released=true
    tag="$new_tag"
    echo "New tag was created (new_tag=$new_tag, previous_tag=$previous_tag)"
else
    echo "No new tag was created (new_tag=$new_tag, previous_tag=$previous_tag)"
    git --no-pager log --pretty=format:'%h %s' "${INITIAL_VERSION_TAG}..HEAD" | sed -n '1,50p'
fi

if [ -z "$GITHUB_OUTPUT" ]; then
    echo "GITHUB_OUTPUT is not set"
    exit 1
fi

echo "released=$released" >> "$GITHUB_OUTPUT"
echo "tag=$tag" >> "$GITHUB_OUTPUT"