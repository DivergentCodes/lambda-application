#!/bin/bash

PUSH_TAG="${1:-false}"
INITIAL_VERSION_TAG="v0.1.0"

# Only configure Git identity in CI environment
if [[ -n "${CI:-}" || -n "${GITHUB_ACTIONS:-}" ]]; then
    echo "Configuring Git identity for CI environment"
    git config --local user.email "actions@users.noreply.github.com"
    git config --local user.name "github-actions"
fi

if ! git describe --tags --abbrev=0 >/dev/null 2>&1; then
    echo "No version tags found; bootstrapping $INITIAL_VERSION_TAG"
    git tag -a "$INITIAL_VERSION_TAG" -m "bootstrap"
    if [ "$PUSH_TAG" = "true" ]; then
        echo "Pushing tag $INITIAL_VERSION_TAG"
        git push origin "$INITIAL_VERSION_TAG"
    else
        echo "Pushing bootstrap tag is disabled (PUSH_TAG=$PUSH_TAG)"
    fi
fi
