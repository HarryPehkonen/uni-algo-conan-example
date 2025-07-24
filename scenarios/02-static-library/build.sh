#!/bin/bash
# Filename: scenarios/02-static-library/build.sh

# Static Library Build Script for uni-algo
# This script demonstrates how to build with g++/clang++/cl directly

set -e  # Exit on any error

echo "=== Static Library uni-algo Build ==="

# Check if Conan has been run
if [ ! -f "conan_toolchain.cmake" ]; then
    echo "Running conan install..."
    conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=False" --build=missing -s compiler.cppstd=17
fi

# The conanbuild.sh from CMakeToolchain doesn't set the necessary env vars for this script.
# We must find the paths manually.
echo "Finding Conan package paths manually..."
CONAN_INCLUDE_DIRS=$(find ~/.conan2 -path "*/p/include" -type d 2>/dev/null | head -1)
CONAN_LIB_DIRS=$(find ~/.conan2 -path "*/p/lib" -type d 2>/dev/null | head -1)

if [ -z "$CONAN_INCLUDE_DIRS" ] || [ -z "$CONAN_LIB_DIRS" ]; then
    echo "ERROR: Could not find Conan directories. Run 'conan install' first."
    exit 1
fi

# Set up library linking. $LDFLAGS is used by the compiler command below.
export LDFLAGS="-L$CONAN_LIB_DIRS -luni-algo"

# If CXX is not set by Conan, find a default system compiler
if [ -z "$CXX" ]; then
    if command -v clang++ &> /dev/null; then
        echo "CXX not set, defaulting to system clang++"
        export CXX="clang++"
    elif command -v g++ &> /dev/null; then
        echo "CXX not set, defaulting to system g++"
        export CXX="g++"
    else
        echo "ERROR: No suitable compiler (g++/clang++) found."
        exit 1
    fi
fi

echo "Building with: $CXX"
echo "Include directories: -I\"$CONAN_INCLUDE_DIRS\""
echo "Library flags: $LDFLAGS"

# Build simple_test
echo "Building simple_test..."
$CXX -std=c++17 $CXXFLAGS -I"$CONAN_INCLUDE_DIRS" ../../shared/src/simple_test.cpp -o simple_test $LDFLAGS

# Build unicode_example
echo "Building unicode_example..."
$CXX -std=c++17 $CXXFLAGS -I"$CONAN_INCLUDE_DIRS" ../../shared/src/unicode_example.cpp -o unicode_example $LDFLAGS

echo ""
echo "=== Build Complete ==="
echo "Run the examples:"
if [[ "$OS" == "Windows_NT" ]] || [[ -f "simple_test.exe" ]]; then
    echo "  ./simple_test.exe"
    echo "  ./unicode_example.exe"
else
    echo "  ./simple_test"
    echo "  ./unicode_example"
fi
