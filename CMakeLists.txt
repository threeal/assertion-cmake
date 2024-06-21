cmake_minimum_required(VERSION 3.21)

project(
  Assertion
  VERSION 0.3.0
  DESCRIPTION "A collection of assertion functions for testing purposes"
  HOMEPAGE_URL https://github.com/threeal/assertion-cmake
  LANGUAGES NONE
)

include(cmake/Assertion.cmake)

if(PROJECT_IS_TOP_LEVEL)
  if(BUILD_TESTING)
    enable_testing()

    add_test(
      NAME "condition assertions"
      COMMAND "${CMAKE_COMMAND}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/test/Assert.cmake)

    add_test(
      NAME "fatal error assertions"
      COMMAND "${CMAKE_COMMAND}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/test/AssertFatalError.cmake)

    add_test(
      NAME "execute process assertions"
      COMMAND "${CMAKE_COMMAND}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/test/AssertExecuteProcess.cmake)

    add_test(
      NAME "internal assertion message formatting"
      COMMAND "${CMAKE_COMMAND}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/test/InternalFormatMessage.cmake)
  endif()

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    AssertionConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
  )

  install(
    FILES
      cmake/Assertion.cmake
      cmake/AssertionConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/AssertionConfigVersion.cmake
    DESTINATION lib/cmake/Assertion
  )
endif()
