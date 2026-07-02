#!/bin/bash

# Usage: ./sync_abseil.sh <release_tag>
# Example: ./sync_abseil.sh 20260107.1

if [ -z "$1" ]; then
    echo "Error: No release tag provided."
    exit 1
fi

RELEASE_TAG=$1
UPSTREAM_URL="https://github.com/abseil/abseil-cpp.git"

echo "--- Syncing Abseil $RELEASE_TAG from Upstream ---"

# 1. Add upstream remote if it doesn't exist
if ! git remote get-url upstream &> /dev/null; then
    echo "Adding upstream remote: $UPSTREAM_URL"
    git remote add upstream "$UPSTREAM_URL"
fi

# 2. Fetch tags from upstream
echo "Fetching tags from upstream..."
git fetch upstream --tags

# 3. Create/Checkout your branch
BRANCH_NAME="sync-$RELEASE_TAG"
git checkout -b "$BRANCH_NAME"

# 4. Checkout the specific tag into your working directory
# Note: We use a forced checkout to pull files from the upstream tag
echo "Syncing files from upstream tag $RELEASE_TAG..."
git checkout "$RELEASE_TAG" -- .

# 5. Cleanup (The SwiftPM-specific pruning)
echo "Applying SwiftPM cleanup..."

find absl/ -name "*_test.cc" -delete
find absl/ -name "*_test.c" -delete
find absl/ -name "*_benchmark.cc" -delete

rm -f absl/status/internal/status_matchers.*
rm -rf absl/time/internal/cctz/testdata
find absl/ -name "BUILD.bazel" -delete
find absl/ -name "CMakeLists.txt" -delete
rm -rf absl/copts

grep -rl '#include "gtest/gtest.h"' absl/ | xargs rm -f
grep -rl '#include "gmock/gmock.h"' absl/ | xargs rm -f
grep -rEl "^int main\(" absl/ | xargs rm -f

echo "Cleanup complete."

# 6. Verify
echo "--- Running Build Verification ---"
if swift build && swift test; then
    echo "SUCCESS: Sync and build verified."
else
    echo "ERROR: Build failed. Please check the logs."
    exit 1
fi