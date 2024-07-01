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

  add_test(
    NAME "inclusion of other modules"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/test/IncludeOtherModules.cmake)

  add_test(
    NAME "condition assertions"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/test/Assert.cmake)

  add_test(
    NAME "fatal error assertions"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/test/AssertFatalError.cmake)

  add_test(
    NAME "execute process assertions"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/test/AssertExecuteProcess.cmake)

  add_test(
    NAME "internal assertion message formatting"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/test/InternalFormatMessage.cmake)

  add_test(
    NAME "section creation"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/test/SectionCreation.cmake)
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
