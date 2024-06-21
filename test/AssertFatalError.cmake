cmake_minimum_required(VERSION 3.5)

find_package(Assertion REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

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

string(
  JOIN "\n" EXPECTED_MESSAGE
  "expected fatal error message:\n  some fatal error message"
  "to be equal to:\n  some other fatal error message")
assert_fatal_error(CALL assert_fail MESSAGE "${EXPECTED_MESSAGE}")
