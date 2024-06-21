cmake_minimum_required(VERSION 3.5)

find_package(Assertion REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

section("fatal error assertions")
  function(throw_fatal_error MESSAGE)
    message(FATAL_ERROR "${MESSAGE}")
  endfunction()

  assert_fatal_error(
    CALL throw_fatal_error "some fatal error message"
    MESSAGE "some fatal error message")

  macro(assert_fail)
    assert_fatal_error(
      CALL throw_fatal_error "some fatal error message"
      MESSAGE "some other fatal error message")
  endmacro()

  assert_fatal_error(
    CALL assert_fail
    MESSAGE "expected fatal error message:\n"
      "  some fatal error message\n"
      "to be equal to:\n"
      "  some other fatal error message")
endsection()

section("mocked message check")
  message("some unspecified message")
  message(STATUS "some status message")
  message(STATUS "some status message" " with additional information")
endsection()
