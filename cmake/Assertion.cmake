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

# Asserts whether the given variable is defined.
#
# Arguments:
#   - VARIABLE: The variable to check.
macro(_assert_internal_assert_2_defined VARIABLE)
  if(NOT DEFINED "${VARIABLE}")
    _assert_internal_format_message(
      MESSAGE "expected variable:" "${VARIABLE}" "to be defined")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given variable is not defined.
#
# Arguments:
#   - VARIABLE: The variable to check.
macro(_assert_internal_assert_2_not_defined VARIABLE)
  if(DEFINED "${VARIABLE}")
    _assert_internal_format_message(
      MESSAGE "expected variable:" "${VARIABLE}" "not to be defined")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given path exists.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_exists PATH)
  if(NOT EXISTS "${PATH}")
    _assert_internal_format_message(
      MESSAGE "expected path:" "${PATH}" "to exist")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given path does not exist.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_not_exists PATH)
  if(EXISTS "${PATH}")
    _assert_internal_format_message(
      MESSAGE "expected path:" "${PATH}" "not to exist")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given path is a directory.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_is_directory PATH)
  if(NOT IS_DIRECTORY "${PATH}")
    _assert_internal_format_message(
      MESSAGE "expected path:" "${PATH}" "to be a directory")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given path is not a directory.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_not_is_directory PATH)
  if(IS_DIRECTORY "${PATH}")
    _assert_internal_format_message(
      MESSAGE "expected path:" "${PATH}" "not to be a directory")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given string matches the given regular expression.
#
# Arguments:
#   - STRING: The string to check.
#   - REGEX: The regular expression pattern.
macro(_assert_internal_assert_3_matches STRING REGEX)
  _assert_internal_get_content("${STRING}" STRING_CONTENT)
  if(NOT "${STRING_CONTENT}" MATCHES "${REGEX}")
    _assert_internal_format_message(
      MESSAGE "expected string:" "${STRING_CONTENT}" "to match:" "${REGEX}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given string does not match the given regular expression.
#
# Arguments:
#   - STRING: The string to check.
#   - REGEX: The regular expression pattern.
macro(_assert_internal_assert_3_not_matches STRING REGEX)
  _assert_internal_get_content("${STRING}" STRING_CONTENT)
  if("${STRING_CONTENT}" MATCHES "${REGEX}")
    _assert_internal_format_message(
      MESSAGE "expected string:" "${STRING_CONTENT}" "not to match:" "${REGEX}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given strings are equal.
#
# Arguments:
#   - STRING1: The first string to check.
#   - STRING2: The second string to check.
macro(_assert_internal_assert_3_strequal STRING1 STRING2)
  _assert_internal_get_content("${STRING1}" STRING1_CONTENT)
  _assert_internal_get_content("${STRING2}" STRING2_CONTENT)
  if(NOT "${STRING1_CONTENT}" STREQUAL "${STRING2_CONTENT}")
    _assert_internal_format_message(
      MESSAGE "expected string:" "${STRING1_CONTENT}"
      "to be equal to:" "${STRING2_CONTENT}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts whether the given strings are not equal.
#
# Arguments:
#   - STRING1: The first string to check.
#   - STRING2: The second string to check.
macro(_assert_internal_assert_3_not_strequal STRING1 STRING2)
  _assert_internal_get_content("${STRING1}" STRING1_CONTENT)
  _assert_internal_get_content("${STRING2}" STRING2_CONTENT)
  if("${STRING1_CONTENT}" STREQUAL "${STRING2_CONTENT}")
    _assert_internal_format_message(
      MESSAGE "expected string:" "${STRING1_CONTENT}"
      "not to be equal to:" "${STRING2_CONTENT}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endmacro()

# Asserts the given condition.
#
# This function performs an assertion on the given condition. It will output a
# fatal error message if the assertion fails.
#
# Refer to the documentation of the 'if' function for supported conditions to
# perform the assertion.
function(assert)
  if(ARGC EQUAL 0)
    # Do nothing on an empty condition.
  elseif(ARGC EQUAL 1)
    if("${ARGV0}" STREQUAL NOT)
      # Do nothing on an empty condition.
    else()
      if(NOT "${ARGV0}")
        _assert_internal_format_message(
          MESSAGE "expected:" "${ARGV0}" "to resolve to true")
        message(FATAL_ERROR "${MESSAGE}")
      endif()
    endif()
  elseif(ARGC EQUAL 2)
    if("${ARGV0}" STREQUAL NOT)
      if("${ARGV1}")
        _assert_internal_format_message(
          MESSAGE "expected:" "${ARGV1}" "to resolve to false")
        message(FATAL_ERROR "${MESSAGE}")
      endif()
    else()
      string(TOLOWER "${ARGV0}" OPERATOR)
      if(COMMAND "_assert_internal_assert_2_${OPERATOR}")
        cmake_language(
          CALL "_assert_internal_assert_2_${OPERATOR}" "${ARGV1}"
        )
      else()
        _assert_internal_format_message(
          MESSAGE "unsupported condition:" "${ARGV0} ${ARGV1}")
        message(FATAL_ERROR "${MESSAGE}")
      endif()
    endif()
  elseif(ARGC EQUAL 3)
    if("${ARGV0}" STREQUAL NOT)
      string(TOLOWER "${ARGV1}" OPERATOR)
      if(COMMAND "_assert_internal_assert_2_not_${OPERATOR}")
        cmake_language(
          CALL "_assert_internal_assert_2_not_${OPERATOR}" "${ARGV2}"
        )
      else()
        _assert_internal_format_message(
          MESSAGE "unsupported condition:" "${ARGV0} ${ARGV1} ${ARGV2}")
        message(FATAL_ERROR "${MESSAGE}")
      endif()
    else()
      string(TOLOWER "${ARGV1}" OPERATOR)
      if(COMMAND "_assert_internal_assert_3_${OPERATOR}")
        cmake_language(
          CALL "_assert_internal_assert_3_${OPERATOR}" "${ARGV0}" "${ARGV2}"
        )
      else()
        _assert_internal_format_message(
          MESSAGE "unsupported condition:" "${ARGV0} ${ARGV1} ${ARGV2}")
        message(FATAL_ERROR "${MESSAGE}")
      endif()
    endif()
  elseif(ARGC EQUAL 4)
    if("${ARGV0}" STREQUAL NOT)
      string(TOLOWER "${ARGV2}" OPERATOR)
      if(COMMAND "_assert_internal_assert_3_not_${OPERATOR}")
        cmake_language(
          CALL "_assert_internal_assert_3_not_${OPERATOR}" "${ARGV1}" "${ARGV3}"
        )
      else()
        _assert_internal_format_message(
          MESSAGE "unsupported condition:"
          "${ARGV0} ${ARGV1} ${ARGV2} ${ARGV3}")
        message(FATAL_ERROR "${MESSAGE}")
      endif()
    else()
      _assert_internal_format_message(
        MESSAGE "unsupported condition:" "${ARGV0} ${ARGV1} ${ARGV2} ${ARGV3}")
      message(FATAL_ERROR "${MESSAGE}")
    endif()
  else()
    set(ARGS "${ARGV0} ${ARGV1} ${ARGV2} ${ARGV3}")
    math(EXPR STOP "${ARGC} - 1")
    foreach(I RANGE 4 "${STOP}")
      set(ARGS "${ARGS} ${ARGV${I}}")
    endforeach()
    _assert_internal_format_message(MESSAGE "unsupported condition:" "${ARGS}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endfunction()

# Begins a scope for mocking the 'message' function.
#
# This function begins a scope for mocking the 'message' function by modifying
# its behavior to store the message into a list variable instead of printing it
# to the log.
#
# Use the 'end_mock_message' function to end the scope for mocking the
# 'message' function, reverting it to the original behavior.
function(mock_message)
  set_property(GLOBAL PROPERTY message_mocked ON)

  macro(message MODE MESSAGE)
    get_property(ENABLED GLOBAL PROPERTY message_mocked)
    if("${ENABLED}")
      list(APPEND ${MODE}_MESSAGES "${MESSAGE}")
      set(${MODE}_MESSAGES "${${MODE}_MESSAGES}" PARENT_SCOPE)
      if("${MODE}" STREQUAL FATAL_ERROR)
        return()
      endif()
    else()
      _message("${MODE}" "${MESSAGE}")
    endif()
  endmacro()

  function(mock_message)
    set_property(GLOBAL PROPERTY message_mocked ON)
  endfunction()
endfunction()

# Ends a scope for mocking the 'message' function.
#
# This function ends the scope for mocking the 'message' function, reverting it
# to the original behavior.
function(end_mock_message)
  set_property(GLOBAL PROPERTY message_mocked OFF)
endfunction()

# Asserts whether the 'message' function was called with the expected arguments.
#
# This function asserts whether a message with the specified mode was called
# with the expected message content.
#
# This function can only assert calls to the mocked 'message' function, which is
# enabled by calling the 'mock_message' function.
#
# Arguments:
#   - MODE: The message mode.
#   - EXPECTED_MESSAGE: The expected message content.
function(assert_message MODE EXPECTED_MESSAGE)
  list(POP_FRONT ${MODE}_MESSAGES MESSAGE)
  if(NOT MESSAGE STREQUAL EXPECTED_MESSAGE)
    string(TOLOWER "${MODE}" MODE)
    string(REPLACE "_" " " MODE "${MODE}")
    _assert_internal_format_message(
      ASSERT_MESSAGE "expected ${MODE} message:" "${MESSAGE}"
      "to be equal to:" "${EXPECTED_MESSAGE}")
    message(FATAL_ERROR "${ASSERT_MESSAGE}")
  endif()

  if(DEFINED ${MODE}_MESSAGES)
    set(${MODE}_MESSAGES "${${MODE}_MESSAGES}" PARENT_SCOPE)
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
