#!/bin/bash

dist_path="dist"

# Ensure distribution artifacts exist. Add more files if you have them.
ls -lah "$dist_path"

# Upload distribution artifacts to GitHub Release (idempotent if re-run).
gh release upload "${{ steps.tag-version.outputs.tag }}" "$dist_path/*" --clobber
