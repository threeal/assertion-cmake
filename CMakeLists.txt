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
    "inclusion of other modules" test/IncludeOtherModules.cmake)

  assertion_add_test("test creation" test/TestCreation.cmake)
  assertion_add_test("failure invocation" test/Fail.cmake)
  assertion_add_test("condition assertions" test/Assert.cmake)
  assertion_add_test("fatal error assertions" test/AssertFatalError.cmake)

  assertion_add_test(
    "execute process assertions" test/AssertExecuteProcess.cmake)

  assertion_add_test("section creation" test/SectionCreation.cmake)
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
