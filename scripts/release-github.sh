#!/bin/bash

# This script is used to create a GitHub release.
# - Tag the commit and push the tag to GitHub.
# - Create a GitHub release with assets.
# - Include the changelog in the release notes.

set -euo pipefail

uv run semantic-release version \
  --skip-build \    # Built in another task.
  --no-commit \     # Work with main branch protection settings.
  --no-changelog \  # A changelog body will still be included in the release notes.
  --push \          # Push the tag to GitHub (not a commit).
  --vcs-release     # Create a GitHub release.
