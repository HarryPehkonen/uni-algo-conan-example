#!/bin/bash

# Helper script to find Conan-installed uni-algo paths
# Run this after 'conan install' to get the correct paths for g++

echo "=== Finding uni-algo Conan installation paths ==="

# Find header path (works for all configurations)
HEADER_PATH=$(find ~/.conan2 -path "*/p/include/uni_algo" -type d 2>/dev/null | head -1)
if [ -n "$HEADER_PATH" ]; then
    INCLUDE_DIR=$(dirname "$HEADER_PATH")
    echo "Include path: -I$INCLUDE_DIR"
else
    echo "ERROR: uni-algo headers not found. Run 'conan install' first."
    exit 1
fi

# Find library paths
STATIC_LIB=$(find ~/.conan2 -path "*/p/lib/libuni-algo.a" 2>/dev/null | head -1)
SHARED_LIB=$(find ~/.conan2 -path "*/p/lib/libuni-algo.so*" 2>/dev/null | head -1)

if [ -n "$STATIC_LIB" ]; then
    LIB_DIR=$(dirname "$STATIC_LIB")
    echo "Static library: -L$LIB_DIR -luni-algo"
fi

if [ -n "$SHARED_LIB" ]; then
    LIB_DIR=$(dirname "$SHARED_LIB")
    echo "Shared library: -L$LIB_DIR -luni-algo"
    echo "Runtime path: LD_LIBRARY_PATH=$LIB_DIR:\$LD_LIBRARY_PATH"
fi

echo ""
echo "=== Complete g++ command examples ==="

# Header-only
echo "Header-only:"
echo "g++ -std=c++17 -I$INCLUDE_DIR shared/src/unicode_example.cpp -o program"

# Static library
if [ -n "$STATIC_LIB" ]; then
    STATIC_LIB_DIR=$(dirname "$STATIC_LIB")
    echo ""
    echo "Static library:"
    echo "g++ -std=c++17 -I$INCLUDE_DIR shared/src/unicode_example.cpp -L$STATIC_LIB_DIR -luni-algo -o program"
fi

# Shared library  
if [ -n "$SHARED_LIB" ]; then
    SHARED_LIB_DIR=$(dirname "$SHARED_LIB")
    echo ""
    echo "Shared library:"
    echo "g++ -std=c++17 -I$INCLUDE_DIR shared/src/unicode_example.cpp -L$SHARED_LIB_DIR -luni-algo -o program"
    echo "LD_LIBRARY_PATH=$SHARED_LIB_DIR:\$LD_LIBRARY_PATH ./program"
fi