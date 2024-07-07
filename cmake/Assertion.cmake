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

# This module contains a collection of assertion functions and other utilities
# for testing CMake code.
#
# The main feature of this module is the `assert` function for asserting the
# given condition in the style of CMake's `if` function. If the assertion fails,
# it will throw a fatal error message with information about the context of the
# asserted condition.
#
# This module also supports CMake test creation using the `assertion_add_test`
# function. This function will create a new test that processes the given file
# in script mode with variables, functions, and macros from this module
# available in the given file.
#
# If this module is processed in script mode, it may optionally include other
# modules by passing the paths of the other modules as additional arguments
# after `--`.

cmake_minimum_required(VERSION 3.17)

# This variable contains the path to the included `Assertion.cmake` module.
set(ASSERTION_LIST_FILE "${CMAKE_CURRENT_LIST_FILE}")

# Adds a new test that processes the given CMake file in script mode.
#
# assertion_add_test(<file> [NAME <name>])
#
# This function adds a new test that processes the given `<file>` in script
# mode. If `NAME` is specified, it will use `<name>` as the test name;
# otherwise, it will use `<file>`.
#
# Internally, the test will process this module in script mode and include the
# given `<file>` at the end of the module, allowing variables, functions, and
# macros in this module to be available in the `<file>` without the need to
# include this module from the `<file>`.
function(assertion_add_test FILE)
  cmake_parse_arguments(PARSE_ARGV 1 ARG "" NAME "")

  if(NOT DEFINED ARG_NAME)
    set(ARG_NAME "${FILE}")
  endif()

  add_test(
    NAME "${ARG_NAME}"
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/${FILE})
endfunction()

# Throws a formatted fatal error message.
#
# fail(<lines>...)
#
# This macro throws a fatal error message formatted from the given `<lines>`.
#
# It formats the message by concatenating all the lines into a single message.
# If one of the lines is a variable, it will be expanded and indented by two
# spaces before being concatenated with the other lines.
macro(fail FIRST_LINE)
  if(DEFINED "${FIRST_LINE}")
    set(MESSAGE "${${FIRST_LINE}}")
  else()
    set(MESSAGE "${FIRST_LINE}")
  endif()

  foreach(LINE IN ITEMS ${ARGN})
    if(DEFINED "${LINE}")
      string(REPLACE "\n" "\n  " LINE "${${LINE}}")
      string(APPEND MESSAGE ":\n  ${LINE}")
    else()
      string(APPEND MESSAGE "\n${LINE}")
    endif()
  endforeach()

  message(FATAL_ERROR "${MESSAGE}")
endmacro()

# Asserts the given condition.
#
# assert(<condition>...)
#
# This function performs an assertion on the given `<condition>`. If the
# assertion fails, it will output a formatted fatal error message with
# information about the context of the asserted condition.
#
# Refer to the documentation of CMake's `if` function for more information about
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
      endif()
    else()
      if(ARGV1 STREQUAL "IN_LIST")
        if(DEFINED "${ARGV0}")
          fail("expected string" "${ARGV0}" "of variable" ARGV0
            "to exist in" "${ARGV2}" "of variable" ARGV2)
        else()
          fail("expected string" ARGV0
            "to exist in" "${ARGV2}" "of variable" ARGV2)
        endif()
        return()
      elseif(ARGV1 STREQUAL "MATCHES")
        if(DEFINED "${ARGV0}")
          fail("expected string" "${ARGV0}" "of variable" ARGV0
            "to match" ARGV2)
        else()
          fail("expected string" ARGV0 "to match" ARGV2)
        endif()
        return()
      elseif(ARGV1 STREQUAL "STREQUAL")
        if(DEFINED "${ARGV0}")
          if(DEFINED "${ARGV2}")
            fail("expected string" "${ARGV0}" "of variable" ARGV0
              "to be equal to string" "${ARGV2}" "of variable" ARGV2)
          else()
            fail("expected string" "${ARGV0}" "of variable" ARGV0
              "to be equal to" ARGV2)
          endif()
        else()
          if(DEFINED "${ARGV2}")
            fail("expected string" ARGV0
              "to be equal to string" "${ARGV2}" "of variable" ARGV2)
          else()
            fail("expected string" ARGV0 "to be equal to" ARGV2)
          endif()
        endif()
        return()
      endif()
    endif()
  elseif(ARGC EQUAL 4)
    if(ARGV0 STREQUAL "NOT")
      if(ARGV2 STREQUAL "IN_LIST")
        if(DEFINED "${ARGV1}")
          fail("expected string" "${ARGV1}" "of variable" ARGV1
            "not to exist in" "${ARGV3}" "of variable" ARGV3)
        else()
          fail("expected string" ARGV1
            "not to exist in" "${ARGV3}" "of variable" ARGV3)
        endif()
        return()
      elseif(ARGV2 STREQUAL "MATCHES")
        if(DEFINED "${ARGV1}")
          fail("expected string" "${ARGV1}" "of variable" ARGV1
            "not to match" ARGV3)
        else()
          fail("expected string" ARGV1 "not to match" ARGV3)
        endif()
        return()
      elseif(ARGV2 STREQUAL "STREQUAL")
        if(DEFINED "${ARGV1}")
          if(DEFINED "${ARGV3}")
            fail("expected string" "${ARGV1}" "of variable" ARGV1
              "not to be equal to string" "${ARGV3}" "of variable" ARGV3)
          else()
            fail("expected string" "${ARGV1}" "of variable" ARGV1
              "not to be equal to" ARGV3)
          endif()
        else()
          if(DEFINED "${ARGV3}")
            fail("expected string" ARGV1
              "not to be equal to string" "${ARGV3}" "of variable" ARGV3)
          else()
            fail("expected string" ARGV1 "not to be equal to" ARGV3)
          endif()
        endif()
        return()
      endif()
    endif()
  endif()

  # Fallback to this message if it could not determine the fatal error message
  # from the given condition.
  string(REPLACE ";" " " ARGS "${ARG_UNPARSED_ARGUMENTS}")
  fail("expected" ARGS "to resolve to true")
endfunction()

# Asserts whether a command call throws a fatal error message.
#
# assert_fatal_error(CALL <command> [<arguments>...] MESSAGE <message>...)
#
# This function asserts whether a function or macro named `<command>`, called
# with the specified `<arguments>`, throws a fatal error message that matches
# the expected `<message>`.
#
# If more than one `<message>` string is given, they are concatenated into a
# single message with no separator between the strings.
function(assert_fatal_error)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "CALL;MESSAGE")
  string(JOIN "" EXPECTED_MESSAGE ${ARG_MESSAGE})

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

    fail("expected to receive a fatal error message that matches"
      EXPECTED_MESSAGE)
    return()
  endif()

  # Assert the captured fatal error message with the expected message.
  get_property(ACTUAL_MESSAGE GLOBAL PROPERTY captured_fatal_error)
  if(NOT "${ACTUAL_MESSAGE}" MATCHES "${EXPECTED_MESSAGE}")
    fail("expected fatal error message" ACTUAL_MESSAGE
      "to match" EXPECTED_MESSAGE)
  endif()
endfunction()

# Asserts whether the given command correctly executes a process.
#
# assert_execute_process(
#   [COMMAND] <command> [<arguments>...]
#   [OUTPUT <output>...]
#   [ERROR <error>...])
#
# This function asserts whether the given `<command>` and `<arguments>`
# successfully execute a process. If `ERROR` is specified, it instead asserts
# whether it fails to execute the process.
#
# If `OUTPUT` is specified, it also asserts whether the output of the executed
# process matches the expected `<output>`. If more than one `<output>` string
# is given, they are concatenated into a single output with no separator between
# the strings.
#
# If `ERROR` is specified, it also asserts whether the error of the executed
# process matches the expected `<error>`. If more than one `<error>` string
# is given, they are concatenated into a single error with no separator between
# the strings.
function(assert_execute_process)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "COMMAND;OUTPUT;ERROR")

  if(NOT DEFINED ARG_COMMAND)
    set(ARG_COMMAND ${ARG_UNPARSED_ARGUMENTS})
  endif()

  execute_process(
    COMMAND ${ARG_COMMAND}
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
    ERROR_VARIABLE ERR)

  if(DEFINED ARG_ERROR)
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

  if(DEFINED ARG_OUTPUT)
    string(JOIN "" EXPECTED_OUTPUT ${ARG_OUTPUT})
    if(NOT "${OUT}" MATCHES "${EXPECTED_OUTPUT}")
      string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
      fail("expected the output" OUT "of command" COMMAND
        "to match" EXPECTED_OUTPUT)
      return()
    endif()
  endif()

  if(DEFINED ARG_ERROR)
    string(JOIN "" EXPECTED_ERROR ${ARG_ERROR})
    if(NOT "${ERR}" MATCHES "${EXPECTED_ERROR}")
      string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
      fail("expected the error" ERR "of command" COMMAND
        "to match" EXPECTED_ERROR)
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

# These lines allow this module to include other modules when processed in
# script mode by passing the paths of the other modules as additional arguments
# after `--`.
if(DEFINED CMAKE_SCRIPT_MODE_FILE AND
  CMAKE_SCRIPT_MODE_FILE STREQUAL CMAKE_CURRENT_LIST_FILE)
  math(EXPR END "${CMAKE_ARGC} - 1")
  foreach(I RANGE 0 "${END}")
    if(CMAKE_ARGV${I} STREQUAL "--")
      math(EXPR I "${I} + 1")
      foreach(I RANGE "${I}" "${END}")
        include("${CMAKE_ARGV${I}}")
      endforeach()
      break()
    endif()
  endforeach()
endif()
