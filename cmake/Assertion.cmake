# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Retrieves the content of the given variable.
#
# If the given variable is defined, it sets the output variable to the content
# of the variable. Otherwise, it sets the output variable to the name of the
# variable.
#
# Arguments:
#   - VARIABLE: The variable to get the content from.
#   - OUTPUT_VARIABLE: The output variable that holds the content of the variable.
function(_assert_internal_get_content VARIABLE OUTPUT_VARIABLE)
  if(DEFINED "${VARIABLE}")
    set("${OUTPUT_VARIABLE}" "${${VARIABLE}}" PARENT_SCOPE)
  else()
    set("${OUTPUT_VARIABLE}" "${VARIABLE}" PARENT_SCOPE)
  endif()
endfunction()

# Formats an assertion message with indentation on even lines.
#
# Arguments:
#   - OUT_VAR: The output variable that holds the formatted message.
#   - FIRST_LINE: The first line of the message.
#   - ARGN: The rest of the lines of the message.
function(_assert_internal_format_message OUT_VAR FIRST_LINE)
  set(MESSAGE "${FIRST_LINE}")
  if(ARGC GREATER 2)
    math(EXPR STOP "${ARGC} - 1")
    foreach(I RANGE 2 "${STOP}")
      string(STRIP "${ARGV${I}}" LINE)
      math(EXPR MOD "${I} % 2")
      if(MOD EQUAL 0)
        string(REPLACE "\n" "\n  " LINE "${LINE}")
        set(MESSAGE "${MESSAGE}\n  ${LINE}")
      else()
        set(MESSAGE "${MESSAGE}\n${LINE}")
      endif()
    endforeach()
  endif()
  set("${OUT_VAR}" "${MESSAGE}" PARENT_SCOPE)
endfunction()

# Asserts the given condition.
#
# This function performs an assertion on the given condition. It will output a
# fatal error message if the assertion fails.
#
# Refer to the documentation of the 'if' function for supported conditions to
# perform the assertion.
function(assert)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "")
  if(${ARG_UNPARSED_ARGUMENTS})
    # Do nothing if the assertion succeeds.
  else()
    string(REPLACE ";" " " ARGS "${ARG_UNPARSED_ARGUMENTS}")
    _assert_internal_format_message(
      MESSAGE "expected:" "${ARGS}" "to resolve to true")

    if(ARGC EQUAL 2)
      if(NOT ARGV0 STREQUAL NOT)
        if(ARGV0 STREQUAL DEFINED)
          _assert_internal_format_message(
            MESSAGE "expected variable:" "${ARGV1}" "to be defined")
        elseif(ARGV0 STREQUAL EXISTS)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV1}" "to exist")
        elseif(ARGV0 STREQUAL IS_DIRECTORY)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV1}" "to be a directory")
        endif()
      endif()
    elseif(ARGC EQUAL 3)
      if(ARGV0 STREQUAL NOT)
        if(ARGV1 STREQUAL DEFINED)
          _assert_internal_format_message(
            MESSAGE "expected variable:" "${ARGV2}" "not to be defined")
        elseif(ARGV1 STREQUAL EXISTS)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV2}" "not to exist")
        elseif(ARGV1 STREQUAL IS_DIRECTORY)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV2}" "not to be a directory")
        endif()
      else()
        if(ARGV1 STREQUAL MATCHES)
          if(DEFINED "${ARGV0}")
            _assert_internal_format_message(
              MESSAGE
              "expected string:" "${${ARGV0}}"
              "of variable:" "${ARGV0}"
              "to match:" "${ARGV2}")
          else()
            _assert_internal_format_message(
              MESSAGE "expected string:" "${ARGV0}" "to match:" "${ARGV2}")
          endif()
        elseif(ARGV1 STREQUAL STREQUAL)
          if(DEFINED "${ARGV0}")
            if(DEFINED "${ARGV2}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV0}}"
                "of variable:" "${ARGV0}"
                "to be equal to string:" "${${ARGV2}}"
                "of variable:" "${ARGV2}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV0}}"
                "of variable:" "${ARGV0}"
                "to be equal to:" "${ARGV2}")
            endif()
          else()
            if(DEFINED "${ARGV2}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV0}"
                "to be equal to string:" "${${ARGV2}}"
                "of variable:" "${ARGV2}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV0}"
                "to be equal to:" "${ARGV2}")
            endif()
          endif()
        endif()
      endif()
    elseif(ARGC EQUAL 4)
      if(ARGV0 STREQUAL NOT)
        if(ARGV2 STREQUAL MATCHES)
          if(DEFINED "${ARGV1}")
            _assert_internal_format_message(
              MESSAGE
              "expected string:" "${${ARGV1}}"
              "of variable:" "${ARGV1}"
              "not to match:" "${ARGV3}")
          else()
            _assert_internal_format_message(
              MESSAGE "expected string:" "${ARGV1}" "not to match:" "${ARGV3}")
          endif()
        elseif(ARGV2 STREQUAL STREQUAL)
          if(DEFINED "${ARGV1}")
            if(DEFINED "${ARGV3}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV1}}"
                "of variable:" "${ARGV1}"
                "not to be equal to string:" "${${ARGV3}}"
                "of variable:" "${ARGV3}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV1}}"
                "of variable:" "${ARGV1}"
                "not to be equal to:" "${ARGV3}")
            endif()
          else()
            if(DEFINED "${ARGV3}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV1}"
                "not to be equal to string:" "${${ARGV3}}"
                "of variable:" "${ARGV3}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV1}"
                "not to be equal to:" "${ARGV3}")
            endif()
          endif()
        endif()
      endif()
    endif()

    message(FATAL_ERROR "${MESSAGE}")
  endif()
endfunction()

# Begins a scope for mocking the `message` function.
#
# ```cmake
# _assert_internal_mock_message()
# ```
#
# Begins a scope for mocking the `message` function by modifying its behavior
# to store the message into a list variable instead of printing it to the log.
#
# Use the '_assert_internal_end_mock_message' macro to end the scope for mocking
# the `message` function, reverting it to the original behavior.
macro(_assert_internal_mock_message)
  macro(message MODE MESSAGE)
    if(DEFINED _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
      list(APPEND ${MODE}_MESSAGES "${MESSAGE}")
      set(${MODE}_MESSAGES "${${MODE}_MESSAGES}" PARENT_SCOPE)
      if("${MODE}" STREQUAL FATAL_ERROR)
        return()
      endif()
    else()
      _message("${MODE}" "${MESSAGE}")
    endif()
  endmacro()

  macro(_assert_internal_mock_message)
    if(NOT DEFINED _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
      set(_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL 1)
    else()
      math(
        EXPR _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL
        "${_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL} + 1")
    endif()
  endmacro()
  _assert_internal_mock_message()
endmacro()

# Ends a scope for mocking the `message` function.
#
# ```cmake
# _assert_internal_end_mock_message()
# ```
#
# Ends a scope for mocking the `message` function, reverting it to the original
# behavior.
macro(_assert_internal_end_mock_message)
  if(DEFINED _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
    math(
      EXPR _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL
      "${_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL} - 1")
    if(_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL LESS_EQUAL 0)
      unset(_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
    endif()
  endif()
endmacro()

# Asserts whether a command call throws a fatal error message.
#
# ```cmake
# assert_fatal_error(CALL <command> [<arg>...] MESSAGE <message>)
# ```
#
# Asserts whether a command named `<command>` called with the specified
# arguments throws the expected `<message>` fatal error message.
function(assert_fatal_error)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" MESSAGE CALL)

  list(POP_FRONT ARG_CALL COMMAND)
  _assert_internal_mock_message()
    cmake_language(CALL "${COMMAND}" ${ARG_CALL})
  _assert_internal_end_mock_message()

  list(POP_FRONT FATAL_ERROR_MESSAGES MESSAGE)
  if(NOT MESSAGE STREQUAL ARG_MESSAGE)
    _assert_internal_format_message(
      ASSERT_MESSAGE "expected fatal error message:" "${MESSAGE}"
      "to be equal to:" "${ARG_MESSAGE}")
    message(FATAL_ERROR "${ASSERT_MESSAGE}")
  endif()
endfunction()

# Asserts whether the given command executes a process.
#
# This function asserts whether the given command successfully executes a
# process. If the `ERROR` argument is specified, this function asserts
# whether the given command fails to execute the process.
#
# Optional arguments:
#   - COMMAND: The command to execute.
#   - OUTPUT: If set, asserts whether the output of the executed process matches
#     the given regular expression.
#   - ERROR: If set, asserts whether the error of the executed process matches
#     the given regular expression.
function(assert_execute_process)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "OUTPUT;ERROR" "COMMAND")

  execute_process(
    COMMAND ${ARG_COMMAND}
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
    ERROR_VARIABLE ERR
  )

  if(DEFINED ARG_ERROR AND RES EQUAL 0)
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected command:" "${COMMAND}" "to fail")
    message(FATAL_ERROR "${MESSAGE}")
  elseif(NOT DEFINED ARG_ERROR AND NOT RES EQUAL 0)
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected command:" "${COMMAND}" "not to fail")
    message(FATAL_ERROR "${MESSAGE}")
  elseif(DEFINED ARG_OUTPUT AND NOT "${OUT}" MATCHES "${ARG_OUTPUT}")
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected the output:" "${OUT}"
      "of command:" "${COMMAND}"
      "to match:" "${ARG_OUTPUT}")
    message(FATAL_ERROR "${MESSAGE}")
  elseif(DEFINED ARG_ERROR AND NOT "${ERR}" MATCHES "${ARG_ERROR}")
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected the error:" "${ERR}"
      "of command:" "${COMMAND}"
      "to match:" "${ARG_ERROR}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endfunction()
