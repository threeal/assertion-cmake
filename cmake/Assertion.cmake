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
