# Static Library Configuration

This scenario demonstrates using uni-algo as a static library - linked at build time into your executable.

## Benefits
- **Self-contained executable**: No runtime library dependencies
- **Faster compilation**: Pre-compiled library code, no header recompilation
- **Predictable deployment**: Single executable file contains everything
- **No version conflicts**: uni-algo version is embedded in your binary

## Trade-offs
- **Larger executable**: Library code is embedded in the binary
- **Build-time linking**: Requires library files at build time
- **Update complexity**: Need to rebuild to update uni-algo version

## Build Methods

### Method 1: CMake (Recommended)

```bash
# Install dependencies
conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=False" --build=missing

# Build with CMake
cmake --preset conan-release
cmake --build . --config Release

# Run examples
./unicode_example
./simple_test
```

### Method 2: Direct g++ Build

```bash
# Use the build script (handles path finding automatically)
./build.sh

# Or manually (all examples work with static library):
conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=False" --build=missing

# Find uni-algo library paths
UNI_ALGO_INCLUDE_DIR=$(echo ~/.conan2/p/uni-*/p/include)
UNI_ALGO_LIB_DIR=$(dirname $(find ~/.conan2 -name "libuni-algo.a" -type f | head -1))

# All of these work (unlike header-only scenario):
g++ -std=c++17 -I${UNI_ALGO_INCLUDE_DIR} ../../shared/src/unicode_example.cpp -L${UNI_ALGO_LIB_DIR} -luni-algo -o unicode_example
g++ -std=c++17 -I${UNI_ALGO_INCLUDE_DIR} ../../shared/src/simple_test.cpp -L${UNI_ALGO_LIB_DIR} -luni-algo -o simple_test
```

## Key Points

- **Include + Link**: Needs both `-I` for headers and `-L -luni-algo` for library
- **Build-time dependency**: Requires `libuni-algo.a` file during compilation
- **No runtime setup**: Executable runs anywhere without library path setup
- **Single executable**: Everything embedded, no separate library files needed

## Verification

Check that the executable doesn't depend on shared libraries:
```bash
ldd ./unicode_example
# Should NOT show libuni-algo.so in the output
```

## Expected Output

The `unicode_example` program will demonstrate Unicode whitespace trimming, showing the difference between standard C++ string operations and uni-algo's Unicode-aware processing.

The `simple_test` program will confirm that uni-algo static library linking is working correctly.
