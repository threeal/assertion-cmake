cmake_minimum_required(VERSION 3.24)

project(
  Assertion
  VERSION 2.0.0
  DESCRIPTION "A collection of assertion functions and other utilities for testing CMake code"
  HOMEPAGE_URL https://github.com/threeal/assertion-cmake
  LANGUAGES NONE)

option(ASSERTION_ENABLE_TESTS "Enable test targets.")
option(ASSERTION_ENABLE_INSTALL "Enable install targets." "${PROJECT_IS_TOP_LEVEL}")

include(cmake/Assertion.cmake)

if(ASSERTION_ENABLE_TESTS)
  enable_testing()

  add_cmake_script_test(test/add_cmake_script_test.cmake)
  add_cmake_script_test(test/assert_execute_process.cmake)
  add_cmake_script_test(test/assert_fatal_error.cmake)
  add_cmake_script_test(test/assert.cmake)
  add_cmake_script_test(test/fail.cmake)
endif()

if(ASSERTION_ENABLE_INSTALL)
  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(cmake/AssertionConfigVersion.cmake
    COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)

  install(
    FILES cmake/Assertion.cmake
      cmake/AssertionConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/AssertionConfigVersion.cmake
    DESTINATION lib/cmake/Assertion)
endif()
