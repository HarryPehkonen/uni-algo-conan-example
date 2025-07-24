#!/bin/bash

# Helper script to find Conan-installed uni-algo paths
# Run this after 'conan install' to get the correct paths for g++

echo "=== Finding uni-algo Conan installation paths ==="

# Find header path (works for all configurations) 
UNI_ALGO_INCLUDE_DIR=$(echo ~/.conan2/p/uni-*/p/include)
if [ -d "$UNI_ALGO_INCLUDE_DIR" ]; then
    echo "Include directory found: $UNI_ALGO_INCLUDE_DIR"
    echo "Variable: UNI_ALGO_INCLUDE_DIR=$UNI_ALGO_INCLUDE_DIR"
else
    echo "ERROR: uni-algo headers not found. Run 'conan install' first."
    exit 1
fi

# Find library paths using reliable file-based search
STATIC_LIB=$(find ~/.conan2 -name "libuni-algo.a" -type f 2>/dev/null | head -1)
SHARED_LIB=$(find ~/.conan2 -name "libuni-algo.so*" -type f 2>/dev/null | head -1)

echo ""
echo "=== Library Detection ==="

if [ -n "$STATIC_LIB" ]; then
    STATIC_LIB_DIR=$(dirname "$STATIC_LIB")
    echo "Static library found: $STATIC_LIB"
    echo "Variable: UNI_ALGO_LIB_DIR=\$(dirname \$(find ~/.conan2 -name \"libuni-algo.a\" -type f | head -1))"
    echo "Resolved: UNI_ALGO_LIB_DIR=$STATIC_LIB_DIR"
fi

if [ -n "$SHARED_LIB" ]; then
    SHARED_LIB_DIR=$(dirname "$SHARED_LIB")
    echo "Shared library found: $SHARED_LIB"
    echo "Variable: UNI_ALGO_LIB_DIR=\$(dirname \$(find ~/.conan2 -name \"libuni-algo.so*\" -type f | head -1))"
    echo "Resolved: UNI_ALGO_LIB_DIR=$SHARED_LIB_DIR"
fi

echo ""
echo "=== Complete g++ command examples ==="

# Header-only
echo "Header-only (from scenarios/01-header-only/):"
echo "UNI_ALGO_INCLUDE_DIR=\$(echo ~/.conan2/p/uni-*/p/include)"
echo ""
echo "# Works:"
echo "g++ -std=c++17 -DUNI_ALGO_HEADER_ONLY -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/simple_test.cpp -o simple_test"
echo "g++ -std=c++17 -DUNI_ALGO_HEADER_ONLY -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/unicode_example_headeronly.cpp -o unicode_example_headeronly"
echo ""
echo "# Won't work (requires compiled Unicode data):"
echo "# g++ -std=c++17 -DUNI_ALGO_HEADER_ONLY -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/unicode_example.cpp -o unicode_example"

# Static library
if [ -n "$STATIC_LIB" ]; then
    echo ""
    echo "Static library (from scenarios/02-static-library/):"
    echo "UNI_ALGO_INCLUDE_DIR=\$(echo ~/.conan2/p/uni-*/p/include)"
    echo "UNI_ALGO_LIB_DIR=\$(dirname \$(find ~/.conan2 -name \"libuni-algo.a\" -type f | head -1))"
    echo ""
    echo "# All work:"
    echo "g++ -std=c++17 -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/unicode_example.cpp -L\${UNI_ALGO_LIB_DIR} -luni-algo -o unicode_example"
    echo "g++ -std=c++17 -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/simple_test.cpp -L\${UNI_ALGO_LIB_DIR} -luni-algo -o simple_test"
fi

# Shared library  
if [ -n "$SHARED_LIB" ]; then
    echo ""
    echo "Shared library (from scenarios/03-shared-library/):"
    echo "UNI_ALGO_INCLUDE_DIR=\$(echo ~/.conan2/p/uni-*/p/include)"
    echo "UNI_ALGO_LIB_DIR=\$(dirname \$(find ~/.conan2 -name \"libuni-algo.so*\" -type f | head -1))"
    echo ""
    echo "# All work:"
    echo "g++ -std=c++17 -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/unicode_example.cpp -L\${UNI_ALGO_LIB_DIR} -luni-algo -o unicode_example"
    echo "g++ -std=c++17 -I\${UNI_ALGO_INCLUDE_DIR} ../../shared/src/simple_test.cpp -L\${UNI_ALGO_LIB_DIR} -luni-algo -o simple_test"
    echo ""
    echo "# Runtime (set library path):"
    echo "LD_LIBRARY_PATH=\${UNI_ALGO_LIB_DIR}:\$LD_LIBRARY_PATH ./unicode_example"
    echo "LD_LIBRARY_PATH=\${UNI_ALGO_LIB_DIR}:\$LD_LIBRARY_PATH ./simple_test"
fi

echo ""
echo "=== Usage Notes ==="
echo "• Copy the variable assignments and g++ commands to use manually"
echo "• Commands assume you're in the appropriate scenario directory"  
echo "• Header-only mode has limitations - some files won't compile"
echo "• Static/shared libraries support all uni-algo features"