#!/bin/bash

set -euo pipefail

# A dummy token is set to avoid the missing token warning. We just need the version.
export GH_TOKEN="${GH_TOKEN:-dummy}"
version="$(uv run semantic-release version --print)"
echo "$version"