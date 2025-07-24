# Shared Library Configuration

This scenario demonstrates using uni-algo as a shared library (.so/.dll) - linked at runtime.

> **   Windows Note**: This scenario only works on Linux and macOS. The uni-algo library cannot be built as a shared library (DLL) with MSVC due to template design and symbol export limitations. Use the [static library](../02-static-library/) or [header-only](../01-header-only/) configurations on Windows.

## Benefits
- **Smaller executable**: Library code is separate from your program
- **Code sharing**: Multiple programs can share the same library
- **Memory efficiency**: Library loaded once in memory, shared by processes
- **Easy updates**: Update library without rebuilding applications

## Trade-offs
- **Runtime dependency**: Requires `.so` file to be available when running
- **Path management**: Need to set `LD_LIBRARY_PATH` or install libraries system-wide
- **Version compatibility**: Need to ensure library versions match expectations
- **Deployment complexity**: Must distribute library files with application
- **Platform limitation**: Not supported on Windows with MSVC

## Build Methods

### Method 1: CMake (Recommended)

```bash
# Install dependencies
conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=True" --build=missing

# Build with CMake
cmake --preset conan-release
cmake --build . --config Release

# Run examples (CMake handles the library path automatically)
ctest --preset conan-release  # or run directly with proper LD_LIBRARY_PATH
```

### Method 2: Direct g++ Build

```bash
# Use the build script (handles path finding automatically)
./build.sh

# Run with helper script
./run.sh unicode_example
./run.sh simple_test

# Or manually (all examples work with shared library):
conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=True" --build=missing

# Find uni-algo library paths
UNI_ALGO_INCLUDE_DIR=$(echo ~/.conan2/p/uni-*/p/include)
UNI_ALGO_LIB_DIR=$(dirname $(find ~/.conan2 -name "libuni-algo.so*" -type f | head -1))

# All of these work (unlike header-only scenario):
g++ -std=c++17 -I${UNI_ALGO_INCLUDE_DIR} ../../shared/src/unicode_example.cpp -L${UNI_ALGO_LIB_DIR} -luni-algo -o unicode_example
g++ -std=c++17 -I${UNI_ALGO_INCLUDE_DIR} ../../shared/src/simple_test.cpp -L${UNI_ALGO_LIB_DIR} -luni-algo -o simple_test

# Remember to set library path when running:
LD_LIBRARY_PATH=${UNI_ALGO_LIB_DIR}:$LD_LIBRARY_PATH ./unicode_example
LD_LIBRARY_PATH=${UNI_ALGO_LIB_DIR}:$LD_LIBRARY_PATH ./simple_test
```

## Key Points

- **Include + Link + Runtime**: Needs `-I`, `-L -luni-algo`, and `LD_LIBRARY_PATH`
- **Build vs Runtime**: Library needed at build time AND runtime
- **Path setup**: Must set library path before running executable
- **Shared dependency**: `libuni-algo.so` must be findable by the loader

## Verification

Check that the executable depends on the shared library:
```bash
ldd ./unicode_example
# Should show libuni-algo.so in the output
```

Check library path resolution:
```bash
# This will fail if library path is not set:
./unicode_example

# This should work:
LD_LIBRARY_PATH=~/.conan2/p/b/uni-*/p/lib:$LD_LIBRARY_PATH ./unicode_example
```

## Runtime Helper

Use the included `run.sh` script to automatically set up the library path:
```bash
./run.sh unicode_example
./run.sh simple_test
```

## Expected Output

The `unicode_example` program will demonstrate Unicode whitespace trimming, showing the difference between standard C++ string operations and uni-algo's Unicode-aware processing.

The `simple_test` program will confirm that uni-algo shared library linking is working correctly.
