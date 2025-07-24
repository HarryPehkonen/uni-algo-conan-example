cmake_minimum_required(VERSION 3.15)
project(uni_algo_conan_examples)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the uni-algo package via Conan
find_package(uni-algo REQUIRED)

# Enable testing
enable_testing()

# Add all scenario subdirectories
add_subdirectory(scenarios/01-header-only)
add_subdirectory(scenarios/02-static-library)
add_subdirectory(scenarios/03-shared-library)

# Create a custom target to build all scenarios
add_custom_target(all_scenarios
    DEPENDS 
        header_only_simple_test 
        header_only_unicode_example_headeronly
        static_simple_test 
        static_unicode_example
        shared_simple_test 
        shared_unicode_example
)

# Print summary
message(STATUS "=== uni-algo Conan Examples Configuration ===")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "uni-algo Found: ${uni-algo_FOUND}")
message(STATUS "Scenarios configured:")
message(STATUS "  - Header-only (scenarios/01-header-only)")
message(STATUS "  - Static library (scenarios/02-static-library)")  
message(STATUS "  - Shared library (scenarios/03-shared-library)")
message(STATUS "==============================================")