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
