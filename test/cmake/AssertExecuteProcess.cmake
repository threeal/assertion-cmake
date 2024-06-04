cmake_minimum_required(VERSION 3.17)

include(Assertion)

message(CHECK_START "execute process assertions")
block()
  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E true)
  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E false ERROR .*)

  assert_fatal_error(
    CALL assert_execute_process COMMAND "${CMAKE_COMMAND}" -E true ERROR .*
    MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E true\nto fail")

  assert_fatal_error(
    CALL assert_execute_process COMMAND "${CMAKE_COMMAND}" -E false
    MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E false\nnot to fail")
endblock()
message(CHECK_PASS passed)

message(CHECK_START "execute process output assertions")
block()
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
endblock()
message(CHECK_PASS passed)

message(CHECK_START "execute process error assertions")
block()
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
endblock()
message(CHECK_PASS passed)
