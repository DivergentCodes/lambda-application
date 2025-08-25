#!/bin/bash

# This script is used to create a GitHub release.
# - Tag the commit and push the tag to GitHub.
# - Create a GitHub release with assets.
# - Include the changelog in the release notes.

set -euo pipefail

uv run semantic-release version \
  --skip-build \
  --no-commit \
  --no-changelog \
  --push \
  --vcs-release
