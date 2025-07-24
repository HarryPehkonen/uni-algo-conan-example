# Shared Library Scenario
# Note: uni-algo package is found by parent CMakeLists.txt

# Create executables with unique names for unified build
add_executable(shared_unicode_example ../../shared/src/unicode_example.cpp)
add_executable(shared_simple_test ../../shared/src/simple_test.cpp)

# Link against uni-algo (shared library mode)
target_link_libraries(shared_unicode_example uni-algo::uni-algo)
target_link_libraries(shared_simple_test uni-algo::uni-algo)

# Add tests for this scenario
add_test(NAME shared_simple_test COMMAND shared_simple_test)
add_test(NAME shared_unicode_example COMMAND shared_unicode_example)

# Set output names to match shell script expectations (for backward compatibility)
set_target_properties(shared_simple_test PROPERTIES OUTPUT_NAME simple_test)
set_target_properties(shared_unicode_example PROPERTIES OUTPUT_NAME unicode_example)