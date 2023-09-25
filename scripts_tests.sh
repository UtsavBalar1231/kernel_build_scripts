#!/bin/bash

# Mock print and exit_with_error functions
function print() {
  echo "$@"
}

function exit_with_error() {
  echo "Error: $@"
  ERROR_COUNT=$((ERROR_COUNT + 1))
}

# Set up mock variables
CLANG_DIR="../clang"
GCC64_DIR="../gcc64"
GCC32_DIR="../gcc32"
DEVICE_ARCH="arm64"
OUT_DIR="/tmp/out"
DEFAULT_CLANG_VERSION="17"

# Initialize error count
ERROR_COUNT=0

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
echo "script called from ${SCRIPT_DIR}"

# Load the functions from the original script
source "${SCRIPT_DIR}"/functions

# Test the download_toolchain function for Clang
print "Testing download_toolchain for Clang..."
download_toolchain "Clang" "${DEFAULT_CLANG_VERSION}" "github" "ThankYouMario" "android_prebuilts_clang-standalone" "$CLANG_DIR"

# Test the get_clang_toolchain function
print "Testing get_clang_toolchain..."
get_clang_toolchain "$DEFAULT_CLANG_VERSION"

# Test the build_clang function
print "Testing build_clang..."
build_clang

# Test the build_gcc function
print "Testing build_gcc..."
build_gcc

# Check if any errors occurred during the tests
if [[ $ERROR_COUNT -eq 0 ]]; then
  print "All functions tested successfully."
else
  print "Some functions encountered errors."
fi

