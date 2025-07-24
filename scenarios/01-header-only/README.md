# Header-Only Configuration

This scenario demonstrates using uni-algo as a header-only library - the simplest deployment method.

## Benefits
- **Easy deployment**: No need to manage separate library files
- **No runtime dependencies**: Everything compiled into your executable
- **Simple build**: Just add include paths, no linking required

## Trade-offs
- **Larger executable**: All uni-algo code is included in your binary
- **Slower compilation**: Headers are recompiled for each source file
- **Template instantiation**: May increase compile times for large projects

## Build Methods

### Method 1: CMake (Recommended)

```bash
# Install dependencies
conan install . -o "uni-algo/*:header_only=True" --build=missing

# Build with CMake
cmake --preset conan-debug
cmake --build . --config Debug

# Run examples
./unicode_example
./simple_test
```

### Method 2: Direct g++ Build

```bash
# Use the build script (handles path finding automatically)
./build.sh

# Or manually:
conan install . -o "uni-algo/*:header_only=True" --build=missing
g++ -std=c++17 -DUNI_ALGO_HEADER_ONLY -I~/.conan2/p/uni-*/p/include ../../shared/src/unicode_example.cpp -o unicode_example
g++ -std=c++17 -DUNI_ALGO_HEADER_ONLY -I~/.conan2/p/uni-*/p/include ../../shared/src/simple_test.cpp -o simple_test
```

## Key Points

- **No linking**: Only include paths needed, no `-l` flags
- **Single dependency**: Just the `conanfile.txt` and source code
- **Portable**: Executable runs anywhere without library dependencies
- **Build definition**: `-DUNI_ALGO_HEADER_ONLY` preprocessor define used in source

## Expected Output

Both programs demonstrate what works in true header-only mode:

- **`simple_test`**: Basic functionality confirmation
- **`unicode_example_headeronly`**: UTF conversions, range views, basic case conversion

## Critical Limitation: Unicode Property Functions

**Important**: While uni-algo advertises "header-only" support, Unicode property functions like:
- `una::codepoint::is_whitespace()`
- `una::codepoint::prop{}.White_Space()`
- Advanced normalization operations

...require compiled Unicode data tables and will cause **linker errors** in header-only mode:

```
undefined reference to `una::detail::stage1_prop'
undefined reference to `una::detail::stage2_prop'
```

## What Actually Works Header-Only

  **Available features:**
- UTF-8/16/32 conversions (`una::utf8to16`, `una::utf16to8`, etc.)
- Range views (`una::views::utf8`, `una::views::utf16`)
- Basic case conversion for ASCII (`una::cases::to_uppercase_utf8`)
- Code point iteration

✗ **Requires compiled library:**
- Unicode property checking (`is_whitespace`, `is_alphabetic`, etc.)
- Locale-aware case conversion
- Advanced normalization (NFC, NFD, NFKC, NFKD)
- Script detection
- Word/sentence breaking

This limitation appears to be a fundamental design choice in uni-algo - the "header-only" mode only includes conversion functions, not the full Unicode database.
