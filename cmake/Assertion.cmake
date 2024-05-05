# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Asserts whether the given condition is true.
#
# Arguments:
#   - CONDITION: The condition to assert.
function(assert_true CONDITION)
  if(NOT "${CONDITION}")
    message(FATAL_ERROR "expected the condition to be true")
  endif()
endfunction()

# Asserts whether the given condition is false.
#
# Arguments:
#   - CONDITION: The condition to assert.
function(assert_false CONDITION)
  if("${CONDITION}")
    message(FATAL_ERROR "expected the condition to be false")
  endif()
endfunction()

# Asserts whether the given variable is defined.
#
# Arguments:
#   - VARIABLE: The variable to assert.
function(assert_defined VARIABLE)
  if(NOT DEFINED "${VARIABLE}")
    message(FATAL_ERROR "expected variable '${VARIABLE}' to be defined")
  endif()
endfunction()

# Asserts whether the given variable is not defined.
#
# Arguments:
#   - VARIABLE: The variable to assert.
function(assert_not_defined VARIABLE)
  if(DEFINED "${VARIABLE}")
    message(FATAL_ERROR "expected variable '${VARIABLE}' not to be defined")
  endif()
endfunction()

# Asserts whether the given path exists.
#
# Arguments:
#   - PATH: The path to assert.
function(assert_exists PATH)
  if(NOT EXISTS "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' to exist")
  endif()
endfunction()

# Asserts whether the given path does not exist.
#
# Arguments:
#   - PATH: The path to assert.
function(assert_not_exists PATH)
  if(EXISTS "${PATH}")
    message(FATAL_ERROR "expected path '${PATH}' not to exist")
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

# Mocks the 'message' function.
#
# If enabled, this function will mock the 'message' function by modifying its
# behavior to store the message into a list variable instead of printing it to
# the log.
#
# Arguments:
#   - ENABLED: Whether to mock the 'message' function or not.
function(mock_message ENABLED)
  if("${ENABLED}")
    set_property(GLOBAL PROPERTY message_mocked "${ENABLED}")

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

    function(mock_message ENABLED)
      set_property(GLOBAL PROPERTY message_mocked "${ENABLED}")
    endfunction()
  endif()
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
