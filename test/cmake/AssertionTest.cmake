cmake_minimum_required(VERSION 3.5)

include(Assertion)

function("Boolean assertions")
  assert(TRUE)
  assert(NOT FALSE)

  assert_fatal_error(
    CALL assert FALSE
    MESSAGE "expected:\n  FALSE\nto resolve to true")

  assert_fatal_error(
    CALL assert NOT TRUE
    MESSAGE "expected:\n  NOT TRUE\nto resolve to true")
endfunction()

function("Variable existence assertions")
  set(EXISTING_VARIABLE TRUE)
  unset(NON_EXSITING_VARIABLE)

  assert(DEFINED EXISTING_VARIABLE)
  assert(NOT DEFINED NON_EXSITING_VARIABLE)

  assert_fatal_error(
    CALL assert DEFINED NON_EXISTING_VARIABLE
    MESSAGE "expected variable:\n  NON_EXISTING_VARIABLE\nto be defined")

  assert_fatal_error(
    CALL assert NOT DEFINED EXISTING_VARIABLE
    MESSAGE "expected variable:\n  EXISTING_VARIABLE\nnot to be defined")
endfunction()

function("Path existence assertions")
  file(TOUCH some_file)
  file(REMOVE_RECURSE non_existing_file)

  assert(EXISTS some_file)
  assert(NOT EXISTS non_existing_file)

  assert_fatal_error(
    CALL assert EXISTS non_existing_file
    MESSAGE "expected path:\n  non_existing_file\nto exist")

  assert_fatal_error(
    CALL assert NOT EXISTS some_file
    MESSAGE "expected path:\n  some_file\nnot to exist")
endfunction()

function("Directory path assertions")
  file(MAKE_DIRECTORY some_directory)
  file(TOUCH some_file)

  assert(IS_DIRECTORY some_directory)
  assert(NOT IS_DIRECTORY some_file)

  assert_fatal_error(
    CALL assert IS_DIRECTORY some_file
    MESSAGE "expected path:\n  some_file\nto be a directory")

  assert_fatal_error(
    CALL assert NOT IS_DIRECTORY some_directory
    MESSAGE "expected path:\n  some_directory\nnot to be a directory")
endfunction()

function("Regular expression match assertions")
  set(STRING_VAR "some string")

  foreach(VALUE STRING_VAR "${STRING_VAR}")
    assert("${VALUE}" MATCHES "so.*ing")
    assert(NOT "${VALUE}" MATCHES "so.*other.*ing")

    assert_fatal_error(
      CALL assert NOT "${VALUE}" MATCHES "so.*ing"
      MESSAGE "expected string:\n  some string\nnot to match:\n  so.*ing")

    assert_fatal_error(
      CALL assert "${VALUE}" MATCHES "so.*other.*ing"
      MESSAGE "expected string:\n  some string\nto match:\n  so.*other.*ing")
  endforeach()
endfunction()

function("String equality assertions")
  set(STRING_VAR "some string")
  set(OTHER_STRING_VAR "some other string")

  foreach(LEFT_VALUE STRING_VAR "${STRING_VAR}")
    foreach(RIGHT_VALUE STRING_VAR "${STRING_VAR}")
      assert("${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
    endforeach()

    foreach(RIGHT_VALUE OTHER_STRING_VAR "${OTHER_STRING_VAR}")
      assert(NOT "${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
    endforeach()

    foreach(RIGHT_VALUE OTHER_STRING_VAR "${OTHER_STRING_VAR}")
      assert_fatal_error(
        CALL assert "${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}"
        MESSAGE "expected string:\n  some string\nto be equal to:\n  some other string")
    endforeach()

    foreach(RIGHT_VALUE STRING_VAR "${STRING_VAR}")
      assert_fatal_error(
        CALL assert NOT "${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}"
        MESSAGE "expected string:\n  some string\nnot to be equal to:\n  some string")
    endforeach()
  endforeach()
endfunction()

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
