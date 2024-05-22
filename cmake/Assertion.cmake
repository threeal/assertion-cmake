# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Asserts whether the given condition is true.
function(assert)
  list(LENGTH ARGN ARGUMENTS_LENGTH)
  if(ARGUMENTS_LENGTH GREATER 0)
    set(ARGUMENTS ${ARGN})

    # Determines whether the given arguments start with 'NOT'.
    list(GET ARGUMENTS 0 ARGUMENTS_0)
    if(ARGUMENTS_0 STREQUAL NOT)
      list(REMOVE_AT ARGUMENTS 0)
      set(BOOLEAN_WORD " false")
      set(NOT_WORD " not")
    else()
      set(ARGUMENT_NOT NOT)
      set(BOOLEAN_WORD " true")
    endif()

    list(LENGTH ARGUMENTS ARGUMENTS_LENGTH)
    if(ARGUMENTS_LENGTH EQUAL 2)
      list(GET ARGUMENTS 0 OPERATOR)
      list(GET ARGUMENTS 1 VALUE)

      if(OPERATOR STREQUAL DEFINED)
        set(MESSAGE "expected variable '${VALUE}'${NOT_WORD} to be defined")
      elseif(OPERATOR STREQUAL EXISTS)
        set(MESSAGE "expected path '${VALUE}'${NOT_WORD} to exist")
      endif()
    endif()

    if(${ARGUMENT_NOT} ${ARGUMENTS})
      if(DEFINED MESSAGE)
        message(FATAL_ERROR "${MESSAGE}")
      else()
        message(FATAL_ERROR "expected '${ARGUMENTS}' to resolve to${BOOLEAN_WORD}")
      endif()
    endif()
  endif()
endfunction()

# Asserts whether the given path is a directory.
#
# Arguments:
#   - PATH: The path to assert.
function(assert_directory PATH)
  if(NOT IS_DIRECTORY "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' to be a directory")
  endif()
endfunction()

# Asserts whether the given path is not a directory.
#
# Arguments:
#   - PATH: The path to assert.
function(assert_not_directory PATH)
  if(IS_DIRECTORY "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' not to be a directory")
  endif()
endfunction()

# Asserts whether the given string matches the given regular expression.
#
# Arguments:
#   - STRING: The string to assert.
#   - REGEX: The regular expression to match against the string.
function(assert_matches STRING REGEX)
  if(NOT "${STRING}" MATCHES "${REGEX}")
    message(FATAL_ERROR "expected string '${STRING}' to match '${REGEX}'")
  endif()
endfunction()

# Asserts whether the given string does not match the given regular expression.
#
# Arguments:
#   - STRING: The string to assert.
#   - REGEX: The regular expression to match against the string.
function(assert_not_matches STRING REGEX)
  if("${STRING}" MATCHES "${REGEX}")
    message(FATAL_ERROR "expected string '${STRING}' not to match '${REGEX}'")
  endif()
endfunction()

# Asserts whether the given strings are equal.
#
# Arguments:
#   - STR1: The first string to assert.
#   - STR2: The second string to assert.
function(assert_strequal STR1 STR2)
  if(NOT "${STR1}" STREQUAL "${STR2}")
    message(FATAL_ERROR "expected string '${STR1}' to be equal to '${STR2}'")
  endif()
endfunction()

# Asserts whether the given strings are not equal.
#
# Arguments:
#   - STR1: The first string to assert.
#   - STR2: The second string to assert.
function(assert_not_strequal STR1 STR2)
  if("${STR1}" STREQUAL "${STR2}")
    message(FATAL_ERROR "expected string '${STR1}' not to be equal to '${STR2}'")
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

# Asserts whether the 'message' function was called with the expected
# arguments.
#
# This function asserts whether a message with the specified mode was called
# with the expected message content.
#
# This function can only assert calls to the mocked 'message' function, which
# is enabled by calling the 'mock_message' function.
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

# Asserts whether the given command successfully executes a process.
#
# Arguments:
#   - ARGN: The command to execute.
#
# Optional arguments:
#   - EXPECTED_OUTPUT: If set, asserts whether the output of the executed
#     process matches the given regular expression.
function(assert_execute_process)
  cmake_parse_arguments(ARG "" "EXPECTED_OUTPUT" "" ${ARGN})
  execute_process(COMMAND ${ARG_UNPARSED_ARGUMENTS} RESULT_VARIABLE RES OUTPUT_VARIABLE OUT)
  string(REPLACE ";" " " ARGUMENTS "${ARG_UNPARSED_ARGUMENTS}")
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "expected command '${ARGUMENTS}' not to fail (exit code: ${RES})")
  elseif(DEFINED ARG_EXPECTED_OUTPUT AND NOT "${OUT}" MATCHES "${ARG_EXPECTED_OUTPUT}")
    message(FATAL_ERROR "expected the output of command '${ARGUMENTS}' to match '${ARG_EXPECTED_OUTPUT}'")
  endif()
endfunction()

# Asserts whether the given command fails to execute a process.
#
# Arguments:
#   - ARGN: The command to execute.
#
# Optional arguments:
#   - EXPECTED_OUTPUT: If set, asserts whether the output of the executed
#     process matches the given regular expression.
function(assert_not_execute_process)
  cmake_parse_arguments(ARG "" "EXPECTED_OUTPUT" "" ${ARGN})
  execute_process(COMMAND ${ARG_UNPARSED_ARGUMENTS} RESULT_VARIABLE RES ERROR_VARIABLE ERR)
  string(REPLACE ";" " " ARGUMENTS "${ARG_UNPARSED_ARGUMENTS}")
  if(RES EQUAL 0)
    message(FATAL_ERROR "expected command '${ARGUMENTS}' to fail (exit code: ${RES})")
  elseif(DEFINED ARG_EXPECTED_OUTPUT AND NOT "${ERR}" MATCHES "${ARG_EXPECTED_OUTPUT}")
    message(FATAL_ERROR "expected the output of command '${ARGUMENTS}' to match '${ARG_EXPECTED_OUTPUT}'")
  endif()
endfunction()
