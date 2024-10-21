# MIT License
#
# Copyright (c) 2024 Alfi Maulana
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This variable contains the version of the included `Assertion.cmake` module.
set(ASSERTION_VERSION 2.0.0)

# Adds a new test that processes the given CMake file in script mode.
#
# add_cmake_script_test(<file> [NAME <name>] [DEFINITIONS <variables>...])
#
# This function adds a new test that processes the specified `<file>` in script
# mode. If `NAME` is provided, `<name>` will be used as the test name;
# otherwise, the test name will default to `<file>`.
#
# If the `CMAKE_SCRIPT_TEST_DEFINITIONS` variable is defined, the script will be
# processed with the predefined variables listed in that variable. Each entry
# should be in the format `<name>=<value>`, where `<name>` is the variable name
# and `<value>` is its value. If `DEFINITIONS` is specified, additional
# variables will also be defined.
function(add_cmake_script_test FILE)
  if(DEFINED CMAKE_SCRIPT_MODE_FILE)
    message(SEND_ERROR "Unable to add a new test in script mode")
    return()
  endif()

  cmake_parse_arguments(PARSE_ARGV 1 ARG "" NAME DEFINITIONS)
  if(NOT DEFINED ARG_NAME)
    set(ARG_NAME "${FILE}")
  endif()

  cmake_path(ABSOLUTE_PATH FILE)
  if(NOT EXISTS ${FILE})
    message(SEND_ERROR "Cannot find test file:\n  ${FILE}")
    return()
  endif()

  set(TEST_COMMAND "${CMAKE_COMMAND}")
  foreach(DEFINITION IN LISTS CMAKE_SCRIPT_TEST_DEFINITIONS ARG_DEFINITIONS)
    list(APPEND TEST_COMMAND -D "${DEFINITION}")
  endforeach()
  list(APPEND TEST_COMMAND -P "${FILE}")

  add_test(NAME "${ARG_NAME}" COMMAND ${TEST_COMMAND})
endfunction()

# Throws a formatted fatal error message.
#
# fail(<lines>...)
#
# This macro throws a fatal error message formatted from the given `<lines>`.
#
# It formats the message by concatenating all the lines into a single message.
# If one of the lines is a variable, it will be expanded and indented by two
# spaces before being concatenated with the other lines. If the expanded
# variable is another variable, it will format both the name and the value of
# the other variable.
macro(fail FIRST_LINE)
  block()
    foreach(LINE IN ITEMS "${FIRST_LINE}" ${ARGN})
      # Expand variable if it is defined and contains another variable.
      if(DEFINED "${LINE}" AND DEFINED "${${LINE}}")
        list(APPEND LINES "${${LINE}}" "of variable" "${LINE}")
      else()
        list(APPEND LINES "${LINE}")
      endif()
    endforeach()

    # Format the first line.
    list(POP_FRONT LINES LINE)
    if(DEFINED "${LINE}")
      set(MESSAGE "${${LINE}}")
      set(PREV_IS_STRING FALSE)
      set(INDENT_VAR FALSE)
    else()
      set(MESSAGE "${LINE}")
      set(PREV_IS_STRING TRUE)
      set(INDENT_VAR TRUE)
    endif()

    # Format the consecutive lines.
    foreach(LINE IN ITEMS ${LINES})
      if(DEFINED "${LINE}")
        if(PREV_IS_STRING)
          string(APPEND MESSAGE ":")
        endif()
        if(INDENT_VAR)
          string(REPLACE "\n" "\n  " LINE "${${LINE}}")
          string(APPEND MESSAGE "\n  ${LINE}")
        else()
          string(APPEND MESSAGE "\n${${LINE}}")
        endif()
        set(PREV_IS_STRING FALSE)
      else()
        string(APPEND MESSAGE "\n${LINE}")
        set(PREV_IS_STRING TRUE)
        set(INDENT_VAR TRUE)
      endif()
    endforeach()

    # Throw a fatal error with the formatted message.
    message(FATAL_ERROR "${MESSAGE}")
  endblock()
endmacro()

# Asserts the given condition.
#
# assert(<condition>...)
#
# This function performs an assertion on the given `<condition>`. If the
# assertion fails, it will output a formatted fatal error message with
# information about the context of the asserted condition.
#
# Internally, this function uses CMake's `if` function to check the given
# condition and throws a fatal error message if the condition resolves to false.
# Refer to the CMake's `if` function documentation for more information about
# supported conditions for the assertion.
function(assert)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "")

  if(${ARG_UNPARSED_ARGUMENTS})
    # Assertion passed, exit immediately.
    return()
  endif()

  # Assertion failed, determine the fatal error message based on the given
  # condition.
  if(ARGC EQUAL 2)
    if(NOT ARGV0 STREQUAL NOT)
      if(ARGV0 STREQUAL "COMMAND")
        fail("expected command" ARGV1 "to be defined")
        return()
      elseif(ARGV0 STREQUAL "POLICY")
        fail("expected policy" ARGV1 "to exist")
        return()
      elseif(ARGV0 STREQUAL "TARGET")
        fail("expected target" ARGV1 "to exist")
        return()
      elseif(ARGV0 STREQUAL "TEST")
        fail("expected test" ARGV1 "to exist")
        return()
      elseif(ARGV0 STREQUAL "DEFINED")
        fail("expected variable" ARGV1 "to be defined")
        return()
      elseif(ARGV0 STREQUAL "EXISTS")
        fail("expected path" ARGV1 "to exist")
        return()
      elseif(ARGV0 STREQUAL "IS_READABLE")
        fail("expected path" ARGV1 "to be readable")
        return()
      elseif(ARGV0 STREQUAL "IS_WRITABLE")
        fail("expected path" ARGV1 "to be writable")
        return()
      elseif(ARGV0 STREQUAL "IS_EXECUTABLE")
        fail("expected path" ARGV1 "to be an executable")
        return()
      elseif(ARGV0 STREQUAL "IS_DIRECTORY")
        fail("expected path" ARGV1 "to be a directory")
        return()
      elseif(ARGV0 STREQUAL "IS_SYMLINK")
        fail("expected path" ARGV1 "to be a symbolic link")
        return()
      elseif(ARGV0 STREQUAL "IS_ABSOLUTE")
        fail("expected path" ARGV1 "to be absolute")
        return()
      endif()
    endif()
  elseif(ARGC EQUAL 3)
    if(ARGV0 STREQUAL NOT)
      if(ARGV1 STREQUAL "COMMAND")
        fail("expected command" ARGV2 "not to be defined")
        return()
      elseif(ARGV1 STREQUAL "POLICY")
        fail("expected policy" ARGV2 "not to exist")
        return()
      elseif(ARGV1 STREQUAL "TARGET")
        fail("expected target" ARGV2 "not to exist")
        return()
      elseif(ARGV1 STREQUAL "TEST")
        fail("expected test" ARGV2 "not to exist")
        return()
      elseif(ARGV1 STREQUAL "DEFINED")
        # Unset this to prevent the value from being formatted.
        unset("${ARGV2}")

        fail("expected variable" ARGV2 "not to be defined")
        return()
      elseif(ARGV1 STREQUAL "EXISTS")
        fail("expected path" ARGV2 "not to exist")
        return()
      elseif(ARGV1 STREQUAL "IS_READABLE")
        fail("expected path" ARGV2 "not to be readable")
        return()
      elseif(ARGV1 STREQUAL "IS_WRITABLE")
        fail("expected path" ARGV2 "not to be writable")
        return()
      elseif(ARGV1 STREQUAL "IS_EXECUTABLE")
        fail("expected path" ARGV2 "not to be an executable")
        return()
      elseif(ARGV1 STREQUAL "IS_DIRECTORY")
        fail("expected path" ARGV2 "not to be a directory")
        return()
      elseif(ARGV1 STREQUAL "IS_SYMLINK")
        fail("expected path" ARGV2 "not to be a symbolic link")
        return()
      elseif(ARGV1 STREQUAL "IS_ABSOLUTE")
        fail("expected path" ARGV2 "not to be absolute")
        return()
      endif()
    else()
      if(ARGV1 STREQUAL "IN_LIST")
        fail("expected string" ARGV0 "to exist in" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "IS_NEWER_THAN")
        fail("expected file" ARGV0 "to be newer than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "MATCHES")
        fail("expected string" ARGV0 "to match" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "LESS")
        fail("expected number" ARGV0 "to be less than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "GREATER")
        fail("expected number" ARGV0 "to be greater than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "EQUAL")
        fail("expected number" ARGV0 "to be equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "LESS_EQUAL")
        fail("expected number" ARGV0 "to be less than or equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "GREATER_EQUAL")
        fail("expected number" ARGV0 "to be greater than or equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "STRLESS")
        fail("expected string" ARGV0 "to be less than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "STRGREATER")
        fail("expected string" ARGV0 "to be greater than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "STREQUAL")
        fail("expected string" ARGV0 "to be equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "STRLESS_EQUAL")
        fail("expected string" ARGV0 "to be less than or equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "STRGREATER_EQUAL")
        fail("expected string" ARGV0 "to be greater than or equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "VERSION_LESS")
        fail("expected version" ARGV0 "to be less than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "VERSION_GREATER")
        fail("expected version" ARGV0 "to be greater than" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "VERSION_EQUAL")
        fail("expected version" ARGV0 "to be equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "VERSION_LESS_EQUAL")
        fail("expected version" ARGV0 "to be less than or equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "VERSION_GREATER_EQUAL")
        fail("expected version" ARGV0 "to be greater than or equal to" ARGV2)
        return()
      elseif(ARGV1 STREQUAL "PATH_EQUAL")
        fail("expected path" ARGV0 "to be equal to" ARGV2)
        return()
      endif()
    endif()
  elseif(ARGC EQUAL 4)
    if(ARGV0 STREQUAL "NOT")
      if(ARGV2 STREQUAL "IN_LIST")
        fail("expected string" ARGV1 "not to exist in" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "IS_NEWER_THAN")
        fail("expected file" ARGV1 "not to be newer than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "MATCHES")
        fail("expected string" ARGV1 "not to match" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "LESS")
        fail("expected number" ARGV1 "not to be less than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "GREATER")
        fail("expected number" ARGV1 "not to be greater than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "EQUAL")
        fail("expected number" ARGV1 "not to be equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "LESS_EQUAL")
        fail("expected number" ARGV1 "not to be less than or equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "GREATER_EQUAL")
        fail("expected number" ARGV1 "not to be greater than or equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "STRLESS")
        fail("expected string" ARGV1 "not to be less than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "STRGREATER")
        fail("expected string" ARGV1 "not to be greater than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "STREQUAL")
        fail("expected string" ARGV1 "not to be equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "STRLESS_EQUAL")
        fail("expected string" ARGV1 "not to be less than or equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "STRGREATER_EQUAL")
        fail("expected string" ARGV1 "not to be greater than or equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "VERSION_LESS")
        fail("expected version" ARGV1 "not to be less than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "VERSION_GREATER")
        fail("expected version" ARGV1 "not to be greater than" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "VERSION_EQUAL")
        fail("expected version" ARGV1 "not to be equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "VERSION_LESS_EQUAL")
        fail("expected version" ARGV1 "not to be less than or equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "VERSION_GREATER_EQUAL")
        fail("expected version" ARGV1 "not to be greater than or equal to" ARGV3)
        return()
      elseif(ARGV2 STREQUAL "PATH_EQUAL")
        fail("expected path" ARGV1 "not to be equal to" ARGV3)
        return()
      endif()
    endif()
  endif()

  # Fallback to this message if it could not determine the fatal error message
  # from the given condition.
  string(REPLACE ";" " " ARGS "${ARG_UNPARSED_ARGUMENTS}")
  fail("expected" ARGS "to resolve to true")
endfunction()

# Performs an assertion on the given command call.
#
# assert_call(
#   [CALL] <command> [<arguments>...]
#   EXPECT_ERROR [MATCHES|STREQUAL] <message>...)
#
# This function performs an assertion on the function or macro named
# `<command>`, called with the specified `<arguments>`. It currently only allows
# asserting whether the given command throws a fatal error message that
# satisfies the expected message.

# If `MATCHES` is specified, it asserts whether the received message matches
# `<message>`. If `STREQUAL` is specified, it asserts whether the received
# message is equal to `<message>`. If nothing is specified, it defaults to the
# `MATCHES` parameter.

# If more than one `<message>` string is given, they are concatenated into a
# single message with no separators.
function(assert_call)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "CALL;EXPECT_ERROR")

  if(NOT DEFINED ARG_CALL)
    set(ARG_CALL ${ARG_UNPARSED_ARGUMENTS})
  endif()

  list(GET ARG_EXPECT_ERROR 0 OPERATOR)
  if(OPERATOR MATCHES ^MATCHES|STREQUAL$)
    list(REMOVE_AT ARG_EXPECT_ERROR 0)
  else()
    set(OPERATOR "MATCHES")
  endif()
  string(JOIN "" EXPECTED_ERROR ${ARG_EXPECT_ERROR})

  # Override the `message` function if it has not been overridden.
  get_property(MESSAGE_MOCKED GLOBAL PROPERTY _assert_internal_message_mocked)
  if(NOT MESSAGE_MOCKED)
    # Override the `message` function to allow the behavior to be mocked by
    # capturing a fatal error message.
    function(message MODE)
      cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "")

      # The fatal error message will only be captured if the capture level is
      # one or above.
      get_property(CAPTURE_LEVEL GLOBAL PROPERTY fatal_error_capture_level)
      if(CAPTURE_LEVEL GREATER_EQUAL 1 AND MODE STREQUAL "FATAL_ERROR")
        string(JOIN "" MESSAGE ${ARG_UNPARSED_ARGUMENTS})
        set_property(GLOBAL PROPERTY captured_fatal_error "${MESSAGE}")

        # Decrease the level for capturing a fatal error message, indicating
        # the requirement to capture a fatal error message is fulfilled.
        math(EXPR CAPTURE_LEVEL "${CAPTURE_LEVEL} - 1")
        set_property(GLOBAL PROPERTY fatal_error_capture_level
          "${CAPTURE_LEVEL}")
      else()
        _message("${MODE}" ${ARG_UNPARSED_ARGUMENTS})
      endif()
    endfunction()
    set_property(GLOBAL PROPERTY _assert_internal_message_mocked ON)
  endif()

  # Increase the level for capturing a fatal error message, indicating the
  # requirement to capture a fatal error message.
  get_property(CAPTURE_LEVEL GLOBAL PROPERTY fatal_error_capture_level)
  if(CAPTURE_LEVEL GREATER_EQUAL 0)
    math(EXPR CAPTURE_LEVEL "${CAPTURE_LEVEL} + 1")
  else()
    set(CAPTURE_LEVEL 1)
  endif()
  set_property(GLOBAL PROPERTY fatal_error_capture_level "${CAPTURE_LEVEL}")

  # Call the command with the specified arguments.
  list(POP_FRONT ARG_CALL COMMAND)
  cmake_language(CALL "${COMMAND}" ${ARG_CALL})

  # Assert if a fatal error message is captured. This can be done by checking
  # whether the capture level is decreased.
  get_property(NEW_CAPTURE_LEVEL GLOBAL PROPERTY fatal_error_capture_level)
  if(NEW_CAPTURE_LEVEL GREATER_EQUAL CAPTURE_LEVEL)
    # Decrease the level for capturing a fatal error message, reverting to the
    # level before this assertion.
    math(EXPR CAPTURE_LEVEL "${CAPTURE_LEVEL} - 1")
    set_property(GLOBAL PROPERTY fatal_error_capture_level "${CAPTURE_LEVEL}")

    fail("expected to receive a fatal error message")
    return()
  endif()

  # Assert the captured fatal error message with the expected message.
  get_property(ACTUAL_MESSAGE GLOBAL PROPERTY captured_fatal_error)
  string(STRIP "${ACTUAL_MESSAGE}" ACTUAL_MESSAGE)
  if(NOT "${ACTUAL_MESSAGE}" ${OPERATOR} "${EXPECTED_ERROR}")
    if(OPERATOR STREQUAL "MATCHES")
      fail("expected fatal error message" ACTUAL_MESSAGE
        "to match" EXPECTED_ERROR)
    else()
      fail("expected fatal error message" ACTUAL_MESSAGE
        "to be equal to" EXPECTED_ERROR)
    endif()
  endif()
endfunction()

# Asserts whether the given command correctly executes a process.
#
# assert_execute_process(
#   [COMMAND] <command> [<arguments>...]
#   [EXPECT_FAIL]
#   [EXPECT_OUTPUT [MATCHES|STREQUAL] <output>...]
#   [EXPECT_ERROR [MATCHES|STREQUAL] <error>...])
#
# This function asserts whether the given `<command>` and `<arguments>`
# successfully execute a process. If `EXPECT_FAIL` or `EXPECT_ERROR` is
# specified, it asserts that the process fails to execute.
#
# If `EXPECT_OUTPUT` or `EXPECT_ERROR` is specified, it also asserts whether the
# output or error of the executed process matches the expected output or error.
#
# If `MATCHES` is specified, it asserts whether the output or error matches the
# `<output>` or `<error>`. If `STREQUAL` is specified, it asserts whether the
# output or error is equal to `<output>` or `<error>`. If neither is specified,
# it defaults to `MATCHES`.
#
# If more than one `<output>` or `<error>` string is given, they are
# concatenated into a single output or error with no separator between the
# strings.
function(assert_execute_process)
  cmake_parse_arguments(
    PARSE_ARGV 0 ARG EXPECT_FAIL "" "COMMAND;EXPECT_OUTPUT;EXPECT_ERROR")

  if(NOT DEFINED ARG_COMMAND)
    set(ARG_COMMAND ${ARG_UNPARSED_ARGUMENTS})
  endif()

  execute_process(
    COMMAND ${ARG_COMMAND}
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
    ERROR_VARIABLE ERR)

  if(ARG_EXPECT_FAIL OR DEFINED ARG_EXPECT_ERROR)
    if(RES EQUAL 0)
      string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
      fail("expected command" COMMAND "to fail")
      return()
    endif()
  else()
    if(NOT RES EQUAL 0)
      string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
      fail("expected command" COMMAND "not to fail with error" ERR)
      return()
    endif()
  endif()

  if(DEFINED ARG_EXPECT_OUTPUT)
    list(GET ARG_EXPECT_OUTPUT 0 OPERATOR)
    if(OPERATOR MATCHES ^MATCHES|STREQUAL$)
      list(REMOVE_AT ARG_EXPECT_OUTPUT 0)
    else()
      set(OPERATOR "MATCHES")
    endif()
    string(JOIN "" EXPECTED_OUTPUT ${ARG_EXPECT_OUTPUT})

    string(STRIP "${OUT}" OUT)
    if(NOT "${OUT}" ${OPERATOR} "${EXPECTED_OUTPUT}")
      string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
      if(OPERATOR STREQUAL "MATCHES")
        fail("expected the output" OUT "of command" COMMAND
          "to match" EXPECTED_OUTPUT)
      else()
        fail("expected the output" OUT "of command" COMMAND
          "to be equal to" EXPECTED_OUTPUT)
      endif()
      return()
    endif()
  endif()

  if(DEFINED ARG_EXPECT_ERROR)
    list(GET ARG_EXPECT_ERROR 0 OPERATOR)
    if(OPERATOR MATCHES ^MATCHES|STREQUAL$)
      list(REMOVE_AT ARG_EXPECT_ERROR 0)
    else()
      set(OPERATOR "MATCHES")
    endif()
    string(JOIN "" EXPECTED_ERROR ${ARG_EXPECT_ERROR})

    string(STRIP "${ERR}" ERR)
    if(NOT "${ERR}" ${OPERATOR} "${EXPECTED_ERROR}")
      string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
      if(OPERATOR STREQUAL "MATCHES")
        fail("expected the error" ERR "of command" COMMAND
          "to match" EXPECTED_ERROR)
      else()
        fail("expected the error" ERR "of command" COMMAND
          "to be equal to" EXPECTED_ERROR)
      endif()
    endif()
  endif()
endfunction()

# Begins a new test section.
#
# section(<name>...)
#
# This function begins a new test section named `<name>`. It prints the test
# section name and indents all subsequent messages by two spaces.
#
# If more than one `<name>` string is given, they are concatenated into a single
# name with no separator between the strings.
#
# Use the `endsection` function to end the test section.
function(section NAME)
  cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "")
  string(JOIN "" NAME "${NAME}" ${ARG_UNPARSED_ARGUMENTS})

  message(STATUS "${NAME}")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  set(CMAKE_MESSAGE_INDENT "${CMAKE_MESSAGE_INDENT}" PARENT_SCOPE)
endfunction()

# Ends the current test section.
#
# endsection()
#
# This function ends the current test section.
function(endsection)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  set(CMAKE_MESSAGE_INDENT "${CMAKE_MESSAGE_INDENT}" PARENT_SCOPE)
endfunction()
