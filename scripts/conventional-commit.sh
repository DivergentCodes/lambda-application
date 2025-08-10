#!/usr/bin/env bash

set -euo pipefail

TITLE="${1:-}"
if [[ -z "$TITLE" ]]; then
  echo "::error::PR title is required"
  exit 1
fi

TYPES_REGEX="build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test"

# Conventional Commits: <type>(<scope>)?(!)?: <subject>
RE="^(${TYPES_REGEX})(\([A-Za-z0-9._/-]+\))?(!)?: .+"

if [[ ! "$TITLE" =~ $RE ]]; then
  echo "::error::PR title must follow Conventional Commits.
Received: \"$TITLE\"
Expected: <type>(<scope>)?: <summary>
Allowed types: ${TYPES_REGEX//|/, }
Examples:
  - feat(api): add token exchange
  - fix(auth)!: reject blank client_id
  - chore: bump dependencies
"
  exit 1
fi

echo "PR title OK: $TITLE"
