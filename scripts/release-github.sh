#!/bin/bash

# This script is used to create a GitHub release.
# - Tag the commit and push it to GitHub.
# - Create a GitHub release with assets.
# - Update the changelog.

set -euo pipefail

uv run semantic-release version \
    --skip-build \
    --push
