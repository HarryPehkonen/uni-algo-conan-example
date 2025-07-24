# Static Library Scenario
cmake_minimum_required(VERSION 3.15)
project(StaticScenario)

# Mark toolchain file as used to avoid warning
if(CMAKE_TOOLCHAIN_FILE)
    message(STATUS "Ignoring toolchain: ${CMAKE_TOOLCHAIN_FILE}")
endif()

# Find uni-algo package (no-op if already found by parent)
find_package(uni-algo REQUIRED)

# Create executables with unique names for unified build
add_executable(static_unicode_example ../../shared/src/unicode_example.cpp)
add_executable(static_simple_test ../../shared/src/simple_test.cpp)

# Link against uni-algo (static library mode)
target_link_libraries(static_unicode_example uni-algo::uni-algo)
target_link_libraries(static_simple_test uni-algo::uni-algo)

# Add tests for this scenario
add_test(NAME static_simple_test COMMAND static_simple_test)
add_test(NAME static_unicode_example COMMAND static_unicode_example)

# Set output names to match shell script expectations (for backward compatibility)
set_target_properties(static_simple_test PROPERTIES OUTPUT_NAME simple_test)
set_target_properties(static_unicode_example PROPERTIES OUTPUT_NAME unicode_example)
