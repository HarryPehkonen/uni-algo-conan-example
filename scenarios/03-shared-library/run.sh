#!/bin/bash
# Filename: scenarios/03-shared-library/run.sh

# Runtime helper script for shared library builds
# Usage: ./run.sh <executable_name>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <executable_name>"
    echo "Example: $0 unicode_example"
    exit 1
fi

EXECUTABLE="$1"

if [ ! -f "$EXECUTABLE" ]; then
    echo "Error: Executable '$EXECUTABLE' not found."
    echo "Make sure to run './build.sh' first."
    exit 1
fi

# <<< CHANGE: Use conanrun.sh for a robust, cross-platform solution
if [ ! -f "conanrun.sh" ]; then
    echo "Error: conanrun.sh not found. Run 'conan install' first."
    exit 1
fi

echo "Setting up environment with conanrun.sh..."
source conanrun.sh

echo "Running $EXECUTABLE..."
"./$EXECUTABLE"

# Clean up environment variables
source deactivate_conanrun.sh
