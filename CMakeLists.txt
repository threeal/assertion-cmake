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

  add_cmake_script_test(test/test_add_test.cmake)
  add_cmake_script_test(test/test_assert_call.cmake)
  add_cmake_script_test(test/test_assert_process.cmake)
  add_cmake_script_test(test/test_assert.cmake)
  add_cmake_script_test(test/test_fail.cmake)
endif()

if(ASSERTION_ENABLE_INSTALL)
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/cmake/AssertionConfig.cmake
    "include(\${CMAKE_CURRENT_LIST_DIR}/Assertion.cmake)\n")

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(cmake/AssertionConfigVersion.cmake
    COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)

  install(
    FILES cmake/Assertion.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/AssertionConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/AssertionConfigVersion.cmake
    DESTINATION lib/cmake/Assertion)

  set(CPACK_SYSTEM_NAME any)
  include(CPack)
endif()
