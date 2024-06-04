cmake_minimum_required(VERSION 3.5)

include(Assertion)

function(call_sample_messages)
  message(WARNING "some warning message")
  message(WARNING "some other warning message")
  message(ERROR "some error message")
  message(FATAL_ERROR "some fatal error message")
  message(ERROR "some other error message")
endfunction()

function("Fatal error assertions")
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
    "expected fatal error message:"
    "  some fatal error message"
    "to be equal to:"
    "  some other fatal error message")
  assert_fatal_error(CALL assert_fail MESSAGE "${EXPECTED_MESSAGE}")
endfunction()

function("Process execution assertions")
  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E true)
  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E false ERROR .*)

  assert_fatal_error(
    CALL assert_execute_process COMMAND "${CMAKE_COMMAND}" -E true ERROR .*
    MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E true\nto fail")

  assert_fatal_error(
    CALL assert_execute_process COMMAND "${CMAKE_COMMAND}" -E false
    MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E false\nnot to fail")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
    OUTPUT "Hello.*!")

  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected the output:"
    "  Hello world!"
    "of command:"
    "  ${CMAKE_COMMAND} -E echo Hello world!"
    "to match:"
    "  Hi.*!")
  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      OUTPUT "Hi.*!"
    MESSAGE "${EXPECTED_MESSAGE}")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E touch /
    ERROR "cmake -E touch: failed to update")

  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected the error:"
    "  cmake -E touch: failed to update \"/\"."
    "of command:"
    "  ${CMAKE_COMMAND} -E touch /"
    "to match:"
    "  cmake -E touch: not failed to update")
  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E touch /
      ERROR "cmake -E touch: not failed to update"
    MESSAGE "${EXPECTED_MESSAGE}")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
