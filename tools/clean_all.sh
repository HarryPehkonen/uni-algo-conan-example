#!/bin/bash

# Clean all build artifacts from all scenarios

echo "=== Cleaning all scenarios ==="

SCENARIOS=("01-header-only" "02-static-library" "03-shared-library" "04-makefile-example")

for scenario in "${SCENARIOS[@]}"; do
    if [ -d "scenarios/$scenario" ]; then
        echo "Cleaning scenarios/$scenario..."
        cd "scenarios/$scenario"
        
        # Remove CMake artifacts
        rm -rf CMakeCache.txt CMakeFiles/ cmake_install.cmake Makefile
        rm -rf *.cmake conanbuild.sh conanrun.sh conanbuildenv-*.sh conanrunenv-*.sh
        rm -rf deactivate_conan*.sh CMakePresets.json
        
        # Remove executables
        rm -f unicode_example simple_test program
        
        echo "  Cleaned scenarios/$scenario"
        cd - > /dev/null
    fi
done

# Clean root directory
echo "Cleaning root directory..."
rm -rf CMakeCache.txt CMakeFiles/ cmake_install.cmake Makefile
rm -rf *.cmake conanbuild.sh conanrun.sh conanbuildenv-*.sh conanrunenv-*.sh
rm -rf deactivate_conan*.sh CMakePresets.json
rm -f simple_test* test_final unicode_example

echo ""
echo "=== All scenarios cleaned ==="
echo "Note: This preserves source files and scenario configurations."
echo "To rebuild, run the build scripts in each scenario directory."