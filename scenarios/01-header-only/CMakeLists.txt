# Header-Only Scenario
cmake_minimum_required(VERSION 3.15)
project(HeaderOnlyScenario)

# Find uni-algo package (no-op if already found by parent)
find_package(uni-algo REQUIRED)

# Create executables with unique names for unified build
add_executable(header_only_unicode_example_headeronly ../../shared/src/unicode_example_headeronly.cpp)
add_executable(header_only_simple_test ../../shared/src/simple_test.cpp)

# Link against uni-algo (header-only mode)
target_link_libraries(header_only_unicode_example_headeronly uni-algo::uni-algo)
target_link_libraries(header_only_simple_test uni-algo::uni-algo)

# Add compile definition to indicate header-only build
target_compile_definitions(header_only_unicode_example_headeronly PRIVATE UNI_ALGO_HEADER_ONLY)
target_compile_definitions(header_only_simple_test PRIVATE UNI_ALGO_HEADER_ONLY)

# Add tests for this scenario
add_test(NAME header_only_simple_test COMMAND header_only_simple_test)
add_test(NAME header_only_unicode_example COMMAND header_only_unicode_example_headeronly)

# Set output names to match shell script expectations (for backward compatibility)
set_target_properties(header_only_simple_test PROPERTIES OUTPUT_NAME simple_test)
set_target_properties(header_only_unicode_example_headeronly PROPERTIES OUTPUT_NAME unicode_example_headeronly)
