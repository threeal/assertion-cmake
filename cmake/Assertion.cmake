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

# Asserts whether the given variable is defined.
#
# Arguments:
#   - VARIABLE: The variable to check.
macro(_assert_internal_assert_2_defined VARIABLE)
  if(NOT DEFINED "${VARIABLE}")
    message(FATAL_ERROR "expected variable '${VARIABLE}' to be defined")
  endif()
endmacro()

# Asserts whether the given variable is not defined.
#
# Arguments:
#   - VARIABLE: The variable to check.
macro(_assert_internal_assert_2_not_defined VARIABLE)
  if(DEFINED "${VARIABLE}")
    message(FATAL_ERROR "expected variable '${VARIABLE}' not to be defined")
  endif()
endmacro()

# Asserts whether the given path exists.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_exists PATH)
  if(NOT EXISTS "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' to exist")
  endif()
endmacro()

# Asserts whether the given path does not exist.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_not_exists PATH)
  if(EXISTS "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' not to exist")
  endif()
endmacro()

# Asserts whether the given path is a directory.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_is_directory PATH)
  if(NOT IS_DIRECTORY "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' to be a directory")
  endif()
endmacro()

# Asserts whether the given path is not a directory.
#
# Arguments:
#   - PATH: The path to check.
macro(_assert_internal_assert_2_not_is_directory PATH)
  if(IS_DIRECTORY "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' not to be a directory")
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
    message(
      FATAL_ERROR
      "expected string '${STRING_CONTENT}' to match '${REGEX}'"
    )
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
    message(
      FATAL_ERROR
      "expected string '${STRING_CONTENT}' not to match '${REGEX}'"
    )
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
    message(
      FATAL_ERROR
      "expected string '${STRING1_CONTENT}' to be equal to '${STRING2_CONTENT}'"
    )
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
    message(
      FATAL_ERROR
      "expected string '${STRING1_CONTENT}' not to be equal to '${STRING2_CONTENT}'"
    )
  endif()
endmacro()

# Asserts whether the given condition is true.
#
# This function performs an assertion on the given condition. It will output a
# fatal error message if the assertion fails.
#
# Refer to the documentation of the 'if' function for supported conditions to
# perform the assertion.
function(assert)
  list(LENGTH ARGN ARGUMENTS_LENGTH)
  if(ARGUMENTS_LENGTH GREATER 0)
    set(ARGUMENTS ${ARGN})

    # Determines whether the given arguments start with 'NOT'.
    list(GET ARGUMENTS 0 ARGUMENTS_0)
    if(ARGUMENTS_0 STREQUAL NOT)
      list(REMOVE_AT ARGUMENTS 0)
      set(HAS_NOT TRUE)
      set(WITH_NOT _not)
    else()
      set(HAS_NOT FALSE)
      set(WITH_NOT "")
    endif()

    list(LENGTH ARGUMENTS ARGUMENTS_LENGTH)
    if(ARGUMENTS_LENGTH EQUAL 0)
      # Do nothing on an empty condition.
    elseif(ARGUMENTS_LENGTH EQUAL 1)
      list(GET ARGUMENTS 0 VALUE)
      if(HAS_NOT AND "${VALUE}")
        message(FATAL_ERROR "expected '${VALUE}' to resolve to false")
      elseif(NOT HAS_NOT AND NOT "${VALUE}")
        message(FATAL_ERROR "expected '${VALUE}' to resolve to true")
      endif()
    elseif(ARGUMENTS_LENGTH EQUAL 2)
      list(GET ARGUMENTS 0 OPERATOR)
      string(TOLOWER "${OPERATOR}" OPERATOR)
      if(COMMAND "_assert_internal_assert_2${WITH_NOT}_${OPERATOR}")
        list(GET ARGUMENTS 1 VALUE)
        cmake_language(CALL "_assert_internal_assert_2${WITH_NOT}_${OPERATOR}" "${VALUE}")
      else()
        string(REPLACE ";" " " ARGUMENTS "${ARGUMENTS}")
        message(FATAL_ERROR "unsupported condition: ${ARGUMENTS}")
      endif()
    elseif(ARGUMENTS_LENGTH EQUAL 3)
      list(GET ARGUMENTS 1 OPERATOR)
      string(TOLOWER "${OPERATOR}" OPERATOR)
      if(COMMAND "_assert_internal_assert_3${WITH_NOT}_${OPERATOR}")
        list(GET ARGUMENTS 0 LEFT_VALUE)
        list(GET ARGUMENTS 2 RIGHT_VALUE)
        cmake_language(CALL "_assert_internal_assert_3${WITH_NOT}_${OPERATOR}" "${LEFT_VALUE}" "${RIGHT_VALUE}")
      else()
        string(REPLACE ";" " " ARGUMENTS "${ARGUMENTS}")
        message(FATAL_ERROR "unsupported condition: ${ARGUMENTS}")
      endif()
    elseif(ARGUMENTS_LENGTH GREATER 1)
      string(REPLACE ";" " " ARGUMENTS "${ARGUMENTS}")
      message(FATAL_ERROR "unsupported condition: ${ARGUMENTS}")
    endif()
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
    message(FATAL_ERROR "expected ${MODE} message '${MESSAGE}' to be equal to '${EXPECTED_MESSAGE}'")
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
  cmake_parse_arguments(ARG "" "OUTPUT;ERROR" "COMMAND" ${ARGN})

  execute_process(
    COMMAND ${ARG_COMMAND}
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
    ERROR_VARIABLE ERR
  )

  if(DEFINED ARG_ERROR AND RES EQUAL 0)
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected command '${ARG_COMMAND}' to fail"
    )
  elseif(NOT DEFINED ARG_ERROR AND NOT RES EQUAL 0)
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected command '${ARG_COMMAND}' not to fail"
    )
  elseif(DEFINED ARG_OUTPUT AND NOT "${OUT}" MATCHES "${ARG_OUTPUT}")
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected the output of command '${ARG_COMMAND}' to match '${ARG_OUTPUT}'"
    )
  elseif(DEFINED ARG_ERROR AND NOT "${ERR}" MATCHES "${ARG_ERROR}")
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected the error of command '${ARG_COMMAND}' to match '${ARG_ERROR}'"
    )
  endif()
endfunction()
