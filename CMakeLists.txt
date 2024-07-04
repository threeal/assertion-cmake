cmake_minimum_required(VERSION 3.21)

project(
  Assertion
  VERSION 0.3.0
  DESCRIPTION "A collection of assertion functions for testing purposes"
  HOMEPAGE_URL https://github.com/threeal/assertion-cmake
  LANGUAGES NONE)

option(ASSERT_ENABLE_TESTS "Enable test targets.")
option(ASSERT_ENABLE_INSTALL "Enable install targets." ${PROJECT_IS_TOP_LEVEL})

include(cmake/Assertion.cmake)

if(ASSERT_ENABLE_TESTS)
  enable_testing()

  assertion_add_test(
    test/include.cmake NAME "inclusion of other modules")

  assertion_add_test(test/assertion_add_test.cmake NAME "test creation")
  assertion_add_test(test/fail.cmake NAME "failure invocation")
  assertion_add_test(test/assert.cmake NAME "condition assertions")
  assertion_add_test(test/assert_fatal_error.cmake NAME "fatal error assertions")

  assertion_add_test(
    test/assert_execute_process.cmake NAME "execute process assertions")
endif()

if(ASSERT_ENABLE_INSTALL)
  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    AssertionConfigVersion.cmake COMPATIBILITY SameMajorVersion)

  install(
    FILES cmake/Assertion.cmake
      cmake/AssertionConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/AssertionConfigVersion.cmake
    DESTINATION lib/cmake/Assertion)
endif()
