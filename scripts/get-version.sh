#!/bin/bash

set -euo pipefail

# A dummy token is set to avoid the missing token warning. We just need the version.
version="$(GH_TOKEN="dummy" uv run semantic-release version --print)"
echo "$version"