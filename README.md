# uni-algo Conan Examples

[![Cross-Platform Build and Test](https://github.com/HarryPehkonen/uni-algo-conan-example/actions/workflows/unified-build.yml/badge.svg)](https://github.com/HarryPehkonen/uni-algo-conan-example/actions/workflows/unified-build.yml)

This repository demonstrates how to use the [uni-algo](https://github.com/uni-algo/uni-algo) Unicode library via Conan package manager in three different configurations: **header-only**, **static library**, and **shared library**.

## Overview

Each scenario is self-contained with its own build files, making it easy to:
- Compare different library configurations side-by-side
- Copy a specific scenario to your own project  
- Understand the trade-offs between approaches
- Learn both CMake and direct g++ build methods

## Quick Start

1. **Set up environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install conan
   conan profile detect --force
   ```

2. **Choose a scenario** and navigate to its directory:
   ```bash
   cd scenarios/01-header-only    # or 02-static-library or 03-shared-library
   ```

3. **Build and run:**
   ```bash
   ./build.sh                     # Uses g++ directly
   ./simple_test                  # Run the test program
   ```

## Scenarios

### [  Header-Only](scenarios/01-header-only/) 
**Simplest deployment - everything compiled into your executable**

-   **Pros**: Easy deployment, no runtime dependencies, single executable file
-   **Cons**: Larger executable, slower compilation, **limited features**
-   **Limitation**: Advanced Unicode features still require compiled library data
-   **Best for**: Basic string operations, simple Unicode conversion

```bash
cd scenarios/01-header-only
./build.sh && ./simple_test  # simple_test works, unicode_example may not
```

### [  Static Library](scenarios/02-static-library/)
**Pre-compiled library linked at build time**

-   **Pros**: Faster compilation, self-contained executable, no runtime dependencies  
-   **Cons**: Larger executable, need library files at build time
-   **Best for**: Applications where runtime dependencies are problematic

```bash
cd scenarios/02-static-library  
./build.sh && ./simple_test
```

### [  Shared Library](scenarios/03-shared-library/)
**Dynamic library loaded at runtime**

-   **Pros**: Smaller executable, code sharing, memory efficiency, easy updates
-   **Cons**: Runtime dependency, need library path setup, deployment complexity
-   **Platform**: **Linux/macOS only** - Windows/MSVC not supported due to library limitations
-   **Best for**: Large applications, multiple programs sharing the library

```bash
cd scenarios/03-shared-library
./build.sh && ./run.sh simple_test
```

> **   Windows Limitation**: The uni-algo library cannot be built as a shared library (DLL) with MSVC due to template design and symbol export limitations. Use static library or header-only configurations on Windows.

## Comparison Table

| Aspect | Header-Only | Static Library | Shared Library |
|--------|-------------|----------------|----------------|
| **Executable Size** | Large | Large | Small |
| **Runtime Dependencies** | None | None | libuni-algo.so |
| **Compilation Speed** | Slow | Fast | Fast |
| **Memory Usage** | Per-process | Per-process | Shared |
| **Deployment** | Single file | Single file | Multiple files |
| **Updates** | Rebuild required | Rebuild required | Library replacement |
| **Windows Support** |   Full |   Full |   Not supported |

## Project Structure

```
uni-algo-conan-example/
├── README.md                          # This overview
├── shared/src/                        # Shared source code
│   ├── unicode_example.cpp            # Full Unicode demonstration
│   └── simple_test.cpp               # Basic functionality test
├── scenarios/                         # Self-contained examples
│   ├── 01-header-only/               # Header-only configuration
│   ├── 02-static-library/            # Static library configuration  
│   └── 03-shared-library/            # Shared library configuration
└── tools/                            # Helper utilities
    ├── find_conan_paths.sh           # Find Conan installation paths
    ├── clean_all.sh                  # Clean all build artifacts
    └── test_all.sh                   # Test all scenarios
```

## Build Methods

This project supports multiple build approaches:

### Unified CMake Build (Recommended)
Build all scenarios from the root directory:

```bash
# All from the root directory of the project

# Header-only configuration
conan install . -o "uni-algo/*:header_only=True" --build=missing
cmake --preset conan-default
cmake --build . --target header_only_simple_test header_only_unicode_example_headeronly

# Static library configuration  
conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=False" --build=missing
cmake --preset conan-default
cmake --build . --target static_simple_test static_unicode_example

# Shared library configuration (Linux/macOS only)
conan install . -o "uni-algo/*:header_only=False" -o "uni-algo/*:shared=True" --build=missing
cmake --preset conan-default
cmake --build . --target shared_simple_test shared_unicode_example

# Or build all scenarios at once (uses default: static library)
conan install . --build=missing
cmake --preset conan-default
cmake --build .

# Run tests for all scenarios
ctest --verbose
```

### Individual Scenario Build
Each scenario can still be built independently (run from within the scenario directory):

#### CMake
```bash
# From within a scenario directory (e.g., scenarios/01-header-only/)
conan install . --build=missing
cmake --preset conan-default  
cmake --build . --config Release
```

#### Direct g++/clang++ 
```bash
./build.sh                    # Automated compiler build
# or manually with paths from:
../tools/find_conan_paths.sh  # Shows exact compiler commands
```

## Example Output

Both programs demonstrate Unicode text processing:

- **`unicode_example`**: Shows Unicode-aware whitespace trimming vs standard C++ string operations
- **`simple_test`**: Confirms uni-algo is working correctly

The programs demonstrate why standard C++ fails with Unicode characters like non-breaking spaces (U+00A0), em spaces (U+2003), and ideographic spaces (U+3000), while uni-algo handles them correctly.

## Helper Tools

- **`tools/find_conan_paths.sh`**: Find Conan installation paths for manual g++ builds
- **`tools/clean_all.sh`**: Clean build artifacts from all scenarios  
- **`tools/test_all.sh`**: Build and test all scenarios automatically

## Limited Features in Header-Only

The limitation in features is confirmed by the official uni-algo documentation. From the official README at `/home/harri/.conan2/p/uni-*/s/src/README.md`:

> **"System locale functions are not available if the library is configured to use static data (UNI_ALGO_STATIC_DATA) or if the library is compiled in header-only mode."**

The `UNI_ALGO_STATIC_DATA` configuration (automatically enabled in header-only mode) specifically excludes:
- Unicode property functions (`is_whitespace`, `is_alphabetic`, etc.)
- Case conversion functions (`to_uppercase`, `to_lowercase`)  
- Locale-aware operations (`una::locale::system()`)
- Advanced normalization requiring Unicode data tables

This explains the linker errors we document:
```
undefined reference to `una::detail::stage1_prop'
undefined reference to `una::detail::stage2_prop'  
```

You can find this documentation in your own Conan installation at:
`~/.conan2/p/uni-*/s/src/README.md` and `~/.conan2/p/uni-*/s/src/include/uni_algo/locale.h`

## Unified vs Individual Builds

### Unified Build Advantages:
-   **Cross-platform**: Single CMake configuration works on Linux, macOS, and Windows
-   **No path issues**: Conan + CMake handles all library paths automatically
-   **Faster CI**: GitHub Actions builds all scenarios efficiently
-   **Testing**: Integrated CTest support for automated testing
-   **IDE support**: Better IntelliSense and debugging experience

### Individual Build Advantages:
-   **Educational**: Clear separation shows each scenario's specific requirements
-   **Lightweight**: Only build what you need
-   **Flexible**: Easy to copy individual scenarios to your project

## Platform Support

**Automatically tested via GitHub Actions on:**
- Linux (Ubuntu latest) with GCC - all scenarios
- macOS (latest) with Clang - all scenarios
- Windows (latest) with MSVC - header-only and static library only

**Locally tested on:**
- Linux (Debian-based, GCC 12.2.0)

Both unified and individual builds are tested on all platforms. The unified CMake approach provides the most reliable cross-platform experience. Check the [Actions tab](../../actions) for the latest test results.

## Getting Help

Each scenario has its own detailed README with:
- Step-by-step instructions
- Troubleshooting tips
- Trade-off explanations
- Platform-specific notes

Start with the [header-only scenario](scenarios/01-header-only/) for the simplest introduction to uni-algo.
